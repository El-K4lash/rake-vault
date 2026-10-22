-- build_wheel.lua : roue de la fortune du lobby, faite main en low-poly (vraies parts, pas de script de rendu).
-- Remplace Map.Hub.Wheel en gardant sa place (pivot). Face avant = +Z local, tournée vers le centre du lobby.
--   Wheel.Disk            : tout ce qui tourne (pivot = Disk.Axis, rotation autour de son Z local)
--   8 parts (Config/Lobby.Wheel.Segments) : vraies parts en éventail (triangles en WedgeParts), icône + texte
--   jante dorée + ampoules, moyeu, pointeur rouge en haut, panneau LUCKY WHEEL, socle à marches
-- Lancé une fois en Edit (require du module).
local H = workspace.Map.Hub
local Lobby = require(game.ReplicatedStorage.Shared.Config.Lobby:Clone())
local W = Lobby.Wheel
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
local NAVY = Color3.fromRGB(27, 42, 53)
local NAVY2 = Color3.fromRGB(46, 69, 86)
local GOLD = Color3.fromRGB(255, 197, 49)
local GOLD2 = Color3.fromRGB(230, 160, 30)
local WHITE = Color3.fromRGB(255, 250, 240)
-- styles (maquettes Claude Design) : _G.WHEEL_STYLE = "Royal" | "Carnival" | "Lab" avant le require
local STYLES = {
	Royal = {
		back = NAVY, seg = function(c) return c end, edge = function(c) return c:Lerp(Color3.new(1, 1, 1), 0.45) end, edgeMat = Enum.Material.SmoothPlastic,
		rim = { GOLD, GOLD }, rimMat = Enum.Material.SmoothPlastic, band = GOLD2, sep = GOLD, bulbs = { WHITE, Color3.fromRGB(255, 226, 122) },
		hub = { GOLD, GOLD2, Color3.fromRGB(230, 57, 70) }, pointer = Color3.fromRGB(230, 57, 70), pointerMat = Enum.Material.SmoothPlastic, cap = GOLD,
		sign = NAVY, signFrame = GOLD, signText = Color3.fromRGB(255, 220, 80), leg = NAVY, base = NAVY, base2 = NAVY2, trim = GOLD, glow = nil,
	},
	Carnival = {
		back = NAVY, seg = function(c) return c:Lerp(Color3.new(1, 1, 1), 0.08) end, edge = function() return Color3.new(1, 1, 1) end, edgeMat = Enum.Material.SmoothPlastic,
		rim = { Color3.fromRGB(232, 48, 79), WHITE }, rimMat = Enum.Material.SmoothPlastic, band = NAVY, sep = WHITE, bulbs = { WHITE, WHITE },
		hub = { WHITE, Color3.fromRGB(232, 48, 79), GOLD }, pointer = GOLD, pointerMat = Enum.Material.SmoothPlastic, cap = Color3.fromRGB(232, 48, 79),
		sign = Color3.fromRGB(232, 48, 79), signFrame = GOLD, signText = WHITE, leg = Color3.fromRGB(232, 48, 79), base = Color3.fromRGB(232, 48, 79),
		base2 = WHITE, trim = GOLD, glow = nil,
	},
	Lab = {
		back = Color3.fromRGB(18, 32, 43), seg = function(c) return c:Lerp(Color3.new(0, 0, 0), 0.55) end, edge = function(c) return c end, edgeMat = Enum.Material.Neon,
		rim = { Color3.fromRGB(91, 107, 124), Color3.fromRGB(91, 107, 124) }, rimMat = Enum.Material.Metal, band = Color3.fromRGB(61, 240, 255),
		sep = Color3.fromRGB(61, 240, 255), bulbs = { Color3.fromRGB(61, 240, 255), Color3.fromRGB(255, 79, 216) },
		hub = { Color3.fromRGB(18, 32, 43), Color3.fromRGB(91, 107, 124), Color3.fromRGB(255, 79, 216) }, pointer = Color3.fromRGB(255, 79, 216),
		pointerMat = Enum.Material.Neon, cap = Color3.fromRGB(61, 240, 255), sign = Color3.fromRGB(18, 32, 43), signFrame = Color3.fromRGB(61, 240, 255),
		signText = Color3.fromRGB(61, 240, 255), leg = Color3.fromRGB(91, 107, 124), base = Color3.fromRGB(91, 107, 124), base2 = Color3.fromRGB(59, 72, 86),
		trim = Color3.fromRGB(61, 240, 255), glow = Color3.fromRGB(61, 240, 255),
	},
}
local ST = STYLES[_G.WHEEL_STYLE or "Royal"] or STYLES.Royal
local R = 6.6          -- rayon du disque
local HC = 9.4         -- hauteur du centre
local ICON = {
	Coins = "rbxassetid://103944045008759", Money = "rbxassetid://103944045008759", Boost = "rbxassetid://103944045008759",
	Egg = "rbxassetid://140583595805309", Luck = "rbxassetid://81193001619814", Jackpot = "rbxassetid://94666332436790",
}
local LABEL = { Coins = "$", Money = "$$$", Boost = "x2 $", Egg = "EGG", Luck = "x2 LUCK", Jackpot = "JACKPOT" }

