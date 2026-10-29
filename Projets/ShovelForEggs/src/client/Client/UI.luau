--!strict
-- Client/UI : accès à l'interface (StarterGui/GUI, construite en instances), ouverture des menus
-- (un seul à la fois, animation), effets des boutons, sons, modèles 3D dans des ViewportFrame.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UI = {}
UI.Gui = playerGui:WaitForChild("GUI") :: ScreenGui
UI.HUD = UI.Gui:WaitForChild("HUD") :: Frame
UI.Frames = UI.Gui:WaitForChild("Frames") :: Frame
UI.Templates = UI.Gui:WaitForChild("Templates") :: Folder
UI.Sfx = true
UI.Open = nil :: Frame?
UI.Opened = Instance.new("BindableEvent") -- (name)

-- [ SONS ] (Assets/Sounds vient de la lib)
local soundsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sounds")
function UI.Play(name: string, volume: number?)
	if not UI.Sfx then return end
	local s = soundsFolder:FindFirstChild(name) :: Sound?
	if not s then return end
	local c = s:Clone()
	if volume then c.Volume = volume end
	c.Parent = SoundService
	c:Play()
	c.Ended:Once(function() c:Destroy() end)
	task.delay(6, function() if c.Parent then c:Destroy() end end)
end

-- [ BOUTONS ] grossit au survol, rétrécit au clic (via UIScale "Pop" ou créé)
local HOVER = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local LEAVE = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
function UI.Button(btn: GuiButton, onClick: (() -> ())?)
	local pop = btn:FindFirstChild("Pop") :: UIScale?
	if not pop then
		pop = Instance.new("UIScale")
		pop.Name = "Pop"
		pop.Parent = btn
	end
	local p = pop :: UIScale
	-- grossissement limité à ~6 px pour les grands boutons (on ne touche pas à AnchorPoint :
	-- certains contrôleurs placent leurs boutons eux-mêmes)
	local function hoverScale(): number
		local m = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y)
		if m < 1 then return 1.06 end
		return math.min(1.06, 1 + 6 / m)
	end
	local function pressScale(): number
		return 1 - (hoverScale() - 1)
	end
	-- pendant l'animation, un mot seul (« FAVORITE ») peut se couper en 2 lignes : on bloque sa taille
	local locks: { [TextLabel]: UITextSizeConstraint } = {}
	local function lockText(on: boolean)
		if on then
			for _, d in ipairs(btn:GetDescendants()) do
				if d:IsA("TextLabel") and d.TextScaled and d.Visible and not d.Text:find("%s") and d.Text ~= "" and not locks[d] and not d:FindFirstChildOfClass("UITextSizeConstraint") then
					local h = d.TextBounds.Y
					if h > 0 then
						local c = Instance.new("UITextSizeConstraint")
						c.Name = "HoverLock"
						c.MaxTextSize = math.max(1, math.floor(h * 1.08))
						c.Parent = d
						locks[d] = c
					end
				end
			end
		else
			for d, c in pairs(locks) do c:Destroy(); locks[d] = nil end
		end
	end
	btn.MouseEnter:Connect(function() lockText(true); TweenService:Create(p, HOVER, { Scale = hoverScale() }):Play(); UI.Play("Hover", 0.2) end)
	btn.MouseLeave:Connect(function()
		local t = TweenService:Create(p, LEAVE, { Scale = 1 })
		t.Completed:Once(function() if p.Scale == 1 then lockText(false) end end)
		t:Play()
	end)
	btn.MouseButton1Down:Connect(function() TweenService:Create(p, LEAVE, { Scale = pressScale() }):Play() end)
	btn.MouseButton1Up:Connect(function() TweenService:Create(p, HOVER, { Scale = hoverScale() }):Play() end)
	if onClick then
		btn.Activated:Connect(function()
			UI.Play("Click", 0.5)
			onClick()
		end)
	end
end

-- [ MENUS ] -------------------------------------------------------------------
local OPEN = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CLOSE = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

local function scaleOf(frame: Frame): UIScale
	local s = frame:FindFirstChild("MenuScale") :: UIScale?
	if not s then
		s = Instance.new("UIScale")
		s.Name = "MenuScale"
		s.Parent = frame
	end
	return s :: UIScale
end

function UI.Close()
	local f = UI.Open
	if not f then return end
	UI.Open = nil
	local s = scaleOf(f)
	local t = TweenService:Create(s, CLOSE, { Scale = 0.85 })
	t:Play()
	t.Completed:Once(function() if UI.Open ~= f then f.Visible = false end end)
	UI.Opened:Fire(nil)
end

