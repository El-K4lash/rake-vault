--!strict
-- ServerScriptService/Services/ProgressService
-- Upgrades de la base, Rebirth, récompenses quotidiennes, codes et paramètres.
-- (petits systèmes regroupés ici pour garder un seul fichier simple)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Formulas = require(Shared.Util.Formulas)
local Format = require(Shared.Util.Format)
local Upgrades = require(Shared.Config.Upgrades)
local DailyRewards = require(Shared.Config.DailyRewards)
local Codes = require(game:GetService("ServerStorage"):WaitForChild("Config"):WaitForChild("Codes"))

local Net = require(script.Parent.Parent.Lib.Net)
local State = require(script.Parent.Parent.Lib.State)
local Rewards = require(script.Parent.Parent.Lib.Rewards)
local DataService = require(script.Parent.DataService)
local IncubatorService = require(script.Parent.IncubatorService)
local PlanetService = require(script.Parent.PlanetService)

local ProgressService = {}

local DAILY_COOLDOWN = 20 * 3600 -- on peut réclamer toutes les 20 h (pas besoin d'attendre minuit)

local function buyUpgrade(player: Player, name: any)
	if not Net.IsString(name, 20) or not Upgrades[name] or not Upgrades[name].MaxLevel then return end
	local data = DataService.Get(player)
	if not data then return end
	local level = data.Upgrades[name] or 0
	local cost = Formulas.UpgradeCost(name, level)
	if not cost then
		Net.Notify(player, "Already maxed!", "warn")
		return
	end
	if data.Money < cost then
		Net.Notify(player, "Not enough money! You need " .. Format.Money(cost - data.Money) .. " more.", "error")
		return
	end
	local oldFactor = Upgrades.HatchSpeed.Value(data.Upgrades.HatchSpeed or 0)
	data.Money -= cost
	data.Upgrades[name] = level + 1
	DataService.Push(player, "Money")
	DataService.Push(player, "Upgrades")
	if name == "HatchSpeed" then
		IncubatorService.Rescale(player, oldFactor, Upgrades.HatchSpeed.Value(level + 1))
	end
	Net.Fire(player, "Upgraded", { Name = name, Level = level + 1 })
end

local function rebirth(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local cost = Formulas.RebirthCost(data.Rebirths)
	if data.Money < cost then
		Net.Notify(player, "You need " .. Format.Money(cost) .. " to rebirth!", "error")
		return
	end
	data.Money = 0
	data.Rebirths += 1
	DataService.Push(player, "Money")
	DataService.Push(player, "Rebirths")
	-- nouvel emplacement d'équipement : on remplit avec les meilleures planètes
	PlanetService.EquipBest(player)
	Net.Fire(player, "Rebirthed", { Rebirths = data.Rebirths })
	Net.Notify(player, "REBIRTH! Money x" .. (1 + 0.5 * data.Rebirths) .. " forever!", "success")
end

local function claimDaily(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local now = os.time()
	if data.Daily.Last > 0 and now - data.Daily.Last < DAILY_COOLDOWN then
		Net.Notify(player, "Come back in " .. Format.Time(DAILY_COOLDOWN - (now - data.Daily.Last)) .. "!", "warn")
		return
	end
	if data.Daily.Last > 0 and now - data.Daily.Last > DailyRewards.ResetAfterHours * 3600 then
		data.Daily.Day = 0 -- série cassée
	end
	data.Daily.Day = data.Daily.Day % #DailyRewards.Days + 1
	data.Daily.Last = now
	local text = Rewards.Give(player, DailyRewards.Days[data.Daily.Day])
	DataService.Push(player, "Daily")
	Net.Fire(player, "DailyClaimed", { Day = data.Daily.Day, Text = text })
end

local function redeem(player: Player, code: any)
	if type(code) ~= "string" or #code > 30 then return { ok = false, msg = "Invalid code" } end
	code = string.upper((code:gsub("%s", "")))
	local data = DataService.Get(player)
	if not data then return { ok = false, msg = "Loading..." } end
	local c = Codes[code]
	if not c then return { ok = false, msg = "Invalid code" } end
	if c.Expires and os.time() > c.Expires then return { ok = false, msg = "Code expired" } end
	if data.Codes[code] then return { ok = false, msg = "Already redeemed" } end
	data.Codes[code] = true
	local text = Rewards.Give(player, c.Reward)
	DataService.Push(player, "Codes")
	return { ok = true, msg = "+" .. text }
end

local SETTINGS = { Music = true, Sfx = true, LowGfx = true, AutoHatch = true }

function ProgressService.Start()
	Net.On("BuyUpgrade", buyUpgrade, 4, 6)
	Net.On("Rebirth", rebirth, 0.5, 1)
	Net.On("ClaimDaily", claimDaily, 0.5, 2)
	Net.OnInvoke("Redeem", redeem, 0.5, 3)
	Net.On("Setting", function(player, key, value)
		if not Net.IsString(key, 16) or not SETTINGS[key] or type(value) ~= "boolean" then return end
		local data = DataService.Get(player)
		if not data then return end
		data.Settings[key] = value
		DataService.Push(player, "Settings")
	end, 4, 8)
	Net.On("Tutorial", function(player, step)
		local data = DataService.Get(player)
		if data and Net.IsInt(step, 0, 50) and step > data.Tutorial then
			data.Tutorial = step
		end
	end, 2, 4)
	local _ = State
end

return ProgressService