-- place d'origine : l'ancienne roue (sinon devant le spawn)
local PARENT = _G.WHEEL_PARENT or H
local NAME = _G.WHEEL_NAME or "Wheel"
local old = PARENT:FindFirstChild(NAME)
local pivot = _G.WHEEL_AT or (old and old:GetPivot()) or (CFrame.new(15.7, 0.2, 54.8) * CFrame.Angles(0, math.rad(197), 0))
if old then old:Destroy() end

local m = Instance.new("Model"); m.Name = NAME; m:SetAttribute("Style", _G.WHEEL_STYLE or "Royal")
local disk = Instance.new("Model"); disk.Name = "Disk"; disk.Parent = m

local function part(parent, name, size, cf, col, mat, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or Enum.Material.SmoothPlastic; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent
	return p
end
-- cylindre dont l'axe est Z (face vers l'avant)
local function zcyl(parent, name, d, thick, pos, col, mat)
	return part(parent, name, Vector3.new(thick, d, d), CFrame.new(pos) * CFrame.Angles(0, math.rad(90), 0), col, mat, Enum.PartType.Cylinder)
end
-- triangle plein (a, b, c dans un plan Z constant) avec 2 WedgeParts
local function tri(parent, a, b, c, thick, col)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	if abd > acd and abd > bcd then c, a = a, c
	elseif acd > bcd and acd > abd then a, b = b, a end
	ab, ac, bc = b - a, c - a, c - b
	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit
	local height = math.abs(ab:Dot(up))
	for i, info in ipairs({ { a + ab / 2, right, ab }, { a + ac / 2, -right, ac } }) do
		local w = Instance.new("WedgePart"); w.Name = "Slice"; w.Anchored = true; w.Color = col
		w.Material = Enum.Material.SmoothPlastic; w.TopSurface = Enum.SurfaceType.Smooth; w.BottomSurface = Enum.SurfaceType.Smooth
		local bk = i == 1 and back or -back
		w.Size = Vector3.new(thick, height, math.abs(info[3]:Dot(back)))
		w.CFrame = CFrame.fromMatrix(info[1], info[2], up, bk)
		w.Parent = parent
	end
end
local function at(ang, r, z) local a = math.rad(ang); return Vector3.new(math.cos(a) * r, HC + math.sin(a) * r, z) end
local function label(parent, name, text, pos, size, color, stroke)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Position = pos; t.Size = size
	t.FontFace = FONT; t.TextScaled = true; t.Text = text; t.TextColor3 = color or Color3.new(1, 1, 1); t.Parent = parent
	local s = Instance.new("UIStroke"); s.Thickness = stroke or 3; s.Color = Color3.fromRGB(20, 24, 40); s.LineJoinMode = Enum.LineJoinMode.Round; s.Parent = t
	return t
end

