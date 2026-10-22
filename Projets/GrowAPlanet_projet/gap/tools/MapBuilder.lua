-- MapBuilder v2 : à exécuter dans Studio (mode Edit). Construit la map en BRIQUES avec studs.
-- Crée Workspace.Map : Hub (3 stands), chemin circulaire, 8 bases, déco, ciel.
-- Relançable : supprime l'ancienne Map avant.
-- Les noms utilisés par les scripts du jeu sont gardés : Plots/PlotN (Floor, Sign, Spawn,
-- Pads/PadN, Slots/SlotN, Sun, UpgradeBoard, Dynamic), Hub (stands avec prompts "Opens").

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Models = require(ReplicatedStorage.Shared.Visuals.Models)

local old = workspace:FindFirstChild("Map")
if old then old:Destroy() end
local map = Instance.new("Folder")
map.Name = "Map"
map.Parent = workspace

local C = Color3.fromRGB
local COL = {
	tileA = C(58, 46, 110),
	tileB = C(74, 58, 138),
	tileHub = C(86, 70, 160),
	path = C(104, 86, 180),
	pathB = C(84, 68, 150),
	curb = C(40, 32, 80),
	edge = C(0, 230, 255),
	rock = C(38, 30, 66),
	rock2 = C(52, 40, 88),
	violet = C(150, 80, 255),
	gold = C(255, 200, 60),
	white = C(240, 240, 250),
	wood = C(150, 95, 55),
	wood2 = C(120, 72, 40),
	bricks = { C(70, 58, 130), C(80, 66, 145), C(62, 50, 118), C(88, 74, 155) },
}
local rng = Random.new(42)

local PLASTIC = Enum.Material.Plastic
local NEON = Enum.Material.Neon

-- [ OUTILS ] -------------------------------------------------------------------

-- brique : Plastic + studs dessus. collide = true par défaut (sol, murs)
local function part(parent, name, size, cf, color, material, props)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	local mat = material or PLASTIC
	p.Material = mat
	p.Anchored = true
	if mat == PLASTIC then
		p.TopSurface = Enum.SurfaceType.Studs
		p.BottomSurface = Enum.SurfaceType.Inlet
	else
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
	end
	if props then for k, v in pairs(props) do p[k] = v end end
	p.Parent = parent
	return p
end

local function deco(parent, name, size, cf, color, material, props)
	local p = part(parent, name, size, cf, color, material, props)
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	return p
end

-- plaque posée à plat dont l'axe X est vertical (les scripts lisent Size.X comme la hauteur)
-- studs sur la face Right, qui pointe vers le haut après rotation
local function flatPad(parent, name, height, width, cf, color, material, props)
	local p = part(parent, name, Vector3.new(height, width, width), cf * CFrame.Angles(0, 0, math.rad(90)), color, material, props)
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if (material or PLASTIC) == PLASTIC then
		p.RightSurface = Enum.SurfaceType.Studs
		p.LeftSurface = Enum.SurfaceType.Inlet
	end
	return p
end

-- "cercle" en blocs SANS chevauchement (sinon les dessus clignotent / se rentrent dedans) :
-- bandes côte à côte de plus en plus courtes. w = largeur (X), d = profondeur (Z)
local function blockyDisc(parent, name, w, d, h, cf, color, material, props)
	local center = part(parent, name, Vector3.new(w, h, d * 0.42), cf, color, material, props)
	for _, sgn in ipairs({ -1, 1 }) do
		part(parent, name, Vector3.new(w * 0.82, h, d * 0.2), cf * CFrame.new(0, 0, sgn * d * 0.31), color, material, props)
		part(parent, name, Vector3.new(w * 0.5, h, d * 0.09), cf * CFrame.new(0, 0, sgn * d * 0.455), color, material, props)
	end
	return center
end

local function octo(parent, name, w, h, cf, color, material, props)
	return blockyDisc(parent, name, w, w, h, cf, color, material, props)
end

local function sign(parent, name, size, cf, text, color, face)
	local p = part(parent, name, size, cf, C(30, 24, 60), PLASTIC)
	local sg = Instance.new("SurfaceGui")
	sg.Face = face or Enum.NormalId.Front
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sg.PixelsPerStud = 40
	sg.LightInfluence = 0
	local l = Instance.new("TextLabel")
	l.Name = "Label"
	l.Size = UDim2.fromScale(1, 1)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamBlack
	l.TextScaled = true
	l.Text = text
	l.TextColor3 = color or Color3.new(1, 1, 1)
	local st = Instance.new("UIStroke")
	st.Thickness = 4
	st.Parent = l
	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0.05, 0); pad.PaddingRight = UDim.new(0.05, 0)
	pad.PaddingTop = UDim.new(0.1, 0); pad.PaddingBottom = UDim.new(0.1, 0)
	pad.Parent = l
	l.Parent = sg
	sg.Parent = p
	-- cadre en briques autour du panneau
	local sx, sy = size.X, size.Y
	local t = 0.6
	deco(parent, name .. "Frame", Vector3.new(sx + t * 2, t, size.Z + 0.3), cf * CFrame.new(0, sy / 2 + t / 2, 0), COL.gold)
	deco(parent, name .. "Frame", Vector3.new(sx + t * 2, t, size.Z + 0.3), cf * CFrame.new(0, -sy / 2 - t / 2, 0), COL.gold)
	deco(parent, name .. "Frame", Vector3.new(t, sy, size.Z + 0.3), cf * CFrame.new(sx / 2 + t / 2, 0, 0), COL.gold)
	deco(parent, name .. "Frame", Vector3.new(t, sy, size.Z + 0.3), cf * CFrame.new(-sx / 2 - t / 2, 0, 0), COL.gold)
	return p
