--!strict
-- StarterPlayerScripts/Client/WorldController
-- Tout ce qui bouge dans le monde, calculé chez le joueur (pas sur le serveur) :
--   * rotation des galaxies / planètes (tag "Spin"), couleurs arc-en-ciel
--   * comptes à rebours au-dessus des galaxies (enclos + spawners)
--   * boutons Buy / Hatch visibles seulement pour le propriétaire de la base
--   * spawners verrouillés ("LOCKED")
--   * planètes équipées en orbite autour du soleil de chaque base

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Models = require(Shared.Visuals.Models)

local State = require(script.Parent.State)

local player = Players.LocalPlayer
local plots = workspace:WaitForChild("Map"):WaitForChild("Plots")

-- [ ROTATION + ARC-EN-CIEL ] -----------------------------------------------------
type Spinner = { model: Model, base: CFrame, angle: number, speed: number, rainbow: { BasePart }? }
local spinners: { [Model]: Spinner } = {}

local function addSpinner(m: Instance)
	if not m:IsA("Model") or spinners[m] then return end
	local rainbow: { BasePart }? = nil
	if m:GetAttribute("Rainbow") then
		rainbow = {}
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") and (d.Name == "Ball" or d.Name == "Core" or d.Name == "Arm" or d.Name == "Ring" or d.Name == "Spot") then
				table.insert(rainbow :: { BasePart }, d)
			end
		end
	end
	spinners[m] = { model = m, base = m:GetPivot(), angle = 0, speed = m:GetAttribute("Spin") or 0.5, rainbow = rainbow }
end
CollectionService:GetInstanceAddedSignal("Spin"):Connect(addSpinner)
CollectionService:GetInstanceRemovedSignal("Spin"):Connect(function(m) spinners[m :: Model] = nil end)
for _, m in ipairs(CollectionService:GetTagged("Spin")) do addSpinner(m) end

-- [ ORBITES ] --------------------------------------------------------------------
type Orbit = { sun: BasePart, models: { Model }, key: string }
local orbits: { [Model]: Orbit } = {}
local orbitFolder = Instance.new("Folder")
orbitFolder.Name = "LocalOrbits"
orbitFolder.Parent = workspace

local function rebuildOrbit(plot: Model)
	local o = orbits[plot]
	if o then
		for _, m in ipairs(o.models) do m:Destroy() end
	end
	local sun = plot:FindFirstChild("Sun") :: BasePart?
	local list = plot:GetAttribute("Equipped")
	if not sun or type(list) ~= "string" or list == "" then
		orbits[plot] = nil
		return
	end
	local models = {}
	for entry in string.gmatch(list, "[^,]+") do
		local id, mut = string.match(entry, "^([^:]+):?(.*)$")
		if id then
			local m = Models.Planet(id, mut ~= "" and mut or nil, 3.2)
			CollectionService:RemoveTag(m, "Spin") -- l'orbite gère sa propre rotation
			m.Parent = orbitFolder
			table.insert(models, m)
		end
	end
	orbits[plot] = { sun = sun, models = models, key = list }
end

local function watchPlot(plot: Instance)
	if not plot:IsA("Model") then return end
	plot:GetAttributeChangedSignal("Equipped"):Connect(function() rebuildOrbit(plot) end)
	rebuildOrbit(plot)
end
for _, p in ipairs(plots:GetChildren()) do watchPlot(p) end
plots.ChildAdded:Connect(watchPlot)

