--!strict
-- StarterPlayerScripts/Client/HUDController
-- Le HUD : argent (compteur qui monte), gain/s, boosts actifs, boutons de gauche / bas / droite,
-- badges "!" quand quelque chose attend le joueur, petit tutoriel.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Formulas = require(Shared.Util.Formulas)
local Models = require(Shared.Visuals.Models)
local Upgrades = require(Shared.Config.Upgrades)
local Gamepasses = require(Shared.Config.Gamepasses)
local DailyRewards = require(Shared.Config.DailyRewards)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local hud = UI.HUD
local top = hud:WaitForChild("Top")
local left = hud:WaitForChild("Left")
local bottom = hud:WaitForChild("Bottom")
local right = hud:WaitForChild("Right")

local HUD = {}

-- [ ARGENT ] : le chiffre affiché rattrape doucement la vraie valeur
local shown = 0
local target = 0
State.On("Money", function(v)
	target = v or 0
	if shown == 0 then shown = target end
end)
local moneyLabel = top:WaitForChild("Money") :: TextLabel
local incomeLabel = top:WaitForChild("Income") :: TextLabel
RunService.RenderStepped:Connect(function(dt)
	if shown ~= target then
		local diff = target - shown
		if math.abs(diff) < 1 then shown = target else shown += diff * math.min(1, dt * 8) end
	end
	moneyLabel.Text = Format.Money(shown)
end)
local function updateIncome()
	incomeLabel.Text = "+" .. Format.Money(player:GetAttribute("Income") or 0) .. "/s"
end
player:GetAttributeChangedSignal("Income"):Connect(updateIncome)
updateIncome()

-- [ BOOSTS ] : petits timers sous l'argent
local boosts = top:WaitForChild("Boosts")
task.spawn(function()
	while true do
		local now = State.Now()
		local b = State.Data.Boosts or {}
		for _, name in ipairs({ "Money", "Luck" }) do
			local f = boosts:FindFirstChild(name) :: Frame?
			if f then
				local left = (b[name] or 0) - now
				f.Visible = left > 0
				if left > 0 then
					UI.SetLabel(f, (name == "Money" and "x2 $ " or "x2 LUCK ") .. Format.Time(left))
				end
			end
		end
		task.wait(0.5)
	end
end)

-- [ BOUTONS ]
UI.Button(left:WaitForChild("Daily"), function() UI.Toggle("Daily") end)
UI.Button(left:WaitForChild("Index"), function() UI.Toggle("Index") end)
UI.Button(left:WaitForChild("Rebirth"), function() UI.Toggle("Rebirth") end)
UI.Button(left:WaitForChild("Codes"), function() UI.Toggle("Codes") end)
UI.Button(left:WaitForChild("Settings"), function() UI.Toggle("Settings") end)
UI.Button(left:WaitForChild("VIP"), function()
	local id = Gamepasses.VIP.Id
	if player:GetAttribute("Pass_VIP") then
		UI.Notify("You are already VIP!", "success")
	elseif id ~= 0 then
		MarketplaceService:PromptGamePassPurchase(player, id)
	else
		UI.Open("Shop")
	end
end)
UI.Button(bottom:WaitForChild("Shop"), function() UI.Toggle("Shop") end)
UI.Button(bottom:WaitForChild("Sell"), function()
	HUD.SellMode = true
	UI.Open("Planets")
end)
UI.Button(bottom:WaitForChild("Base"), function()
	UI.Close()
	State.Request("TeleportBase")
end)
UI.Button(right:WaitForChild("Galaxies"), function() UI.Toggle("Galaxies") end)
UI.Button(right:WaitForChild("Planets"), function()
	HUD.SellMode = false
	UI.Toggle("Planets")
end)

-- icônes 3D des boutons de droite
-- si l'icône image est uploadée (Config/UIAssets), on l'affiche ; sinon modèle 3D
local UIAssets = require(Shared.Config.UIAssets)
for name, id in pairs({ Galaxies = UIAssets.IconGalaxies, Planets = UIAssets.IconPlanets }) do
	local f = right[name]
	local icon = f:FindFirstChild("Icon") :: ImageLabel?
	if icon and id ~= 0 then
		icon.Image = "rbxassetid://" .. id
		icon.Visible = true
		f.View.Visible = false
	end
end
if right.Galaxies.View.Visible then UI.Viewport(right.Galaxies.View, Models.Galaxy("AmethystSpiral", 1), 0.8, 0.8) end
if right.Planets.View.Visible then UI.Viewport(right.Planets.View, Models.Planet("GoldenSaturn", nil, 3), 0.6, 0.9) end

-- VIP : la case devient "OWNED" quand on l'a
local function vipLabel()
	UI.SetLabel(left.VIP, player:GetAttribute("Pass_VIP") and "OWNED" or "VIP")
