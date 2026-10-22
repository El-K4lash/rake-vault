--!strict
-- ServerScriptService/Services/SpawnerService
-- Les spawners de la base : une galaxie apparaît sur chaque spawner libre.
-- Le joueur l'achète avec le bouton "Buy" (ProximityPrompt vérifié par le serveur).
-- Ces offres ne sont pas sauvegardées : elles se renouvellent tout le temps.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Formulas = require(Shared.Util.Formulas)
local Format = require(Shared.Util.Format)
local Galaxies = require(Shared.Config.Galaxies)
local Rarities = require(Shared.Config.Rarities)
local Models = require(Shared.Visuals.Models)

local Net = require(script.Parent.Parent.Lib.Net)
local State = require(script.Parent.Parent.Lib.State)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)
local IncubatorService = require(script.Parent.IncubatorService)

local SpawnerService = {}
local MAX_PADS = 4

type Offer = { Galaxy: string, Expires: number, Model: Model }
type PlayerPads = { offers: { [number]: Offer? }, nextAt: { [number]: number } }
local pads: { [Player]: PlayerPads } = {}
local rng = Random.new()

local function padPart(plot: Model, i: number): BasePart?
	local f = plot:FindFirstChild("Pads")
	local p = f and f:FindFirstChild("Pad" .. i)
	return if p and p:IsA("BasePart") then p else nil
end

local function clearOffer(player: Player, i: number)
	local pp = pads[player]
	if not pp then return end
	local o = pp.offers[i]
	if o and o.Model then o.Model:Destroy() end
	pp.offers[i] = nil
	pp.nextAt[i] = os.clock() + Galaxies.Spawn.Interval
end

local function buy(player: Player, i: number)
	local pp = pads[player]
	local data = DataService.Get(player)
	local o = pp and pp.offers[i]
	if not o or not data then return end
	local g = Galaxies.ById[o.Galaxy]
	if not g then return end
	-- le joueur doit être à côté du spawner
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not root or not o.Model.PrimaryPart or (root.Position - o.Model.PrimaryPart.Position).Magnitude > 20 then return end
	if data.Money < g.Price then
		Net.Notify(player, "Not enough money! You need " .. Format.Money(g.Price - data.Money) .. " more.", "error")
		return
	end
	if IncubatorService.FreeSlots(player) <= 0 then
		Net.Notify(player, "Your incubator is full! Hatch a galaxy first.", "warn")
		return
	end
	data.Money -= g.Price
	DataService.Push(player, "Money")
	clearOffer(player, i)
	IncubatorService.Add(player, g.Id)
	Net.Fire(player, "GalaxyBought", { Galaxy = g.Id })
end

local function spawnOffer(player: Player, plot: Model, i: number)
	local pad = padPart(plot, i)
	local data = DataService.Get(player)
	if not pad or not data then return end
	local luck = Formulas.Luck(State.Build(player, data))
	local galaxyId = Formulas.RollGalaxy(rng, luck)
	local g = Galaxies.ById[galaxyId]
	local rarity = Rarities.Info[g.Rarity]

	local model = Models.Galaxy(galaxyId, 0.75)
	-- les pads sont des cylindres couchés : la hauteur est Size.X
	model:PivotTo(CFrame.new(pad.Position + Vector3.new(0, pad.Size.X / 2 + 4, 0)))
	model:SetAttribute("OwnerId", player.UserId)
	model:SetAttribute("Expires", os.time() + Galaxies.Spawn.Lifetime)
	model:SetAttribute("Rarity", g.Rarity)

	local bb = Instance.new("BillboardGui")
	bb.Name = "Info"
	bb.Size = UDim2.fromScale(7, 3)
	bb.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
	bb.MaxDistance = 90
	bb.LightInfluence = 0
	local function line(name: string, text: string, y: number, h: number, color: Color3)
		local l = Instance.new("TextLabel")
		l.Name = name
		l.BackgroundTransparency = 1
		l.Position = UDim2.fromScale(0, y)
		l.Size = UDim2.fromScale(1, h)
		l.Font = Enum.Font.GothamBlack
		l.TextScaled = true
		l.Text = text
		l.TextColor3 = color
		l.TextStrokeTransparency = 0
		l.Parent = bb
	end
	line("Rarity", string.upper(rarity.Name), 0, 0.26, rarity.Color)
	line("GalaxyName", g.Name, 0.26, 0.3, Color3.new(1, 1, 1))
	line("Price", Format.Money(g.Price), 0.56, 0.3, Color3.fromRGB(120, 255, 100))
	line("Time", "", 0.86, 0.18, Color3.fromRGB(220, 220, 230))
	bb.Parent = model.PrimaryPart

	local prompt = Instance.new("ProximityPrompt")
	prompt.Name = "BuyPrompt"
	prompt.ActionText = "Buy " .. Format.Money(g.Price)
	prompt.ObjectText = g.Name
	prompt.HoldDuration = 0
	prompt.MaxActivationDistance = 12
	prompt.RequiresLineOfSight = false
	prompt.Parent = model.PrimaryPart
	prompt.Triggered:Connect(function(who)
		if who == player then buy(player, i) end
	end)

	local dyn = plot:FindFirstChild("Dynamic")
	model.Parent = dyn
	pads[player].offers[i] = { Galaxy = galaxyId, Expires = os.time() + Galaxies.Spawn.Lifetime, Model = model }

	-- annonce serveur pour les galaxies très rares
	if rarity.Order >= 5 then
		for _, other in ipairs(Players:GetPlayers()) do
			Net.Notify(other, player.DisplayName .. " got a " .. string.upper(rarity.Name) .. " galaxy: " .. g.Name .. "!", "rare")
		end
	end
end

local function tick()
	local now = os.clock()
	for _, player in ipairs(Players:GetPlayers()) do
		local data = DataService.Get(player)
		local plot = PlotService.Get(player)
		if data and plot then
			local pp = pads[player]
			if not pp then
				pp = { offers = {}, nextAt = {} }
				pads[player] = pp
			end
			local count = Formulas.SpawnerCount(State.Build(player, data))
			for i = 1, MAX_PADS do
				local pad = padPart(plot, i)
				if pad then pad:SetAttribute("Locked", i > count) end
				local o = pp.offers[i]
				if i > count then
					if o then clearOffer(player, i) end
				elseif o then
					if os.time() >= o.Expires then clearOffer(player, i) end
				elseif now >= (pp.nextAt[i] or 0) then
					spawnOffer(player, plot, i)
				end
			end
		end
	end
end

function SpawnerService.Start()
	Players.PlayerRemoving:Connect(function(player)
		pads[player] = nil
	end)
	task.spawn(function()
		while true do
			task.wait(1)
			local ok, err = pcall(tick)
			if not ok then warn("[SpawnerService] " .. tostring(err)) end
		end
	end)
end

return SpawnerService
