--!strict
-- Client/TutorialController : tutoriel des nouveaux joueurs (interface = StarterGui.Tutorial, construite en instances).
-- 7 étapes guidées : équiper le râteau, aller à la Beach, ratisser 5 objets, vendre, aller au Shop,
-- voir son enclos, découvrir le rebirth. Pour chaque étape :
--   * une carte en haut de l'écran (icône, STEP x / 7, consigne, progression)
--   * une flèche + un anneau lumineux sur le bouton à toucher
--   * un chemin de losanges lumineux au sol + un panneau 3D au-dessus de l'objectif
-- Le serveur (TutorialService) garde l'avancement (data.Tutorial) et donne la récompense à la fin.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Zones = require(Shared.Config.Zones)
local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local gui = pg:WaitForChild("Tutorial") :: ScreenGui
local Dim = gui:WaitForChild("Dim") :: Frame
local Welcome = gui:WaitForChild("Welcome") :: Frame
local Card = gui:WaitForChild("Card") :: Frame
local Ring = gui:WaitForChild("Ring") :: Frame
local Pointer = gui:WaitForChild("Pointer") :: GuiObject
local DoneWin = gui:WaitForChild("Done") :: Frame
local Confetti = gui:WaitForChild("Confetti") :: Frame
local MarkerTpl = gui:WaitForChild("Templates"):WaitForChild("Marker") :: BillboardGui

local map = workspace:WaitForChild("Map")
local DONE = 99
local function A(id: number): string return "rbxassetid://" .. tostring(id) end

-- [ ÉTAPES ] -------------------------------------------------------------------
type Step = { id: string, icon: number, title: string, body: string, goal: number?, next: boolean? }
local STEPS: { Step } = {
	{ id = "Equip", icon = 102082573689395, title = "EQUIP YOUR RAKE", body = "Click your rake in the hotbar below (or press 1)." },
	{ id = "Zone", icon = 134323598185216, title = "GO TO THE BEACH", body = "Press ZONES or follow the glowing path!" },
	{ id = "Rake", icon = 110119422421461, title = "RAKE 5 ITEMS", body = "Walk up to items and hold click to rake them.", goal = 5 },
	{ id = "Sell", icon = 103944045008759, title = "SELL YOUR LOOT", body = "Press SELL or step on a green sell pad." },
	{ id = "Upgrade", icon = 81193001619814, title = "UPGRADE YOUR GEAR", body = "Visit the Shop stand in the lobby: better rakes, bigger bags!" },
	{ id = "Base", icon = 101341556251840, title = "YOUR PEN", body = "Brainrots you find live in your pen and earn $ every second. Collect it!", next = true },
	{ id = "Rebirth", icon = 102040339566414, title = "REBIRTH", body = "Rebirth to multiply your money and unlock new zones!", next = true },
}

local cur = 0             -- étapes validées
local active = false      -- tutoriel en cours (carte affichée)
local busy = false        -- transition entre deux étapes
local raked = 0
local flags: { [string]: boolean } = {}

-- [ OUTILS ] -------------------------------------------------------------------
local function pop(o: GuiObject, from: number?)
	local s = o:FindFirstChild("Pop") :: UIScale?
	if not s then return end
	s.Scale = from or 0.7
	TweenService:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end
local function setText(parent: Instance, name: string, text: string)
	local t = parent:FindFirstChild(name, true) :: TextLabel?
	if t then t.Text = text end
end
local function root(): BasePart?
	local c = player.Character
	return c and c:FindFirstChild("HumanoidRootPart") :: BasePart?
end
local function promptPos(action: string): Vector3?
	local hub = map:FindFirstChild("Hub")
	if not hub then return nil end
	for _, d in ipairs(hub:GetDescendants()) do
		if d:IsA("ProximityPrompt") and (d:GetAttribute("ClientAction") == action or d:GetAttribute("Action") == action) then
			local p = d.Parent
			if p and p:IsA("BasePart") then return p.Position end
			if p and p:IsA("Attachment") then return p.WorldPosition end
		end
	end
	return nil
end
local function myPen(): Instance?
	local plotName = player:GetAttribute("Plot")
	local plots = map:FindFirstChild("Plots")
	local plot = plots and plotName and plots:FindFirstChild(plotName :: string)
	return plot and plot:FindFirstChild("Pen")
