--!strict
-- ServerScriptService/Services/HarvestService
-- Le coup de râteau. Le client dit seulement "Swing" ; le serveur :
--   * vérifie le cooldown (plus long dans le pond), le niveau de rebirth de la zone, la place dans le sac
--   * ramasse les objets dans le rayon du râteau (jusqu'à N par coup selon le râteau)
--   * tire la chance de pet (zone × pond × luck), puis la rareté, le pet, la mutation
--   * donne l'outil râteau au joueur (Assets/Shovels/<niveau>)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Zones = require(Shared.Config.Zones)
local Items = require(Shared.Config.Items)
local Upgrades = require(Shared.Config.Upgrades)
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)
local IndexService = require(script.Parent.IndexService)

local HarvestService = {}
local rng = Random.new()
local lastSwing: { [Player]: number } = {}
-- combo de creusage : coups réussis enchaînés sans traîner -> plus de chance d'œuf
local combo: { [Player]: { N: number, Last: number } } = {}
local function comboMult(n: number): number
	if n >= 50 then return 2 elseif n >= 25 then return 1.6 elseif n >= 10 then return 1.3 end
	return 1
end
HarvestService.ComboMult = comboMult

local function giveShovel(player: Player, data: any)
	local shovels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Shovels")
	local lvl = math.clamp(data.Shovel, 1, #Upgrades.Shovels)
	local template = shovels:FindFirstChild("Shovel" .. lvl) :: Tool?
	if not template then return end
	local backpack = player:FindFirstChildOfClass("Backpack")
	local char = player.Character
	local wasEquipped = false
	if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") and t:GetAttribute("Shovel") then wasEquipped = true end end end
	for _, c in ipairs({ backpack, char }) do
		if c then
			for _, t in ipairs(c:GetChildren()) do
				if t:IsA("Tool") and t:GetAttribute("Shovel") then t:Destroy() end
			end
		end
	end
	local tool = template:Clone()
	tool.Name = "Shovel"
	tool:SetAttribute("Shovel", lvl)
	tool.Parent = backpack
	-- s'il avait le râteau en main, il garde le nouveau en main
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if wasEquipped and hum then hum:EquipTool(tool) end
end
HarvestService.GiveShovel = giveShovel

-- ajoute un pet à l'inventaire, renvoie l'entrée
function HarvestService.AddPet(player: Player, data: any, id: string, mut: string): any
	local uid = tostring(data.NextUid)
	data.NextUid += 1
	local entry = { Id = id, Mut = mut, Slot = 0 }
	data.Pets[uid] = entry
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
local function rollEgg(player: Player, data: any, z: Zones.Zone, inPond: boolean, mult: number?, force: boolean?)
	local luck = Stats.Luck(data) * (inPond and Upgrades.PondLuckMult or 1) * (mult or 1)
	local chance = (z.EggChance or z.PetChance) * luck
	if not force and rng:NextNumber() >= chance then return end
	local eggId = z.Egg
	-- tempête dorée : œuf de la zone du dessus (40 %) ou doré dans la dernière zone
	local StormService = require(script.Parent.StormService) :: any
	eggId = StormService.EggFor(z.Id, eggId)
	data.Eggs[eggId] = (data.Eggs[eggId] or 0) + 1
	data.Stats.Found += 1
	DataService.Push(player, "Eggs")
	Net.Fire(player, "EggFound", { Egg = eggId, Count = data.Eggs[eggId] })
	local RewardsService = require(script.Parent.RewardsService) :: any
	RewardsService.Progress(player, "Egg", 1)
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
		Net.Notify(player, "You need " .. z.Rebirths .. (z.Rebirths == 1 and " rebirth" or " rebirths") .. " for this zone!", "error")
		return
	end
	local inPond = Zones.InPond(z, pos)
	local cd = Stats.ShovelCooldown(data) * (inPond and Upgrades.PondCooldownMult or 1)
	local now = os.clock()
	if now - (lastSwing[player] or 0) < cd * 0.9 then return end
	lastSwing[player] = now

	local cap = Stats.SledCapacity(data)
	local count = Stats.SledCount(data)
	if count >= cap then
		Net.Notify(player, "Sled full! Go sell.", "error")
		Net.Fire(player, "SledFull", nil)
		return
	end
	local shovel = Upgrades.Shovels[math.clamp(data.Shovel, 1, #Upgrades.Shovels)]
	-- objets PERSONNELS du joueur les plus proches dans le rayon (WorldService fait foi)
	local WorldService = require(script.Parent.WorldService) :: any
	local near = WorldService.Near(player, z.Id, pos, shovel.Value2)
	local cs = combo[player] or { N = 0, Last = 0 }
	combo[player] = cs
	local window = math.max(1.2, cd * 2.6)
	if #near == 0 then
		Net.Fire(player, "SwingMiss", nil)
		if now - cs.Last > window and cs.N > 0 then cs.N = 0; Net.Fire(player, "Combo", { N = 0, Mult = 1 }) end
		return
	end
	-- combo : +1 si le coup précédent était réussi il y a peu, sinon on repart à 1
	cs.N = (now - cs.Last <= window) and math.min(cs.N + 1, 999) or 1
	cs.Last = now
	local cm = comboMult(cs.N)
	if cs.N > (data.BestCombo or 0) then data.BestCombo = cs.N end
	Net.Fire(player, "Combo", { N = cs.N, Mult = cm, Window = window })
	local picked, taken = {}, {}
	local RewardsService = require(script.Parent.RewardsService) :: any
	local StormService = require(script.Parent.StormService) :: any
	local rares, chests = 0, 0
	for i = 1, math.min(shovel.Value, #near, cap - count) do
		local r = near[i].r
		local id = r.I
		local def = Items.ById[id]
		if not def then continue end
		local pond = r.P == true
		if def.Kind == "Chest" then
			-- coffre gelé : grosse récompense, rien dans la luge
			chests += 1
			local money = math.floor(600 * z.ItemValueMult * Stats.MoneyMult(data) * rng:NextNumber(1, 1.6))
			data.Money += money; data.TotalEarned += money
			DataService.Push(player, "Money")
			local eggId = StormService.EggFor(z.Id, z.Egg)
			data.Eggs[eggId] = (data.Eggs[eggId] or 0) + 1
			DataService.Push(player, "Eggs")
			local EggService = require(script.Parent.EggService) :: any
			EggService.SyncTools(player, data)
			local charm: string? = nil
			if rng:NextNumber() < 0.25 then
				local stats = { "Luck", "Speed", "Income" }
				charm = stats[rng:NextInteger(1, 3)]
				data.Runes[charm] = math.min((data.Runes[charm] or 0) + 0.02, Items.RuneCaps[charm])
				DataService.Push(player, "Runes")
			end
			Net.Fire(player, "ChestOpened", { Pos = r.C, Money = money, Egg = eggId, Charm = charm })
			table.insert(picked, { Id = id, Pos = r.C })
			table.insert(taken, r.U)
			continue
		end
		if def.Kind == "Rare" then rares += 1 end
		if def.Kind == "Charm" and def.Rune then
			-- bonus permanent, pas dans le sac
			local cur = data.Runes[def.Rune.Stat] or 0
			data.Runes[def.Rune.Stat] = math.min(cur + def.Rune.Amount, Items.RuneCaps[def.Rune.Stat])
			DataService.Push(player, "Runes")
			Net.Notify(player, def.Name .. " : +" .. def.Rune.Stat .. "!", "rune")
		else
			local key = id .. "@" .. z.Id -- la zone fixe la valeur de l'objet
			data.SledItems[key] = (data.SledItems[key] or 0) + 1
		end
		data.Stats.Harvested += 1
		table.insert(picked, { Id = id, Pos = r.C })
		table.insert(taken, r.U)
		-- premier œuf garanti très vite (tuto court) : au 3e tas creusé si aucun œuf trouvé
		local first = (data.Stats.Found or 0) == 0 and data.Stats.Harvested >= 3
		rollEgg(player, data, z, pond, cm, first)
	end
	local dug = #picked - chests
	if dug > 0 then
		RewardsService.Progress(player, "Dig", dug)
		if StormService.Kind() ~= "" then RewardsService.Progress(player, "StormDig", dug) end
	end
	if rares > 0 then RewardsService.Progress(player, "Rare", rares) end
	if chests > 0 then RewardsService.Progress(player, "Chest", chests) end
	RewardsService.Progress(player, "Combo", cs.N)
	WorldService.Take(player, z.Id, taken)
	DataService.Push(player, "SledItems")
	Net.Fire(player, "Harvested", picked)
	if Stats.SledCount(data) >= cap then
		Net.Fire(player, "SledFull", nil)
	end
end

function HarvestService.Start()
	Net.On("Swing", onSwing, 6, 4)
	DataService.OnLoaded(function(player, data)
		local function equip()
			giveShovel(player, data)
		end
		if player.Character then equip() end
		player.CharacterAdded:Connect(function() task.wait(0.2); equip() end)
	end)
	Players.PlayerRemoving:Connect(function(p) lastSwing[p] = nil; combo[p] = nil end)
end

return HarvestService
