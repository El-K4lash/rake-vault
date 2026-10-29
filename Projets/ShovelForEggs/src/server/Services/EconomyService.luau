--!strict
-- ServerScriptService/Services/EconomyService
-- Vente (pads de vente, touchés côté serveur), achats du shop (râteau, sac, slots), vente de pets.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Items = require(Shared.Config.Items)
local Zones = require(Shared.Config.Zones)
local Upgrades = require(Shared.Config.Upgrades)
local Pets = require(Shared.Config.Pets)
local Admins = require(Shared.Config.Admins)
local GroupService = game:GetService("GroupService")

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)
local HarvestService = require(script.Parent.HarvestService)
local PlotService = require(script.Parent.PlotService)

local EconomyService = {}
local lastSell: { [Player]: number } = {}

-- valeur d'un objet : base × zone d'origine... on ne stocke pas la zone, donc on prend
-- la zone la plus haute où l'objet existe (simple et lisible pour le joueur).
local itemMult: { [string]: number } = {}
for _, z in ipairs(Zones.List) do
	for _, list in ipairs({ z.Items, z.PondItems }) do
		for _, id in ipairs(list) do
			itemMult[id] = math.max(itemMult[id] or 1, z.ItemValueMult)
		end
	end
end

-- clé du sac : "ItemId@ZoneId" (la zone où l'objet a été ramassé fixe sa valeur)
function EconomyService.ItemValue(data: any, key: string): number
	local id, zoneId = string.match(key, "^(.-)@(.+)$")
	id = id or key
	local def = Items.ById[id]
	if not def then return 0 end
	local z = zoneId and Zones.ById[zoneId]
	local mult = z and z.ItemValueMult or (itemMult[id] or 1)
	return math.floor(def.Value * mult * Stats.MoneyMult(data))
end

function EconomyService.SellAll(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local now = os.clock()
	if now - (lastSell[player] or 0) < 1 then return end
	lastSell[player] = now
	local total, count = 0, 0
	for id, c in pairs(data.SledItems) do
		total += EconomyService.ItemValue(data, id) * c
		count += c
	end
	if count == 0 then return end
	data.SledItems = {}
	data.Money += total
	data.TotalEarned += total
	data.Stats.Sold += count
	DataService.Push(player, "SledItems")
	DataService.Push(player, "Money")
	Net.Fire(player, "Sold", { Money = total, Count = count })
	local RewardsService = require(script.Parent.RewardsService) :: any
	RewardsService.Progress(player, "Sell", count)
end

local function buyShovel(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local nextLvl = data.Shovel + 1
	local def = Upgrades.Shovels[nextLvl]
	if not def then Net.Notify(player, "Max shovel!", "error"); return end
	if data.Money < def.Price then Net.Notify(player, "Not enough money!", "error"); return end
	data.Money -= def.Price
	data.Shovel = nextLvl
	DataService.Push(player, "Money")
	DataService.Push(player, "Shovel")
	HarvestService.GiveShovel(player, data)
	Net.Notify(player, def.Name .. " bought!", "success")
end

local function buySled(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local nextLvl = data.Sled + 1
	local def = Upgrades.Sleds[nextLvl]
	if not def then Net.Notify(player, "Max sled!", "error"); return end
	if data.Money < def.Price then Net.Notify(player, "Not enough money!", "error"); return end
	data.Money -= def.Price
	data.Sled = nextLvl
	DataService.Push(player, "Money")
	DataService.Push(player, "Sled")
	Net.Notify(player, def.Name .. " bought!", "success")
end

local function buySlot(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local n = data.Slots + 1
	if n > Upgrades.MaxSlots then Net.Notify(player, "Max slots!", "error"); return end
	local price = Upgrades.SlotPrices[n] or 0
	if data.Money < price then Net.Notify(player, "Not enough money!", "error"); return end
	data.Money -= price
	data.Slots = n
	DataService.Push(player, "Money")
	DataService.Push(player, "Slots")
	Net.Notify(player, "Chalet slot " .. n .. " unlocked! Your chalet got bigger.", "success")
	PlotService.Refresh(player)
end

local function sellPet(player: Player, uid: any)
	local data = DataService.Get(player)
	if not data or type(uid) ~= "string" then return end
	local entry = data.Pets[uid]
	if not entry then return end
	local price = Stats.PetSellPrice(data, entry)
	data.Pets[uid] = nil
	PlotService.Remove(player, uid)
	data.Money += price
	data.TotalEarned += price
	DataService.Push(player, "Pets")
	DataService.Push(player, "Money")
	Net.Fire(player, "Sold", { Money = price, Count = 0, Pet = entry.Id })
end

-- clôture : achète (si pas possédée) puis équipe
local function buyFence(player: Player, id: any)
	local data = DataService.Get(player)
	if not data or type(id) ~= "string" then return end
	local def = Upgrades.FenceById[id]
	if not def then return end
	if not data.Fences[id] then
		if data.Money < def.Price then Net.Notify(player, "Not enough money!", "error"); return end
		data.Money -= def.Price
		data.Fences[id] = true
		DataService.Push(player, "Money")
		Net.Notify(player, def.Name .. " bought!", "success")
	end
	data.Fence = id
	DataService.Push(player, "Fences")
	DataService.Push(player, "Fence")
	PlotService.Refresh(player)
end

-- coffre du hub : un œuf gratuit (meilleure zone débloquée) toutes les 10 minutes
-- Réservé aux membres du groupe (Admins.GroupId) qui ont mis le jeu en favori : sinon la fenêtre GroupChest s'ouvre.
local CHEST_COOLDOWN = 600
local inGroup: { [Player]: boolean } = {}
-- fresh = après "rejoindre" dans le jeu : IsInGroup garde l'ancienne réponse en cache, GetGroupsAsync non
local function checkGroup(p: Player, fresh: boolean?): boolean
	local gid = (Admins :: any).GroupId
	if not gid then return true end
	if not fresh and inGroup[p] ~= nil then return inGroup[p] end
	local ok, yes
	if fresh then
		ok, yes = pcall(function()
			for _, g in ipairs(GroupService:GetGroupsAsync(p.UserId)) do
				if g.Id == gid then return true end
			end
			return false
		end)
	else
		ok, yes = pcall(p.IsInGroup, p, gid)
	end
	if ok then inGroup[p] = yes == true end
	return inGroup[p] == true
end
function EconomyService.ChestStatus(p: Player, fresh: boolean?): any
	local data = DataService.Get(p)
	local left = data and math.max(0, (data.ChestAt or 0) - os.time()) or 0
	return { Group = checkGroup(p, fresh), Fav = data ~= nil and data.Favorited == true, Left = left, GroupId = (Admins :: any).GroupId }
end

function EconomyService.OpenChest(p: Player)
	local data = DataService.Get(p)
	if not data then return end
	if not checkGroup(p) or data.Favorited ~= true then
		Net.Fire(p, "ChestLocked", EconomyService.ChestStatus(p))
		return
	end
	local now = os.time()
	if (data.ChestAt or 0) > now then
		local left = data.ChestAt - now
		Net.Notify(p, string.format("Chest ready in %d:%02d", left // 60, left % 60), "error")
		return
	end
	local best = Zones.List[1]
	for _, z in ipairs(Zones.List) do
		if (data.Rebirths or 0) >= z.Rebirths then best = z end
	end
	local eggId = best.Egg
	data.Eggs[eggId] = (data.Eggs[eggId] or 0) + 1
	data.ChestAt = now + CHEST_COOLDOWN
	DataService.Push(p, "Eggs")
	DataService.Push(p, "ChestAt")
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(p, data)
	Net.Fire(p, "EggFound", { Egg = eggId, Chest = true })
	Net.Notify(p, "Free " .. best.Name .. " Egg! Place it in your chalet.", "success")
end

function EconomyService.Start()
	Net.On("BuyShovel", buyShovel, 2, 2)
	Net.On("BuySled", buySled, 2, 2)
	Net.On("BuySlot", buySlot, 2, 2)
	Net.On("SellPet", sellPet, 3, 3)
	Net.On("BuyFence", buyFence, 2, 2)
	Net.On("Sell", EconomyService.SellAll, 1, 2)
	-- coffre du groupe (fenêtre GroupChest)
	Net.OnInvoke("ChestStatus", function(p: Player) return EconomyService.ChestStatus(p) end, 2, 4)
	Net.OnInvoke("GroupJoined", function(p: Player) return EconomyService.ChestStatus(p, true) end, 1, 2)
	Net.OnInvoke("Favorited", function(p: Player)
		local data = DataService.Get(p)
		if data and not data.Favorited then data.Favorited = true; DataService.Push(p, "Favorited") end
		return EconomyService.ChestStatus(p)
	end, 1, 2)
	Net.OnInvoke("ClaimChest", function(p: Player)
		-- il faut être près du coffre (comme avec l'invite)
		local chest = workspace.Map:FindFirstChild("Hub") and workspace.Map.Hub:FindFirstChild("FreeChest")
		local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart") :: BasePart?
		if chest and root and (chest:GetPivot().Position - root.Position).Magnitude > 40 then
			return { ok = false, msg = "Go to the chest in the lobby!" }
		end
		local st = EconomyService.ChestStatus(p)
		if not (st.Group and st.Fav) then return { ok = false, msg = "Join the group and favorite the game first!" } end
		EconomyService.OpenChest(p)
		return { ok = true }
	end, 1, 2)
	Players.PlayerRemoving:Connect(function(p) inGroup[p] = nil end)

	-- pads de vente : hub + un par zone (Parts nommés SellPad, tag "SellPad")
	local function hook(pad: BasePart)
		pad.Touched:Connect(function(hit)
			local p = Players:GetPlayerFromCharacter(hit.Parent)
			if p then EconomyService.SellAll(p) end
		end)
	end
	local map = workspace:WaitForChild("Map")
	for _, d in ipairs(map:GetDescendants()) do
		if d:IsA("BasePart") and d.Name == "SellPad" then hook(d) end
	end
	-- stands du hub : ProximityPrompt avec l'attribut Action = Sell / Shop / Index / Rebirth
	local function hookPrompt(d: Instance)
		if not d:IsA("ProximityPrompt") or d:GetAttribute("Hooked") then return end
		local action = d:GetAttribute("Action")
		if not action then return end
		d:SetAttribute("Hooked", true)
		d.Triggered:Connect(function(p: Player)
			if action == "Sell" then
				local data = DataService.Get(p)
				if data and Stats.SledCount(data) == 0 then
					Net.Notify(p, "Your sled is empty! Go shovel.", "error")
				else
					EconomyService.SellAll(p)
				end
			elseif action == "Chest" then
				EconomyService.OpenChest(p)
			elseif action == "ToAurora" or action == "FromAurora" then
				-- téléporteurs de l'île volante (Aurora Peak) : il faut les rebirths de la zone pour monter
				local data = DataService.Get(p)
				local char = p.Character
				local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
				local aurora, glacier = Zones.ById.Aurora, Zones.ById.Glacier
				if not data or not root then return end
				if action == "ToAurora" then
					if (data.Rebirths or 0) < aurora.Rebirths then
						Net.Notify(p, "You need " .. aurora.Rebirths .. " rebirths to reach Aurora Peak!", "error")
						return
					end
					local at = aurora.Center + Vector3.new(0, 4, -aurora.Size / 2 + 10)
					char:PivotTo(CFrame.lookAt(at, at + Vector3.new(0, 0, 1)))
					Net.Fire(p, "Teleported", "Aurora")
				else
					local at = glacier.Center + Vector3.new(0, 4, glacier.Size / 2 - 12)
					char:PivotTo(CFrame.lookAt(at, at + Vector3.new(0, 0, -1)))
				end
			else
				Net.Fire(p, "OpenMenu", action)
			end
		end)
	end
	local hub = map:FindFirstChild("Hub")
	if hub then
		for _, d in ipairs(hub:GetDescendants()) do hookPrompt(d) end
		hub.DescendantAdded:Connect(hookPrompt)
	end
	-- téléportations rapides (boutons du HUD) : Base / Sell / Zone (meilleure zone débloquée)
	local lastTp: { [Player]: number } = {}
	Net.On("Teleport", function(p: Player, where: any)
		local char = p.Character
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		local data = DataService.Get(p)
		if not root or not data or type(where) ~= "string" then return end
		local now = os.clock()
		if lastTp[p] and now - lastTp[p] < 2 then return end
		lastTp[p] = now
		local cf: CFrame? = nil
		if where == "Base" then
			cf = PlotService.SpawnCFrame(p)
		elseif where == "Sell" then
			-- devant le stand de vente (sur le bord du pad, face au vendeur), pas dans le stand
			local pad = hub and hub:FindFirstChild("SellPad", true) :: BasePart?
			local stand = hub and hub:FindFirstChild("SellStand") :: Model?
			if stand and pad then
				local scf, ssz = stand:GetBoundingBox()
				local out = -Vector3.new(scf.LookVector.X, 0, scf.LookVector.Z).Unit -- côté lobby
				local base = Vector3.new(scf.Position.X, pad.Position.Y + 3, scf.Position.Z)
				local p = base + out * (ssz.Z / 2 + 4)
				cf = CFrame.lookAt(p, Vector3.new(scf.Position.X, p.Y, scf.Position.Z))
			elseif pad then
				cf = CFrame.new(pad.Position + Vector3.new(0, 4, 7))
			end
		elseif where == "Zone" then
			local best = nil
			for _, z in ipairs(Zones.List) do
				if (data.Rebirths or 0) >= z.Rebirths then best = z end
			end
			local zf = best and map.Zones:FindFirstChild(best.Id)
			local g = zf and zf:FindFirstChild("Ground") :: BasePart?
			-- juste derrière l'arche d'entrée, face au pond (pas au centre : le pond y est)
			if g then
				local p = Vector3.new(g.Position.X, g.Position.Y + g.Size.Y / 2 + 3, g.Position.Z - g.Size.Z / 2 + 8)
				cf = CFrame.lookAt(p, p + Vector3.new(0, 0, 1))
			end
		end
		if cf then char:PivotTo(cf) end
	end, 2, 2)
	Players.PlayerRemoving:Connect(function(p) lastSell[p] = nil; lastTp[p] = nil end)
end

return EconomyService