end

-- [ CIBLES ] : bouton à montrer + objectif dans le monde --------------------------
local function uiTarget(id: string): GuiObject?
	local main = pg:FindFirstChild("GUI")
	if id == "Equip" then
		local hb = pg:FindFirstChild("Hotbar")
		local bar = hb and hb:FindFirstChild("Bar")
		if bar then
			for i = 1, 9 do
				local s = bar:FindFirstChild("Slot" .. i) :: GuiObject?
				if s and s.Visible then return s end
			end
		end
	elseif main then
		local path = ({ Zone = { "HUD", "Quick", "TpZone" }, Sell = { "HUD", "Quick", "TpSell" }, Base = { "HUD", "Quick", "TpBase" },
			Rebirth = { "HUD", "Left", "Rebirth" } } :: any)[id]
		if path then
			local o: Instance? = main
			for _, n in ipairs(path) do o = o and o:FindFirstChild(n) end
			return o :: GuiObject?
		end
	end
	return nil
end

local function worldTarget(id: string): (Vector3?, string)
	local r = root()
	if id == "Zone" then
		local z = Zones.ById.Beach
		return Vector3.new(z.Center.X, 0.5, z.Center.Z - z.Size / 2 + 6), "BEACH"
	elseif id == "Rake" then
		local f = workspace:FindFirstChild("MyItems")
		local best, bd = nil, math.huge
		if f and r then
			for _, p in ipairs(f:GetChildren()) do
				if p:IsA("BasePart") and p:GetAttribute("ZoneId") == "Beach" then
					local d = (p.Position - r.Position).Magnitude
					if d < bd then best, bd = p, d end
				end
			end
		end
		return best and best.Position or nil, "RAKE!"
	elseif id == "Sell" then
		local best, bd = nil, math.huge
		for _, d in ipairs(map:GetDescendants()) do
			if d.Name == "SellPad" and d:IsA("BasePart") and r then
				local dist = (d.Position - r.Position).Magnitude
				if dist < bd then best, bd = d, dist end
			end
		end
		return best and best.Position or nil, "SELL"
	elseif id == "Upgrade" then
		return promptPos("Shop"), "SHOP"
	elseif id == "Base" then
		local pen = myPen()
		local pad = pen and pen:FindFirstChild("CollectPad", true)
		if pad and pad:IsA("BasePart") then return pad.Position, "YOUR PEN" end
		return pen and (pen :: Model):GetPivot().Position or nil, "YOUR PEN"
	elseif id == "Rebirth" then
		return promptPos("Rebirth"), "REBIRTH"
	end
	return nil, ""
end

-- [ GUIDE AU SOL ] : losanges lumineux de moi vers l'objectif + panneau 3D ----------
local fx = Instance.new("Folder"); fx.Name = "TutorialFx"; fx.Parent = workspace
local DOTS = 24
local dots: { BasePart } = {}
for i = 1, DOTS do
	local d = Instance.new("Part")
	d.Name = "Dot"; d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false; d.CastShadow = false
	d.Material = Enum.Material.Neon; d.Color = Color3.fromRGB(255, 226, 90); d.Size = Vector3.new(1.5, 0.2, 1.5)
	d.Transparency = 1; d.Parent = fx
	dots[i] = d
end
local anchor = Instance.new("Part")
anchor.Name = "Goal"; anchor.Anchored = true; anchor.CanCollide = false; anchor.CanQuery = false; anchor.CanTouch = false
anchor.Transparency = 1; anchor.Size = Vector3.new(0.2, 0.2, 0.2); anchor.Parent = fx
local beacon = Instance.new("Part")
beacon.Name = "Beacon"; beacon.Shape = Enum.PartType.Cylinder; beacon.Anchored = true; beacon.CanCollide = false; beacon.CanQuery = false
beacon.CanTouch = false; beacon.CastShadow = false; beacon.Material = Enum.Material.Neon; beacon.Color = Color3.fromRGB(255, 214, 74)
beacon.Size = Vector3.new(0.15, 7, 7); beacon.Transparency = 1; beacon.Parent = fx
local marker = MarkerTpl:Clone()
marker.Adornee = anchor; marker.Enabled = false; marker.Parent = pg

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
local function groundY(x: number, z: number, y: number): number
	local list: { Instance } = { fx }
	if player.Character then table.insert(list, player.Character) end
	local mi = workspace:FindFirstChild("MyItems"); if mi then table.insert(list, mi) end
	rayParams.FilterDescendantsInstances = list
	local hit = workspace:Raycast(Vector3.new(x, y + 25, z), Vector3.new(0, -60, 0), rayParams)
	return hit and hit.Position.Y or y
