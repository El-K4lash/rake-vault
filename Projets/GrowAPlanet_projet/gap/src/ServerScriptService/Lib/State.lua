--!strict
-- ServerScriptService/Lib/State
-- Construit l'état "calculable" d'un joueur pour Formulas, à partir de sa sauvegarde
-- et de ses gamepasses (attributs Pass_<Nom> posés par ShopService).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Gamepasses = require(ReplicatedStorage.Shared.Config.Gamepasses)

local State = {}

function State.Build(player: Player, data: any)
	local passes = {}
	for name in pairs(Gamepasses) do
		passes[name] = player:GetAttribute("Pass_" .. name) == true
	end
	return {
		Rebirths = data.Rebirths,
		Upgrades = data.Upgrades,
		Passes = passes,
		Boosts = data.Boosts,
		IndexClaimed = data.IndexClaimed,
		Now = os.time(),
	}
end

return State
