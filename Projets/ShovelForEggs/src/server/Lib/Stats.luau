--!strict
-- ServerScriptService/Lib/Stats
-- Calculs partagés par les services : multiplicateurs, capacité du sac, boosts actifs.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Upgrades = require(Shared.Config.Upgrades)
local Rebirth = require(Shared.Config.Rebirth)
local Items = require(Shared.Config.Items)
local Mutations = require(Shared.Config.Mutations)
local Pets = require(Shared.Config.Pets)
local Levels = require(Shared.Config.Levels)

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

-- chance de pet (multiplicateur)
function Stats.Luck(data: any): number
	local l = 1 + math.min(data.Runes.Luck or 0, Items.RuneCaps.Luck)
	if Stats.BoostActive(data, "Luck") then l *= 2 end
	if data.Passes and data.Passes.Luck then l *= 2 end
	return l * Stats.ServerEvent("Luck")
end

-- multiplicateur d'argent (vente + base)
function Stats.MoneyMult(data: any): number
	local m = Rebirth.Mult(data.Rebirths) * (1 + math.min(data.Runes.Income or 0, Items.RuneCaps.Income))
	-- Index : +5 % d'argent par zone complétée (en plus du +5 % de chance)
	local n = 0
	for _ in pairs(data.IndexClaimed or {}) do n += 1 end
	m *= 1 + 0.05 * n
	if Stats.BoostActive(data, "Money") then m *= 2 end
	if data.Passes and data.Passes.Money then m *= 2 end
	if data.Passes and data.Passes.VIP then m *= 1.5 end
	return m * Stats.ServerEvent("Money")
end

function Stats.SledCapacity(data: any): number
	local lvl = Upgrades.Sleds[math.clamp(data.Sled, 1, #Upgrades.Sleds)]
	local cap = lvl.Value + math.min(data.Runes.Sled or 0, Items.RuneCaps.Sled)
	if data.Passes and data.Passes.VIP then cap = math.floor(cap * 1.5) end
	return cap
end

function Stats.SledCount(data: any): number
	local n = 0
	for _, c in pairs(data.SledItems) do n += c end
	return n
end

function Stats.ShovelCooldown(data: any): number
	return Upgrades.ShovelCooldown / (1 + math.min(data.Runes.Speed or 0, Items.RuneCaps.Speed))
end

-- revenu d'un pet ($/s) avec mutation, niveau et multiplicateurs du joueur
function Stats.PetIncome(data: any, entry: any): number
	local br = Pets.ById[entry.Id]
	if not br then return 0 end
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	return br.Income * mut.Mult * Levels.IncomeMult(Levels.Of(entry)) * Stats.MoneyMult(data)
end

-- prix de vente d'un pet (+ la moitié de l'argent investi dans ses niveaux)
function Stats.PetSellPrice(data: any, entry: any): number
	local br = Pets.ById[entry.Id]
	if not br then return 0 end
	local r = Pets.RarityById[br.Rarity]
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	return math.floor(br.Income * mut.Mult * r.SellMult + Levels.Refund(entry))
end

function Stats.BaseIncome(data: any): number
	local total = 0
	for _, e in pairs(data.Pets) do
		if e.Slot and e.Slot > 0 then total += Stats.PetIncome(data, e) end
	end
	return total
end

return Stats