-- [ SOCLE ] ---------------------------------------------------------------------------------
part(m, "Base", Vector3.new(12, 0.9, 6.4), CFrame.new(0, 0.45, -0.8), ST.base)
part(m, "BaseTrim", Vector3.new(12.3, 0.16, 6.7), CFrame.new(0, 0.95, -0.8), ST.trim, ST.glow and Enum.Material.Neon or nil)
part(m, "BaseTop", Vector3.new(11.2, 0.3, 5.6), CFrame.new(0, 1.15, -0.8), ST.base2)
part(m, "Step", Vector3.new(6.5, 0.5, 1.8), CFrame.new(0, 0.25, 3.3), ST.base2)
part(m, "StepTrim", Vector3.new(6.7, 0.1, 2.0), CFrame.new(0, 0.52, 3.3), ST.trim, ST.glow and Enum.Material.Neon or nil)
if _G.WHEEL_STYLE == "Carnival" then
	-- losanges blancs sur le socle "tambour"
	for k = -2, 2 do
		local d = part(m, "Diamond", Vector3.new(0.9, 0.9, 0.12), CFrame.new(k * 2.2, 0.45, 2.42) * CFrame.Angles(0, 0, math.rad(45)), WHITE)
		d.CanCollide = false
	end
end
-- pieds en A derrière le disque + axe
for _, sx in ipairs({ -1, 1 }) do
	local a, b = Vector3.new(sx * 4.4, 1.3, -1.5), Vector3.new(sx * 0.5, HC, -1.5)
	local leg = part(m, "Leg", Vector3.new(0.9, (b - a).Magnitude, 0.9), CFrame.lookAt((a + b) / 2, b) * CFrame.Angles(math.rad(-90), 0, 0), ST.leg,
		ST.glow and Enum.Material.Metal or nil)
	part(m, "LegFoot", Vector3.new(1.6, 0.5, 1.6), CFrame.new(a + Vector3.new(0, 0.1, 0)), ST.trim, ST.glow and Enum.Material.Neon or nil)
	leg.Name = "Leg"
end
zcyl(m, "Axle", 1.2, 1.6, Vector3.new(0, HC, -1.2), Color3.fromRGB(150, 160, 175), Enum.Material.Metal)
-- mât jusqu'au panneau
local signY = HC + R + 3.4
part(m, "Mast", Vector3.new(0.7, signY - HC, 0.7), CFrame.new(0, (HC + signY) / 2, -1.5), ST.leg)

