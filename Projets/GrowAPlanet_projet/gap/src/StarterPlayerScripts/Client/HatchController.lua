--!strict
-- StarterPlayerScripts/Client/HatchController
-- Popup d'éclosion : la planète apparaît en grand avec des rayons, sa rareté,
-- sa mutation et "NEW!" si elle est nouvelle dans l'Index. File d'attente si plusieurs.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Formulas = require(Shared.Util.Formulas)
local Planets = require(Shared.Config.Planets)
local Rarities = require(Shared.Config.Rarities)
local Mutations = require(Shared.Config.Mutations)
local Models = require(Shared.Visuals.Models)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local popup = UI.Popups:WaitForChild("Hatch") :: Frame
local rays = popup:WaitForChild("Rays") :: ImageLabel
local view = popup:WaitForChild("View") :: ViewportFrame

local queue: { any } = {}
local showing = false
local closeSignal = Instance.new("BindableEvent")

UI.Button(popup, function() closeSignal:Fire() end)

RunService.RenderStepped:Connect(function(dt)
	if popup.Visible then rays.Rotation = (rays.Rotation + dt * 25) % 360 end
end)

local function showOne(r: any)
	local p = Planets.ById[r.Planet]
	local rarity = p and p.Rarity or "Common"
	local order = Rarities.Info[rarity].Order;
	(popup:WaitForChild("PlanetName") :: TextLabel).Text = p and p.Name or r.Planet
	local rl = popup:WaitForChild("Rarity") :: TextLabel
	rl.Text = string.upper(rarity)
	UI.Tint(rl, rarity, "TextColor3")
	rays.ImageColor3 = UI.RarityColor(rarity)
	local ml = popup:WaitForChild("Mutation") :: TextLabel
	local m = r.Mutation and Mutations.ById[r.Mutation]
	ml.Text = m and (string.upper(m.Name) .. "  x" .. m.Multiplier) or ""
	ml.TextColor3 = m and m.Color or Color3.new(1, 1, 1);
	(popup:WaitForChild("New") :: TextLabel).Visible = r.New == true
	local mult = Formulas.MoneyMultiplier(State.Build());
	(popup:WaitForChild("Income") :: TextLabel).Text = "+" .. Format.Money(Formulas.PlanetIncome(r.Planet, r.Mutation) * mult) .. "/s"

	UI.Viewport(view, Models.Planet(r.Planet, r.Mutation, 3), 1.2, 0.9)
	popup.Visible = true
	popup.BackgroundTransparency = 1
	view.Size = UDim2.fromScale(0.05, 0.05)
	TweenService:Create(popup, TweenInfo.new(0.2), { BackgroundTransparency = 0.45 }):Play()
	TweenService:Create(view, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromScale(0.36, 0.5) }):Play()
	UI.Play(order >= 4 and "Rare" or "Hatch", 0.7)

	-- fermeture : clic, ou automatiquement (plus long pour les raretés hautes)
	local done = false
	local conn = closeSignal.Event:Connect(function() done = true end)
	local t = 0
	local maxTime = order >= 4 and 6 or 2.5
	while not done and t < maxTime do
		t += task.wait()
	end
	conn:Disconnect()
	popup.Visible = false
	UI.Viewport(view, nil)
end

State.OnEvent("Hatched", function(r)
	table.insert(queue, r)
	if showing then return end
	showing = true
	while #queue > 0 do
		local item = table.remove(queue, 1)
		-- si beaucoup d'éclosions d'un coup (Hatch All) : on ne montre que les intéressantes
		local p = Planets.ById[item.Planet]
		local order = p and Rarities.Info[p.Rarity].Order or 1
		if #queue >= 3 and order < 3 and not item.Mutation and not item.New then
			UI.Notify("Hatched " .. (p and p.Name or item.Planet), "info")
		else
			showOne(item)
		end
	end
	showing = false
end)

State.OnEvent("GalaxyBought", function()
	UI.Play("Buy", 0.6)
end)
State.OnEvent("Rebirthed", function()
	UI.Play("Rare", 0.7)
end)

return {}