end
player:GetAttributeChangedSignal("Pass_VIP"):Connect(vipLabel)
vipLabel()

-- [ BADGES "!" ] : vérifiés toutes les secondes
local function setBadge(frame: Instance, on: boolean)
	local b = frame:FindFirstChild("Badge") :: GuiObject?
	if not b then return end
	if on and not b.Visible then
		b.Visible = true
		b.Size = UDim2.fromScale(0.1, 0.1)
		TweenService:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromScale(0.34, 0.34) }):Play()
	elseif not on then
		b.Visible = false
	end
end

task.spawn(function()
	while true do
		local d = State.Data
		if State.Loaded then
			local now = State.Now()
			-- galaxies prêtes
			local ready, n = 0, 0
			for _, e in ipairs(d.Incubator or {}) do
				n += 1
				if now >= e.EndsAt then ready += 1 end
			end
			setBadge(right.Galaxies, ready > 0)
			local count = right.Galaxies:FindFirstChild("Count") :: TextLabel?
			if count then count.Text = n .. "/" .. Upgrades.Base.IncubatorSlots end
			local pc = right.Planets:FindFirstChild("Count") :: TextLabel?
			if pc then
				local np = 0
				for _ in pairs(d.Planets or {}) do np += 1 end
				pc.Text = tostring(np)
			end
			-- récompense quotidienne
			local daily = d.Daily or { Last = 0 }
			setBadge(left.Daily, daily.Last == 0 or now - daily.Last >= 20 * 3600)
			-- rebirth possible
			setBadge(left.Rebirth, (d.Money or 0) >= Formulas.RebirthCost(d.Rebirths or 0))
			-- collection complète à réclamer
			local claim = false
			local Planets = require(Shared.Config.Planets)
			for rarity, pool in pairs(Planets.ByRarity) do
				if not (d.IndexClaimed or {})[rarity] then
					local all = true
					for _, p in ipairs(pool) do
						if not (d.Index or {})[p.Id] then all = false break end
					end
					if all then claim = true break end
				end
			end
			setBadge(left.Index, claim)
		end
		task.wait(1)
	end
end)

-- [ TUTORIEL ] : une ligne d'aide sous l'argent pour les nouveaux joueurs
local hint = top:FindFirstChild("Hint") :: TextLabel?
if not hint then
	local h = (top:WaitForChild("Income") :: TextLabel):Clone()
	h.Name = "Hint"
	h.Position = UDim2.fromScale(-0.3, 1.25)
	h.Size = UDim2.fromScale(1.6, 0.26)
	h.TextColor3 = Color3.fromRGB(255, 230, 120)
	h.Text = ""
	h.Parent = top
	hint = h
end
local STEPS = {
	"Walk to a galaxy on your spawner and BUY it!",
	"Your galaxy is in the incubator. Wait for the timer...",
	"Open GALAXIES (right) and press HATCH!",
	"Your planet now makes money! Buy more galaxies!",
}
task.spawn(function()
	while true do
		local d = State.Data
		local step = d.Tutorial or 0
		local h = hint :: TextLabel
		if State.Loaded and step < 4 then
			-- avance tout seul selon ce que le joueur a fait
			local hasIncubator = #(d.Incubator or {}) > 0
			local hasPlanet = next(d.Planets or {}) ~= nil
			local newStep = step
			if hasPlanet then newStep = 4
			elseif hasIncubator then
				local readyOne = false
				for _, e in ipairs(d.Incubator) do if State.Now() >= e.EndsAt then readyOne = true end end
				newStep = readyOne and 3 or 2
			else newStep = 1 end
			if newStep ~= step and newStep > step then State.Request("Tutorial", newStep) ; d.Tutorial = newStep end
			h.Text = newStep < 4 and STEPS[newStep] or ""
			h.Visible = newStep < 4
		else
			h.Visible = false
		end
		task.wait(1)
	end
end)

-- [ MESSAGES DU SERVEUR ]
ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Notify").OnClientEvent:Connect(function(text, kind)
	UI.Notify(text, kind)
end)

-- gains hors ligne
State.OnEvent("Offline", function(p)
	local o = UI.Popups:WaitForChild("Offline") :: Frame;
	(o:WaitForChild("Amount") :: TextLabel).Text = Format.Money(p.Amount);
	(o:WaitForChild("Info") :: TextLabel).Text = "You were away for " .. Format.Time(p.Seconds) .. " and earned"
	o.Visible = true
end)
UI.Button(UI.Popups:WaitForChild("Offline"):WaitForChild("Ok"), function()
	UI.Popups.Offline.Visible = false
end)

local _ = DailyRewards
return HUD