-- [ DISQUE ] ----------------------------------------------------------------------------------
local axis = part(disk, "Axis", Vector3.new(0.4, 0.4, 0.4), CFrame.new(0, HC, 0), WHITE)
axis.Transparency = 1; axis.CanCollide = false; axis.CanQuery = false
disk.PrimaryPart = axis
zcyl(disk, "BackPlate", R * 2 + 1.6, 0.5, Vector3.new(0, HC, -0.45), ST.back)
zcyl(disk, "Band", R * 2 + 0.5, 0.52, Vector3.new(0, HC, -0.2), ST.band, ST.glow and Enum.Material.Neon or nil)
local n = #W.Segments
local span = 360 / n
for i, s in ipairs(W.Segments) do
	local rw = W.Rewards[s.Reward]
	local a0, a1 = s.Angle - span / 2, s.Angle + span / 2
	-- part en éventail : 4 petits triangles pour que le bord soit bien rond
	local sub = 4
	for k = 0, sub - 1 do
		local t0, t1 = a0 + (a1 - a0) * k / sub, a0 + (a1 - a0) * (k + 1) / sub
		tri(disk, Vector3.new(0, HC, 0.05), at(t0, R, 0.05), at(t1, R, 0.05), 0.4, ST.seg(rw.Color))
	end
	-- liseré clair au bord extérieur de la part
	for k = 0, sub - 1 do
		local t0, t1 = a0 + (a1 - a0) * k / sub, a0 + (a1 - a0) * (k + 1) / sub
		local p0, p1 = at(t0, R - 0.35, 0.3), at(t1, R - 0.35, 0.3)
		local mid = (p0 + p1) / 2
		part(disk, "Edge", Vector3.new((p1 - p0).Magnitude + 0.05, 0.22, 0.12), CFrame.new(mid) * CFrame.Angles(0, 0, math.atan2(p1.Y - p0.Y, p1.X - p0.X)),
			ST.edge(rw.Color), ST.edgeMat)
	end
	-- séparateur doré sur le bord de la part
	local dir = at(a0, 1, 0) - Vector3.new(0, HC, 0)
	local mid = Vector3.new(0, HC, 0.35) + dir * (R / 2 + 0.6)
	part(disk, "Separator", Vector3.new(0.26, R - 1.2, 0.2), CFrame.new(mid) * CFrame.Angles(0, 0, math.rad(a0 - 90)), ST.sep,
		ST.glow and Enum.Material.Neon or nil)
	-- icône + texte, lisibles depuis le centre vers l'extérieur
	local radial = (at(s.Angle, 1, 0) - Vector3.new(0, HC, 0)).Unit
	local p = Vector3.new(0, HC, 0.32) + radial * (R * 0.6)
	local holder = part(disk, "Label" .. i, Vector3.new(2.7, 3.2, 0.05), CFrame.fromMatrix(p, radial:Cross(Vector3.zAxis), radial), WHITE)
	holder.Transparency = 1; holder.CanCollide = false; holder.CanQuery = false
	local sg = Instance.new("SurfaceGui"); sg.Name = "Gui"; sg.Face = Enum.NormalId.Back; sg.LightInfluence = 0
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 60; sg.Parent = holder
	local img = Instance.new("ImageLabel"); img.Name = "Icon"; img.BackgroundTransparency = 1; img.Image = ICON[s.Reward]
	img.Position = UDim2.fromScale(0.16, 0.02); img.Size = UDim2.fromScale(0.68, 0.58); img.ScaleType = Enum.ScaleType.Fit; img.Parent = sg
	label(sg, "Text", LABEL[s.Reward], UDim2.fromScale(0, 0.6), UDim2.fromScale(1, 0.34), Color3.new(1, 1, 1), 4)
