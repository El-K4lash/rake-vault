--!strict
-- ServerScriptService/Services/EggService
-- Œufs : un outil par type d'œuf dans le sac à dos ("Beach Egg x3"). Avec l'outil en main, un clic dans SON enclos
-- pose l'œuf (le client envoie la position, le serveur vérifie). L'œuf éclot après HatchTime en un pet
-- (rareté selon l'œuf, mutation tirée au sort) qui part dans l'enclos. Les œufs éclosent aussi hors ligne.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Eggs = require(Shared.Config.Eggs)
local Upgrades = require(Shared.Config.Upgrades)
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)

local EggService = {}
local rng = Random.new()

-- [ OUTILS ] ------------------------------------------------------------------
local function eggTool(def: any, count: number): Tool
	local tool = Instance.new("Tool")
	tool.Name = def.Name
	tool.CanBeDropped = false
	tool.RequiresHandle = true
	tool:SetAttribute("EggId", def.Id)
	tool:SetAttribute("Count", count)
	tool.ToolTip = "Click inside your chalet to place it"
	local folder = ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("Eggs")
	local tpl = folder and folder:FindFirstChild(def.Model) :: Model?
	local handle = Instance.new("Part")
	handle.Name = "Handle"; handle.Size = Vector3.new(1, 1, 1); handle.Transparency = 1; handle.CanCollide = false; handle.Massless = true
	handle.Parent = tool
	if tpl then
		local m = tpl:Clone()
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("LuaSourceContainer") then d:Destroy() end
			if d:IsA("BasePart") then d.Anchored = false; d.CanCollide = false; d.Massless = true; d.CanQuery = false end
			if d:IsA("WeldConstraint") or d:IsA("Weld") then d:Destroy() end
		end
		local _, size = m:GetBoundingBox()
		m:ScaleTo(m:GetScale() * 1.8 / math.max(size.X, size.Y, size.Z))
		m:PivotTo(handle.CFrame * CFrame.new(0, 0, -0.6))
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then
				local w = Instance.new("WeldConstraint"); w.Part0 = handle; w.Part1 = d; w.Parent = d
			end
		end
		m.Parent = handle
	else
		handle.Transparency = 0; handle.Shape = Enum.PartType.Ball; handle.Size = Vector3.new(1.4, 1.7, 1.4); handle.Color = def.Color
	end
	return tool
end

-- met les outils d'œufs du sac à dos à jour avec data.Eggs
function EggService.SyncTools(player: Player, data: any)
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not backpack then return end
	local char = player.Character
	local have: { [string]: Tool } = {}
	for _, c in ipairs({ backpack, char }) do
		if c then
			for _, t in ipairs(c:GetChildren()) do
				if t:IsA("Tool") and t:GetAttribute("EggId") then
					local id = t:GetAttribute("EggId") :: string
					if have[id] then t:Destroy() else have[id] = t end
				end
			end
		end
	end
	for _, def in ipairs(Eggs.List) do
		local n = data.Eggs[def.Id] or 0
		local t = have[def.Id]
		if n <= 0 then
			if t then t:Destroy() end
		elseif t then
			t:SetAttribute("Count", n)
			t.Name = def.Name .. (n > 1 and (" x" .. n) or "")
		else
			local nt = eggTool(def, n)
			nt.Name = def.Name .. (n > 1 and (" x" .. n) or "")
			nt.Parent = backpack
		end
	end
end

