--!strict
-- ServerScriptService/Services/UpgradeService
-- Panneau UPGRADES de l'enclos : achat des améliorations de base (Config/Upgrades.BaseUpgrades, remises à zéro au rebirth).
-- Calcule aussi, toutes les 2 s, les stats affichées sur le panneau STATS (attributs du joueur : Income, Luck, MoneyMult).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Upgrades = require(Shared.Config.Upgrades)
local Format = require(Shared.Util.Format)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)

local UpgradeService = {}

local function level(data: any, id: string): number
	return (data.Up and data.Up[id]) or 0
end

-- applique les effets "physiques" (vitesse de marche)
function UpgradeService.Apply(player: Player, data: any)
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = Upgrades.BaseUpgradeById.WalkSpeed.Value(level(data, "WalkSpeed")) end
end

local function buy(player: Player, id: any)
	local data = DataService.Get(player)
	if not data or type(id) ~= "string" then return end
	local u = Upgrades.BaseUpgradeById[id]
	if not u then return end
	data.Up = data.Up or {}
	local lvl = level(data, id)
	if lvl >= u.Max then Net.Notify(player, u.Name .. " is maxed!", "info"); return end
	if u.Requires and level(data, u.Requires) <= 0 then
		Net.Notify(player, "Unlock " .. Upgrades.BaseUpgradeById[u.Requires].Name .. " first!", "error")
		return
	end
	local cost = Upgrades.UpgradeCost(u, lvl, data.Rebirths)
	if data.Money < cost then Net.Notify(player, "Not enough money! (" .. Format.Money(cost) .. ")", "error"); return end
	data.Money -= cost
	data.Up[id] = lvl + 1
	DataService.Push(player, "Money")
	DataService.Push(player, "Up")
	UpgradeService.Apply(player, data)
	Net.Notify(player, u.Name .. " → " .. u.Show(lvl + 1), "success")
	Net.Fire(player, "Upgraded", id)
end

local function refreshStats(player: Player, data: any)
	player:SetAttribute("Income", Stats.BaseIncome(data))
	player:SetAttribute("Luck", Stats.Luck(data))
	player:SetAttribute("MoneyMult", Stats.MoneyMult(data))
	player:SetAttribute("BagCap", Stats.BagCapacity(data))
end

function UpgradeService.Start()
	Net.On("BuyUpgrade", buy, 4, 4)
	DataService.OnLoaded(function(player, data)
		if player.Character then UpgradeService.Apply(player, data) end
		player.CharacterAdded:Connect(function()
			task.wait(0.2)
			local d = DataService.Get(player)
			if d then UpgradeService.Apply(player, d) end
		end)
		refreshStats(player, data)
	end)
	task.spawn(function()
		while true do
			task.wait(2)
			for _, p in ipairs(Players:GetPlayers()) do
				local d = DataService.Get(p)
				if d then pcall(refreshStats, p, d) end
			end
		end
	end)
end

return UpgradeService
