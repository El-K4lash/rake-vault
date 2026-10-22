--!strict
-- ServerScriptService/Services/EggService
-- Œufs : un outil par type d'œuf dans le sac à dos ("Beach Egg x3"). Avec l'outil en main, un clic dans SON enclos
-- pose l'œuf (le client envoie la position, le serveur vérifie). L'œuf éclot après HatchTime en un brainrot
-- (rareté selon l'œuf, mutation tirée au sort) qui part dans l'enclos. Les œufs éclosent aussi hors ligne.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Eggs = require(Shared.Config.Eggs)
local Upgrades = require(Shared.Config.Upgrades)
local Brainrots = require(Shared.Config.Brainrots)
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
	tool.ToolTip = "Click inside your pen to place it"
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
	local def = Eggs.ById[eggId]
	if not def or (data.Eggs[eggId] or 0) <= 0 then return end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not root or (root.Position - pos).Magnitude > 60 then return end
	local u, v = PlotService.ToPen(player, pos)
	if not u or not v then
		Net.Notify(player, "Place eggs inside YOUR pen!", "error")
		return
	end
	local maxEggs = Upgrades.BaseUpgradeById.EggSlots.Value((data.Up and data.Up.EggSlots) or 0)
	local hatching = 0
	for _ in pairs(data.Incubating) do hatching += 1 end
	if hatching >= maxEggs then
		Net.Notify(player, "Max " .. maxEggs .. " eggs hatching at once! Upgrade Egg Slots on your board.", "error")
		return
	end
	if not PlotService.FreeSlot(data) then
		Net.Notify(player, "Your pen is full! Buy more slots in the shop.", "error")
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
local function hatch(player: Player, data: any, uid: string)
	local inc = data.Incubating[uid]
	if not inc then return end
	local def = Eggs.ById[inc.Egg]
	local pos = PlotService.EggPosition(player, uid)
	data.Incubating[uid] = nil
	PlotService.RenderEgg(player, uid, nil)
	if not def then return end
	local eggLuck = Upgrades.BaseUpgradeById.EggLuck.Value((data.Up and data.Up.EggLuck) or 0)
	local rarity = Eggs.RollRarity(rng, def, Stats.Luck(data) * eggLuck)
	local pool = Brainrots.ByRarity[rarity] or Brainrots.ByRarity.Common
	local br = pool[rng:NextInteger(1, #pool)]
	local mut = Mutations.Roll(rng, Stats.Luck(data))
	local HarvestService = require(script.Parent.HarvestService) :: any
	local bUid = HarvestService.AddBrainrot(player, data, br.Id, mut)
	-- l'œuf libère sa place : le brainrot la prend tout de suite
	local slot = PlotService.FreeSlot(data)
	if slot then data.Brainrots[bUid].Slot = slot end
	PlotService.Refresh(player)
	DataService.Push(player, "Incubating")
	DataService.Push(player, "Brainrots")
	DataService.Push(player, "Index")
	Net.Fire(player, "BrainrotFound", { Uid = bUid, Id = br.Id, Mut = mut, Rarity = rarity, Egg = inc.Egg, Pos = pos })
	-- annonce pour les très rares
	local order = Brainrots.RarityById[rarity].Order
	if order >= 4 or mut ~= "Normal" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player then
				Net.Fire(p, "ServerAnnounce", { Player = player.Name, Id = br.Id, Mut = mut, Rarity = rarity })
			end
		end
	end
end

-- éclosion immédiate payante en temps : "skip" (bouton sur l'œuf, coût = argent)
local function skip(player: Player, uid: any)
	local data = DataService.Get(player)
	if not data or type(uid) ~= "string" then return end
	local inc = data.Incubating[uid]
	if not inc then return end
	local left = inc.HatchAt - os.time()
	if left <= 0 then return end
	local cost = math.floor(left * 2 * (1 + data.Rebirths))
	if data.Money < cost then Net.Notify(player, "Not enough money to skip!", "error"); return end
	data.Money -= cost
	DataService.Push(player, "Money")
	hatch(player, data, uid)
end

function EggService.Start()
	Net.On("PlaceEgg", place, 6, 6)
	Net.On("SkipEgg", skip, 2, 2)
	DataService.OnLoaded(function(player, data)
		local function give()
			task.wait(0.4)
			EggService.SyncTools(player, data)
		end
		if player.Character then task.spawn(give) end
		player.CharacterAdded:Connect(give)
	end)
	-- éclosions : toutes les secondes
	task.spawn(function()
		while true do
			task.wait(1)
			local now = os.time()
			for _, player in ipairs(Players:GetPlayers()) do
				local data = DataService.Get(player)
				if data and PlotService.GetPlot(player) then
					for uid, inc in pairs(data.Incubating) do
						if inc.HatchAt <= now then hatch(player, data, uid) end
					end
				end
			end
		end
	end)
end

return EggService
