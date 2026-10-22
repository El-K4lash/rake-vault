--!strict
-- ServerScriptService/Services/HarvestService
-- Le coup de râteau. Le client dit seulement "Swing" ; le serveur :
--   * vérifie le cooldown (plus long dans le pond), le niveau de rebirth de la zone, la place dans le sac
--   * ramasse les objets dans le rayon du râteau (jusqu'à N par coup selon le râteau)
--   * tire la chance de brainrot (zone × pond × luck), puis la rareté, le brainrot, la mutation
--   * donne l'outil râteau au joueur (Assets/Rakes/<niveau>)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Zones = require(Shared.Config.Zones)
local Items = require(Shared.Config.Items)
local Upgrades = require(Shared.Config.Upgrades)
local Brainrots = require(Shared.Config.Brainrots)
local Mutations = require(Shared.Config.Mutations)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)
local IndexService = require(script.Parent.IndexService)

local HarvestService = {}
local rng = Random.new()
local lastSwing: { [Player]: number } = {}

local function giveRake(player: Player, data: any)
	local rakes = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Rakes")
	local lvl = math.clamp(data.Rake, 1, #Upgrades.Rakes)
	local template = rakes:FindFirstChild("Rake" .. lvl) :: Tool?
	if not template then return end
	local backpack = player:FindFirstChildOfClass("Backpack")
	local char = player.Character
	local wasEquipped = false
	if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and t:GetAttribute("Rake") then wasEquipped = true end end end
	for _, c in ipairs({ backpack, char }) do
		if c then
			for _, t in ipairs(c:GetChildren()) do
				if t:IsA("Tool") and t:GetAttribute("Rake") then t:Destroy() end
			end
		end
	end
	local tool = template:Clone()
	tool.Name = "Rake"
	tool:SetAttribute("Rake", lvl)
	tool.Parent = backpack
	-- s'il avait le râteau en main, il garde le nouveau en main
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if wasEquipped and hum then hum:EquipTool(tool) end
end
HarvestService.GiveRake = giveRake

-- ajoute un brainrot à l'inventaire, renvoie l'entrée
function HarvestService.AddBrainrot(player: Player, data: any, id: string, mut: string): any
	local uid = tostring(data.NextUid)
	data.NextUid += 1
	local entry = { Id = id, Mut = mut, Slot = 0 }
	data.Brainrots[uid] = entry
	data.Stats.Found += 1
	IndexService.Discover(player, data, id, mut)
	-- posé tout de suite dans la base s'il reste un slot libre
	task.defer(function()
		local PlotService = require(script.Parent.PlotService) :: any
		PlotService.AutoEquip(player, uid)
	end)
	return uid, entry
end

-- chance de trouver l'œuf de la zone (par objet ramassé). L'œuf va dans la poche (outil dans le sac à dos).
local function rollEgg(player: Player, data: any, z: Zones.Zone, inPond: boolean)
	local luck = Stats.Luck(data) * (inPond and Upgrades.PondLuckMult or 1)
	local chance = (z.EggChance or z.BrainrotChance) * luck
	if rng:NextNumber() >= chance then return end
	local eggId = z.Egg
	data.Eggs[eggId] = (data.Eggs[eggId] or 0) + 1
	data.Stats.Found += 1
	DataService.Push(player, "Eggs")
	Net.Fire(player, "EggFound", { Egg = eggId, Count = data.Eggs[eggId] })
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(player, data)
end

local function onSwing(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not root then return end
	local pos = root.Position
	local z = Zones.At(pos)
	if not z then return end
	if data.Rebirths < z.Rebirths then
		Net.Notify(player, "You need " .. z.Rebirths .. " rebirths for this zone!", "error")
		return
	end
	local inPond = Zones.InPond(z, pos)
	local cd = Stats.RakeCooldown(data) * (inPond and Upgrades.PondCooldownMult or 1)
	local now = os.clock()
	if now - (lastSwing[player] or 0) < cd * 0.9 then return end
	lastSwing[player] = now

	local cap = Stats.BagCapacity(data)
	local count = Stats.BagCount(data)
	if count >= cap then
		Net.Notify(player, "Bag full! Go sell.", "error")
		Net.Fire(player, "BagFull", nil)
		return
	end
	local rake = Upgrades.Rakes[math.clamp(data.Rake, 1, #Upgrades.Rakes)]
	-- objets PERSONNELS du joueur les plus proches dans le rayon (WorldService fait foi)
	local WorldService = require(script.Parent.WorldService) :: any
	local near = WorldService.Near(player, z.Id, pos, rake.Value2)
	if #near == 0 then
		Net.Fire(player, "SwingMiss", nil)
		return
	end
	local picked, taken = {}, {}
	for i = 1, math.min(rake.Value, #near, cap - count) do
		local r = near[i].r
		local id = r.I
		local def = Items.ById[id]
		if not def then continue end
		local pond = r.P == true
		if def.Kind == "Rune" and def.Rune then
			-- bonus permanent, pas dans le sac
			local cur = data.Runes[def.Rune.Stat] or 0
			data.Runes[def.Rune.Stat] = math.min(cur + def.Rune.Amount, Items.RuneCaps[def.Rune.Stat])
			DataService.Push(player, "Runes")
			Net.Notify(player, def.Name .. " : +" .. def.Rune.Stat .. "!", "rune")
		else
			local key = id .. "@" .. z.Id -- la zone fixe la valeur de l'objet
			data.BagItems[key] = (data.BagItems[key] or 0) + 1
		end
		data.Stats.Harvested += 1
		table.insert(picked, { Id = id, Pos = r.C })
		table.insert(taken, r.U)
		rollEgg(player, data, z, pond)
	end
	WorldService.Take(player, z.Id, taken)
	DataService.Push(player, "BagItems")
	Net.Fire(player, "Harvested", picked)
	if Stats.BagCount(data) >= cap then
		Net.Fire(player, "BagFull", nil)
	end
end

function HarvestService.Start()
	Net.On("Swing", onSwing, 6, 4)
	DataService.OnLoaded(function(player, data)
		local function equip()
			giveRake(player, data)
		end
		if player.Character then equip() end
		player.CharacterAdded:Connect(function() task.wait(0.2); equip() end)
	end)
	Players.PlayerRemoving:Connect(function(p) lastSwing[p] = nil end)
end

return HarvestService