-- [ POSE ] --------------------------------------------------------------------
local function place(player: Player, eggId: any, pos: any)
	local data = DataService.Get(player)
	if not data or type(eggId) ~= "string" or typeof(pos) ~= "Vector3" then return end
	if pos.X ~= pos.X or pos.Y ~= pos.Y or pos.Z ~= pos.Z then return end -- NaN : refusé
	local def = Eggs.ById[eggId]
	if not def or (data.Eggs[eggId] or 0) <= 0 then return end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not root or not ((root.Position - pos).Magnitude <= 60) then return end
	local u, v = PlotService.ToPen(player, pos)
	if not u or not v then
		Net.Notify(player, "Place eggs inside YOUR chalet!", "error")
		return
	end
	local maxEggs = Upgrades.BaseUpgradeById.EggSlots.Value((data.Up and data.Up.EggSlots) or 0)
		+ ((data.Passes and data.Passes.TripleEgg) and 3 or 0)
	local hatching = 0
	for _ in pairs(data.Incubating) do hatching += 1 end
	if hatching >= maxEggs then
		Net.Notify(player, "Max " .. maxEggs .. " eggs hatching at once! Buy Hatch slots in the Shop.", "error")
		return
	end
	-- chalet plein de brainrots : 2 œufs peuvent quand même éclore (PlotService.FreeEggs)
	if hatching >= PlotService.FreeEggs and not PlotService.FreeSlot(data) then
		Net.Notify(player, "Your chalet is full! Wait for your eggs or buy Chalet slots in the Shop.", "error")
		return
	end
	data.Eggs[eggId] -= 1
	if data.Eggs[eggId] <= 0 then data.Eggs[eggId] = nil end
	local uid = "E" .. tostring(data.NextUid)
	data.NextUid += 1
	-- l'œuf éclot plus vite avec la rune de vitesse
	local speed = (1 + (data.Runes.Speed or 0)) * ((data.Passes and data.Passes.Hatch) and 2 or 1)
	local hatchMult = Upgrades.BaseUpgradeById.HatchSpeed.Value((data.Up and data.Up.HatchSpeed) or 0)
	local hatch = math.max(3, math.floor(def.HatchTime * hatchMult / speed))
	local inc = { Egg = eggId, HatchAt = os.time() + hatch, U = math.clamp(u, -0.45, 0.45), V = math.clamp(v, -0.45, 0.45) }
	data.Incubating[uid] = inc
	PlotService.RenderEgg(player, uid, inc)
	DataService.Push(player, "Eggs")
	DataService.Push(player, "Incubating")
	EggService.SyncTools(player, data)
	Net.Fire(player, "EggPlaced", { Egg = eggId, HatchIn = hatch })
end