function UI.Show(name: string)
	local f = UI.Frames:FindFirstChild(name) :: Frame?
	if not f then return end
	if UI.Open == f then UI.Close(); return end
	if UI.Open then
		UI.Open.Visible = false
	end
	UI.Open = f
	local s = scaleOf(f)
	s.Scale = 0.85
	f.Visible = true
	TweenService:Create(s, OPEN, { Scale = 1 }):Play()
	UI.Play("Click", 0.4)
	UI.Opened:Fire(name)
end

function UI.Toggle(name: string)
	UI.Show(name)
end

-- Fermer avec le bouton "Close" d'un frame
function UI.HookClose(frame: Frame)
	local c = frame:FindFirstChild("Close") :: GuiButton?
	if c then UI.Button(c, UI.Close) end
end

-- [ VIEWPORT ] : un modèle 3D dans une ViewportFrame (cartes d'index / base / shop)
-- fill (optionnel, 0..1) : cadrage automatique — le modèle remplit cette part de la case, centré
-- (tient compte du champ de vision et du format de la case). Sans fill : ancien cadrage.
-- la caméra est placée côté -Z : c'est la face avant des pets du pack (orientation d'origine gardée)
local VIEW_DIR = Vector3.new(0.6, 0.45, -1).Unit
function UI.ShowModel(vp: ViewportFrame, model: Model?, spin: boolean?, fill: number?)
	for _, c in ipairs(vp:GetChildren()) do c:Destroy() end
	if not model then return end
	local m = model:Clone()
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
		if d:IsA("ParticleEmitter") or d:IsA("PointLight") then d:Destroy() end
	end
	local cam = Instance.new("Camera")
	cam.Parent = vp
	vp.CurrentCamera = cam
	local world = Instance.new("WorldModel")
	world.Parent = vp
	m.Parent = world
	-- on garde l'orientation du modèle (sinon les pets du pack apparaissent couchés)
	m:PivotTo(m:GetPivot().Rotation)
	local _, s2 = m:GetBoundingBox()
	local dist = math.max(s2.X, s2.Y, s2.Z) * 1.15 + 1
	local center = m:GetBoundingBox().Position
	if fill and not spin then
		-- coins de la boîte englobante vus depuis la direction de la caméra
		local bcf, bs = m:GetBoundingBox()
		local basis = CFrame.lookAt(Vector3.zero, -VIEW_DIR)
		local right, up = basis.RightVector, basis.UpVector
		local corners = {}
		for _, sx in ipairs({ -1, 1 }) do for _, sy in ipairs({ -1, 1 }) do for _, sz in ipairs({ -1, 1 }) do
			table.insert(corners, bcf:PointToWorldSpace(Vector3.new(sx * bs.X / 2, sy * bs.Y / 2, sz * bs.Z / 2)))
		end end end
		-- on recentre sur le milieu de la silhouette projetée
		local x0, x1, y0, y1 = math.huge, -math.huge, math.huge, -math.huge
		for _, c in ipairs(corners) do
			local r = c - center
			x0 = math.min(x0, r:Dot(right)); x1 = math.max(x1, r:Dot(right))
			y0 = math.min(y0, r:Dot(up)); y1 = math.max(y1, r:Dot(up))
		end
		center += right * (x0 + x1) / 2 + up * (y0 + y1) / 2
		local abs = vp.AbsoluteSize
		local aspect = (abs.Y > 0 and abs.X > 0) and abs.X / abs.Y or 1
		local tanV = math.tan(math.rad(cam.FieldOfView / 2)) * fill
		local tanH = tanV * aspect
		dist = 0.5
		for _, c in ipairs(corners) do
			local r = c - center
			local depth = r:Dot(VIEW_DIR)
			dist = math.max(dist, depth + math.abs(r:Dot(right)) / tanH, depth + math.abs(r:Dot(up)) / tanV)
		end
	end
	cam.CFrame = CFrame.lookAt(center + VIEW_DIR * dist, center)
	vp.Ambient = Color3.new(1, 1, 1)
	vp.LightColor = Color3.new(1, 1, 1)
	if spin then
		local a = 0
		local conn
		conn = RunService.RenderStepped:Connect(function(dt)
			if not vp.Parent then conn:Disconnect(); return end
			a += dt * 0.8
			cam.CFrame = CFrame.lookAt(center + (CFrame.Angles(0, a, 0) * VIEW_DIR) * dist, center)
		end)
	end
end

-- texte avec bouton : ex. "Buy" → "$1.2K"
function UI.SetText(parent: Instance, childName: string, text: string)
	local t = parent:FindFirstChild(childName, true) :: TextLabel?
	if t then t.Text = text end
end

-- téléphone : menus un peu plus grands
local cam = workspace.CurrentCamera
local function fit()
	local vs = cam.ViewportSize
	UI.Gui:SetAttribute("Phone", vs.X < 900)
end
cam:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
fit()

return UI
