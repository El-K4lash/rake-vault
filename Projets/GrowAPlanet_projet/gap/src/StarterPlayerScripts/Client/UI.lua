--!strict
-- StarterPlayerScripts/Client/UI
-- Outils communs des interfaces : ouvrir / fermer les menus (un seul à la fois),
-- effets des boutons (comme le kit : grossit au survol, rétrécit au clic, sons),
-- notifications, et modèles 3D dans des ViewportFrame.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Rarities = require(Shared.Config.Rarities)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UI = {}
UI.HUD = playerGui:WaitForChild("HUD") :: ScreenGui
UI.Menus = playerGui:WaitForChild("Menus") :: ScreenGui
UI.Popups = playerGui:WaitForChild("Popups") :: ScreenGui
UI.SfxEnabled = true
UI.MenuScale = 1 -- agrandi sur téléphone (voir en bas)

-- [ SONS ] ---------------------------------------------------------------------
local SOUNDS = {
	Hover = "rbxassetid://408524543",
	Click = "rbxassetid://6042053626",
	Open = "rbxassetid://6042053626",
	-- sons du kit K4LSH ; à remplacer par des sons dédiés (Creator Store) plus tard
	Buy = "rbxassetid://6042053626",
	Error = "rbxassetid://408524543",
	Hatch = "rbxassetid://6042053626",
	Rare = "rbxassetid://6042053626",
}
local soundCache: { [string]: Sound } = {}
function UI.Play(name: string, volume: number?)
	if not UI.SfxEnabled then return end
	local id = SOUNDS[name]
	if not id then return end
	local s = soundCache[name]
	if not s then
		s = Instance.new("Sound")
		s.SoundId = id
		s.Parent = SoundService
		soundCache[name] = s
	end
	s.Volume = volume or 0.5
	SoundService:PlayLocalSound(s)
end

-- [ BOUTONS ] ------------------------------------------------------------------
local HOVER = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local LEAVE = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local PRESS = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- branche un bouton du kit : frame avec enfant "Button" (ImageButton) et "Pop" (UIScale)
function UI.Button(frame: Instance, onClick: () -> ()): GuiButton?
	local btn = frame:FindFirstChild("Button") :: GuiButton?
	if not btn then return nil end
	local pop = frame:FindFirstChild("Pop") :: UIScale?
	if pop then
		btn.MouseEnter:Connect(function()
			TweenService:Create(pop, HOVER, { Scale = 1.05 }):Play()
			UI.Play("Hover", 0.3)
		end)
		btn.MouseLeave:Connect(function() TweenService:Create(pop, LEAVE, { Scale = 1 }):Play() end)
		btn.MouseButton1Down:Connect(function() TweenService:Create(pop, PRESS, { Scale = 0.95 }):Play() end)
		btn.MouseButton1Up:Connect(function() TweenService:Create(pop, HOVER, { Scale = 1 }):Play() end)
	end
	btn.Activated:Connect(function()
		UI.Play("Click", 0.6)
		onClick()
	end)
	return btn
end

-- texte d'un bouton barre
function UI.SetLabel(frame: Instance, text: string)
	local l = frame:FindFirstChild("Label") :: TextLabel?
	if l then l.Text = text end
end

-- [ MENUS ] --------------------------------------------------------------------
local openName: string? = nil
local openHooks: { [string]: { () -> () } } = {}
local closeHooks: { [string]: { () -> () } } = {}

function UI.Panel(name: string): Frame
	return UI.Menus:WaitForChild(name) :: Frame
end

function UI.OnOpen(name: string, fn: () -> ())
	openHooks[name] = openHooks[name] or {}
	table.insert(openHooks[name], fn)
end
function UI.OnClose(name: string, fn: () -> ())
	closeHooks[name] = closeHooks[name] or {}
	table.insert(closeHooks[name], fn)
end

function UI.IsOpen(name: string): boolean
	return openName == name
end

function UI.Close(name: string?)
	local n = name or openName
	if not n then return end
	local p = UI.Menus:FindFirstChild(n) :: Frame?
	if p and p.Visible then
		local sc = p:FindFirstChild("Open") :: UIScale?
		if sc then
			local tw = TweenService:Create(sc, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Scale = 0.7 * UI.MenuScale })
			tw:Play()
			tw.Completed:Wait()
		end
		p.Visible = false
		for _, fn in ipairs(closeHooks[n] or {}) do task.spawn(fn) end
	end
	if openName == n then openName = nil end
end

function UI.Open(name: string)
	if openName == name then return end
	if openName and name ~= "Odds" then UI.Close(openName) end
	local p = UI.Menus:FindFirstChild(name) :: Frame?
	if not p then return end
	if name ~= "Odds" then openName = name end
	local sc = p:FindFirstChild("Open") :: UIScale?
	if sc then sc.Scale = 0.6 * UI.MenuScale end
	p.Visible = true
	UI.Play("Open", 0.4)
	if sc then
		TweenService:Create(sc, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = UI.MenuScale }):Play()
	end
	for _, fn in ipairs(openHooks[name] or {}) do task.spawn(fn) end
end

function UI.Toggle(name: string)
	if openName == name then UI.Close(name) else UI.Open(name) end
end

-- croix de fermeture de tous les panneaux
for _, p in ipairs(UI.Menus:GetChildren()) do
	local close = p:FindFirstChild("Header") and p.Header:FindFirstChild("Close")
	if close then
		UI.Button(close, function()
			if p.Name == "Odds" then
				p.Visible = false
			else
				UI.Close(p.Name)
			end
		end)
	end
end

