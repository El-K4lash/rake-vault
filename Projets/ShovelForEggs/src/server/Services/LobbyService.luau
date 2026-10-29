--!strict
-- ServerScriptService/Services/LobbyService
-- Les machines du lobby (Map.Hub) :
--   * SpinWheel  : roue de la fortune, 1 tour gratuit / heure (data.SpinAt). Le serveur tire le gain et le donne
--                  tout de suite ; le client fait tourner la roue jusqu'au segment renvoyé.
--   * SuperHatch : incubateur, éclot immédiatement l'œuf demandé (payant) avec x3 chances de mutation.
--   * Fuse       : machine de fusion, 3 pets choisis : identiques -> mutation suivante, différents -> pet au hasard.
-- Tout est validé ici (le client n'envoie que des noms).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Lobby = require(Shared.Config.Lobby)
local Eggs = require(Shared.Config.Eggs)
local Zones = require(Shared.Config.Zones)
local Upgrades = require(Shared.Config.Upgrades)
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)
local Format = require(Shared.Util.Format)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)

local LobbyService = {}
local rng = Random.new()

local function bestEgg(data: any): string
	local best = Zones.List[1]
	for _, z in ipairs(Zones.List) do
		if (data.Rebirths or 0) >= z.Rebirths then best = z end
	end
	return best.Egg
end

local function giveEggs(player: Player, data: any, eggId: string, n: number)
	data.Eggs[eggId] = (data.Eggs[eggId] or 0) + n
	DataService.Push(player, "Eggs")
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(player, data)
end

local function announce(player: Player, id: string, mut: string, rarity: string)
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then Net.Fire(p, "ServerAnnounce", { Player = player.Name, Id = id, Mut = mut, Rarity = rarity }) end
	end
end

-- [ ROUE ] -----------------------------------------------------------------------------
local W = Lobby.Wheel
local function rollReward(): string
	local total = 0
	for _, r in pairs(W.Rewards) do total += r.Weight end
	local x = rng:NextNumber() * total
	for id, r in pairs(W.Rewards) do
		x -= r.Weight
		if x <= 0 then return id end
	end
	return "Coins"
end

