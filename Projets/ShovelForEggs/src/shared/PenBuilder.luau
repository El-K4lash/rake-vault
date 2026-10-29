--!strict
-- Shared/PenBuilder
-- Enclos repris du Rake Vault (constellation "Enclos"), style chalet : poteaux en bois, chapeaux de neige, portail "Player's Chalet"
-- avec lanternes, chaînes et grand panneau. Géométrie portée des modèles procéduraux du vault (pens_fence_*, pens_gate_*).
--   root : CFrame au centre de l'entrée, au niveau du sol ; LookVector = vers l'intérieur de l'enclos
--   width / length : taille intérieure (studs) ; style : couleurs (Upgrades.FenceStyles)
-- Renvoie un Model "Pen" avec : Fence, Gate, Decor, Floor, Area (zone de balade, invisible), Spawn, CollectPad.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PenBuilder = {}

-- style hiver : poteaux en bois sombre, chapeaux enneigés, chaînes givrées
local NAVY = Color3.fromRGB(92, 58, 32)
local NAVY2 = Color3.fromRGB(122, 80, 44)
local GOLD_L = Color3.fromRGB(255, 226, 122)
local CHAIN = Color3.fromRGB(205, 220, 232)
local SNOWC = Color3.fromRGB(244, 248, 255)
local BAY = 6.7      -- largeur d'une travée (comme le vault : 20 studs = 3 travées)
local GATE = 7.8     -- demi-largeur de l'entrée (axe des poteaux du portail)

local function tint(c: Color3, k: number): Color3
	local h, s, v = c:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(v * (1 + k), 0, 1))
end

local function railColor(style: any, i: number): Color3
	if style.Rainbow then return Color3.fromHSV((i * 0.07) % 1, 0.75, 1) end
	return style.Rail
end

local function mk(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, neon: boolean?): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Anchored = true
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = neon and Enum.Material.Neon or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end

-- B(x, yb, z, w, h, d) du vault : boîte posée (yb = bas de la boîte) dans le repère F
local function B(parent: Instance, F: CFrame, x: number, yb: number, z: number, w: number, h: number, d: number, c: Color3, neon: boolean?, rz: number?, ry: number?): Part
	return mk(parent, "P", Vector3.new(w, h, d), F * CFrame.new(x, yb + h / 2, z) * CFrame.Angles(0, ry or 0, rz or 0), c, neon)
end

-- petit chapeau pointu (cône 4 faces du vault) : 2 paliers tournés à 45°
local function cap(parent: Instance, F: CFrame, x: number, y: number, z: number, w: number, h: number, c: Color3)
	local r = math.rad(45)
	B(parent, F, x, y, z, w * 0.72, h * 0.5, w * 0.72, c, false, 0, r)
	B(parent, F, x, y + h * 0.5, z, w * 0.36, h * 0.5, w * 0.36, c, false, 0, r)
end

-- clôture du vault entre a et b (au sol) : poteaux bleu nuit + travées (2 rails + croix + losange)
local function fence(parent: Instance, a: Vector3, b: Vector3, style: any, counter: { n: number }, firstPost: boolean)
	local L = (b - a).Magnitude
	if L < 1 then return end
	local dir = (b - a).Unit
	local F = CFrame.fromMatrix(a, dir, Vector3.yAxis)
	local segs = math.max(1, math.round(L / BAY))
	local sl = L / segs
	local post = style.Post or NAVY
	local neon = style.Neon == true
	for i = firstPost and 0 or 1, segs do
		local x = i * sl
		B(parent, F, x, 0, 0, 1.15, 5.0, 1.15, post)
		B(parent, F, x, 0.9, 0, 1.35, 0.3, 1.35, style.Post and tint(post, 0.25) or NAVY2)
		B(parent, F, x, 5.0, 0, 1.45, 0.35, 1.45, post)
		cap(parent, F, x, 5.35, 0, 0.98, 0.6, style.Cap or SNOWC)
	end
	for i = 0, segs - 1 do
		counter.n += 1
		local rail = railColor(style, counter.n)
		local dark = tint(rail, -0.28)
		local mid, w = (i + 0.5) * sl, sl - 1.15
		B(parent, F, mid, 3.55, 0, w, 0.62, 0.5, rail, neon)
		B(parent, F, mid, 3.84, 0, w, 0.06, 0.52, dark)
		B(parent, F, mid, 0.7, 0, w, 0.62, 0.5, rail, neon)
		B(parent, F, mid, 0.99, 0, w, 0.06, 0.52, dark)
		local h = 2.85
		local len = math.sqrt(w * w + h * h) - 0.3
		local an = math.atan2(h, w)
		mk(parent, "P", Vector3.new(len, 0.42, 0.32), F * CFrame.new(mid, 2.6, 0) * CFrame.Angles(0, 0, an), rail, neon)
		mk(parent, "P", Vector3.new(len, 0.42, 0.32), F * CFrame.new(mid, 2.6, 0) * CFrame.Angles(0, 0, -an), rail, neon)
		mk(parent, "P", Vector3.new(0.4, 0.4, 0.46), F * CFrame.new(mid, 2.6, 0) * CFrame.Angles(0, 0, math.pi / 4), post)
	end