end
-- jante dorée + ampoules
local RIM = 36
for k = 0, RIM - 1 do
	local t0, t1 = k * 360 / RIM, (k + 1) * 360 / RIM
	local p0, p1 = at(t0, R + 0.4, 0.15), at(t1, R + 0.4, 0.15)
	part(disk, "Rim", Vector3.new((p1 - p0).Magnitude + 0.08, 0.8, 1.0), CFrame.new((p0 + p1) / 2) * CFrame.Angles(0, 0, math.atan2(p1.Y - p0.Y, p1.X - p0.X)),
		ST.rim[(k // 2) % 2 + 1], ST.rimMat)
end
for k = 0, 15 do
	local b = part(disk, "Bulb", Vector3.new(0.5, 0.5, 0.5), CFrame.new(at(k * 22.5 + 11.25, R + 0.4, 0.75)), ST.bulbs[k % 2 + 1],
		Enum.Material.Neon, Enum.PartType.Ball)
	b:SetAttribute("Bulb", k)
end
-- moyeu
zcyl(disk, "Hub", 2.6, 0.8, Vector3.new(0, HC, 0.5), ST.hub[1])
zcyl(disk, "HubRing", 2.0, 0.85, Vector3.new(0, HC, 0.52), ST.hub[2], ST.glow and Enum.Material.Metal or nil)
zcyl(disk, "HubGem", 1.1, 1.0, Vector3.new(0, HC, 0.6), ST.hub[3], ST.glow and Enum.Material.Neon or nil)
local light = Instance.new("PointLight"); light.Color = Color3.fromRGB(255, 220, 140); light.Range = 18; light.Brightness = 1.1; light.Parent = axis

-- [ POINTEUR ] cliquet fin en haut : pivote autour de son axe (PointerCap) quand les séparateurs passent
-- (animation dans Client/LobbyController : toutes les parts nommées "Pointer")
local top = HC + R
tri(m, Vector3.new(-0.45, top + 0.95, 0.95), Vector3.new(0.45, top + 0.95, 0.95), Vector3.new(0, top - 0.5, 0.95), 0.3, ST.pointer)
for _, d in ipairs(m:GetChildren()) do if d:IsA("WedgePart") then d.Name = "Pointer"; d.Material = ST.pointerMat end end
local cap = zcyl(m, "PointerCap", 0.62, 0.5, Vector3.new(0, top + 1.0, 1.0), ST.cap, ST.glow and Enum.Material.Neon or nil)
part(m, "PointerArm", Vector3.new(0.3, 1.2, 0.3), CFrame.new(0, top + 1.45, 0.45) * CFrame.Angles(math.rad(-45), 0, 0), ST.leg)

-- [ PANNEAU ] ------------------------------------------------------------------------------------------
part(m, "SignBack", Vector3.new(10.4, 2.9, 0.5), CFrame.new(0, signY, -1.2), ST.signFrame, ST.glow and Enum.Material.Neon or nil)
local sign = part(m, "Sign", Vector3.new(10, 2.5, 0.5), CFrame.new(0, signY, -0.95), ST.sign)
local ssg = Instance.new("SurfaceGui"); ssg.Name = "SignGui"; ssg.Face = Enum.NormalId.Back; ssg.LightInfluence = 0
ssg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; ssg.PixelsPerStud = 50; ssg.Parent = sign
label(ssg, "Text", "LUCKY WHEEL", UDim2.fromScale(0.04, 0.1), UDim2.fromScale(0.92, 0.8), ST.signText, 4)
if _G.WHEEL_STYLE == "Carnival" then
	-- ampoules autour du panneau
	for k = 0, 8 do
		for _, y in ipairs({ signY + 1.05, signY - 1.05 }) do
			part(m, "SignBulb", Vector3.new(0.3, 0.3, 0.3), CFrame.new(-4.4 + k * 1.1, y, -0.62), WHITE, Enum.Material.Neon, Enum.PartType.Ball)
		end
	end
end
for _, sx in ipairs({ -1, 1 }) do
	part(m, "SignBulb", Vector3.new(0.6, 0.6, 0.6), CFrame.new(sx * 5.3, signY, -0.8), ST.bulbs[2], Enum.Material.Neon, Enum.PartType.Ball)
end

-- [ TIMER ] (texte mis à jour par Client/LobbyController : "Timer") ---------------------------------------
local anchor = part(m, "LabelAnchor", Vector3.new(1, 1, 1), CFrame.new(0, signY + 1.6, -0.9), WHITE)
anchor.Transparency = 1; anchor.CanCollide = false; anchor.CanQuery = false
local bb = Instance.new("BillboardGui"); bb.Name = "Label"; bb.Size = UDim2.fromScale(11, 1.6); bb.StudsOffset = Vector3.new(0, 0.8, 0)
bb.MaxDistance = 200; bb.LightInfluence = 0; bb.Adornee = anchor; bb.Parent = anchor
label(bb, "Timer", "FREE SPIN READY!", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), Color3.fromRGB(120, 255, 140), 3)

-- [ PROMPT ] ------------------------------------------------------------------------------------------------
local pp = Instance.new("ProximityPrompt"); pp.ActionText = "Spin"; pp.ObjectText = "Lucky Wheel"; pp.HoldDuration = 0
pp.MaxActivationDistance = 14; pp.RequiresLineOfSight = false; pp.KeyboardKeyCode = Enum.KeyCode.E
pp:SetAttribute("ClientAction", "Wheel"); pp.Parent = axis

for _, d in ipairs(m:GetDescendants()) do
	if d:IsA("BasePart") and d.Parent == disk then d.CanCollide = false end
end
m.WorldPivot = CFrame.new(0, 0, 0)
m:PivotTo(pivot)
m.Parent = PARENT
return "Wheel ok (" .. #disk:GetChildren() .. " pièces qui tournent)"
