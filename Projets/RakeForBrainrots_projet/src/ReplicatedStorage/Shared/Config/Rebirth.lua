--!strict
-- Shared/Config/Rebirth
-- Coût du rebirth N (argent), bonus permanent, et ce que ça donne.

local M = {}
M.BonusPerRebirth = 0.25   -- +25 % de gains par rebirth
M.SlotsPerRebirth = 1      -- +1 slot de base offert par rebirth (jusqu'au max)

function M.Cost(rebirths: number): number
	-- 5k, 15k, 45k, 135k... (x3) plafonné pour rester faisable
	return math.floor(5000 * (3 ^ rebirths))
end

function M.Mult(rebirths: number): number
	return 1 + rebirths * M.BonusPerRebirth
end

return M
