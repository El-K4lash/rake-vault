--!strict
-- Shared/Config/Levels
-- Niveaux des brainrots (amélioration avec de l'argent). Partagé serveur + client : même calcul partout.
--   * chaque niveau = +25 % de revenu (Lv 15 = x4.5)
--   * le prix dépend du pet (revenu de base x mutation) et des rebirths du joueur, et monte de x1.4 par niveau
--   * les niveaux restent après un rebirth (les pets ne sont pas perdus)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local Pets = require(Config:WaitForChild("Pets"))
local Mutations = require(Config:WaitForChild("Mutations"))
local Rebirth = require(Config:WaitForChild("Rebirth"))

local M = {}

M.Max = 15            -- niveau maximum
M.PerLevel = 0.25     -- +25 % de revenu par niveau
M.CostSeconds = 20    -- Lv1 -> Lv2 = 20 s du revenu de base du pet (60 s était trop cher au début)
M.CostGrowth = 1.4    -- chaque niveau coûte x1.4 de plus
M.RefundPart = 0.5    -- vente / fusion d'un pet amélioré : on rend la moitié de l'argent investi

-- argent rendu pour les niveaux d'un pet (entry.Spent = ce que le joueur a vraiment payé)
function M.Refund(entry: any): number
	return math.floor((tonumber(entry and entry.Spent) or 0) * M.RefundPart)
end

function M.Of(entry: any): number
	local lv = entry and tonumber(entry.Lv) or 1
	return math.clamp(math.floor(lv), 1, M.Max)
end

-- multiplicateur de revenu d'un niveau
function M.IncomeMult(lv: number?): number
	return 1 + M.PerLevel * (math.clamp(lv or 1, 1, M.Max) - 1)
end

-- taille du brainrot dans l'enclos selon son niveau : Lv 1 = x1, Lv MAX = x1.6
M.MaxScale = 1.6
function M.Scale(lv: number?): number
	return 1 + (M.MaxScale - 1) * (math.clamp(lv or 1, 1, M.Max) - 1) / (M.Max - 1)
end

-- prix pour passer du niveau lv au niveau lv + 1 (nil si déjà au max)
function M.Cost(entry: any, rebirths: number?, lv: number?): number?
	local br = Pets.ById[entry.Id]
	if not br then return nil end
	local l = lv or M.Of(entry)
	if l >= M.Max then return nil end
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	local base = br.Income * mut.Mult * Rebirth.Mult(rebirths or 0) * M.CostSeconds
	return math.max(10, math.floor(base * M.CostGrowth ^ (l - 1)))
end

-- combien de niveaux on peut acheter avec money (max n), et le prix total
function M.Affordable(entry: any, rebirths: number?, money: number, n: number?): (number, number)
	local l = M.Of(entry)
	local count, total = 0, 0
	while count < (n or M.Max) and l < M.Max do
		local c = M.Cost(entry, rebirths, l) :: number
		if total + c > money then break end
		total += c
		count += 1
		l += 1
	end
	return count, total
end

return M