-- [ NOTIFICATIONS ] ------------------------------------------------------------
local notesFrame = UI.Popups:WaitForChild("Notifications")
local noteTemplate = notesFrame:WaitForChild("Template") :: TextLabel
local NOTE_COLORS = {
	info = Color3.fromRGB(255, 255, 255),
	success = Color3.fromRGB(120, 255, 90),
	money = Color3.fromRGB(120, 255, 90),
	warn = Color3.fromRGB(255, 220, 90),
	error = Color3.fromRGB(255, 90, 90),
	rare = Color3.fromRGB(255, 120, 220),
}
local noteOrder = 0
function UI.Notify(text: string, kind: string?)
	noteOrder += 1
	local n = noteTemplate:Clone()
	n.Name = "Note"
	n.Text = text
	n.TextColor3 = NOTE_COLORS[kind or "info"] or NOTE_COLORS.info
	n.LayoutOrder = noteOrder
	n.Visible = true
	n.TextTransparency = 1
	n.Parent = notesFrame
	local st = n:FindFirstChildWhichIsA("UIStroke")
	TweenService:Create(n, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
	if kind == "error" then UI.Play("Error", 0.4) end
	-- garde au plus 4 messages
	local all = {}
	for _, c in ipairs(notesFrame:GetChildren()) do
		if c.Name == "Note" then table.insert(all, c) end
	end
	if #all > 4 then all[1]:Destroy() end
	task.delay(3, function()
		if not n.Parent then return end
		TweenService:Create(n, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
		if st then TweenService:Create(st, TweenInfo.new(0.4), { Transparency = 1 }):Play() end
		task.wait(0.45)
		n:Destroy()
	end)
end

-- [ VIEWPORTS ] ----------------------------------------------------------------
-- affiche un modèle dans un ViewportFrame, cadré automatiquement
local spinning: { [ViewportFrame]: { model: Model, cf: CFrame, speed: number } } = {}
function UI.Viewport(vf: ViewportFrame, model: Model?, spin: number?, distanceMul: number?)
	for _, c in ipairs(vf:GetChildren()) do
		if c:IsA("Model") or c:IsA("Camera") or c:IsA("WorldModel") then c:Destroy() end
	end
	spinning[vf] = nil
	if not model then return end
	model:PivotTo(CFrame.new())
	local _, size = model:GetBoundingBox()
	local radius = size.Magnitude / 2
	local cam = Instance.new("Camera")
	cam.FieldOfView = 40
	local dist = radius / math.tan(math.rad(20)) * (distanceMul or 1.05)
	cam.CFrame = CFrame.lookAt(Vector3.new(0, radius * 0.25, dist), Vector3.zero)
	cam.Parent = vf
	vf.CurrentCamera = cam
	model.Parent = vf
	if spin and spin ~= 0 then
		spinning[vf] = { model = model, cf = CFrame.new(), speed = spin }
	end
end

RunService.RenderStepped:Connect(function(dt)
	for vf, s in pairs(spinning) do
		if not vf.Parent or not s.model.Parent then
			spinning[vf] = nil
		elseif vf.Visible and vf:FindFirstAncestorWhichIsA("LayerCollector") then
			s.cf *= CFrame.Angles(0, dt * s.speed, 0)
			s.model:PivotTo(s.cf)
		end
	end
end)

-- [ COULEURS ] -----------------------------------------------------------------
local rainbowObjects: { [GuiObject]: string } = {}
function UI.RarityColor(rarity: string): Color3
	local r = Rarities.Info[rarity]
	return r and r.Color or Color3.new(1, 1, 1)
end

-- colore un texte ou une image selon la rareté (Secret = arc-en-ciel animé)
function UI.Tint(obj: GuiObject, rarity: string, prop: string)
	local r = Rarities.Info[rarity]
	rainbowObjects[obj] = nil
	if r and r.Rainbow then
		rainbowObjects[obj] = prop
	else
		(obj :: any)[prop] = r and r.Color or Color3.new(1, 1, 1)
	end
end

RunService.Heartbeat:Connect(function()
	local hue = (os.clock() * 0.25) % 1
	for obj, prop in pairs(rainbowObjects) do
		if not obj.Parent then
			rainbowObjects[obj] = nil
		else
			(obj :: any)[prop] = Color3.fromHSV(hue, 0.65, 1)
		end
	end
end)

-- [ TÉLÉPHONE ] ----------------------------------------------------------------
-- agrandit l'interface sur les petits écrans pour des boutons faciles à toucher
local function applyScale()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local h = cam.ViewportSize.Y
	local s = if h < 450 then 1.25 elseif h < 650 then 1.12 else 1
	UI.MenuScale = math.min(s, 1.12)
	-- HUD : un UIScale par bloc (Top, Left, Bottom, Right)
	for _, f in ipairs(UI.HUD:GetChildren()) do
		if f:IsA("GuiObject") then
			local sc = f:FindFirstChild("MobileScale") :: UIScale?
			if not sc then
				sc = Instance.new("UIScale")
				sc.Name = "MobileScale"
				sc.Parent = f
			end;
			(sc :: UIScale).Scale = s
		end
	end
	-- menus : leur UIScale "Open" sert aussi d'échelle
	for _, p in ipairs(UI.Menus:GetChildren()) do
		local sc = p:FindFirstChild("Open") :: UIScale?
		if sc and p:IsA("GuiObject") and p.Visible then sc.Scale = UI.MenuScale end
	end
end
task.defer(function()
	applyScale()
	local cam = workspace.CurrentCamera
	if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(applyScale) end
end)

return UI
