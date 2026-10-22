--!strict
-- ReplicatedStorage/Shared/Config/Upgrades
-- Panneau d'upgrades de la base. Cost(level) = prix pour passer au niveau suivant.

local Upgrades = {
	Luck = {
		Name = "Luck", MaxLevel = 10,
		Value = function(level: number): number return 1 + 0.15 * level end, -- x1.00 → x2.50
		Cost = function(level: number): number return math.floor(1_000 * 3 ^ level) end,
	},
	Spawners = {
		Name = "Spawners", MaxLevel = 2, -- niveau 0 = 1 spawner, niveau 2 = 3 spawners (4e = gamepass)
		Value = function(level: number): number return 1 + level end,
		Cost = function(level: number): number return ({ 25_000, 1_000_000 })[level + 1] or math.huge end,
	},
	HatchSpeed = {
		Name = "Hatch Speed", MaxLevel = 10,
		Value = function(level: number): number return 1 - 0.05 * level end, -- temps x1.00 → x0.50
		Cost = function(level: number): number return math.floor(2_000 * 2.8 ^ level) end,
	},
}

-- règles de base du joueur
Upgrades.Base = {
	EquipSlots = 3,       -- planètes équipées au départ
	IncubatorSlots = 6,   -- galaxies en même temps dans l'enclos
	InventoryMax = 200,   -- planètes stockées max
	OfflineRate = 0.5,    -- 50 % des gains pendant l'absence
	OfflineMaxHours = 8,
	SellSeconds = 20,     -- revendre une planète = 20 s de ses gains de base
	AutoHatchInterval = 2, -- gamepass Auto-Éclore : vérifie toutes les 2 s
}

return Upgrades