end

-- portail "Player's Chalet" du vault (pens_gate_*) : 2 gros poteaux à lanterne, linteau, chaînes, grand panneau
local function gate(g: Model, root: CFrame, style: any, ownerName: string?)
	local rail = railColor(style, 1)
	local post = style.Post or NAVY
	local neon = style.Neon == true
	local LIFT = 3.5 -- portail rehaussé : le panneau passe bien au-dessus des joueurs
	for _, sd in ipairs({ -1, 1 }) do
		local gx = sd * GATE
		B(g, root, gx, 0, 0, 2.6, 1.3, 2.6, style.Post and tint(post, 0.25) or NAVY2)
		B(g, root, gx, 1.3, 0, 1.75, 10.4 + LIFT, 1.75, post)
		B(g, root, gx, 3.8, 0, 1.95, 0.35, 1.95, rail, neon)
		B(g, root, gx, 7.6 + LIFT, 0, 1.95, 0.35, 1.95, rail, neon)
		B(g, root, gx, 11.7 + LIFT, 0, 1.7, 0.3, 1.7, post)
		local lantern = B(g, root, gx, 12.0 + LIFT, 0, 1.0, 1.15, 1.0, style.Accent or GOLD_L, true)
		lantern.Name = "Lantern"
		local light = Instance.new("PointLight")
		light.Color = style.Accent or GOLD_L; light.Range = 14; light.Brightness = 1.2; light.Shadows = false
		light.Parent = lantern
		for _, q in ipairs({ { -1, -1 }, { 1, -1 }, { -1, 1 }, { 1, 1 } }) do
			B(g, root, gx + q[1] * 0.58, 12.0 + LIFT, q[2] * 0.58, 0.16, 1.15, 0.16, post)
		end
		B(g, root, gx, 13.15 + LIFT, 0, 1.7, 0.25, 1.7, post)
		cap(g, root, gx, 13.3 + LIFT, 0, 1.2, 0.9, style.Cap or SNOWC)
	end
	B(g, root, 0, 10.45 + LIFT, 0, 17.6, 1.2, 1.35, post)
	B(g, root, 0, 10.9 + LIFT, 0, 16.8, 0.3, 1.45, rail, neon)
	for _, chx in ipairs({ -4.6, 4.6 }) do B(g, root, chx, 9.95 + LIFT, 0, 0.13, 0.5, 0.13, CHAIN) end
	B(g, root, 0, 6.7 + LIFT, 0, 15.9, 3.45, 0.55, rail, neon)
	local board = B(g, root, 0, 6.85 + LIFT, 0, 15.2, 3.15, 0.72, NAVY)
	board.Name = "Sign"
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local sg = Instance.new("SurfaceGui")
		sg.Name = "OwnerSign"; sg.Face = face; sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 40
		sg.LightInfluence = 0; sg.MaxDistance = 220; sg.Parent = board
		local t = Instance.new("TextLabel")
		t.Name = "Text"; t.BackgroundTransparency = 1; t.Size = UDim2.fromScale(0.94, 0.78); t.Position = UDim2.fromScale(0.03, 0.11)
		t.TextScaled = true; t.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
		t.TextColor3 = Color3.new(1, 1, 1); t.Text = ownerName and (ownerName .. "'s Chalet") or "Player's Chalet"; t.Parent = sg
		local st = Instance.new("UIStroke"); st.Thickness = 3; st.Color = Color3.fromRGB(10, 16, 22); st.Parent = t
	end