-- [ BOUCLE D'ANIMATION ] ---------------------------------------------------------
local hue = 0
RunService.RenderStepped:Connect(function(dt)
	local cam = workspace.CurrentCamera
	local camPos = cam and cam.CFrame.Position or Vector3.zero
	hue = (hue + dt * 0.25) % 1
	local rainbowColor = Color3.fromHSV(hue, 0.7, 1)
	for m, s in pairs(spinners) do
		if not m.Parent then
			spinners[m] = nil
		elseif m:IsDescendantOf(workspace) then
			if (s.base.Position - camPos).Magnitude < 250 then
				s.angle += dt * s.speed
				m:PivotTo(s.base * CFrame.Angles(0, s.angle, 0))
				if s.rainbow then
					for _, p in ipairs(s.rainbow) do p.Color = rainbowColor end
				end
			end
		end
	end
	local t = os.clock()
	for plot, o in pairs(orbits) do
		local center = o.sun.Position
		if (center - camPos).Magnitude < 350 then
			local n = #o.models
			for i, m in ipairs(o.models) do
				-- chaque planète sur son anneau, de plus en plus loin et lente
				local ring = 9 + i * 3.2
				local speed = 0.55 / (1 + i * 0.12)
				local a = t * speed + i * (math.pi * 2 / math.max(n, 1))
				local pos = center + Vector3.new(math.cos(a) * ring, math.sin(a * 2 + i) * 1.2, math.sin(a) * ring)
				m:PivotTo(CFrame.new(pos) * CFrame.Angles(0, t * 0.8, 0))
				if m:GetAttribute("Rainbow") then
					for _, d in ipairs(m:GetChildren()) do
						if d:IsA("BasePart") and (d.Name == "Ball" or d.Name == "Ring" or d.Name == "Spot") then d.Color = rainbowColor end
					end
				end
			end
		end
	end
end)

-- [ TIMERS + BOUTONS PROPRIÉTAIRE + SPAWNERS VERROUILLÉS ] -----------------------
local lockBillboards: { [BasePart]: BillboardGui } = {}
local function lockLabel(pad: BasePart): BillboardGui
	local bb = lockBillboards[pad]
	if bb then return bb end
	bb = Instance.new("BillboardGui")
	bb.Size = UDim2.fromScale(8, 2)
	bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
	bb.MaxDistance = 60
	bb.LightInfluence = 0
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Size = UDim2.fromScale(1, 1)
	l.Font = Enum.Font.GothamBlack
	l.TextScaled = true
	l.TextColor3 = Color3.fromRGB(255, 210, 80)
	l.TextStrokeTransparency = 0
	l.Text = pad.Name == "Pad4" and "LOCKED\n4th Spawner Pass" or "LOCKED\nUpgrade Spawners"
	l.Parent = bb
	bb.Adornee = pad
	bb.Parent = player:WaitForChild("PlayerGui")
	lockBillboards[pad] = bb
	return bb
end

task.spawn(function()
	while true do
		local now = State.Now()
		local myId = player.UserId
		for _, plot in ipairs(plots:GetChildren()) do
			local mine = plot:GetAttribute("OwnerId") == myId
			local dyn = plot:FindFirstChild("Dynamic")
			if dyn then
				for _, d in ipairs(dyn:GetDescendants()) do
					if d:IsA("ProximityPrompt") and d.Name ~= "HatchPrompt" then
						d.Enabled = mine
					elseif d:IsA("TextLabel") and d.Name == "Time" then
						local model = d:FindFirstAncestorWhichIsA("Model")
						if model then
							local ends = model:GetAttribute("EndsAt")
							local exp = model:GetAttribute("Expires")
							if ends then
								local left = ends - now
								d.Text = left <= 0 and "READY!" or Format.Time(left)
								d.TextColor3 = left <= 0 and Color3.fromRGB(120, 255, 90) or Color3.new(1, 1, 1)
								local prompt = model:FindFirstChild("HatchPrompt", true) :: ProximityPrompt?
								if prompt then prompt.Enabled = mine and left <= 0 end
							elseif exp then
								d.Text = "Leaves in " .. Format.Time(exp - now)
							end
						end
					end
				end
			end
			-- spawners verrouillés (seulement dans ma base)
			local pads = plot:FindFirstChild("Pads")
			if pads then
				for _, pad in ipairs(pads:GetChildren()) do
					if pad:IsA("BasePart") and pad.Name:match("^Pad%d$") then
						local locked = mine and pad:GetAttribute("Locked") == true
						if locked then
							lockLabel(pad).Enabled = true
						elseif lockBillboards[pad] then
							lockBillboards[pad].Enabled = false
						end
					end
				end
			end
		end
		task.wait(0.25)
	end
end)

return {}