end

local function prompt(parent, action, object, opens)
	local pp = Instance.new("ProximityPrompt")
	pp.ActionText = action
	pp.ObjectText = object
	pp.HoldDuration = 0
	pp.MaxActivationDistance = 14
	pp.RequiresLineOfSight = false
	pp:SetAttribute("Opens", opens)
	pp.Parent = parent
	return pp
end

-- mur de briques décalées. cf = centre du pied du mur, axe X = longueur
local function brickWall(parent, cf, length, rows, thick)
	local BL, BH = 4, 1.5
	for r = 0, rows - 1 do
		local x = -length / 2 - ((r % 2 == 1) and BL / 2 or 0)
		while x < length / 2 do
			local x0 = math.max(x, -length / 2)
			local x1 = math.min(x + BL, length / 2)
			if x1 - x0 > 0.2 then
				part(parent, "Brick", Vector3.new(x1 - x0 - 0.08, BH, thick), cf * CFrame.new((x0 + x1) / 2, BH / 2 + r * BH, 0),
					COL.bricks[rng:NextInteger(1, #COL.bricks)])
			end
			x += BL
		end
	end
	-- chapeau néon
	deco(parent, "WallCap", Vector3.new(length, 0.3, thick + 0.3), cf * CFrame.new(0, rows * BH + 0.15, 0), COL.edge, NEON)
end

-- lampadaire en blocs
local function lamp(parent, cf, color)
	part(parent, "LampBase", Vector3.new(1.6, 0.6, 1.6), cf * CFrame.new(0, 0.3, 0), COL.curb)
	part(parent, "LampPost", Vector3.new(0.6, 6, 0.6), cf * CFrame.new(0, 3.6, 0), COL.curb)
	deco(parent, "LampArm", Vector3.new(0.4, 0.4, 1.6), cf * CFrame.new(0, 6.5, 0.6), COL.curb)
	local head = deco(parent, "LampHead", Vector3.new(1.3, 1.3, 1.3), cf * CFrame.new(0, 7.2, 0), color or COL.edge, NEON)
	local l = Instance.new("PointLight"); l.Color = color or COL.edge; l.Range = 14; l.Brightness = 1.2; l.Parent = head
end

-- plante extraterrestre en blocs
local function plant(parent, cf, color)
	local h = rng:NextInteger(3, 5)
	part(parent, "Pot", Vector3.new(2.4, 1.4, 2.4), cf * CFrame.new(0, 0.7, 0), COL.wood2)
	for i = 1, h do
		deco(parent, "Stem", Vector3.new(0.5, 1, 0.5), cf * CFrame.new(0, 1.4 + i - 0.5, 0), C(40, 140, 90))
	end
	for i = 1, 4 do
		local a = i / 4 * math.pi * 2 + rng:NextNumber()
		deco(parent, "Leaf", Vector3.new(1.6, 0.35, 0.8), cf * CFrame.new(0, 1.4 + h * 0.6 + i * 0.4, 0) * CFrame.Angles(0, a, math.rad(20)) * CFrame.new(0.8, 0, 0), C(60, 200, 110))
	end
	deco(parent, "Bulb", Vector3.new(1, 1, 1), cf * CFrame.new(0, 1.9 + h, 0) * CFrame.Angles(0, math.rad(45), math.rad(45)), color or C(255, 120, 220), NEON)
end

-- amas de cristaux
local function crystals(parent, cf, color)
	for i = 1, 4 do
		local h = rng:NextNumber(1.5, 4)
		deco(parent, "Crystal", Vector3.new(0.8, h, 0.8), cf * CFrame.new(rng:NextNumber(-1, 1), h / 2, rng:NextNumber(-1, 1)) * CFrame.Angles(rng:NextNumber(-0.3, 0.3), rng:NextNumber() * 3, rng:NextNumber(-0.3, 0.3)),
			color or COL.violet, NEON, { Transparency = 0.1 })
	end
	part(parent, "CrystalRock", Vector3.new(2.6, 0.8, 2.6), cf * CFrame.new(0, 0.4, 0), COL.rock2)
end

-- dessous d'île flottante : étages de roche qui rétrécissent + cristaux qui pendent
local function islandUnder(parent, cf, w, d, depth)
	local steps = 4
	for k = 1, steps do
		local f = 1 - k * 0.18
		local h = depth / steps
		local lcf = cf * CFrame.new(0, -(k - 0.5) * h, 0)
		local col = k % 2 == 0 and COL.rock or COL.rock2
		-- arrondi en bandes de blocs (sans chevauchement), ne dépasse pas du dessus
		blockyDisc(parent, "Under", w * f, d * f, h, lcf, col, Enum.Material.Slate)
	end
	for i = 1, 5 do
		local x = rng:NextNumber(-w * 0.3, w * 0.3)
		local z = rng:NextNumber(-d * 0.3, d * 0.3)
		local h = rng:NextNumber(3, 7)
		deco(parent, "HangCrystal", Vector3.new(1, h, 1), cf * CFrame.new(x, -depth * 0.7 - h / 2, z) * CFrame.Angles(0, math.rad(45), 0), i % 2 == 0 and COL.edge or COL.violet, NEON)
	end
end

-- [ HUB ] ----------------------------------------------------------------------
local hub = Instance.new("Model")
hub.Name = "Hub"
hub.Parent = map

local HUB_R = 46
local RIM_IN = HUB_R - 3 -- bord intérieur du rebord : aucune dalle ne dépasse ce rayon
local T = 8
-- vrai si le carré (centre x,z, côté t) est entièrement dans le cercle de rayon r
local function inside(x, z, t, r)
	local h = t / 2
	for _, c in ipairs({ { x - h, z - h }, { x + h, z - h }, { x - h, z + h }, { x + h, z + h } }) do
		if c[1] * c[1] + c[2] * c[2] > r * r then return false end
	end
	return true
end
-- dalles 8x8 en damier ; au bord, on découpe en dalles 4x4 pour mieux remplir le cercle
for gx = -6, 5 do
	for gz = -6, 5 do
		local x, z = (gx + 0.5) * T, (gz + 0.5) * T
		local col = (gx + gz) % 2 == 0 and COL.tileHub or COL.tileB
		if inside(x, z, T, RIM_IN) then
			part(hub, "Floor", Vector3.new(T - 0.1, 2, T - 0.1), CFrame.new(x, -1, z), col)
		else
			for _, o in ipairs({ { -2, -2 }, { 2, -2 }, { -2, 2 }, { 2, 2 } }) do
				local sx, sz = x + o[1], z + o[2]
				if inside(sx, sz, T / 2, RIM_IN) then
					part(hub, "Floor", Vector3.new(T / 2 - 0.1, 2, T / 2 - 0.1), CFrame.new(sx, -1, sz), col)
				end
			end
		end
	end
end
-- joint sous les dalles (un peu plus bas : visible seulement dans les fentes, ne clignote pas)
blockyDisc(hub, "Grout", RIM_IN * 2 + 2, RIM_IN * 2 + 2, 1.8, CFrame.new(0, -1.05, 0), COL.tileA)
-- bord du hub : rebord surélevé en briques (longueur = corde au rayon intérieur → aucun chevauchement) + bande néon
local RIM_N = 60
for i = 1, RIM_N do
	local a = i / RIM_N * math.pi * 2
	local rot = CFrame.Angles(0, -a + math.pi / 2, 0)
	local len = 2 * RIM_IN * math.sin(math.pi / RIM_N) - 0.05
	part(hub, "Rim", Vector3.new(len, 2.4, 4), CFrame.new(math.cos(a) * (RIM_IN + 2), -0.8, math.sin(a) * (RIM_IN + 2)) * rot, i % 2 == 0 and COL.tileA or COL.tileB)
	local llen = 2 * (RIM_IN + 4) * math.sin(math.pi / RIM_N) - 0.02
	deco(hub, "RimLight", Vector3.new(llen, 0.4, 0.4), CFrame.new(math.cos(a) * (RIM_IN + 4.2), 0.2, math.sin(a) * (RIM_IN + 4.2)) * rot, COL.edge, NEON)
end
islandUnder(hub, CFrame.new(0, -2, 0), 88, 88, 18)

-- piédestal central en marches
octo(hub, "Step1", 26, 1, CFrame.new(0, 0.5, 0), COL.tileA)
octo(hub, "Step2", 19, 1, CFrame.new(0, 1.5, 0), COL.tileB)
octo(hub, "Step3", 12, 1, CFrame.new(0, 2.5, 0), COL.violet)
for i = 1, 8 do
	local a = i / 8 * math.pi * 2
	deco(hub, "StepLight", Vector3.new(1, 1, 1), CFrame.new(math.cos(a) * 12.5, 1.2, math.sin(a) * 12.5) * CFrame.Angles(0, a, 0), COL.edge, NEON)
end
local spawnLoc = Instance.new("SpawnLocation")
spawnLoc.Name = "HubSpawn"
spawnLoc.Size = Vector3.new(10, 1, 10)
spawnLoc.CFrame = CFrame.new(0, 3.5, 0)
spawnLoc.Anchored = true
spawnLoc.Transparency = 1
spawnLoc.CanCollide = false
spawnLoc.Neutral = true
spawnLoc.Duration = 0
spawnLoc.Parent = hub

-- grosse planète en briques au centre (même modèle que dans le jeu, en géant)
local statue = Models.Planet("GoldenSaturn", nil, 14)
statue.Name = "BigPlanet"
statue:PivotTo(CFrame.new(0, 19, 0))
statue:SetAttribute("Spin", 0.2)
statue.Parent = hub
-- colonne lumineuse qui la "porte"
deco(hub, "Beam", Vector3.new(1.5, 9, 1.5), CFrame.new(0, 7.5, 0), COL.edge, NEON, { Transparency = 0.4 })

-- 3 stands en forme de petit marché
local stands = {
	{ name = "Shop", color = C(40, 170, 255), opens = "Shop", angle = 90 },
	{ name = "Sell", color = C(255, 70, 70), opens = "Sell", angle = 210 },
	{ name = "Upgrade", color = C(70, 220, 90), opens = "Upgrades", angle = 330 },
}
for _, s in ipairs(stands) do
	local a = math.rad(s.angle)
	local pos = Vector3.new(math.cos(a) * 30, 0, math.sin(a) * 30)
	local cf = CFrame.lookAt(pos, Vector3.new(0, 0, 0)) -- face vers le centre
	local m = Instance.new("Model")
	m.Name = s.name .. "Stand"
	m.Parent = hub
	part(m, "Base", Vector3.new(18, 1, 12), cf * CFrame.new(0, 0.5, 0.5), COL.curb)
	-- comptoir en briques (2 rangées) + plateau blanc
	for row = 0, 1 do
		for i = -3, 3 do
			local off = (row % 2 == 1) and 1 or 0
			if i + off <= 3 then
				part(m, "CounterBrick", Vector3.new(1.95, 1.5, 3), cf * CFrame.new(i * 2 + off, 1.75 + row * 1.5, -2.5), row == 0 and s.color or s.color:Lerp(Color3.new(1, 1, 1), 0.2))
			end
		end
	end
	local counter = part(m, "Counter", Vector3.new(15, 0.8, 4), cf * CFrame.new(0, 4.4, -2.5), COL.white)
	-- piliers en bois + lanternes
	for _, x in ipairs({ -7.5, 7.5 }) do
		for _, z in ipairs({ -4, 4.5 }) do
			part(m, "Pillar", Vector3.new(1, 10, 1), cf * CFrame.new(x, 6, z), COL.wood)
		end
		local lan = deco(m, "Lantern", Vector3.new(1.2, 1.4, 1.2), cf * CFrame.new(x, 8, -4.8), C(255, 220, 120), NEON)
		local l = Instance.new("PointLight"); l.Color = C(255, 210, 140); l.Range = 12; l.Brightness = 1; l.Parent = lan
	end
	-- auvent rayé (bandes couleur / blanc) en pente
	for i = 0, 8 do
		part(m, "Awning", Vector3.new(2, 0.6, 12), cf * CFrame.new(-8 + i * 2, 11.6, 0.2) * CFrame.Angles(math.rad(-10), 0, 0), i % 2 == 0 and s.color or COL.white)
	end
	deco(m, "AwningEdge", Vector3.new(18.2, 0.4, 0.4), cf * CFrame.new(0, 10.6, -6), COL.edge, NEON)
	sign(m, "Sign", Vector3.new(14, 4, 0.6), cf * CFrame.new(0, 15, 1), string.upper(s.name), Color3.new(1, 1, 1), Enum.NormalId.Front)
	-- caisses
	part(m, "Crate", Vector3.new(2.4, 2.4, 2.4), cf * CFrame.new(10.5, 2.2, -1), COL.wood)
	part(m, "Crate", Vector3.new(1.8, 1.8, 1.8), cf * CFrame.new(10.2, 4.3, -1) * CFrame.Angles(0, 0.4, 0), COL.wood2)
	part(m, "Crate", Vector3.new(2.2, 2.2, 2.2), cf * CFrame.new(-10.5, 2.1, 0), COL.wood2)
	prompt(counter, "Open", s.name, s.opens)
	m.PrimaryPart = counter
end

-- lampadaires autour du piédestal
for i = 1, 6 do
	local a = i / 6 * math.pi * 2 + 0.5
	lamp(hub, CFrame.new(math.cos(a) * 40, 0, math.sin(a) * 40), i % 2 == 0 and COL.violet or COL.edge)
end

-- [ CHEMIN ] -------------------------------------------------------------------
local path = Instance.new("Model")
path.Name = "Path"
path.Parent = map
local SEG = 64
local PATH_R = 54 -- dalles de 47.1 à 60.9 : commence juste après le rebord du hub (47)
local PATH_OUT = PATH_R + 6.9
-- angle des 8 ponts (pas de bordure ni de lampadaire devant un pont)
local function nearBridge(a)
	for k = 1, 8 do
		local b = math.rad((k - 1) * 45 + 22.5)
		local diff = math.abs((a - b + math.pi) % (math.pi * 2) - math.pi)
		if diff < math.rad(8.5) then return true end
	end
	return false
end
local chord = function(r) return 2 * r * math.sin(math.pi / SEG) end
for i = 1, SEG do
	local a = (i / SEG) * math.pi * 2
	local rot = CFrame.Angles(0, -a + math.pi / 2, 0)
	local function at(r, y) return CFrame.new(math.cos(a) * r, y, math.sin(a) * r) * rot end
	-- 2 rangées de dalles décalées d'une demi-dalle. Longueur = corde au bord INTÉRIEUR
	-- de la rangée → les dalles se touchent sans jamais se chevaucher (petit joint côté extérieur)
	local ai = a + (math.pi / SEG)
	local roti = CFrame.Angles(0, -ai + math.pi / 2, 0)
	part(path, "Seg", Vector3.new(chord(PATH_R - 6.9) - 0.08, 1, 6.8), at(PATH_R - 3.5, -0.5), i % 2 == 0 and COL.path or COL.pathB)
	part(path, "Seg", Vector3.new(chord(PATH_R + 0.1) - 0.08, 1, 6.8), CFrame.new(math.cos(ai) * (PATH_R + 3.5), -0.5, math.sin(ai) * (PATH_R + 3.5)) * roti, i % 2 == 1 and COL.path or COL.pathB)
	-- dessous en roche, un sur deux légèrement plus bas (pas de clignotement dans les joints)
	part(path, "Under", Vector3.new(chord(PATH_OUT), 4, 14), at(PATH_R, i % 2 == 0 and -3 or -3.06), COL.rock, Enum.Material.Slate)
	if not nearBridge(a) then
		part(path, "Curb", Vector3.new(chord(PATH_OUT) - 0.05, 1.2, 1), at(PATH_OUT + 0.5, -0.4), COL.curb)
		deco(path, "Light", Vector3.new(chord(PATH_OUT + 1), 0.3, 0.4), at(PATH_OUT + 1.2, -0.1), COL.edge, NEON)
		if i % 8 == 0 then
			lamp(path, at(PATH_OUT + 0.5, 0.2), i % 16 == 0 and COL.violet or COL.edge)
		end
	end
end

-- [ BASES ] --------------------------------------------------------------------
local plots = Instance.new("Folder")
plots.Name = "Plots"
plots.Parent = map

local PLOT_R = 128 -- distance du centre
local W, D = 70, 60 -- largeur (gauche-droite), profondeur

for k = 1, 8 do
	local a = math.rad((k - 1) * 45 + 22.5)
	local center = Vector3.new(math.cos(a) * PLOT_R, 0, math.sin(a) * PLOT_R)
	-- repère local : -Z = vers le hub (entrée)
	local cf = CFrame.lookAt(center, Vector3.new(0, 0, 0))
	local plot = Instance.new("Model")
	plot.Name = "Plot" .. k
	plot:SetAttribute("Index", k)
	plot.Parent = plots

	-- sol en dalles 10x10 (damier) + dalle invisible "Floor" pour le pivot
	local floor = part(plot, "Floor", Vector3.new(W, 2, D), cf * CFrame.new(0, -1.05, 0), COL.tileA, PLASTIC, { Transparency = 1, CanCollide = false, CanQuery = false })
	plot.PrimaryPart = floor
	for gx = 0, 6 do
		for gz = 0, 5 do
			local x = -W / 2 + 5 + gx * 10
			local z = -D / 2 + 5 + gz * 10
			part(plot, "Tile", Vector3.new(9.9, 2, 9.9), cf * CFrame.new(x, -1, z), (gx + gz) % 2 == 0 and COL.tileA or COL.tileB)
		end
	end
	islandUnder(plot, cf * CFrame.new(0, -2, 0), W - 4, D - 4, 16)

	-- murs en briques (côtés + fond + devant avec ouverture)
	brickWall(plot, cf * CFrame.new(0, 0, D / 2 - 0.75), W, 2, 1.5)
	brickWall(plot, cf * CFrame.new(W / 2 - 0.75, 0, 0) * CFrame.Angles(0, math.rad(90), 0), D - 3, 2, 1.5)
	brickWall(plot, cf * CFrame.new(-W / 2 + 0.75, 0, 0) * CFrame.Angles(0, math.rad(90), 0), D - 3, 2, 1.5)
	-- murs de devant : de l'arche (x = 10.2) jusqu'au coin, sans rentrer dans l'arche
	local fw = W / 2 - 10.2
	brickWall(plot, cf * CFrame.new(10.2 + fw / 2, 0, -D / 2 + 0.75), fw, 2, 1.5)
	brickWall(plot, cf * CFrame.new(-10.2 - fw / 2, 0, -D / 2 + 0.75), fw, 2, 1.5)
	-- piliers d'angle avec cube néon
	for _, x in ipairs({ -W / 2 + 1, W / 2 - 1 }) do
		for _, z in ipairs({ -D / 2 + 1, D / 2 - 1 }) do
			part(plot, "Corner", Vector3.new(3, 5, 3), cf * CFrame.new(x, 2.5, z), COL.rock2)
			deco(plot, "CornerLight", Vector3.new(1.6, 1.6, 1.6), cf * CFrame.new(x, 5.8, z) * CFrame.Angles(0, math.rad(45), 0), COL.edge, NEON)
		end
	end

	-- pont vers le chemin (dalles + bordures)
	-- le pont va du bord de la base jusqu'au bord EXTÉRIEUR du chemin, sans le chevaucher
	local bridgeLen = PLOT_R - D / 2 - PATH_OUT
	local bz = -D / 2 - bridgeLen / 2
	local nb = math.max(1, math.floor(bridgeLen / 4))
	for i = 1, nb do
		local z0 = -D / 2 - (i - 0.5) * bridgeLen / nb
		part(plot, "Bridge", Vector3.new(14, 1, bridgeLen / nb - 0.1), cf * CFrame.new(0, -0.5, z0), i % 2 == 0 and COL.path or COL.pathB)
	end
	part(plot, "BridgeRail", Vector3.new(1, 1.6, bridgeLen), cf * CFrame.new(7.5, 0, bz), COL.curb)
	part(plot, "BridgeRail", Vector3.new(1, 1.6, bridgeLen), cf * CFrame.new(-7.5, 0, bz), COL.curb)
	deco(plot, "BridgeLight", Vector3.new(0.4, 0.3, bridgeLen), cf * CFrame.new(7.5, 0.9, bz), COL.edge, NEON)
	deco(plot, "BridgeLight", Vector3.new(0.4, 0.3, bridgeLen), cf * CFrame.new(-7.5, 0.9, bz), COL.edge, NEON)

	-- arche d'entrée en briques + panneau avec le nom
	for _, x in ipairs({ -9, 9 }) do
		for r = 0, 7 do
			part(plot, "ArchBrick", Vector3.new(2.4, 1.5, 2.4), cf * CFrame.new(x, 0.75 + r * 1.5, -D / 2), r % 2 == 0 and COL.violet or C(120, 60, 220))
		end
		deco(plot, "ArchLight", Vector3.new(1.6, 1.6, 1.6), cf * CFrame.new(x, 13, -D / 2) * CFrame.Angles(0, math.rad(45), 0), COL.gold, NEON)
	end
	part(plot, "ArchTop", Vector3.new(21, 1.5, 2.4), cf * CFrame.new(0, 12.75, -D / 2), COL.violet)
	sign(plot, "Sign", Vector3.new(18, 4, 1), cf * CFrame.new(0, 16.2, -D / 2), "Empty Base", Color3.new(1, 1, 1), Enum.NormalId.Front)

	local spawn = part(plot, "Spawn", Vector3.new(4, 1, 4), cf * CFrame.new(0, 0.5, -D / 2 + 6) * CFrame.Angles(0, math.pi, 0), COL.tileA, nil, { Transparency = 1, CanCollide = false, CanQuery = false })
	spawn.Name = "Spawn"

	-- spawners à gauche (+X) : socle en marches + plaque à studs + coins néon
	local pads = Instance.new("Folder")
	pads.Name = "Pads"
	pads.Parent = plot
	for i = 1, 4 do
		local z = -16 + (i - 1) * 11
		local pcf = cf * CFrame.new(20, 0, z)
		part(plot, "PadBase", Vector3.new(10, 0.5, 10), pcf * CFrame.new(0, 0.25, 0), COL.curb)
		local pad = flatPad(pads, "Pad" .. i, 1, 8, pcf * CFrame.new(0, 1, 0), i == 4 and C(120, 90, 30) or COL.tileB)
		pad:SetAttribute("Index", i)
		for _, cx in ipairs({ -4.4, 4.4 }) do
			for _, cz in ipairs({ -4.4, 4.4 }) do
				deco(plot, "PadLight", Vector3.new(1, 1, 1), pcf * CFrame.new(cx, 1.15, cz), i == 4 and COL.gold or COL.edge, NEON)
			end
		end
		-- numéro du spawner
		deco(plot, "PadMark", Vector3.new(0.6, 0.2, 3), pcf * CFrame.new(-4.6, 0.6, 0), i == 4 and COL.gold or COL.edge, NEON)
	end
	-- panneau d'upgrades à côté des spawners (pieds en briques)
	local board = sign(plot, "UpgradeBoard", Vector3.new(12, 7, 0.8), cf * CFrame.new(30, 5.5, 6) * CFrame.Angles(0, math.rad(90), 0), "UPGRADES", C(120, 255, 120), Enum.NormalId.Front)
	for _, dz in ipairs({ -4.5, 4.5 }) do
		part(plot, "BoardLeg", Vector3.new(1, 1.3, 1), cf * CFrame.new(30, 0.65, 6 + dz), COL.wood)
	end
	prompt(board, "Open", "Upgrades", "Upgrades")

	-- incubateur à droite (-X) : socle octogonal à marches + dôme en arceaux de briques
	local icf = cf * CFrame.new(-16, 0, 2)
	octo(plot, "IncubatorBase", 30, 0.8, icf * CFrame.new(0, 0.4, 0), COL.tileB)
	octo(plot, "IncubatorBase2", 26, 0.6, icf * CFrame.new(0, 1.1, 0), COL.tileA)
	for i = 1, 16 do
		local aa = i / 16 * math.pi * 2
		deco(plot, "IncubatorRim", Vector3.new(5.6, 0.4, 0.5), icf * CFrame.Angles(0, aa, 0) * CFrame.new(0, 0.9, 14.6), COL.violet, NEON)
	end
	-- arceaux (6 demi-cercles de blocs)
	local DR = 14.5
	for rib = 0, 5 do
		local ra = rib / 6 * math.pi
		for j = 1, 11 do
			local t = (j - 0.5) / 11 * math.pi
			local pos = Vector3.new(math.cos(t) * DR, math.sin(t) * DR * 0.9, 0)
			deco(plot, "DomeRib", Vector3.new(1.2, 4.2, 0.8), icf * CFrame.Angles(0, ra, 0) * CFrame.new(pos) * CFrame.Angles(0, 0, t - math.pi / 2),
				j % 2 == 0 and C(150, 200, 255) or C(200, 230, 255), Enum.Material.Glass, { Transparency = 0.45 })
		end
	end
	deco(plot, "DomeTop", Vector3.new(3, 1, 3), icf * CFrame.new(0, DR * 0.9 + 0.4, 0) * CFrame.Angles(0, math.rad(45), 0), COL.edge, NEON)
	part(plot, "Dome", Vector3.new(29, 26, 29), icf * CFrame.new(0, 0, 0), C(150, 200, 255), Enum.Material.Glass,
		{ Shape = Enum.PartType.Ball, Transparency = 0.9, CanCollide = false, CanQuery = false, CastShadow = false })
	local slots = Instance.new("Folder")
	slots.Name = "Slots"
	slots.Parent = plot
	local n = 0
	for row = 0, 1 do
		for col = 0, 2 do
			n += 1
			local scf = cf * CFrame.new(-10 - row * 12, 1.4, -8 + col * 10)
			part(plot, "SlotStand", Vector3.new(6, 0.6, 6), scf * CFrame.new(0, -0.1, 0), COL.curb)
			local s = flatPad(slots, "Slot" .. n, 0.6, 5, scf * CFrame.new(0, 0.5, 0), COL.violet, NEON, { Transparency = 0.25, CanCollide = false })
			s:SetAttribute("Index", n)
		end
	end
	sign(plot, "IncubatorSign", Vector3.new(14, 3, 0.6), cf * CFrame.new(-16, 4.5, -14), "INCUBATOR", C(220, 170, 255), Enum.NormalId.Front)

	-- soleil en blocs au-dessus de la base (les planètes équipées tournent autour, côté client)
	local scf = cf * CFrame.new(0, 26, 8)
	local sun = part(plot, "Sun", Vector3.new(6, 6, 6), scf, C(255, 190, 60), NEON, { CanCollide = false, CastShadow = false })
	local sl = Instance.new("PointLight"); sl.Color = C(255, 200, 120); sl.Range = 45; sl.Brightness = 2.5; sl.Parent = sun
	deco(plot, "SunCore", Vector3.new(7.5, 4.5, 4.5), scf, C(255, 160, 40), NEON)
	deco(plot, "SunCore", Vector3.new(4.5, 7.5, 4.5), scf, C(255, 160, 40), NEON)
	deco(plot, "SunCore", Vector3.new(4.5, 4.5, 7.5), scf, C(255, 160, 40), NEON)
	for i = 1, 8 do
		local ra = i / 8 * math.pi * 2
		deco(plot, "SunRay", Vector3.new(1.2, 1.2, 3), scf * CFrame.Angles(0, ra, 0) * CFrame.new(0, 0, 6) * CFrame.Angles(0, 0, math.rad(45)), C(255, 220, 90), NEON)
		deco(plot, "SunRay", Vector3.new(1, 1, 2.4), scf * CFrame.Angles(ra, 0, math.rad(90)) * CFrame.new(0, 0, 6), C(255, 200, 70), NEON, { Transparency = 0.2 })
	end
	deco(plot, "SunGlow", Vector3.new(10, 10, 10), scf * CFrame.Angles(0, math.rad(45), math.rad(45)), C(255, 140, 40), NEON, { Transparency = 0.8 })

	-- déco de la base : plantes, cristaux, lampadaires à l'entrée
	plant(plot, cf * CFrame.new(W / 2 - 5, 0, D / 2 - 5), C(255, 120, 220))
	plant(plot, cf * CFrame.new(-W / 2 + 5, 0, D / 2 - 5), C(120, 220, 255))
	plant(plot, cf * CFrame.new(-W / 2 + 5, 0, -D / 2 + 5), C(255, 220, 90))
	crystals(plot, cf * CFrame.new(4, 0, D / 2 - 5), COL.edge)
	crystals(plot, cf * CFrame.new(W / 2 - 6, 0, -D / 2 + 6), COL.violet)
	lamp(plot, cf * CFrame.new(6, 0, -D / 2 + 3), COL.gold)
	lamp(plot, cf * CFrame.new(-6, 0, -D / 2 + 3), COL.gold)

	local dyn = Instance.new("Folder")
	dyn.Name = "Dynamic"
	dyn.Parent = plot
end

-- [ DÉCO : astéroïdes en blocs, cristaux, satellites ] ---------------------------
local decor = Instance.new("Folder")
decor.Name = "Decor"
decor.Parent = map
for i = 1, 40 do
	local a = rng:NextNumber() * math.pi * 2
	local r = rng:NextNumber(195, 330)
	local s = rng:NextNumber(4, 12)
	local cf = CFrame.new(math.cos(a) * r, rng:NextNumber(-60, 80), math.sin(a) * r) * CFrame.Angles(rng:NextNumber() * 6, rng:NextNumber() * 6, rng:NextNumber() * 6)
	-- astéroïde = 3 à 5 blocs collés
	for j = 1, rng:NextInteger(3, 5) do
		local bs = s * rng:NextNumber(0.45, 0.8)
		deco(decor, "Asteroid", Vector3.new(bs, bs * rng:NextNumber(0.6, 1), bs * rng:NextNumber(0.7, 1.1)),
			cf * CFrame.new(rng:NextNumber(-0.4, 0.4) * s, rng:NextNumber(-0.3, 0.3) * s, rng:NextNumber(-0.4, 0.4) * s),
			j % 2 == 0 and C(84, 70, 120) or C(70, 58, 104), PLASTIC)
	end
	if i % 3 == 0 then
		deco(decor, "Crystal", Vector3.new(s * 0.22, s * 0.7, s * 0.22), cf * CFrame.new(0, s * 0.55, 0) * CFrame.Angles(0, 0.7, 0), i % 2 == 0 and COL.edge or COL.violet, NEON)
	end
end
-- satellites
for i = 1, 6 do
	local a = i / 6 * math.pi * 2 + 0.3
	local cf = CFrame.new(math.cos(a) * 240, rng:NextNumber(40, 90), math.sin(a) * 240) * CFrame.Angles(0, a, rng:NextNumber(-0.4, 0.4))
	deco(decor, "Satellite", Vector3.new(3, 3, 4), cf, C(220, 220, 230), PLASTIC)
	deco(decor, "SatDish", Vector3.new(2.4, 0.4, 2.4), cf * CFrame.new(0, 2, 0), C(200, 200, 210), PLASTIC)
	for _, side in ipairs({ -1, 1 }) do
		deco(decor, "SolarPanel", Vector3.new(6, 0.3, 2.6), cf * CFrame.new(side * 5, 0, 0), C(40, 80, 200), PLASTIC)
		deco(decor, "SatArm", Vector3.new(2, 0.3, 0.3), cf * CFrame.new(side * 2, 0, 0), C(160, 160, 170), PLASTIC)
	end
	deco(decor, "SatLight", Vector3.new(0.6, 0.6, 0.6), cf * CFrame.new(0, 2.6, 0), C(255, 60, 60), NEON)
end
-- nébuleuses : grandes formes néon très transparentes, très loin
for i = 1, 10 do
	local a = rng:NextNumber() * math.pi * 2
	local r = rng:NextNumber(700, 900)
	local s = rng:NextNumber(200, 400)
	deco(decor, "Nebula", Vector3.new(s, s * 0.6, s), CFrame.new(math.cos(a) * r, rng:NextNumber(50, 300), math.sin(a) * r),
		i % 2 == 0 and C(120, 50, 220) or C(40, 120, 255), NEON,
		{ Shape = Enum.PartType.Ball, Transparency = 0.93 })
end

-- [ CIEL / LUMIÈRE ] -----------------------------------------------------------
Lighting.ClockTime = 0
Lighting.Brightness = 2
Lighting.Ambient = C(80, 70, 120)
Lighting.OutdoorAmbient = C(120, 105, 170)
Lighting.EnvironmentDiffuseScale = 0.4
Lighting.EnvironmentSpecularScale = 0.4
Lighting.GlobalShadows = true
for _, c in ipairs(Lighting:GetChildren()) do
	if c:IsA("Sky") or c:IsA("Atmosphere") or c:IsA("BloomEffect") or c:IsA("ColorCorrectionEffect") or c:IsA("SunRaysEffect") or c:IsA("DepthOfFieldEffect") then c:Destroy() end
end
local sky = Instance.new("Sky")
sky.StarCount = 6000
sky.CelestialBodiesShown = false
sky.Parent = Lighting
local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.6; bloom.Size = 30; bloom.Threshold = 1.6
bloom.Parent = Lighting
local cc = Instance.new("ColorCorrectionEffect")
cc.Saturation = 0.25; cc.Contrast = 0.08; cc.TintColor = C(240, 235, 255)
cc.Parent = Lighting
workspace.FallenPartsDestroyHeight = -120
workspace.StreamingEnabled = false -- petite map : tout est chargé, les orbites trouvent toujours le soleil
workspace.Gravity = 160

pcall(function() game:GetService("Players").MaxPlayers = 8 end)
local count = 0
for _, d in ipairs(map:GetDescendants()) do if d:IsA("BasePart") then count += 1 end end
local _ = CollectionService
return "Map construite (" .. count .. " parts)"
