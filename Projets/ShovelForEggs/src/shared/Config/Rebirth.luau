--!strict
-- Shared/Config/Rebirth
-- Coût du rebirth N (argent), bonus permanent, et ce que ça donne.

local M = {}
M.BonusPerRebirth = 0.25   -- +25 % de gains par rebirth
M.SlotsPerRebirth = 1      -- +1 slot de base offert par rebirth (jusqu'au max)

function M.Cost(rebirths: number): number
	-- 10k, 60k, 360k, 2.2M, 13M, 78M, 467M, 2.8B... (x6)
	-- équilibrage du 23/10 (simulation) : 1er rebirth ~10 min, Glacier (5) ~1 h, Aurora (8) ~4 h de jeu.
	-- Avec x3 on finissait toute la montagne en 30 min (les pets gardés au rebirth accélèrent tout).
	return math.floor(10000 * (6 ^ rebirths))
end

function M.Mult(rebirths: number): number
	return 1 + rebirths * M.BonusPerRebirth
end

return M
