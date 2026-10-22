--!strict
-- ServerScriptService/Services/IndexService
-- L'Index retient chaque planète découverte (et chaque version mutée).
-- Compléter une rareté (les 5 planètes, version normale) = bonus d'argent permanent à réclamer.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Planets = require(Shared.Config.Planets)
local IndexRewards = require(Shared.Config.IndexRewards)
local Format = require(Shared.Util.Format)

local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local IndexService = {}

-- marque une planète comme découverte. Renvoie true si c'est une nouvelle entrée.
function IndexService.Mark(player: Player, planetId: string, mutation: string?): boolean
	local data = DataService.Get(player)
	if not data then return false end
	local isNew = false
	if not data.Index[planetId] then
		data.Index[planetId] = true
		isNew = true
	end
	if mutation then
		local k = planetId .. ":" .. mutation
		if not data.Index[k] then
			data.Index[k] = true
			isNew = true
		end
	end
	if isNew then DataService.Push(player, "Index") end
	return isNew
end

function IndexService.IsComplete(data: any, rarity: string): boolean
	local pool = Planets.ByRarity[rarity]
	if not pool then return false end
	for _, p in ipairs(pool) do
		if not data.Index[p.Id] then return false end
	end
	return true
end

function IndexService.Start()
	Net.On("ClaimIndex", function(player, rarity)
		if not Net.IsString(rarity, 16) or not IndexRewards.Bonus[rarity] then return end
		local data = DataService.Get(player)
		if not data or data.IndexClaimed[rarity] then return end
		if not IndexService.IsComplete(data, rarity) then
			Net.Notify(player, "Discover every " .. rarity .. " planet first!", "warn")
			return
		end
		data.IndexClaimed[rarity] = true
		DataService.Push(player, "IndexClaimed")
		Net.Notify(player, rarity .. " collection complete! +" .. Format.Percent(IndexRewards.Bonus[rarity]) .. " money forever!", "success")
		Net.Fire(player, "IndexClaimed", rarity)
	end, 1, 3)
end

return IndexService
