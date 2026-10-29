--!strict
-- ServerScriptService/Services/RewardsService
-- Tout ce qui fait revenir le joueur (contenu dans Config/Events) :
--   * calendrier de l'Avent (1er -> 24 décembre, UTC) : une case par jour, les cases ratées restent ouvrables
--   * 3 quêtes du jour (même tirage pour un joueur toute la journée, remise à zéro à 00:00 UTC) + bonus si les 3 sont finies
--   * Winter Pass : XP gagnée en jouant, 30 paliers, piste gratuite + premium (Game Pass "WinterPass")
--   * offre de départ (après 5 min de jeu, tant qu'elle n'est pas achetée)
--   * gains hors ligne x2 (produit "OfflineX2", valable 15 min après la connexion)
--   * stats de la semaine (classements hebdomadaires : tas creusés, Secret trouvés)
-- Les autres services appellent RewardsService.Progress(player, stat, n) quand le joueur fait quelque chose.
-- Le serveur décide de tout : le client ne fait que demander "ouvre la case 5", "réclame la quête 2"...

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared.Config.Events)
local Eggs = require(Shared.Config.Eggs)
local Zones = require(Shared.Config.Zones)
local Pets = require(Shared.Config.Pets)
local Items = require(Shared.Config.Items)
local Format = require(Shared.Util.Format)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)

local RewardsService = {}
local rng = Random.new()

-- temps "de jeu" : en Studio, l'admin peut forcer le jour de l'Avent (attribut workspace AdventDayOverride)
local function now(): number return os.time() end
local function adventDay(): number
	local o = workspace:GetAttribute("AdventDayOverride")
	if RunService:IsStudio() and type(o) == "number" then return o end
	return Events.AdventDay(now())
end

-- [ RÉCOMPENSES ] ----------------------------------------------------------------------
local function bestEgg(data: any): string
	local best = "SnowEgg"
	for _, z in ipairs(Zones.List) do
		if (data.Rebirths or 0) >= z.Rebirths and z.Egg then best = z.Egg end
	end
	return best
end

local function moneyFor(data: any, r: any): number
	local perMin = Stats.BaseIncome(data) * 60
	-- minutes de revenu de la base ; minimum qui grandit avec les rebirths (utile pour un joueur sans pets)
	return math.floor(math.max((r.Min or 0) * (1 + (data.Rebirths or 0)), perMin * (r.Mins or 5)))
end

-- texte court d'une récompense (affichage client et notifications)
function RewardsService.Describe(data: any?, r: any): string
	if r.Kind == "Money" then return data and Format.Money(moneyFor(data, r)) or ((r.Mins or 5) .. " min of income") end
	if r.Kind == "Egg" then local e = Eggs.ById[r.Egg]; return (r.Count or 1) .. "x " .. (e and e.Name or r.Egg) end
	if r.Kind == "BestEgg" then local e = data and Eggs.ById[bestEgg(data)]; return (r.Count or 1) .. "x " .. (e and e.Name or "Best Egg") end
	if r.Kind == "Boost" then return "x2 " .. r.Stat .. " " .. r.Mins .. " min" end
	if r.Kind == "Charm" then return "+" .. math.floor(r.Amount * 100) .. "% " .. r.Stat .. " forever" end
	if r.Kind == "Pet" then return (r.Mut or "") .. " " .. r.Rarity .. " pet" end
	if r.Kind == "XP" then return "+" .. r.Amount .. " Pass XP" end
	return "?"
end

local addXP: (Player, any, number) -> ()