-- [ ÉCLOSION ] -----------------------------------------------------------------
local MAX_PETS = 500 -- inventaire max : au-delà l'œuf attend (le joueur doit vendre / fusionner)
local fullWarned: { [Player]: number } = {}
local function hatch(player: Player, data: any, uid: string)
	local inc = data.Incubating[uid]
	if not inc then return end
	local n = 0
	for _ in pairs(data.Pets) do n += 1 end
	if n >= MAX_PETS then
		if os.clock() - (fullWarned[player] or 0) > 60 then
			fullWarned[player] = os.clock()
			Net.Notify(player, "Pet inventory full (" .. MAX_PETS .. ")! Sell or fuse some to hatch your eggs.", "error")
		end
		return
	end
	local def = Eggs.ById[inc.Egg]
	local pos = PlotService.EggPosition(player, uid)
	if not def then
		data.Incubating[uid] = nil
		PlotService.RenderEgg(player, uid, nil)
		return
	end
	local eggLuck = Upgrades.BaseUpgradeById.EggLuck.Value((data.Up and data.Up.EggLuck) or 0)
	local rarity = Eggs.RollRarity(rng, def, Stats.Luck(data) * eggLuck)
	local pool = Pets.ByRarity[rarity] or Pets.ByRarity.Common
	local br = pool[rng:NextInteger(1, #pool)]
	local mut = Mutations.Roll(rng, Stats.Luck(data))
	local HarvestService = require(script.Parent.HarvestService) :: any
	local bUid = HarvestService.AddPet(player, data, br.Id, mut)
	-- le pet existe : l'œuf peut disparaître (si une erreur arrive avant, l'œuf n'est pas perdu)
	data.Incubating[uid] = nil
	PlotService.RenderEgg(player, uid, nil)
	-- l'œuf libère sa place : le pet la prend tout de suite
	local slot = PlotService.FreeSlot(data)
	if slot then data.Pets[bUid].Slot = slot end
	PlotService.Refresh(player)
	DataService.Push(player, "Incubating")
	DataService.Push(player, "Pets")
	DataService.Push(player, "Index")
	Net.Fire(player, "PetFound", { Uid = bUid, Id = br.Id, Mut = mut, Rarity = rarity, Egg = inc.Egg, Pos = pos })
	local RewardsService = require(script.Parent.RewardsService) :: any
	RewardsService.Progress(player, "Hatch", 1)
	if rarity == "Secret" then RewardsService.Progress(player, "Secret", 1) end
	-- annonce pour les très rares
	local order = Pets.RarityById[rarity].Order
	if order >= 4 or mut ~= "Normal" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				Net.Fire(p, "ServerAnnounce", { Player = player.Name, Id = br.Id, Mut = mut, Rarity = rarity })
			end
		end
	end
end

-- éclosion immédiate payante en temps : "skip" (bouton sur l'œuf, coût = argent)
-- œuf visé par l'achat Robux "Hatch Now" (le reçu ne dit pas quel œuf : on le retient avant l'achat)
local skipTarget: { [Player]: string } = {}
function EggService.GrantSkip(player: Player, data: any): boolean
	local uid = skipTarget[player]
	if not uid or not data.Incubating[uid] then
		-- œuf déjà éclos : on fait éclore celui qui finit le plus tard
		local best, at = nil, -1
		for u, inc in pairs(data.Incubating) do if inc.HatchAt > at then best, at = u, inc.HatchAt end end
		uid = best
	end
	if not uid then
		-- plus aucun œuf en incubation : on rend un œuf de la meilleure zone
		data.Eggs.GoldenEgg = (data.Eggs.GoldenEgg or 0) + 1
		DataService.Push(player, "Eggs"); EggService.SyncTools(player, data)
		Net.Notify(player, "No egg to hatch: you got a Golden Egg instead!", "success")
		return true
	end
	skipTarget[player] = nil
	hatch(player, data, uid :: string)
	return true
end

-- [GIFT] Skip Timer : un joueur paie (Robux uniquement) pour faire éclore tout de suite l'œuf d'un AUTRE joueur.
-- Le reçu ne dit pas quel œuf : le client envoie la cible (GiftSkipTarget) juste avant d'ouvrir l'achat,
-- le serveur la vérifie et la retient. L'acheteur ne perd jamais son achat (œuf doré si plus rien à faire éclore).
local giftTarget: { [Player]: { Owner: number, Uid: string } } = {}
local function latestEgg(data: any): string?
	local best, at = nil, -1
	for u, inc in pairs(data.Incubating) do if inc.HatchAt > at then best, at = u, inc.HatchAt end end
	return best
end
local function giftFallback(buyer: Player, buyerData: any, why: string)
	buyerData.Eggs.GoldenEgg = (buyerData.Eggs.GoldenEgg or 0) + 1
	DataService.Push(buyer, "Eggs"); EggService.SyncTools(buyer, buyerData)
	Net.Notify(buyer, why .. " You got a Golden Egg instead!", "success")
end
function EggService.GrantGiftSkip(buyer: Player, buyerData: any): boolean
	local t = giftTarget[buyer]
	giftTarget[buyer] = nil
	local owner = t and Players:GetPlayerByUserId(t.Owner)
	local odata = owner and owner ~= buyer and DataService.Get(owner)
	if not owner or not odata then
		giftFallback(buyer, buyerData, "That player left the game.")
		return true
	end
	local uid = t and t.Uid
	-- l'œuf visé a éclos entre-temps : on offre celui du même joueur qui finit le plus tard
	if not uid or not odata.Incubating[uid] then uid = latestEgg(odata) end
	if not uid then
		giftFallback(buyer, buyerData, "That egg already hatched.")
		return true
	end
	local def = Eggs.ById[odata.Incubating[uid].Egg]
	local eggName = def and def.Name or "egg"
	hatch(owner, odata, uid)
	if odata.Incubating[uid] then
		-- pas éclos (inventaire de pets plein du joueur)
		giftFallback(buyer, buyerData, owner.DisplayName .. "'s pet inventory is full.")
		return true
	end
	task.spawn(function() pcall(DataService.SaveNow, owner) end)
	Net.Notify(owner, "🎁 " .. buyer.DisplayName .. " gifted you an instant hatch!", "success")
	Net.Notify(buyer, "🎁 You hatched " .. owner.DisplayName .. "'s " .. eggName .. "!", "success")
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= buyer and p ~= owner then
			Net.Notify(p, "🎁 " .. buyer.DisplayName .. " gifted " .. owner.DisplayName .. " an instant hatch!", "info")
		end
	end
	return true
end

-- prix du skip en argent : selon l'œuf (sa zone), le niveau du joueur (rebirths) et ses revenus,
-- multiplié par la part de temps qui reste (plus l'œuf est avancé, moins c'est cher). Le prix Robux ne change pas.
local SKIP_BASE = {
	SnowEgg = 150, PineEgg = 900, FrozenEgg = 5000, CrystalEgg = 30000,
	GlacierEgg = 180000, AuroraEgg = 1000000, NorthPoleEgg = 6000000, GoldenEgg = 25000,
}
local SKIP_REBIRTH_POW = 1.6 -- x(1 + rebirths)^1.6 : x3 au 1er rebirth, x6 au 2e, x60 au 12e
local SKIP_INCOME_MULT = 1.5 -- jamais moins que 1,5x ce que la base rapporte pendant l'éclosion complète
local SKIP_MIN = 50
local function skipCost(data: any, inc: any): (number, number, number)
	local left = math.max(0, inc.HatchAt - os.time())
	local def = Eggs.ById[inc.Egg]
	local full = def and def.HatchTime or 60
	local frac = math.clamp(left / math.max(full, 1), 0.05, 1)
	local byLevel = (SKIP_BASE[inc.Egg] or 1000) * (1 + (data.Rebirths or 0)) ^ SKIP_REBIRTH_POW
	local byIncome = Stats.BaseIncome(data) * full * SKIP_INCOME_MULT
	return math.max(SKIP_MIN, math.floor(math.max(byLevel, byIncome) * frac)), left, full
end

local function skip(player: Player, uid: any)
	local data = DataService.Get(player)
	if not data or type(uid) ~= "string" then return end
	local inc = data.Incubating[uid]
	if not inc then return end
	local cost, left = skipCost(data, inc)
	if left <= 0 then return end
	if data.Money < cost then Net.Notify(player, "Not enough money to skip!", "error"); return end
	data.Money -= cost
	DataService.Push(player, "Money")
	hatch(player, data, uid)
end

function EggService.Start()
	Net.On("PlaceEgg", place, 6, 6)
	Net.On("SkipEgg", skip, 2, 2)
	Net.On("GiftSkipTarget", function(player: Player, ownerId: any, uid: any)
		if type(ownerId) ~= "number" or type(uid) ~= "string" or ownerId == player.UserId then return end
		local owner = Players:GetPlayerByUserId(ownerId)
		local odata = owner and DataService.Get(owner)
		if odata and odata.Incubating[uid] then giftTarget[player] = { Owner = ownerId, Uid = uid } end
	end, 3, 5)
	Net.On("SkipTarget", function(player: Player, uid: any)
		local data = DataService.Get(player)
		if data and type(uid) == "string" and data.Incubating[uid] then skipTarget[player] = uid end
	end, 2, 3)
	Net.OnInvoke("SkipCost", function(player: Player, uid: any)
		local data = DataService.Get(player)
		local inc = data and type(uid) == "string" and data.Incubating[uid]
		if not inc then return nil end
		local cost, left, full = skipCost(data, inc)
		return { Left = left, Cost = cost, Full = full, Egg = inc.Egg }
	end, 3, 5)
	DataService.OnLoaded(function(player, data)
		local function give()
			task.wait(0.4)
			EggService.SyncTools(player, data)
		end
		if player.Character then task.spawn(give) end
		player.CharacterAdded:Connect(give)
	end)
	Players.PlayerRemoving:Connect(function(p) fullWarned[p] = nil; skipTarget[p] = nil; giftTarget[p] = nil end)
	-- éclosions : toutes les secondes
	task.spawn(function()
		while true do
			task.wait(1)
			local now = os.time()
			for _, player in ipairs(Players:GetPlayers()) do
				local data = DataService.Get(player)
				if data and PlotService.GetPlot(player) then
					for uid, inc in pairs(data.Incubating) do
						if inc.HatchAt <= now then
							local ok, err = pcall(hatch, player, data, uid)
							if not ok then warn("[EggService] hatch : " .. tostring(err)) end
						end
					end
				end
			end
		end
	end)
end

return EggService
