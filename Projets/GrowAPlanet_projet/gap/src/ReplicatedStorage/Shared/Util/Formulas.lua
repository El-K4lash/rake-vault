--!strict
-- ReplicatedStorage/Shared/Util/Formulas
-- TOUTES les règles de calcul du jeu, au même endroit, utilisées par le serveur
-- (qui décide) et par le client (qui affiche les mêmes chiffres).
-- Ce module ne touche à rien dans le jeu : il calcule seulement.

local Config = script.Parent.Parent:WaitForChild("Config")
local Rarities = require(Config:WaitForChild("Rarities"))
local Galaxies = require(Config:WaitForChild("Galaxies"))
local Planets = require(Config:WaitForChild("Planets"))
local Mutations = require(Config:WaitForChild("Mutations"))
local Upgrades = require(Config:WaitForChild("Upgrades"))
local Rebirth = require(Config:WaitForChild("Rebirth"))
local Gamepasses = require(Config:WaitForChild("Gamepasses"))
local IndexRewards = require(Config:WaitForChild("IndexRewards"))

local Formulas = {}

-- État minimal du joueur dont les calculs ont besoin.
-- Le serveur le construit depuis la sauvegarde, le client depuis ce que le serveur lui envoie.
export type PlayerState = {
	Rebirths: number,
	Upgrades: { [string]: number },
	Passes: { [string]: boolean },
	Boosts: { [string]: number }, -- nom -> os.time() de fin
	IndexClaimed: { [string]: boolean }, -- rareté -> bonus de collection réclamé
	Now: number,
}

local function boostActive(state: PlayerState, name: string): boolean
	local ends = state.Boosts[name]
	return ends ~= nil and ends > state.Now
end
Formulas.BoostActive = boostActive

-- [ ARGENT ] -----------------------------------------------------------------

-- argent/s d'une planète seule (sans les bonus du joueur)
function Formulas.PlanetIncome(planetId: string, mutationId: string?): number
	local p = Planets.ById[planetId]
	if not p then return 0 end
	local mult = 1
	if mutationId and Mutations.ById[mutationId] then
		mult = Mutations.ById[mutationId].Multiplier
	end
	return p.Income * mult
end

-- bonus de collection de l'Index (somme des raretés complétées et réclamées)
function Formulas.IndexBonus(state: PlayerState): number
	local total = 0
	for rarity, claimed in pairs(state.IndexClaimed) do
		if claimed and IndexRewards.Bonus[rarity] then
			total += IndexRewards.Bonus[rarity]
		end
	end
	return total
end

-- multiplicateur total d'argent du joueur
function Formulas.MoneyMultiplier(state: PlayerState): number
	local m = Rebirth.Multiplier(state.Rebirths)
	if state.Passes.DoubleMoney then m *= 2 end
	if boostActive(state, "Money") then m *= 2 end
	if state.Passes.VIP then m *= 1 + Gamepasses.VIP.MoneyBonus end
	m *= 1 + Formulas.IndexBonus(state)
	return m
end

-- [ LUCK ] -------------------------------------------------------------------

function Formulas.Luck(state: PlayerState): number
	local l = Upgrades.Luck.Value(state.Upgrades.Luck or 0)
	if state.Passes.DoubleLuck then l *= 2 end
	if boostActive(state, "Luck") then l *= 2 end
	return l
end

-- [ CAPACITÉS ] --------------------------------------------------------------

function Formulas.EquipSlots(state: PlayerState): number
	local n = Upgrades.Base.EquipSlots + Rebirth.BonusSlots(state.Rebirths)
	if state.Passes.ExtraSlots then n += Gamepasses.ExtraSlots.Value end
	return n
end

function Formulas.SpawnerCount(state: PlayerState): number
	local n = Upgrades.Spawners.Value(state.Upgrades.Spawners or 0)
	if state.Passes.FourthSpawner then n += 1 end
	return n
end

-- durée réelle d'éclosion d'une galaxie (secondes)
function Formulas.HatchDuration(galaxyId: string, state: PlayerState): number
	local g = Galaxies.ById[galaxyId]
	if not g then return 10 end
	local t = g.HatchTime * Upgrades.HatchSpeed.Value(state.Upgrades.HatchSpeed or 0)
	if state.Passes.FastHatch then t *= Gamepasses.FastHatch.Value end
	return math.max(1, math.floor(t + 0.5))
