--!strict
-- ServerScriptService/Services/IncomeService
-- Toutes les secondes : argent += gains des planètes équipées x multiplicateurs.
-- À l'arrivée : gains hors ligne (50 % pendant 8 h max, réglable dans Config/Upgrades).
-- Affiche aussi l'argent dans le classement (leaderstats).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Formulas = require(Shared.Util.Formulas)
local Format = require(Shared.Util.Format)
local Upgrades = require(Shared.Config.Upgrades)

local Net = require(script.Parent.Parent.Lib.Net)
local State = require(script.Parent.Parent.Lib.State)
local DataService = require(script.Parent.DataService)
local PlanetService = require(script.Parent.PlanetService)

local IncomeService = {}

-- argent/s actuel du joueur, tous bonus compris
function IncomeService.PerSecond(player: Player): number
	local data = DataService.Get(player)
	if not data then return 0 end
	return PlanetService.BaseIncome(data) * Formulas.MoneyMultiplier(State.Build(player, data))
end

function IncomeService.Give(player: Player, amount: number)
	local data = DataService.Get(player)
	if not data or amount <= 0 then return end
	data.Money += amount
	data.TotalEarned += amount
	DataService.Push(player, "Money")
end

local function setupLeaderstats(player: Player, data: any)
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	local money = Instance.new("StringValue")
	money.Name = "Money"
	money.Value = Format.Money(data.Money)
	money.Parent = ls
	local reb = Instance.new("IntValue")
	reb.Name = "Rebirths"
	reb.Value = data.Rebirths
	reb.Parent = ls
	ls.Parent = player
end

function IncomeService.Start()
	DataService.OnLoaded(function(player, data)
		setupLeaderstats(player, data)
		-- gains hors ligne
		if data.LastOnline > 0 then
			local away = math.min(os.time() - data.LastOnline, Upgrades.Base.OfflineMaxHours * 3600)
			if away > 60 then
				local rate = IncomeService.PerSecond(player)
				local gain = math.floor(rate * away * Upgrades.Base.OfflineRate)
				if gain > 0 then
					IncomeService.Give(player, gain)
					Net.Fire(player, "Offline", { Amount = gain, Seconds = away })
				end
			end
		end
		DataService.Push(player) -- envoie toutes les données au client
	end)

	task.spawn(function()
		while true do
			task.wait(1)
			for _, player in ipairs(Players:GetPlayers()) do
				local data = DataService.Get(player)
				if data then
					local rate = IncomeService.PerSecond(player)
					player:SetAttribute("Income", rate)
					data.Stats.Playtime += 1
					if rate > 0 then
						data.Money += rate
						data.TotalEarned += rate
						DataService.Push(player, "Money")
					end
					local ls = player:FindFirstChild("leaderstats")
					if ls then
						(ls :: any).Money.Value = Format.Money(data.Money);
						(ls :: any).Rebirths.Value = data.Rebirths
					end
				end
			end
		end
	end)
end

return IncomeService