end

-- déco d'enclos du vault (foin, abreuvoir, gamelle, nid) : clonée côté serveur depuis ServerStorage.Vault.pens
local function vaultModel(name: string): Model?
	if RunService:IsClient() and RunService:IsRunning() then return nil end
	local ss = game:GetService("ServerStorage")
	local v = ss:FindFirstChild("Vault")
	if not v then return nil end
	for _, f in ipairs(v:GetChildren()) do
		local m = f:FindFirstChild(name)
		if m then return m :: Model end
	end
	return nil
end

-- deux grands panneaux contre la clôture du fond, tournés vers l'entrée : UPGRADES (gauche) et STATS (droite).
-- Le contenu est une SurfaceGui de StarterGui (vraies instances) que le client du propriétaire pose dessus (Adornee).
local BOARD_W, BOARD_H = 13, 9.6
local SLATE = Color3.fromRGB(40, 62, 54)
-- panneaux aux couleurs de la clôture : poteaux / linteau = couleur des poteaux, planches et cadre = couleur des rails,
-- mêmes chapeaux pointus et petites lanternes que le portail. Neon / arc-en-ciel suivent le style.
local function boards(pen: Model, root: CFrame, length: number, style: any)
	local post = style.Post or NAVY
	local post2 = style.Post and tint(post, 0.25) or NAVY2
	local neon = style.Neon == true
	for bi, b in ipairs({ { "UpgradeBoard", -8.3 }, { "StatsBoard", 8.3 } }) do
		local rail = railColor(style, bi * 3)
		local railD = tint(rail, -0.28)
		local m = Instance.new("Model"); m.Name = b[1] .. "Model"; m.Parent = pen
		local F = root * CFrame.new(b[2] :: number, 0, -(length - 2.2)) * CFrame.Angles(0, math.pi, 0)
		local hw = BOARD_W / 2
		local topY = BOARD_H + 2.0
		-- poteaux comme ceux de la clôture (socle, bague, chapeau pointu) + lanterne
		for _, sx in ipairs({ -1, 1 }) do
			local x = sx * (hw + 0.55)
			B(m, F, x, 0, 0.15, 1.9, 0.9, 1.9, post2)
			B(m, F, x, 0.9, 0.15, 1.3, topY + 0.4, 1.3, post)
			B(m, F, x, 3.2, 0.15, 1.5, 0.3, 1.5, rail, neon)
			B(m, F, x, topY - 1.0, 0.15, 1.5, 0.3, 1.5, rail, neon)
			B(m, F, x, topY + 1.3, 0.15, 1.45, 0.3, 1.45, post)
			local lan = B(m, F, x, topY + 1.6, 0.15, 0.85, 0.95, 0.85, style.Accent or Color3.fromRGB(255, 226, 122), true)
			lan.Name = "Lantern"
			local pl = Instance.new("PointLight"); pl.Color = lan.Color; pl.Range = 10; pl.Brightness = 0.9; pl.Shadows = false; pl.Parent = lan
			B(m, F, x, topY + 2.55, 0.15, 1.45, 0.25, 1.45, post)
			cap(m, F, x, topY + 2.8, 0.15, 1.1, 0.8, style.Cap or SNOWC)
		end
		-- dos en planches (rail / rail foncé, comme les rails de la clôture)
		local n = 6
		for i = 0, n - 1 do
			B(m, F, 0, 1.2 + i * (BOARD_H + 0.6) / n, 0.2, BOARD_W + 0.2, (BOARD_H + 0.6) / n - 0.08, 0.3, i % 2 == 0 and railD or rail, neon and i % 2 == 1)
		end
		-- ardoise + cadre couleur rail
		local face = B(m, F, 0, 1.5, -0.02, BOARD_W - 0.4, BOARD_H, 0.12, SLATE)
		face.Name = b[1] :: string
		face.Material = Enum.Material.Slate
		B(m, F, 0, 1.15, -0.1, BOARD_W + 0.2, 0.4, 0.34, rail, neon)
		B(m, F, 0, BOARD_H + 1.45, -0.1, BOARD_W + 0.2, 0.4, 0.34, rail, neon)
		for _, sx in ipairs({ -1, 1 }) do B(m, F, sx * (hw - 0.1), 1.15, -0.1, 0.4, BOARD_H + 0.7, 0.34, rail, neon) end
		-- linteau comme le portail : poutre couleur poteau + liseré couleur rail, petit losange au centre
		B(m, F, 0, topY, 0.15, BOARD_W + 2.6, 0.9, 1.1, post)
		B(m, F, 0, topY + 0.35, 0.15, BOARD_W + 2.2, 0.22, 1.2, rail, neon)
		mk(m, "P", Vector3.new(0.7, 0.7, 0.5), F * CFrame.new(0, topY + 0.45, -0.45) * CFrame.Angles(0, 0, math.pi / 4), style.Accent or rail, true)
		-- clous
		for _, p in ipairs({ { -hw + 0.6, 1.75 }, { hw - 0.6, 1.75 }, { -hw + 0.6, BOARD_H + 1.15 }, { hw - 0.6, BOARD_H + 1.15 } }) do
			B(m, F, p[1], p[2], -0.17, 0.18, 0.18, 0.06, post)
		end
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then d.CanQuery = d == face; d.CastShadow = true end
		end
	end