end

-- prix de revente d'une planète (en secondes de gains de base)
function Formulas.SellValue(planetId: string, mutationId: string?): number
	return math.floor(Formulas.PlanetIncome(planetId, mutationId) * Upgrades.Base.SellSeconds)
end

-- [ TIRAGES ] ----------------------------------------------------------------
-- rng = Random.new() côté serveur. Toutes les chances sont calculées ici
-- pour que l'affichage des chances (règle Roblox) soit EXACTEMENT ce qui est tiré.

-- poids d'apparition des galaxies sur un spawner, avec la Luck
function Formulas.GalaxyWeights(luck: number): { { id: string, weight: number } }
	local list = {}
	for _, g in ipairs(Galaxies.List) do
		if not g.RobuxOnly then
			local w = g.SpawnWeight
			if Galaxies.Spawn.LuckAffects and Rarities.Info[g.Rarity].Order >= 2 then
				w *= luck
			end
			table.insert(list, { id = g.Id, weight = w })
		end
	end
	return list
end

local function pickWeighted(rng: Random, list: { { id: string, weight: number } }): string
	local total = 0
	for _, e in ipairs(list) do total += e.weight end
	local r = rng:NextNumber() * total
	for _, e in ipairs(list) do
		r -= e.weight
		if r <= 0 then return e.id end
	end
	return list[#list].id
end
Formulas.PickWeighted = pickWeighted

function Formulas.RollGalaxy(rng: Random, luck: number): string
	return pickWeighted(rng, Formulas.GalaxyWeights(luck))
end

-- chance de monter d'une rareté à l'éclosion (plafonnée à 50 %)
function Formulas.UpgradeChance(galaxyId: string, luck: number): number
	local g = Galaxies.ById[galaxyId]
	if not g or not Rarities.Next(g.Rarity) then return 0 end
	return math.min(0.5, g.UpgradeChance * luck)
end

-- liste complète des planètes possibles d'une galaxie avec leur chance exacte
function Formulas.PlanetOdds(galaxyId: string, luck: number): { { id: string, chance: number } }
	local g = Galaxies.ById[galaxyId]
	local odds = {}
	if not g then return odds end
	local up = Formulas.UpgradeChance(galaxyId, luck)
	local function addRarity(rarity: string, share: number)
		local pool = Planets.ByRarity[rarity]
		if not pool or share <= 0 then return end
		local total = 0
		for _, p in ipairs(pool) do total += p.Weight end
		for _, p in ipairs(pool) do
			table.insert(odds, { id = p.Id, chance = share * p.Weight / total })
		end
	end
	addRarity(g.Rarity, 1 - up)
	local nextRarity = Rarities.Next(g.Rarity)
	if nextRarity then addRarity(nextRarity, up) end
	return odds
end

function Formulas.RollPlanet(rng: Random, galaxyId: string, luck: number): string
	local odds = Formulas.PlanetOdds(galaxyId, luck)
	local list = {}
	for _, o in ipairs(odds) do table.insert(list, { id = o.id, weight = o.chance }) end
	return pickWeighted(rng, list)
end

-- chance de chaque mutation avec la Luck
function Formulas.MutationChance(mutationId: string, luck: number): number
	local m = Mutations.ById[mutationId]
	if not m then return 0 end
	return m.Chance * (1 + (luck - 1) * Mutations.LuckFactor)
end

function Formulas.RollMutation(rng: Random, luck: number): string?
	-- un seul tirage pour toutes les mutations : la plus rare est testée en premier
	local r = rng:NextNumber()
	for _, m in ipairs(Mutations.List) do
		local c = Formulas.MutationChance(m.Id, luck)
		if r < c then return m.Id end
		r -= c
	end
	return nil
end

-- [ UPGRADES / REBIRTH ] -----------------------------------------------------

function Formulas.UpgradeCost(name: string, level: number): number?
	local u = Upgrades[name]
	if not u or not u.MaxLevel or level >= u.MaxLevel then return nil end
	return u.Cost(level)
end

function Formulas.RebirthCost(rebirths: number): number
	return Rebirth.Cost(rebirths)
end

return Formulas
