--!strict
-- ReplicatedStorage/Shared/Config/Rebirth
-- Rebirth : argent remis à 0. On GARDE planètes, upgrades et galaxies dans l'enclos.
-- Gain : multiplicateur d'argent permanent + 1 emplacement d'équipement (max +5).

local Rebirth = {
	Cost = function(rebirths: number): number return math.floor(10_000_000 * 4 ^ rebirths) end,
	Multiplier = function(rebirths: number): number return 1 + 0.5 * rebirths end,
	BonusSlots = function(rebirths: number): number return math.min(rebirths, 5) end,
}

return Rebirth
