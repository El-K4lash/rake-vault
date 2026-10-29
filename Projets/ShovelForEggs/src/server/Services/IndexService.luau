--!strict
-- ServerScriptService/Services/IndexService
-- Découvertes (Index) : "Id" et "Id:Mutation". Récompense quand tous les pets d'une zone sont trouvés.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Pets = require(Shared.Config.Pets)
local Zones = require(Shared.Config.Zones)
local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local IndexService = {}

local function zoneComplete(data: any, zoneId: string): boolean
	local any = false
	for _, br in ipairs(Pets.List) do
		if br.Zone == zoneId then
			any = true
			if not data.Index[br.Id] then return false end
		end
	end
	return any
end

function IndexService.Discover(player: Player, data: any, id: string, mut: string)
	local new = false
	if not data.Index[id] then data.Index[id] = true; new = true end
	if mut ~= "Normal" and not data.Index[id .. ":" .. mut] then data.Index[id .. ":" .. mut] = true; new = true end
	if new then
		Net.Fire(player, "IndexNew", { Id = id, Mut = mut })
	end
end

-- réclame le bonus d'une zone complétée : +5 % luck ET +5 % d'argent permanents (Stats.MoneyMult) + 2 œufs dorés
local function onClaim(player: Player, zoneId: any)
	local data = DataService.Get(player)
	if not data or type(zoneId) ~= "string" or not Zones.ById[zoneId] then return end
	if data.IndexClaimed[zoneId] then return end
	if not zoneComplete(data, zoneId) then
		Net.Notify(player, "Find every pet of this zone first!", "error")
		return
	end
	data.IndexClaimed[zoneId] = true
	data.Runes.Luck = (data.Runes.Luck or 0) + 0.05
	data.Eggs.GoldenEgg = (data.Eggs.GoldenEgg or 0) + 2
	DataService.Push(player, "IndexClaimed")
	DataService.Push(player, "Runes")
	DataService.Push(player, "Eggs")
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(player, data)
	local z = Zones.ById[zoneId]
	Net.Notify(player, (z and z.Name or zoneId) .. " index complete: +5% luck, +5% money forever, +2 Golden Eggs!", "success")
	Net.Fire(player, "IndexReward", zoneId)
end

function IndexService.Start()
	Net.On("ClaimIndex", onClaim, 2, 2)
end

return IndexService