end

local goal: Vector3? = nil
local function hideGuide()
	for _, d in ipairs(dots) do d.Transparency = 1 end
	marker.Enabled = false
	beacon.Transparency = 1
	goal = nil
end

-- [ POINTEUR ] sur un bouton de l'écran ---------------------------------------------
local uiGoal: GuiObject? = nil
-- position du bouton dans le repère de l'écran du tutoriel (les AbsolutePosition sont toutes dans le même
-- espace : on retire l'origine de notre ScreenGui)
local function screenRect(o: GuiObject): (Vector2, Vector2)
	return o.AbsolutePosition - gui.AbsolutePosition, o.AbsoluteSize
end
local function visibleChain(o: GuiObject): boolean
	local x: Instance? = o
	while x and x:IsA("GuiObject") do
		if not x.Visible then return false end
		x = x.Parent
	end
	local sg = o:FindFirstAncestorWhichIsA("ScreenGui")
	return sg ~= nil and sg.Enabled
end

-- [ CARTE ] --------------------------------------------------------------------
local Fill = Card:FindFirstChild("Fill", true) :: Frame
local BarText = (Card:FindFirstChild("Bar") :: Frame):FindFirstChild("Text") :: TextLabel
local NextBtn = Card:FindFirstChild("Next") :: GuiButton
local Check = Card:FindFirstChild("Check") :: Frame
local Icon = Card:FindFirstChild("Icon", true) :: ImageLabel

local function setProgress(frac: number, text: string)
	TweenService:Create(Fill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { Size = UDim2.fromScale(math.clamp(frac, 0.04, 1), 1) }):Play()
	BarText.Text = text
end