end

-- igloo construit bloc par bloc (même style que la clôture) : dôme en briques de glace décalées, joints bleutés,
-- tunnel d'entrée en arche, intérieur sombre éclairé en orange, fenêtre de glace, lanterne, tas de neige.
--   F : CFrame au sol au centre de l'igloo, LookVector = côté de l'entrée
local ICE = { Color3.fromRGB(242, 249, 255), Color3.fromRGB(222, 238, 253), Color3.fromRGB(204, 226, 250) }
local SEAM = Color3.fromRGB(165, 200, 232)
local function igloo(parent: Instance, F: CFrame): Model
	local m = Instance.new("Model"); m.Name = "Igloo"; m.Parent = parent
	local R, T = 5.4, 0.85 -- rayon extérieur, épaisseur des briques
	local rings = 6
	local dTh = (math.pi / 2) / (rings + 0.6)
	local doorHalf = 1.9 -- demi-largeur de l'ouverture dans le dôme
	local rnd = Random.new(7)
	local function ice(): Color3 return ICE[rnd:NextInteger(1, #ICE)] end
	-- coque intérieure bleutée : se voit entre les briques comme des joints
	local shell = mk(m, "Shell", Vector3.new(2 * (R - T * 0.6), 2 * (R - T * 0.6), 2 * (R - T * 0.6)), F, SEAM)
	shell.Shape = Enum.PartType.Ball
	-- dôme : anneaux de briques, décalés d'une demi-brique un anneau sur deux
	for i = 0, rings - 1 do
		local th = (i + 0.5) * dTh
		local rc = (R - T / 2) * math.cos(th)
		local y = (R - T / 2) * math.sin(th)
		local n = math.max(6, math.round(2 * math.pi * rc / 2.3))
		local bl = 2 * math.pi * rc / n
		local bh = R * dTh
		for j = 0, n - 1 do
			local phi = (j + (i % 2) * 0.5) / n * 2 * math.pi
			local a = (phi + math.pi) % (2 * math.pi) - math.pi
			local skip = y < 3.4 and math.abs(math.sin(a)) * rc < doorHalf + bl * 0.3 and math.cos(a) > 0
			if not skip then
				local win = (i == 2 and j == math.floor(n * 0.3))
				local p = mk(m, win and "Window" or "Brick", Vector3.new(bl * 0.93, bh * 0.9, T),
					F * CFrame.Angles(0, -phi, 0) * CFrame.new(0, y, -rc) * CFrame.Angles(th, 0, 0), win and Color3.fromRGB(150, 225, 255) or ice(), win)
				if win then
					p.Transparency = 0.15
					local pl = Instance.new("PointLight"); pl.Color = Color3.fromRGB(255, 190, 110); pl.Range = 8; pl.Brightness = 0.8; pl.Shadows = false; pl.Parent = p
				end
			end
		end
	end
	-- sommet : 2 galettes de neige
	local topY = (R - T / 2) * math.sin(rings * dTh)
	local c1 = mk(m, "Cap", Vector3.new(0.6, 2 * (R - T / 2) * math.cos(rings * dTh) + 0.6, 2 * (R - T / 2) * math.cos(rings * dTh) + 0.6), F * CFrame.new(0, topY + 0.1, 0) * CFrame.Angles(0, 0, math.pi / 2), SNOWC)
	c1.Shape = Enum.PartType.Cylinder
	-- tunnel d'entrée : 3 arches de briques (voûte en demi-cercle) devant l'ouverture
	local ra, ay = 2.05, 0.35
	for k = 0, 2 do
		local z = -(R - 0.25) - k * 1.15
		local nb = 7
		for b = 0, nb - 1 do
			local al = (b + 0.5 + (k % 2) * 0.25) / nb * math.pi
			if al < math.pi then
				local x, yy = math.cos(al) * ra, ay + math.sin(al) * ra
				mk(m, "Arch", Vector3.new(0.8, math.pi * ra / nb * 0.92, 1.08), F * CFrame.new(x, yy, z) * CFrame.Angles(0, 0, al - math.pi / 2), ice())
			end
		end
		-- pieds de l'arche jusqu'au sol
		for _, sx in ipairs({ -1, 1 }) do mk(m, "Arch", Vector3.new(0.8, ay + 0.3, 1.08), F * CFrame.new(sx * ra, (ay + 0.3) / 2, z), ice()) end
	end
	-- intérieur sombre + lueur chaude
	local door = mk(m, "Door", Vector3.new(0.2, 2 * (ra - 0.35), 2 * (ra - 0.35)), F * CFrame.new(0, ay, -(R - 0.55)) * CFrame.Angles(0, math.pi / 2, 0), Color3.fromRGB(26, 30, 52))
	door.Shape = Enum.PartType.Cylinder
	local glow = mk(m, "Glow", Vector3.new(1.4, 0.15, 1.2), F * CFrame.new(0, 0.4, -(R - 0.2)), Color3.fromRGB(255, 150, 70), true)
	glow.Transparency = 1 -- seule la lumière se voit (lueur chaude au fond du tunnel)
	local gl = Instance.new("PointLight"); gl.Color = Color3.fromRGB(255, 170, 90); gl.Range = 9; gl.Brightness = 1.4; gl.Shadows = false; gl.Parent = glow
	-- socle de neige + petits tas
	local base = mk(m, "SnowBase", Vector3.new(0.35, 2 * R + 2.6, 2 * R + 2.6), F * CFrame.new(0, 0.18, -0.8) * CFrame.Angles(0, 0, math.pi / 2), SNOWC)
	base.Shape = Enum.PartType.Cylinder
	for _, s in ipairs({ { -R - 0.4, 1.6, 1.8 }, { R + 0.2, -1.2, 1.4 }, { 2.6, -R - 2.2, 1.1 } }) do
		local b = mk(m, "Pile", Vector3.new(s[3] * 2, s[3], s[3] * 2), F * CFrame.new(s[1], 0.2, s[2]), SNOWC)
		b.Shape = Enum.PartType.Ball
	end
	-- lanterne sur piquet à côté de l'entrée (comme celles du portail)
	local LF = F * CFrame.new(-ra - 1.4, 0, -(R + 1.6))
	B(m, LF, 0, 0, 0, 0.35, 3.2, 0.35, NAVY)
	B(m, LF, 0, 3.2, 0, 0.75, 0.2, 0.75, NAVY)
	local lan = B(m, LF, 0, 3.4, 0, 0.6, 0.7, 0.6, GOLD_L, true)
	local ll = Instance.new("PointLight"); ll.Color = GOLD_L; ll.Range = 8; ll.Brightness = 1; ll.Shadows = false; ll.Parent = lan
	B(m, LF, 0, 4.1, 0, 0.75, 0.18, 0.75, NAVY)
	cap(m, LF, 0, 4.28, 0, 0.7, 0.55, SNOWC)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.CanCollide = false; d.CanQuery = false; d.CanTouch = false; d.CastShadow = true end
	end
	return m
end
PenBuilder.Igloo = igloo

local function decor(pen: Model, root: CFrame, width: number, length: number)
	local folder = Instance.new("Model"); folder.Name = "Decor"; folder.Parent = pen
	local hw = width / 2
	-- igloo (fait main) tourné vers le centre de l'enclos
	do
		local pos = (root * CFrame.new(-hw + 7.5, 0, -9)).Position
		local center = (root * CFrame.new(0, 0, -length / 2)).Position
		igloo(folder, CFrame.lookAt(pos, Vector3.new(center.X, pos.Y, center.Z)))
	end
	-- décor hiver : igloo, feu de camp, caisses, sapin enneigé (modèles du vault, échelle = hauteur)
	-- 4e valeur (optionnelle) = part de la hauteur à enterrer : l'igloo a une sphère sous son disque de neige,
	-- son vrai sol est au milieu du disque (47 % de la hauteur), sinon il flotte
	local spots = {
		{ "general_campfire", root * CFrame.new(hw - 5, 0, -length * 0.5), 2.6 },
		{ "general_crates", root * CFrame.new(-hw + 3.5, 0, -length * 0.5) * CFrame.Angles(0, math.pi / 2, 0), 3 },
		{ "biomes_ice_tree_small", root * CFrame.new(hw - 5, 0, -length + 5) * CFrame.Angles(0, math.rad(-15), 0), 7 },
		{ "biomes_ice_sp_snowman", root * CFrame.new(hw - 6, 0, -7), 4.5 },
	}
	for _, s in ipairs(spots) do
		local tpl = vaultModel(s[1] :: string)
		if tpl then
			local m = tpl:Clone()
			-- pivot remis droit (exports du vault) puis mise à l'échelle sur la hauteur voulue
			local lo, hi = Vector3.new(1e9, 1e9, 1e9), Vector3.new(-1e9, -1e9, -1e9)
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then
					local cf, h = d.CFrame, d.Size / 2
					local ex = Vector3.new(math.abs(cf.RightVector.X) * h.X + math.abs(cf.UpVector.X) * h.Y + math.abs(cf.LookVector.X) * h.Z,
						math.abs(cf.RightVector.Y) * h.X + math.abs(cf.UpVector.Y) * h.Y + math.abs(cf.LookVector.Y) * h.Z,
						math.abs(cf.RightVector.Z) * h.X + math.abs(cf.UpVector.Z) * h.Y + math.abs(cf.LookVector.Z) * h.Z)
					lo = lo:Min(d.Position - ex); hi = hi:Max(d.Position + ex)
				end
			end
			if lo.X < 1e8 then m.WorldPivot = CFrame.new((lo.X + hi.X) / 2, lo.Y, (lo.Z + hi.Z) / 2) end
			local hgt = hi.Y - lo.Y
			if hgt > 0.1 then m:ScaleTo(m:GetScale() * (s[3] :: number) / hgt) end
			local sink = (s[4] :: number?) or 0
			m:PivotTo((s[2] :: CFrame) * CFrame.new(0, -sink * (s[3] :: number), 0))
			-- 5e valeur = true : la porte (la plus grande pièce noire du modèle) regarde le centre de l'enclos
			if s[5] then
				local door: BasePart?, area = nil, 0
				for _, d in ipairs(m:GetDescendants()) do
					if d:IsA("BasePart") and d.BrickColor == BrickColor.new("Really black") then
						local sz = d.Size
						local a = sz.X * sz.Y + sz.Y * sz.Z + sz.X * sz.Z
						if a > area then door, area = d, a end
					end
				end
				if door then
					local piv = m:GetPivot()
					local center = (root * CFrame.new(0, 0, -length / 2)).Position
					local want = Vector3.new(center.X - piv.X, 0, center.Z - piv.Z)
					local have = Vector3.new(door.Position.X - piv.X, 0, door.Position.Z - piv.Z)
					if want.Magnitude > 0.01 and have.Magnitude > 0.01 then
						want, have = want.Unit, have.Unit
						local delta = math.atan2(have:Cross(want).Y, have:Dot(want))
						m:PivotTo(CFrame.new(piv.Position) * CFrame.Angles(0, delta, 0) * (piv - piv.Position))
					end
				end
			end
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then d.CanCollide = false; d.CanQuery = false; d.CanTouch = false; d.CastShadow = true end
			end
			m.Parent = folder
		end
	end
end

function PenBuilder.Build(parent: Instance, root: CFrame, width: number, length: number, style: any, ownerName: string?): Model
	local old = parent:FindFirstChild("Pen")
	if old then old:Destroy() end
	local pen = Instance.new("Model")
	pen.Name = "Pen"
	local fenceM = Instance.new("Model"); fenceM.Name = "Fence"; fenceM.Parent = pen
	local hw = width / 2
	local function P(x: number, d: number): Vector3
		return (root * CFrame.new(x, 0, -d)).Position
	end
	local c = { n = 0 }
	-- devant (de part et d'autre du portail), côtés, fond
	fence(fenceM, P(-hw, 0), P(-GATE - 1.3, 0), style, c, true)
	fence(fenceM, P(GATE + 1.3, 0), P(hw, 0), style, c, true)
	fence(fenceM, P(hw, 0), P(hw, length), style, c, false)
	fence(fenceM, P(hw, length), P(-hw, length), style, c, false)
	fence(fenceM, P(-hw, length), P(-hw, 0), style, c, false)
	local g = Instance.new("Model"); g.Name = "Gate"; g.Parent = pen
	gate(g, root, style, ownerName)
	-- sol de neige tassée à damier
	local floor = mk(pen, "Floor", Vector3.new(width, 0.2, length), root * CFrame.new(0, 0.1, -length / 2), Color3.fromRGB(236, 242, 250))
	floor.Material = Enum.Material.Plastic
	floor.CastShadow = false
	local tx = Instance.new("Texture")
	tx.Texture = "rbxassetid://6372755229"; tx.Face = Enum.NormalId.Top; tx.StudsPerTileU = 8; tx.StudsPerTileV = 8
	tx.Transparency = 0.8; tx.Color3 = Color3.new(0, 0, 0); tx.Parent = floor
	-- zone de balade (invisible)
	local area = mk(pen, "Area", Vector3.new(width - 5, 1, length - 6), root * CFrame.new(0, 0.5, -length / 2 - 0.5), Color3.new(1, 1, 1))
	area.Transparency = 1; area.CanCollide = false; area.CanQuery = false; area.CanTouch = false
	-- point d'apparition du joueur : juste devant l'entrée
	local sp = mk(pen, "Spawn", Vector3.new(4, 1, 4), root * CFrame.new(0, 0.5, 13), Color3.new(1, 1, 1))
	sp.Transparency = 1; sp.CanCollide = false; sp.CanQuery = false; sp.CanTouch = false
	decor(pen, root, width, length)
	boards(pen, root, length, style)
	-- pad de collecte (pad du kit) devant à droite
	local kit = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Kit")
	local padTpl = kit and kit:FindFirstChild("Pad")
	local padCf = root * CFrame.new(hw - 4.5, 0, 7)
	local pad: BasePart
	if padTpl then
		local m = padTpl:Clone()
		m.Name = "CollectPad"
		m:PivotTo(padCf * CFrame.new(0, 0.15, 0))
		m.Parent = pen
		pad = (m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart", true)) :: BasePart
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then d.Color = Color3.fromRGB(60, 235, 90) end
		end
		if m:IsA("BasePart") then m.Color = Color3.fromRGB(60, 235, 90) end
	else
		pad = mk(pen, "CollectPad", Vector3.new(7, 0.4, 7), padCf * CFrame.new(0, 0.2, 0), Color3.fromRGB(60, 235, 90), true)
	end
	pad.CanTouch = true
	pen.PrimaryPart = area
	pen.Parent = parent
	return pen
end

return PenBuilder