function RewardsService.Grant(player: Player, data: any, r: any): string
	if r.Kind == "Money" then
		local m = moneyFor(data, r)
		data.Money += m; data.TotalEarned += m
		DataService.Push(player, "Money")
		return Format.Money(m)
	elseif r.Kind == "Egg" or r.Kind == "BestEgg" then
		local id = r.Kind == "Egg" and r.Egg or bestEgg(data)
		data.Eggs[id] = (data.Eggs[id] or 0) + (r.Count or 1)
		DataService.Push(player, "Eggs")
		local EggService = require(script.Parent.EggService) :: any
		EggService.SyncTools(player, data)
		local e = Eggs.ById[id]
		return (r.Count or 1) .. "x " .. (e and e.Name or id)
	elseif r.Kind == "Boost" then
		data.Boosts[r.Stat] = math.max(data.Boosts[r.Stat] or 0, now()) + r.Mins * 60
		DataService.Push(player, "Boosts")
		return "x2 " .. r.Stat .. " (" .. r.Mins .. " min)"
	elseif r.Kind == "Charm" then
		local cap = Items.RuneCaps[r.Stat] or 0.5
		data.Runes[r.Stat] = math.min((data.Runes[r.Stat] or 0) + r.Amount, cap)
		DataService.Push(player, "Runes")
		return "+" .. math.floor(r.Amount * 100) .. "% " .. r.Stat
	elseif r.Kind == "Pet" then
		local pool = Pets.ByRarity[r.Rarity] or Pets.ByRarity.Legendary
		local br = pool[rng:NextInteger(1, #pool)]
		local HarvestService = require(script.Parent.HarvestService) :: any
		local uid = HarvestService.AddPet(player, data, br.Id, r.Mut or "Normal")
		DataService.Push(player, "Pets"); DataService.Push(player, "Index")
		Net.Fire(player, "PetFound", { Uid = uid, Id = br.Id, Mut = r.Mut or "Normal", Rarity = r.Rarity, Egg = "Gift" })
		return (r.Mut and r.Mut ~= "Normal" and (r.Mut .. " ") or "") .. br.Id
	elseif r.Kind == "XP" then
		addXP(player, data, r.Amount)
		return "+" .. r.Amount .. " XP"
	end
	return ""
end

local function grantAll(player: Player, data: any, list: { any }): { string }
	local out = {}
	for _, r in ipairs(list) do table.insert(out, RewardsService.Grant(player, data, r)) end
	return out
end

-- [ WINTER PASS ] -------------------------------------------------------------------------
local function passOpen(): boolean return now() < Events.Pass.Ends end
local function tierOf(xp: number): (number, number, number)
	-- palier atteint, XP dans le palier en cours, XP nécessaire pour le suivant
	local t, left = 0, xp
	while t < #Events.Pass.Tiers do
		local need = Events.Pass.TierXP(t + 1)
		if left < need then return t, left, need end
		left -= need
		t += 1
	end
	return t, 0, 0
end
RewardsService.TierOf = tierOf

addXP = function(player: Player, data: any, amount: number)
	if amount <= 0 or not passOpen() then return end
	local before = tierOf(data.Pass.XP)
	data.Pass.XP += amount
	local after = tierOf(data.Pass.XP)
	DataService.Push(player, "Pass")
	if after > before then
		Net.Fire(player, "PassTier", after)
	end
end

local function claimPass(player: Player, tier: any, premium: any)
	local data = DataService.Get(player)
	if not data or type(tier) ~= "number" or tier ~= math.floor(tier) then return { ok = false } end
	local def = Events.Pass.Tiers[tier]
	if not def then return { ok = false } end
	if tierOf(data.Pass.XP) < tier then return { ok = false, msg = "Reach tier " .. tier .. " first!" } end
	local key = tostring(tier)
	if premium == true then
		if not (data.Passes and data.Passes.WinterPass) then return { ok = false, msg = "Premium rewards need the Winter Pass!" } end
		if data.Pass.Premium[key] then return { ok = false, msg = "Already claimed" } end
		data.Pass.Premium[key] = true
		DataService.Push(player, "Pass")
		return { ok = true, msg = "Claimed: " .. RewardsService.Grant(player, data, def.Premium) }
	else
		if data.Pass.Free[key] then return { ok = false, msg = "Already claimed" } end
		data.Pass.Free[key] = true
		DataService.Push(player, "Pass")
		return { ok = true, msg = "Claimed: " .. RewardsService.Grant(player, data, def.Free) }
	end
end

-- [ QUÊTES DU JOUR ] ------------------------------------------------------------------------
local function rollQuests(player: Player, data: any)
	local key = Events.DayKey(now())
	if data.Quests.Day == key then return end
	local seed = (player.UserId % 100000) * 7 + tonumber((key:gsub("-", ""))) :: number
	local r = Random.new(seed)
	local pool = table.clone(Events.Quests)
	-- pas de quête "coffre" ni "tempête" si le joueur débute
	local list = {}
	while #list < Events.QuestCount and #pool > 0 do
		local q = table.remove(pool, r:NextInteger(1, #pool))
		table.insert(list, { Id = q.Id, Goal = q.Goal(data.Rebirths or 0), Have = 0, Done = false })
	end
	data.Quests = { Day = key, List = list, Bonus = false }
	DataService.Push(player, "Quests")
end

RewardsService.EnsureQuests = rollQuests

local function questDef(id: string): any
	for _, q in ipairs(Events.Quests) do if q.Id == id then return q end end
	return nil
end

local function claimQuest(player: Player, idx: any)
	local data = DataService.Get(player)
	if not data then return { ok = false } end
	rollQuests(player, data)
	if idx == "bonus" then
		if data.Quests.Bonus then return { ok = false, msg = "Already claimed" } end
		for _, q in ipairs(data.Quests.List) do if not q.Done then return { ok = false, msg = "Finish the 3 quests first!" } end end
		data.Quests.Bonus = true
		DataService.Push(player, "Quests")
		return { ok = true, msg = "Daily bonus: " .. table.concat(grantAll(player, data, Events.QuestBonus), " + ") }
	end
	if type(idx) ~= "number" then return { ok = false } end
	local q = data.Quests.List[idx]
	if not q then return { ok = false } end
	if q.Done then return { ok = false, msg = "Already claimed" } end
	if q.Have < q.Goal then return { ok = false, msg = "Not finished yet!" } end
	q.Done = true
	DataService.Push(player, "Quests")
	return { ok = true, msg = "Quest done: " .. table.concat(grantAll(player, data, Events.QuestReward), " + ") }
end

-- [ PROGRESSION ] ---------------------------------------------------------------------------
-- stat : Dig, Egg, Hatch, Sell, Rare, Combo (valeur max), Chest, StormDig, Secret
function RewardsService.Progress(player: Player, stat: string, amount: number)
	local data = DataService.Get(player)
	if not data or amount <= 0 then return end
	rollQuests(player, data)
	local changed = false
	for _, q in ipairs(data.Quests.List) do
		local def = questDef(q.Id)
		if def and def.Stat == stat and not q.Done and q.Have < q.Goal then
			q.Have = def.Max and math.max(q.Have, math.min(amount, q.Goal)) or math.min(q.Goal, q.Have + amount)
			if q.Have >= q.Goal then Net.Fire(player, "QuestReady", q.Id) end
			changed = true
		end
	end
	if changed then DataService.Push(player, "Quests") end
	-- XP du pass
	local xp = Events.Pass.XP[stat]
	if xp then
		data.Pass.Acc = (data.Pass.Acc or 0) + xp * amount
		local whole = math.floor(data.Pass.Acc)
		if whole >= 1 then data.Pass.Acc -= whole; addXP(player, data, whole) end
	end
	-- semaine (classements hebdomadaires)
	local wk = Events.WeekId(now())
	if data.Week.Id ~= wk then data.Week = { Id = wk, Dug = 0, Secrets = 0 } end
	if stat == "Dig" then data.Week.Dug += amount
	elseif stat == "Secret" then data.Week.Secrets += amount end
end

-- [ CALENDRIER DE L'AVENT ] ------------------------------------------------------------------
local function claimAdvent(player: Player, day: any)
	local data = DataService.Get(player)
	if not data or type(day) ~= "number" or day ~= math.floor(day) or day < 1 or day > 24 then return { ok = false } end
	local today = adventDay()
	if today == 0 then return { ok = false, msg = "The calendar opens on December 1st!" } end
	if day > today then return { ok = false, msg = "Come back on December " .. day .. "!" } end
	local key = tostring(day)
	if data.Advent[key] then return { ok = false, msg = "Already opened" } end
	data.Advent[key] = true
	DataService.Push(player, "Advent")
	local got = grantAll(player, data, Events.Advent.Days[day])
	addXP(player, data, 100)
	return { ok = true, msg = "Day " .. day .. ": " .. table.concat(got, " + "), Day = day }
end

-- [ OFFRE DE DÉPART / HORS LIGNE / ÉCLOSION IMMÉDIATE (produits Robux) ] --------------------
function RewardsService.GrantStarter(player: Player, data: any): boolean
	if data.StarterBought then return true end
	data.StarterBought = true
	DataService.Push(player, "StarterBought")
	local got = grantAll(player, data, Events.Starter.Rewards)
	Net.Fire(player, "StarterBought", got)
	return true
end

function RewardsService.SetOffline(player: Player, data: any, money: number)
	data.OfflineLast = { Money = money, At = now() }
end

function RewardsService.GrantOfflineX2(player: Player, data: any): boolean
	local o = data.OfflineLast
	local m = (o and now() - (o.At or 0) < 15 * 60) and (o.Money or 0) or 0
	if m <= 0 then
		-- achat hors délai : on donne quand même 10 minutes de revenu
		m = math.floor(Stats.BaseIncome(data) * 600)
	end
	data.OfflineLast = { Money = 0, At = 0 }
	data.Money += m; data.TotalEarned += m
	DataService.Push(player, "Money")
	Net.Notify(player, "x2 offline earnings: +" .. Format.Money(m) .. "!", "success")
	return true
end

-- [ DÉMARRAGE ] ------------------------------------------------------------------------------
function RewardsService.Start()
	Net.OnInvoke("ClaimAdvent", claimAdvent, 2, 4)
	Net.OnInvoke("ClaimQuest", claimQuest, 2, 4)
	Net.OnInvoke("ClaimPass", claimPass, 3, 6)
	Net.OnInvoke("RewardsInfo", function(player)
		local data = DataService.Get(player)
		if not data then return nil end
		rollQuests(player, data)
		-- textes des récompenses avec les montants réels du joueur (le client les affiche tels quels)
		local adv = {}
		for d = 1, 24 do
			local t = {}
			for _, r in ipairs(Events.Advent.Days[d]) do table.insert(t, RewardsService.Describe(data, r)) end
			adv[d] = table.concat(t, " + ")
		end
		local pass = {}
		for t, def in ipairs(Events.Pass.Tiers) do
			pass[t] = { Free = RewardsService.Describe(data, def.Free), Premium = RewardsService.Describe(data, def.Premium) }
		end
		local q = {}
		for _, r in ipairs(Events.QuestReward) do table.insert(q, RewardsService.Describe(data, r)) end
		local b = {}
		for _, r in ipairs(Events.QuestBonus) do table.insert(b, RewardsService.Describe(data, r)) end
		return { AdventDay = adventDay(), Advent = adv, Pass = pass, QuestReward = table.concat(q, " + "), QuestBonus = table.concat(b, " + "),
			ToMidnight = Events.ToMidnight(now()), PassEnds = Events.Pass.Ends - now() }
	end, 1, 3)
	DataService.OnLoaded(function(player, data)
		rollQuests(player, data)
		local wk = Events.WeekId(now())
		if data.Week.Id ~= wk then data.Week = { Id = wk, Dug = 0, Secrets = 0 } end
	end)
	-- offre de départ : proposée après 5 min de jeu (une fois par session, si pas achetée)
	local offered: { [Player]: boolean } = {}
	Players.PlayerRemoving:Connect(function(p) offered[p] = nil end)
	task.spawn(function()
		while true do
			task.wait(15)
			for _, p in ipairs(Players:GetPlayers()) do
				local data = DataService.Get(p)
				if data and not data.StarterBought and not offered[p] and (data.Stats.Playtime or 0) >= Events.Starter.ShowAfter then
					offered[p] = true
					Net.Fire(p, "StarterOffer", true)
				end
				-- nouveau jour : nouvelles quêtes
				if data then rollQuests(p, data) end
			end
		end
	end)
end

return RewardsService
