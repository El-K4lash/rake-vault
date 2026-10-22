--!strict
-- ServerScriptService/Lib/Stats
-- Calculs partagés par les services : multiplicateurs, capacité du sac, boosts actifs.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Upgrades = require(Shared.Config.Upgrades)
local Rebirth = require(Shared.Config.Rebirth)
local Items = require(Shared.Config.Items)
local Mutations = require(Shared.Config.Mutations)
local Brainrots = require(Shared.Config.Brainrots)

local Stats = {}

-- événement serveur lancé depuis le panel admin (attributs sur workspace : Event<Stat> = multiplicateur, Event<Stat>End = fin)
function Stats.ServerEvent(stat: string): number
	local m = workspace:GetAttribute("Event" .. stat)
	local e = workspace:GetAttribute("Event" .. stat .. "End")
	if type(m) == "number" and type(e) == "number" and e > os.time() then return m end
	return 1
end

function Stats.BoostActive(data: any, stat: string): boolean
	local t = data.Boosts[stat]
	return type(t) == "number" and t > os.time()
end

-- chance de brainrot (multiplicateur)
function Stats.Luck(data: any): number
	local l = 1 + math.min(data.Runes.Luck or 0, Items.RuneCaps.Luck)
	if Stats.BoostActive(data, "Luck") then l *= 2 end
	if data.Passes and data.Passes.Luck then l *= 2 end
	return l * Stats.ServerEvent("Luck")
end

-- multiplicateur d'argent (vente + base)
function Stats.MoneyMult(data: any): number
	local m = Rebirth.Mult(data.Rebirths) * (1 + math.min(data.Runes.Income or 0, Items.RuneCaps.Income))
	if Stats.BoostActive(data, "Money") then m *= 2 end
	if data.Passes and data.Passes.Money then m *= 2 end
	if data.Passes and data.Passes.VIP then m *= 1.5 end
	return m * Stats.ServerEvent("Money")
end

function Stats.BagCapacity(data: any): number
	local lvl = Upgrades.Bags[math.clamp(data.Bag, 1, #Upgrades.Bags)]
	local cap = lvl.Value + math.min(data.Runes.Bag or 0, Items.RuneCaps.Bag)
	if data.Passes and data.Passes.VIP then cap = math.floor(cap * 1.5) end
	return cap
end

function Stats.BagCount(data: any): number
	local n = 0
	for _, c in pairs(data.BagItems) do n += c end
	return n
end

function Stats.RakeCooldown(data: any): number
	return Upgrades.RakeCooldown / (1 + math.min(data.Runes.Speed or 0, Items.RuneCaps.Speed))
end

-- revenu d'un brainrot ($/s) avec mutation et multiplicateurs du joueur
function Stats.BrainrotIncome(data: any, entry: any): number
	local br = Brainrots.ById[entry.Id]
	if not br then return 0 end
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	return br.Income * mut.Mult * Stats.MoneyMult(data)
end

-- prix de vente d'un brainrot
function Stats.BrainrotSellPrice(data: any, entry: any): number
	local br = Brainrots.ById[entry.Id]
	if not br then return 0 end
	local r = Brainrots.RarityById[br.Rarity]
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	return math.floor(br.Income * mut.Mult * r.SellMult)
end

function Stats.BaseIncome(data: any): number
	local total = 0
	for _, e in pairs(data.Brainrots) do
		if e.Slot and e.Slot > 0 then total += Stats.BrainrotIncome(data, e) end
	end
	return total
end

return Stats