-- le gain est tiré tout de suite (le client fait tourner la roue jusqu'à la bonne part) mais il n'est DONNÉ
-- qu'à la fin de l'animation (W.SpinTime). En attendant il est gardé dans data.WheelPending : s'il quitte
-- pendant le tour, il le récupère à sa prochaine connexion.
local function applyWheel(player: Player, data: any)
	local pend = data.WheelPending
	if type(pend) ~= "table" then return end
	data.WheelPending = nil
	local kind = pend.Kind
	if kind == "Coins" or kind == "Money" or kind == "Jackpot" then
		local amount = tonumber(pend.Amount) or 0
		data.Money += amount
		data.TotalEarned += amount
		DataService.Push(player, "Money")
	elseif kind == "Egg" then
		giveEggs(player, data, pend.Egg, 1)
	elseif kind == "Luck" or kind == "Boost" then
		local now = os.time()
		local stat = kind == "Luck" and "Luck" or "Money"
		local cur = data.Boosts[stat]
		local from = (type(cur) == "number" and cur > now) and cur or now
		data.Boosts[stat] = from + W.BoostTime
		DataService.Push(player, "Boosts")
	end
	Net.Fire(player, "WheelReward", { Reward = kind, Text = pend.Text })
end

local function spin(player: Player): any
	local data = DataService.Get(player)
	if not data then return { ok = false, msg = "Loading..." } end
	local now = os.time()
	if (data.SpinAt or 0) > now then
		local left = data.SpinAt - now
		return { ok = false, msg = string.format("Next free spin in %d:%02d", left // 60, left % 60) }
	end
	if data.WheelPending then applyWheel(player, data) end
	data.SpinAt = now + W.Cooldown
	local kind = rollReward()
	local segs = {}
	for i, s in ipairs(W.Segments) do if s.Reward == kind then table.insert(segs, i) end end
	local seg = segs[rng:NextInteger(1, #segs)]
	local pend: any = { Kind = kind }
	if kind == "Coins" or kind == "Money" or kind == "Jackpot" then
		pend.Amount = W.MoneyFor(kind, Stats.BaseIncome(data), data.Rebirths or 0)
		pend.Text = "+" .. Format.Money(pend.Amount)
	elseif kind == "Egg" then
		pend.Egg = bestEgg(data)
		pend.Text = "+1 " .. Eggs.ById[pend.Egg].Name
	else
		pend.Text = (kind == "Luck" and "Luck" or "Money") .. " x2 for 10 min"
	end
	data.WheelPending = pend
	DataService.Push(player, "SpinAt")
	task.delay(W.SpinTime + 0.25, function()
		local d = DataService.Get(player)
		if d and d.WheelPending == pend then applyWheel(player, d) end
	end)
	return { ok = true, Seg = seg, Reward = kind, Text = pend.Text }
end

-- [ INCUBATEUR ] -------------------------------------------------------------------------
local function superHatch(player: Player, eggId: any): any
	local data = DataService.Get(player)
	if not data or type(eggId) ~= "string" then return { ok = false, msg = "Hold an egg first!" } end
	local def = Eggs.ById[eggId]
	if not def or (data.Eggs[eggId] or 0) <= 0 then return { ok = false, msg = "Hold an egg first!" } end
	local cost = Lobby.Incubator.Cost(def.Order, data.Rebirths or 0)
	if data.Money < cost then return { ok = false, msg = "Not enough money! (" .. Format.Money(cost) .. ")" } end
	data.Money -= cost
	data.Eggs[eggId] -= 1
	if data.Eggs[eggId] <= 0 then data.Eggs[eggId] = nil end
	local eggLuck = Upgrades.BaseUpgradeById.EggLuck.Value((data.Up and data.Up.EggLuck) or 0)
	local rarity = Eggs.RollRarity(rng, def, Stats.Luck(data) * eggLuck * Lobby.Incubator.RarityLuck)
	local pool = Pets.ByRarity[rarity] or Pets.ByRarity.Common
	local br = pool[rng:NextInteger(1, #pool)]
	local mut = Mutations.Roll(rng, Stats.Luck(data) * Lobby.Incubator.MutationLuck)
	local HarvestService = require(script.Parent.HarvestService) :: any
	local uid = HarvestService.AddPet(player, data, br.Id, mut)
	DataService.Push(player, "Money")
	DataService.Push(player, "Eggs")
	DataService.Push(player, "Pets")
	DataService.Push(player, "Index")
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(player, data)
	Net.Fire(player, "PetFound", { Uid = uid, Id = br.Id, Mut = mut, Rarity = rarity, Egg = eggId })
	if Pets.RarityById[rarity].Order >= 4 or mut ~= "Normal" then announce(player, br.Id, mut, rarity) end
	return { ok = true, Id = br.Id, Mut = mut, Rarity = rarity }
end

-- [ FUSION ] -----------------------------------------------------------------------------
local function nextMutation(mut: string): string?
	local m = Mutations.ById[mut]
	if not m then return nil end
	for _, o in ipairs(Mutations.List) do
		if o.Order == m.Order + 1 then return o.Id end
	end
	return nil
end

local function nextRarity(rarity: string): string?
	local r = Pets.RarityById[rarity]
	if not r then return nil end
	local n = Pets.Rarities[r.Order + 1]
	return n and n.Id or nil
end

-- uids = les 3 pets choisis dans le menu (le client n'envoie que des identifiants : tout est revérifié ici)
local function fuse(player: Player, uids: any): any
	local data = DataService.Get(player)
	local F = Lobby.Fusion
	if not data or type(uids) ~= "table" or #uids ~= F.Count then return { ok = false, msg = "Pick " .. F.Count .. " pets!" } end
	local picked, seen = {}, {}
	for i = 1, F.Count do
		local uid = uids[i]
		if type(uid) ~= "string" or seen[uid] or not data.Pets[uid] then return { ok = false, msg = "Pick " .. F.Count .. " pets!" } end
		seen[uid] = true
		table.insert(picked, data.Pets[uid])
	end
	local same = true
	for i = 2, #picked do
		if picked[i].Id ~= picked[1].Id or picked[i].Mut ~= picked[1].Mut then same = false end
	end
	local id, mut
	if same then
		mut = nextMutation(picked[1].Mut)
		if not mut then return { ok = false, msg = "Already max mutation!" } end
		id = picked[1].Id
	else
		-- rareté la plus haute des 3, parfois une au-dessus
		local best, low = nil, nil
		for _, e in ipairs(picked) do
			local br = Pets.ById[e.Id]
			local r = br and Pets.RarityById[br.Rarity]
			if r and (not best or r.Order > best.Order) then best = r end
			local m = Mutations.ById[e.Mut] or Mutations.ById.Normal
			if not low or m.Order < low.Order then low = m end
		end
		local rarity = best and best.Id or "Common"
		if rng:NextNumber() < F.UpChance then rarity = nextRarity(rarity) or rarity end
		local pool = Pets.ByRarity[rarity] or Pets.ByRarity.Common
		id = pool[rng:NextInteger(1, #pool)].Id
		mut = low and low.Id or "Normal"
		if rng:NextNumber() < F.MutUpChance then mut = nextMutation(mut) or mut end
	end
	-- niveaux des pets fusionnés : même pet -> on garde le meilleur niveau ; pets différents -> Lv 1
	-- (sinon on monterait des Common pour transférer le niveau sur un Legendary). L'argent des niveaux perdus
	-- est rendu à moitié (même règle que la vente).
	local Levels = require(ReplicatedStorage.Shared.Config.Levels) :: any
	local keep: any = nil
	if same then
		for _, e in ipairs(picked) do
			if not keep or Levels.Of(e) > Levels.Of(keep) then keep = e end
		end
		if keep and Levels.Of(keep) <= 1 then keep = nil end
	end
	local refund = 0
	for _, e in ipairs(picked) do
		if e ~= keep then refund += Levels.Refund(e) end
	end
	local keepLv, keepSpent = keep and Levels.Of(keep) or nil, keep and keep.Spent or nil
	for uid in pairs(seen) do
		local wasPlaced = (data.Pets[uid].Slot or 0) > 0
		data.Pets[uid] = nil
		if wasPlaced then PlotService.Remove(player, uid) end
	end
	local HarvestService = require(script.Parent.HarvestService) :: any
	local uid = HarvestService.AddPet(player, data, id, mut)
	local newEntry = data.Pets[uid]
	if newEntry and keepLv then newEntry.Lv = keepLv; newEntry.Spent = keepSpent end
	if refund > 0 then
		data.Money += refund
		DataService.Push(player, "Money")
		Net.Notify(player, "Upgrade refund: +" .. Format.Money(refund), "success")
	end
	DataService.Push(player, "Pets")
	DataService.Push(player, "Index")
	local rarity = Pets.ById[id].Rarity
	Net.Fire(player, "PetFound", { Uid = uid, Id = id, Mut = mut, Rarity = rarity, Fused = true })
	if Mutations.ById[mut].Order >= 4 or Pets.RarityById[rarity].Order >= 4 then announce(player, id, mut, rarity) end
	return { ok = true, Id = id, Mut = mut, Rarity = rarity, Same = same }
end

function LobbyService.Start()
	-- gain de roue pas encore donné (déconnexion pendant le tour) : on le donne au retour
	DataService.OnLoaded(function(player, data)
		if data.WheelPending then task.delay(3, function() local d = DataService.Get(player); if d then applyWheel(player, d) end end) end
	end)
	Net.OnInvoke("SpinWheel", spin, 1, 2)
	Net.OnInvoke("SuperHatch", superHatch, 2, 3)
	Net.OnInvoke("Fuse", fuse, 2, 3)
end

return LobbyService