local function showStep(i: number)
	local s = STEPS[i]
	if not s then return end
	raked = 0
	flags = {}
	Card.Visible = true
	Check.Visible = false
	Icon.Image = A(s.icon)
	setText(Card, "Step", "STEP " .. i .. " / " .. #STEPS)
	setText(Card, "Title", s.title)
	setText(Card, "Body", s.body)
	NextBtn.Visible = s.next == true
	if s.goal then setProgress(0, "0 / " .. s.goal .. " items") else setProgress((i - 1) / #STEPS, (i - 1) .. " / " .. #STEPS) end
	pop(Card, 0.6)
	UI.Play("Click", 0.4)
	uiGoal = uiTarget(s.id)
end

local finish: () -> ()
local function complete()
	if busy or not active then return end
	local i = cur + 1
	local s = STEPS[i]
	if not s then return end
	busy = true
	cur = i
	State.Send("Tutorial", i)
	Check.Visible = true
	NextBtn.Visible = false
	pop(Check, 0.3)
	setProgress(i / #STEPS, i .. " / " .. #STEPS)
	UI.Play("LevelUp", 0.45)
	uiGoal = nil
	Ring.Visible = false; Pointer.Visible = false
	hideGuide()
	task.delay(1.3, function()
		busy = false
		if not active then return end
		if cur >= #STEPS then finish() else showStep(cur + 1) end
	end)
end

-- [ FIN / PASSER ] ---------------------------------------------------------------
local function stop()
	active = false
	Card.Visible = false; Ring.Visible = false; Pointer.Visible = false
	uiGoal = nil
	hideGuide()
end

local function confetti()
	Confetti.Visible = true
	local vs = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
	for _, c in ipairs(Confetti:GetChildren()) do
		if c:IsA("Frame") then
			local x = math.random()
			c.Position = UDim2.new(x, 0, -0.05 - math.random() * 0.2, 0)
			c.Rotation = math.random(0, 360)
			local t = 1.8 + math.random() * 1.4
			TweenService:Create(c, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(x + (math.random() - 0.5) * 0.25, 0, 1.05, 0), Rotation = c.Rotation + math.random(-540, 540),
			}):Play()
		end
	end
	task.delay(3.4, function() Confetti.Visible = false end)
	local _ = vs
end

function finish()
	stop()
	State.Send("Tutorial", "done")
	Dim.Visible = true
	DoneWin.Visible = true
	pop(DoneWin, 0.6)
	confetti()
	UI.Play("LevelUp", 0.7)
end

UI.Button(DoneWin:FindFirstChild("Go") :: GuiButton, function()
	DoneWin.Visible = false; Dim.Visible = false
end)

local function skip()
	State.Send("Tutorial", "skip")
	cur = DONE
	stop()
	Welcome.Visible = false; Dim.Visible = false
end
UI.Button(Card:FindFirstChild("Close") :: GuiButton, skip)
UI.Button(Welcome:FindFirstChild("Skip") :: GuiButton, skip)
UI.Button(NextBtn, function() complete() end)

-- [ ACCUEIL ] ---------------------------------------------------------------------
local Rays = Welcome:FindFirstChild("Rays", true) :: Frame
local function start()
	Welcome.Visible = false; Dim.Visible = false
	active = true
	showStep(cur + 1)
end
UI.Button(Welcome:FindFirstChild("Start") :: GuiButton, start)

local function showWelcome()
	Dim.Visible = true
	Welcome.Visible = true
	pop(Welcome, 0.6)
	local mascot = Welcome:FindFirstChild("Mascot", true) :: ViewportFrame
	local br = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Brainrots"):WaitForChild("Normal")
	local pick = br:FindFirstChild("Tralalero Tralala") or br:FindFirstChild("Brr Brr Patapim") or br:GetChildren()[1]
	UI.ShowModel(mascot, pick :: Model?, true)
end

-- [ DÉTECTION DES ÉTAPES ] ---------------------------------------------------------
State.Event.Event:Connect(function(name: string, payload: any)
	if not active or busy then return end
	local s = STEPS[cur + 1]
	if not s then return end
	if name == "Harvested" and s.id == "Rake" and type(payload) == "table" then
		raked += #payload
		setProgress(raked / (s.goal or 5), math.min(raked, s.goal or 5) .. " / " .. (s.goal or 5) .. " items")
		if raked >= (s.goal or 5) then complete() end
	elseif name == "Sold" and s.id == "Sell" then
		complete()
	elseif name == "Upgraded" and s.id == "Upgrade" then
		complete()
	end
end)
UI.Opened.Event:Connect(function(n: string?)
	if not active or busy then return end
	local s = STEPS[cur + 1]
	if s and ((s.id == "Upgrade" and n == "Shop") or (s.id == "Rebirth" and n == "Rebirth")) then complete() end
end)

local function check()
	if not active or busy then return end
	local s = STEPS[cur + 1]
	if not s then return end
	local r = root()
	if s.id == "Equip" then
		local c = player.Character
		if c then
			for _, t in ipairs(c:GetChildren()) do
				if t:IsA("Tool") and t:GetAttribute("Rake") then complete(); return end
			end
		end
	elseif s.id == "Zone" and r then
		local z = Zones.At(r.Position)
		if z and z.Id == "Beach" then complete() end
	elseif s.id == "Base" and r then
		local p = worldTarget("Base")
		if p and (Vector3.new(p.X, 0, p.Z) - Vector3.new(r.Position.X, 0, r.Position.Z)).Magnitude < 14 then complete() end
	end
end

-- [ BOUCLE ] ----------------------------------------------------------------------
local t = 0
local acc = 0
RunService.RenderStepped:Connect(function(dt: number)
	t += dt
	if Welcome.Visible and Rays then Rays.Rotation = (Rays.Rotation + dt * 20) % 360 end
	if not active then return end
	acc += dt
	if acc > 0.2 then
		acc = 0
		check()
		local s = STEPS[cur + 1]
		if s and not busy then
			uiGoal = uiTarget(s.id)
			local p, label = worldTarget(s.id)
			goal = p
			if p then
				anchor.Position = p
				setText(marker, "Label", label)
			end
		end
	end
	-- pointeur sur le bouton (caché quand un menu est ouvert)
	local o = uiGoal
	if o and o.Parent and visibleChain(o) and UI.Open == nil and not busy then
		local pos, size = screenRect(o)
		local pad = 6 + math.sin(t * 6) * 2
		Ring.Visible = true
		Ring.Position = UDim2.fromOffset(pos.X - pad, pos.Y - pad)
		Ring.Size = UDim2.fromOffset(size.X + pad * 2, size.Y + pad * 2)
		local st = Ring:FindFirstChild("Stroke") :: UIStroke
		st.Transparency = 0.15 + 0.35 * (0.5 + 0.5 * math.sin(t * 6))
		local vs = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
		local bob = math.abs(math.sin(t * 5)) * 10
		Pointer.Visible = true
		if pos.Y > vs.Y * 0.5 then
			-- bouton en bas : épingle au-dessus, pointe vers le bas
			Pointer.AnchorPoint = Vector2.new(0.5, 1); Pointer.Rotation = 0
			Pointer.Position = UDim2.fromOffset(pos.X + size.X / 2, pos.Y - 6 - bob)
		else
			-- bouton en haut : épingle en dessous, pointe vers le haut
			Pointer.AnchorPoint = Vector2.new(0.5, 0); Pointer.Rotation = 180
			Pointer.Position = UDim2.fromOffset(pos.X + size.X / 2, pos.Y + size.Y + 6 + bob)
		end
	else
		Ring.Visible = false; Pointer.Visible = false
	end
	-- chemin lumineux au sol + panneau 3D
	local r = root()
	local g = goal
	if g and r and not busy then
		local from = Vector3.new(r.Position.X, 0, r.Position.Z)
		local to = Vector3.new(g.X, 0, g.Z)
		local dist = (to - from).Magnitude
		-- le panneau 3D disparaît quand on est dessus (il cachait le stand / l'objet)
		marker.Enabled = dist > 12
		setText(marker, "Dist", math.floor(dist) .. "m")
		local holder = marker:FindFirstChild("Holder") :: Frame
		holder.Position = UDim2.fromOffset(0, -math.abs(math.sin(t * 4)) * 10)
		beacon.Transparency = 0.55 + 0.25 * math.sin(t * 4)
		beacon.CFrame = CFrame.new(g.X, groundY(g.X, g.Z, g.Y) + 0.1, g.Z) * CFrame.Angles(0, 0, math.pi / 2)
		beacon.Size = Vector3.new(0.15, 5 + math.sin(t * 4), 5 + math.sin(t * 4))
		local dir = dist > 0.01 and (to - from).Unit or Vector3.zAxis
		local spacing = 4
		local flow = (t * 6) % spacing
		local yaw = math.atan2(dir.X, dir.Z)
		for i, d in ipairs(dots) do
			local along = 3 + (i - 1) * spacing + flow
			if dist > 7 and along < dist - 2 then
				local p = from + dir * along
				local hop = 0.45 + 0.25 * math.sin(t * 6 - along * 0.6)
				d.CFrame = CFrame.new(p.X, groundY(p.X, p.Z, r.Position.Y) + hop, p.Z) * CFrame.Angles(0, yaw + math.pi / 4, 0)
				local fade = math.clamp(along / 6, 0, 1) * math.clamp((dist - 2 - along) / 6, 0, 1)
				d.Transparency = 1 - 0.85 * fade
			else
				d.Transparency = 1
			end
		end
	else
		for _, d in ipairs(dots) do d.Transparency = 1 end
		marker.Enabled = false
		beacon.Transparency = 1
	end
end)

-- [ DÉMARRAGE ] -------------------------------------------------------------------
local started = false
local function boot()
	if started then return end
	local d = State.Data
	if not d then return end
	started = true
	cur = d.Tutorial or 0
	if cur >= DONE then return end
	if cur >= #STEPS then
		-- toutes les étapes faites mais fenêtre de fin pas vue
		finish()
		return
	end
	task.delay(2, function()
		if cur == 0 then showWelcome() else active = true; showStep(cur + 1) end
	end)
end
State.On({ "*", "Tutorial" }, boot)
task.spawn(function()
	for _ = 1, 40 do
		if State.Data then boot(); return end
		task.wait(0.5)
	end
end)

return true
