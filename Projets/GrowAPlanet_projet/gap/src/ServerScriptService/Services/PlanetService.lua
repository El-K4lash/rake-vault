--!strict
-- ServerScriptService/Services/PlanetService
-- Inventaire des planètes : ajouter, équiper / déséquiper, équiper les meilleures,
-- verrouiller (protège de la vente), vendre.
-- Les planètes équipées sont affichées en orbite (attribut "Equipped" sur la base, lu par le client).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Formulas = require(Shared.Util.Formulas)
local Format = require(Shared.Util.Format)
local Planets = require(Shared.Config.Planets)
local Rarities = require(Shared.Config.Rarities)

local Net = require(script.Parent.Parent.Lib.Net)
local State = require(script.Parent.Parent.Lib.State)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)
local IndexService = require(script.Parent.IndexService)

local PlanetService = {}

function PlanetService.Count(data: any): number
	local n = 0
	for _ in pairs(data.Planets) do n += 1 end
	return n
end

local function equippedCount(data: any): number
	local n = 0
	for _, p in pairs(data.Planets) do
		if p.Eq then n += 1 end
	end
	return n
end

local function slots(player: Player, data: any): number
	return Formulas.EquipSlots(State.Build(player, data))
end

-- met à jour l'orbite visible (liste "Id:Mutation" séparée par des virgules)
function PlanetService.RefreshOrbit(player: Player)
	local data = DataService.Get(player)
	local plot = PlotService.Get(player)
	if not data or not plot then return end
	local list = {}
	for _, p in pairs(data.Planets) do
		if p.Eq then table.insert(list, p.Id .. ":" .. (p.Mut or "")) end
	end
	table.sort(list)
	plot:SetAttribute("Equipped", table.concat(list, ","))
end

-- argent/s de base de toutes les planètes équipées (sans multiplicateurs)
function PlanetService.BaseIncome(data: any): number
	local total = 0
	for _, p in pairs(data.Planets) do
		if p.Eq then total += Formulas.PlanetIncome(p.Id, p.Mut) end
	end
	return total
end

local function changed(player: Player)
	DataService.Push(player, "Planets")
	PlanetService.RefreshOrbit(player)
end

-- ajoute une planète. Équipe automatiquement s'il reste un emplacement.
function PlanetService.Add(player: Player, planetId: string, mutation: string?): (string?, boolean)
	local data = DataService.Get(player)
	if not data or not Planets.ById[planetId] then return nil, false end
	local uid = tostring(data.NextUid)
	data.NextUid += 1
	local entry = { Id = planetId, Mut = mutation, Eq = false, Lock = false }
	data.Planets[uid] = entry
	if equippedCount(data) < slots(player, data) then
		entry.Eq = true
	end
	local isNew = IndexService.Mark(player, planetId, mutation)
	changed(player)
	return uid, isNew
end

local function get(data: any, uid: any): any?
	if type(uid) ~= "string" or #uid > 16 then return nil end
	return data.Planets[uid]
end

function PlanetService.EquipBest(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local list = {}
	for uid, p in pairs(data.Planets) do
		p.Eq = false
		table.insert(list, { uid = uid, income = Formulas.PlanetIncome(p.Id, p.Mut) })
	end
	table.sort(list, function(a, b) return a.income > b.income end)
	for i = 1, math.min(#list, slots(player, data)) do
		data.Planets[list[i].uid].Eq = true
	end
	changed(player)
end

function PlanetService.Start()
	DataService.OnLoaded(function(player, data)
		-- si des emplacements ont disparu (ex. gamepass remboursé), on retire l'excédent
		local maxSlots = slots(player, data)
		if equippedCount(data) > maxSlots then
			PlanetService.EquipBest(player)
		end
		local t = 0
		while not PlotService.Get(player) and t < 10 and player.Parent do
			task.wait(0.2); t += 0.2
		end
		PlanetService.RefreshOrbit(player)
	end)

	Net.On("Equip", function(player, uid)
		local data = DataService.Get(player)
		local p = data and get(data, uid)
		if not p or p.Eq then return end
		if equippedCount(data) >= slots(player, data) then
			Net.Notify(player, "All slots are full! Unequip a planet first.", "warn")
			return
		end
		p.Eq = true
		changed(player)
	end, 8, 12)

	Net.On("Unequip", function(player, uid)
		local data = DataService.Get(player)
		local p = data and get(data, uid)
		if not p or not p.Eq then return end
		p.Eq = false
		changed(player)
	end, 8, 12)

	Net.On("EquipBest", function(player)
		PlanetService.EquipBest(player)
	end, 1, 3)

	Net.On("Lock", function(player, uid)
		local data = DataService.Get(player)
		local p = data and get(data, uid)
		if not p then return end
		p.Lock = not p.Lock
		DataService.Push(player, "Planets")
	end, 6, 10)

	Net.On("Sell", function(player, uid)
		local data = DataService.Get(player)
		local p = data and get(data, uid)
		if not p then return end
		if p.Eq or p.Lock then
			Net.Notify(player, "Unequip / unlock this planet before selling it.", "warn")
			return
		end
		local value = Formulas.SellValue(p.Id, p.Mut)
		data.Planets[uid] = nil
		data.Money += value
		DataService.Push(player, "Money")
		changed(player)
		Net.Notify(player, "Sold for " .. Format.Money(value), "money")
	end, 8, 12)

	-- vend toutes les planètes NON équipées, NON verrouillées, jusqu'à une rareté donnée
	Net.On("SellAll", function(player, maxOrder)
		if not Net.IsInt(maxOrder, 1, #Rarities.List) then return end
		local data = DataService.Get(player)
		if not data then return end
		local total, n = 0, 0
		for uid, p in pairs(data.Planets) do
			local planet = Planets.ById[p.Id]
			if not p.Eq and not p.Lock and planet and Rarities.Info[planet.Rarity].Order <= maxOrder then
				total += Formulas.SellValue(p.Id, p.Mut)
				data.Planets[uid] = nil
				n += 1
			end
		end
		if n == 0 then
			Net.Notify(player, "Nothing to sell.", "warn")
			return
		end
		data.Money += total
		DataService.Push(player, "Money")
		changed(player)
		Net.Notify(player, "Sold " .. n .. " planets for " .. Format.Money(total), "money")
	end, 1, 2)
end

return PlanetService
