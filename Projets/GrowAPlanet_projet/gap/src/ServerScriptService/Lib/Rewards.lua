--!strict
-- ServerScriptService/Lib/Rewards
-- Donne une récompense décrite dans la Config (daily, codes, packs) :
--   { Type = "Money", Amount = 1000 } ou { Type = "Money", Minutes = 10, Min = 1000 }
--   { Type = "Galaxy", Galaxy = "GoldenCrown" }
--   { Type = "Boost", Boost = "Luck", Duration = 900 }
-- Renvoie un petit texte pour l'affichage.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Galaxies = require(Shared.Config.Galaxies)

local Services = script.Parent.Parent.Services
local DataService = require(Services.DataService)
local IncomeService = require(Services.IncomeService)
local IncubatorService = require(Services.IncubatorService)

local Rewards = {}

function Rewards.AddBoost(player: Player, boost: string, duration: number)
	local data = DataService.Get(player)
	if not data then return end
	local now = os.time()
	data.Boosts[boost] = math.max(data.Boosts[boost] or 0, now) + duration
	DataService.Push(player, "Boosts")
end

function Rewards.Give(player: Player, reward: any): string
	if reward.Type == "Money" then
		local amount = reward.Amount
		if not amount then
			amount = math.max(reward.Min or 0, math.floor(IncomeService.PerSecond(player) * (reward.Minutes or 1) * 60))
		end
		IncomeService.Give(player, amount)
		return Format.Money(amount)
	elseif reward.Type == "Galaxy" then
		IncubatorService.Give(player, reward.Galaxy)
		local g = Galaxies.ById[reward.Galaxy]
		return (g and g.Name or reward.Galaxy) .. " Galaxy"
	elseif reward.Type == "Boost" then
		Rewards.AddBoost(player, reward.Boost, reward.Duration)
		return "x2 " .. reward.Boost .. " (" .. Format.Time(reward.Duration) .. ")"
	end
	return ""
end

return Rewards
