-- build_map.lua : construit toute la map de Rake for Brainrots dans Workspace.Map à partir de la map v1
-- (île, zones, chemins) et des modèles Steal an Egg rangés dans ServerStorage.SAE.
-- Disposition : maquette Claude Design (lobby au centre, 8 enclos en cercle, route des 5 biomes vers +Z).
-- À lancer une fois en Edit (require du module). Tout reste en vraies instances.
local SAE = game.ServerStorage.SAE
local MAP = workspace.Map
local CHECK, WALL = "rbxassetid://6372755229", "rbxassetid://6905003203"
local NAVY = Color3.fromRGB(27, 42, 53)
local GRASS, DIRT, SAND = Color3.fromRGB(105, 208, 20), Color3.fromRGB(226, 145, 74), Color3.fromRGB(246, 224, 168)
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy) -- (FredokaOne ne se charge pas dans les BillboardGui)
local rng = Random.new(42)
local log = {}

-- [ OUTILS ] ---------------------------------------------------------------------
local function texture(p, top, sides, tile)
	for _, c in ipairs(p:GetChildren()) do if c:IsA("Texture") or c:IsA("Decal") then c:Destroy() end end
	if top then
		local t = Instance.new("Texture"); t.Texture = CHECK; t.Face = top == true and Enum.NormalId.Top or top
		t.StudsPerTileU = tile or 8; t.StudsPerTileV = tile or 8; t.Transparency = 0.8; t.Color3 = Color3.new(0, 0, 0); t.Parent = p
	end
	if sides then
		for _, f in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right }) do
			local t = Instance.new("Texture"); t.Texture = WALL; t.Face = f; t.StudsPerTileU = 8; t.StudsPerTileV = 8; t.Transparency = 0.9; t.Parent = p
		end
	end
end
local function part(parent, name, size, cf, col, mat, shape)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or Enum.Material.Plastic; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if shape then p.Shape = shape end
	p.Parent = parent
	return p
end
local function disk(parent, name, d, yTop, h, col)
	return part(parent, name, Vector3.new(h, d, d), CFrame.new(0, yTop - h / 2, 0) * CFrame.Angles(0, 0, math.rad(90)), col, nil, Enum.PartType.Cylinder)
end
local function clean(m)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("LuaSourceContainer") or d:IsA("Sound") or d:IsA("ProximityPrompt") or d:IsA("ClickDetector") then d:Destroy()
		elseif d:IsA("BasePart") then d.Anchored = true end
	end
	return m
end
local function bottomTo(m, pos)
	local cf, s = m:GetBoundingBox()
	m:PivotTo(m:GetPivot() + (pos - Vector3.new(cf.X, cf.Y - s.Y / 2, cf.Z)))
end
local function scaleKeepBase(m, k)
	local cf, s = m:GetBoundingBox()
	local base = Vector3.new(cf.X, cf.Y - s.Y / 2, cf.Z)
	m:ScaleTo(m:GetScale() * k)
	bottomTo(m, base)
end
local function yaw(d) return math.atan2(d.X, d.Z) end
local function flat(v) return Vector3.new(v.X, 0, v.Z).Unit end
local function polar(deg, r) local a = math.rad(deg); return Vector3.new(math.sin(a) * r, 0, math.cos(a) * r) end
-- place un modèle au point (deg, r) avec sa face avant (frontLocal, dans l'espace du pivot) tournée vers le centre
local function placeFacing(m, frontLocal, deg, r)
	local at = polar(deg, r)
	local cur = flat(m:GetPivot():VectorToWorldSpace(frontLocal))
	local want = flat(-at)
	m:PivotTo(CFrame.Angles(0, yaw(want) - yaw(cur), 0) * (m:GetPivot() - m:GetPivot().Position) + m:GetPivot().Position)
	bottomTo(m, at + Vector3.new(0, 0.2, 0))
	return at, want
end
local function bigLabel(adornee, text, color, offsetY)
	local bb = Instance.new("BillboardGui"); bb.Name = "Label"; bb.Size = UDim2.fromScale(12, 3); bb.StudsOffset = Vector3.new(0, offsetY, 0)
	bb.MaxDistance = 260; bb.LightInfluence = 0; bb.AlwaysOnTop = false; bb.Adornee = adornee; bb.Parent = adornee
	local t = Instance.new("TextLabel"); t.BackgroundTransparency = 1; t.Size = UDim2.fromScale(1, 1); t.TextScaled = true; t.FontFace = FONT
	t.Text = text; t.TextColor3 = color or Color3.new(1, 1, 1); t.Parent = bb
	local s = Instance.new("UIStroke"); s.Thickness = 4; s.Parent = t
	return bb
end
local PROPS = SAE.SAE_Build_Rest.Props
local function find(zone, name)
	for _, d in ipairs(PROPS[zone]:GetDescendants()) do
		if d.Name == name and (d:IsA("Model") or d:IsA("BasePart")) then return d end
	end
end
-- clone d'un prop SAE, mis à l'échelle (h = hauteur, ou largeur si w) et posé au sol
local function prop(src, parent, pos, h, w, opts)
	opts = opts or {}
	local m = src:Clone()
	if m:IsA("BasePart") then local mm = Instance.new("Model"); mm.Name = m.Name; m.Parent = mm; m = mm end
	clean(m)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then
			d.CanCollide = opts.collide or false; d.CanQuery = false; d.CanTouch = false
			if opts.tint then d.Color = opts.tint end
			if opts.mat then d.Material = opts.mat end
		end
	end
	local _, size = m:GetBoundingBox()
	local dim = w and math.max(size.X, size.Z) or size.Y
	m:ScaleTo(m:GetScale() * h / math.max(dim, 0.2))
	m:PivotTo(CFrame.new(m:GetPivot().Position) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0))
	bottomTo(m, pos + Vector3.new(0, (opts.y or 0) - 0.1, 0))
	m.Parent = parent
	return m
end

-- [ 1. ÎLE ] ----------------------------------------------------------------------
do
	local I = MAP.Island
	for _, n in ipairs({ "Ground", "GroundZones" }) do
		local g = I[n]; g.Material = Enum.Material.Plastic; g.Color = GRASS; texture(g, true, false)
	end
	for _, n in ipairs({ "Sand", "SandZones" }) do
		local s = I[n]; s.Material = Enum.Material.Plastic; s.Color = DIRT; texture(s, true, true)
	end
	-- l'île des zones descend jusqu'à z = 770 (la zone Void va jusqu'à 732 : avant, le bord passait au milieu)
	I.GroundZones.Size = Vector3.new(260, 8, 630); I.GroundZones.Position = Vector3.new(0, -4, 455)
	I.SandZones.Size = Vector3.new(300, 2, 670); I.SandZones.Position = Vector3.new(0, -7.6, 455)
	I.Water.Color = Color3.fromRGB(56, 200, 230); I.Water.Material = Enum.Material.Glass; I.Water.Transparency = 0.15
	I.Seabed.Color = Color3.fromRGB(230, 205, 150)
	local old = I:FindFirstChild("Rim"); if old then old:Destroy() end
	local rim = Instance.new("Model"); rim.Name = "Rim"; rim.Parent = I
	local pts = { Vector3.new(-210, 0, -210), Vector3.new(210, 0, -210), Vector3.new(210, 0, 210), Vector3.new(130, 0, 210),
		Vector3.new(130, 0, 770), Vector3.new(-130, 0, 770), Vector3.new(-130, 0, 210), Vector3.new(-210, 0, 210) }
	for i, a in ipairs(pts) do
		local b = pts[i % #pts + 1]
		local mid, len = (a + b) / 2, (b - a).Magnitude
		part(rim, "Rim", Vector3.new(2.4, 1.2, len + 2.4), CFrame.lookAt(mid + Vector3.new(0, 0.6, 0), b + Vector3.new(0, 0.6, 0)), Color3.fromRGB(0, 231, 0), Enum.Material.Neon)
	end
	local L = game.Lighting
	L.ClockTime = 14; L.Brightness = 2.6; L.EnvironmentDiffuseScale = 0.7; L.EnvironmentSpecularScale = 0.4
	L.OutdoorAmbient = Color3.fromRGB(150, 150, 165); L.Ambient = Color3.fromRGB(100, 100, 115); L.GlobalShadows = true
	for _, c in ipairs(L:GetChildren()) do c:Destroy() end
	local sky = Instance.new("Sky"); sky.Parent = L
	local a = Instance.new("Atmosphere"); a.Density = 0.22; a.Haze = 0.8; a.Color = Color3.fromRGB(200, 230, 255); a.Decay = Color3.fromRGB(150, 200, 255); a.Parent = L
	local b = Instance.new("BloomEffect"); b.Intensity = 0.35; b.Size = 24; b.Threshold = 1.3; b.Parent = L
	local cc = Instance.new("ColorCorrectionEffect"); cc.Saturation = 0.12; cc.Contrast = 0.05; cc.Parent = L
	table.insert(log, "île ok")
end
task.wait()

-- [ 2. ENCLOS : 8 points d'ancrage (Root) à 76 studs, entrée tournée vers le lobby ] ----
do
	local P = MAP.Plots
	P:ClearAllChildren()
	local spots = { { 27.5, -70.85 }, { 68.1, -33.75 }, { 73.03, 21.03 }, { 39.72, 64.79 }, { -39.72, 64.79 }, { -73.03, 21.03 }, { -68.1, -33.75 }, { -27.5, -70.85 } }
	for i, s in ipairs(spots) do
		local m = Instance.new("Model"); m.Name = "Plot" .. i; m.Parent = P
		local at = Vector3.new(s[1], 0.5, s[2])
		local r = part(m, "Root", Vector3.new(4, 1, 4), CFrame.lookAt(at, at + flat(at)), Color3.new(1, 1, 1))
		r.Transparency = 1; r.CanCollide = false; r.CanQuery = false; r.CanTouch = false
		m.PrimaryPart = r
	end
	table.insert(log, "8 enclos ok")
end
task.wait()

-- [ 3. LOBBY ] -------------------------------------------------------------------
local H = MAP.Hub
do
	-- on garde la place et le chemin des zones (slabs x=0, z>=49), le reste part
	for _, c in ipairs(H:GetChildren()) do
		local keepSlab = c.Name == "Slab" and c:IsA("BasePart") and math.abs(c.Position.X) < 1 and c.Position.Z >= 49
		if not (keepSlab or c.Name == "Plaza") then c:Destroy() end
	end
	local plaza = H.Plaza
	plaza.Size = Vector3.new(1.2, 104, 104); plaza.CFrame = CFrame.new(0, -0.4, 0) * CFrame.Angles(0, 0, math.rad(90))
	plaza.Material = Enum.Material.Plastic; plaza.Color = DIRT; texture(plaza, Enum.NormalId.Right, false)
	disk(H, "PlazaBorder", 107, 0.1, 1.2, NAVY)
	local inner = disk(H, "PlazaInner", 62, 0.3, 0.4, SAND); texture(inner, Enum.NormalId.Right, false)
	disk(H, "InnerBorder", 64, 0.25, 0.4, NAVY)
	-- jardinière centrale : tools/build_lobby.lua (lobby_planter du vault)
	local deco = Instance.new("Folder"); deco.Name = "Decor"; deco.Parent = H
	-- chemin des zones : terre à damier
	for _, c in ipairs(H:GetChildren()) do
		if c.Name == "Slab" then c.Material = Enum.Material.Plastic; c.Color = DIRT; c.Size = Vector3.new(9, 0.3, c.Size.Z); texture(c, true, false) end
	end
	-- chemins vers les 8 enclos
	local paths = Instance.new("Folder"); paths.Name = "PenPaths"; paths.Parent = H
	for _, p in ipairs(MAP.Plots:GetChildren()) do
		local dir = flat(p.Root.Position)
		-- du bord de la place (r = 51.23, le chemin passe SOUS la bordure : dessus à 0.14 < place 0.2) jusqu'au portail (r = 76)
		local a, b = dir * 51.23, dir * 76
		local pp = part(paths, "Path", Vector3.new(9, 0.22, (b - a).Magnitude), CFrame.lookAt((a + b) / 2 + Vector3.new(0, 0.03, 0), b + Vector3.new(0, 0.03, 0)), DIRT)
		texture(pp, true, false)
	end
	-- spawn
	local sp = Instance.new("SpawnLocation"); sp.Name = "SpawnLocation"; sp.Anchored = true; sp.Size = Vector3.new(8, 1, 8)
	sp.CFrame = CFrame.new(0, 0.6, 16); sp.Transparency = 1; sp.CanCollide = false; sp.Duration = 0; sp.Parent = H
	for _, d in ipairs(sp:GetChildren()) do d:Destroy() end
	table.insert(log, "place ok")
end
task.wait()

-- stands, machine Rebirth, classements, coffre, jardinière, lampadaires : voir tools/build_lobby.lua
-- (modèles du vault, catégorie Lobby) — à lancer juste après ce script.


-- décor du lobby : arbres, bambous, buissons, fleurs entre les chemins
do
	local deco = H.Decor
	local angs = {}
	for _, p in ipairs(MAP.Plots:GetChildren()) do local r = p.Root.Position; table.insert(angs, math.atan2(r.X, r.Z)) end
	local function blocked(x, z)
		if math.abs(x) < 9 and z > 0 then return true end
		local a = math.atan2(x, z)
		for _, b in ipairs(angs) do if math.abs((a - b + math.pi) % (2 * math.pi) - math.pi) < math.rad(14) then return true end end
		return false
	end
	local specs = {
		{ find("Zone4Props", "Tree2"), 10, { 13, 17 }, { 57, 64 }, 11 },
		{ find("Zone8Props", "Bush"), 16, { 3, 4.5 }, { 53, 60 }, 6 },
		{ find("Zone8Props", "Flower"), 20, { 3, 4 }, { 47, 52 }, 3, true },
		{ find("Zone2Props", "Bamboo"), 6, { 8, 11 }, { 58, 64 }, 8 },
	}
	local placed = {}
	for _, s in ipairs(specs) do
		for _ = 1, s[2] do
			for _ = 1, 80 do
				local a = rng:NextNumber(0, math.pi * 2); local r = rng:NextNumber(s[4][1], s[4][2])
				local x, z = math.sin(a) * r, math.cos(a) * r
				local ok = not blocked(x, z)
				if ok then for _, q in ipairs(placed) do if (q - Vector3.new(x, 0, z)).Magnitude < s[5] then ok = false; break end end end
				if ok then
					table.insert(placed, Vector3.new(x, 0, z))
					prop(s[1], deco, Vector3.new(x, 0, z), rng:NextNumber(s[3][1], s[3][2]), s[6])
					break
				end
			end
		end
	end
	table.insert(log, "décor lobby " .. #deco:GetChildren())
end
task.wait()

-- arbres éparpillés sur l'île (loin des enclos, du lobby et des zones)
do
	local f = MAP.Island:FindFirstChild("Trees") or Instance.new("Folder"); f.Name = "Trees"; f.Parent = MAP.Island; f:ClearAllChildren()
	local tree, bush = find("Zone4Props", "Tree2"), find("Zone8Props", "Bush")
	local n = 0
	for _ = 1, 400 do
		local x, z = rng:NextNumber(-200, 200), rng:NextNumber(-200, 200)
		local d = math.sqrt(x * x + z * z)
		local inZoneCorridor = math.abs(x) < 60 and z > 110
		if d > 175 and not inZoneCorridor then
			prop(rng:NextNumber() < 0.6 and tree or bush, f, Vector3.new(x, 0, z), rng:NextNumber() < 0.6 and rng:NextNumber(12, 18) or rng:NextNumber(3, 5))
			n += 1
			if n % 20 == 0 then task.wait() end
		end
		if n >= 45 then break end
	end
	-- le long du couloir des zones
	for zz = 150, 690, 30 do
		for _, sx in ipairs({ -1, 1 }) do
			if rng:NextNumber() < 0.7 then prop(rng:NextNumber() < 0.5 and tree or bush, f, Vector3.new(sx * rng:NextNumber(60, 120), 0, zz + rng:NextNumber(-10, 10)), rng:NextNumber(4, 16)) end
		end
	end
	table.insert(log, "arbres île " .. #f:GetChildren())
end
task.wait()

-- [ 4. ZONES (biomes) ] -------------------------------------------------------------
do
	local function fenceSeg(parent, a, b, col)
		local mid, len = (a + b) / 2, (b - a).Magnitude
		local cf = CFrame.lookAt(mid, b)
		part(parent, "FenceRail", Vector3.new(0.5, 0.6, len - 1), cf * CFrame.new(0, 5, 0), col)
		part(parent, "FenceRail", Vector3.new(0.5, 0.6, len - 1), cf * CFrame.new(0, 0.85, 0), col)
		local diag, ang = math.sqrt((len - 1) ^ 2 + 4.15 ^ 2), math.atan2(4.15, len - 1)
		part(parent, "FenceRail", Vector3.new(0.36, 0.6, diag), cf * CFrame.new(0, 2.92, 0) * CFrame.Angles(ang, 0, 0), col)
		part(parent, "FenceRail", Vector3.new(0.28, 0.6, diag), cf * CFrame.new(0, 2.92, 0) * CFrame.Angles(-ang, 0, 0), col)
	end
	local function side(parent, a, b, col)
		local len = (b - a).Magnitude; if len < 1 then return end
		local n = math.max(1, math.round(len / 10.5)); local prev = a
		local function post(at) part(parent, "FencePost", Vector3.new(1, 5.4, 1), CFrame.new(at + Vector3.new(0, 2.7, 0)), NAVY) end
		post(a)
		for k = 1, n do local p = a:Lerp(b, k / n); post(p); fenceSeg(parent, prev, p, col); prev = p end
	end
	local function decorate(zf, specs)
		local d = zf:FindFirstChild("Decor"); if d then d:Destroy() end
		d = Instance.new("Folder"); d.Name = "Decor"; d.Parent = zf
		local cz = zf.Ground.Position.Z
		local pondR = zf.Pond.Size.X / 2 + 3
		local placed = {}
		for _, s in ipairs(specs) do
			if not s.src then continue end
			for _ = 1, s.n do
				for _ = 1, 60 do
					local x, z = rng:NextNumber(-38, 38), rng:NextNumber(-38, 38)
					local ok = (s.pond and (x * x + z * z < (pondR - 6) ^ 2)) or (not s.pond and x * x + z * z > pondR * pondR and math.abs(x) > 7 and not (x < -32 and z < -30))
					if ok and not s.pond then for _, q in ipairs(placed) do if (q - Vector3.new(x, 0, z)).Magnitude < (s.gap or 6) then ok = false; break end end end
					if ok then
						table.insert(placed, Vector3.new(x, 0, z))
						prop(s.src, d, Vector3.new(x, 0, cz + z), rng:NextNumber(s.h[1], s.h[2]), s.w, { tint = s.tint, mat = s.mat, y = s.y })
						break
					end
				end
			end
		end
	end
	local function style(zf, ground, rail, back)
		local g = zf.Ground; g.Material = Enum.Material.Plastic; g.Color = ground; texture(g, true, true)
		for _, c in ipairs(zf:GetChildren()) do
			if c.Name == "Slab" then c.Material = Enum.Material.Plastic; c.Color = DIRT; c.Size = Vector3.new(9, 0.3, c.Size.Z); texture(c, true, false) end
			if c.Name == "PondEdge" or c.Name == "GatePost" then c.Material = Enum.Material.Plastic; c.Color = NAVY end
			if c.Name == "FencePost" or c.Name == "FenceRail" or c.Name == "Fence" then c:Destroy() end
		end
		zf.GateTop.Color = rail; zf.GateTop.Material = Enum.Material.Plastic
		local f = Instance.new("Model"); f.Name = "Fence"
		local cz, h = g.Position.Z, g.Size.X / 2
		local V = function(x, z) return Vector3.new(x, 0, z) end
		side(f, V(-h, cz - h), V(-9.5, cz - h), rail); side(f, V(9.5, cz - h), V(h, cz - h), rail)
		side(f, V(h, cz - h), V(h, cz + h), rail)
		if back then side(f, V(h, cz + h), V(6, cz + h), rail); side(f, V(-6, cz + h), V(-h, cz + h), rail) else side(f, V(h, cz + h), V(-h, cz + h), rail) end
		side(f, V(-h, cz + h), V(-h, cz - h), rail)
		f.Parent = zf
		-- nom du biome en gros au-dessus du portail
		local ns = zf:FindFirstChild("NameSign")
		if ns then
			for _, c in ipairs(ns:GetChildren()) do if c:IsA("BillboardGui") then c:Destroy() end end
			bigLabel(ns, string.upper(zf.Name), rail, 0).Size = UDim2.fromScale(22, 5)
		end
	end
	local Z = MAP.Zones
	style(Z.Beach, Color3.fromRGB(244, 206, 118), Color3.fromRGB(255, 170, 60), true)
	decorate(Z.Beach, {
		{ src = find("Zone3Props", "Cactus_1"), n = 7, h = { 9, 13 }, gap = 8 }, { src = find("Zone3Props", "Cactus_2"), n = 6, h = { 5, 7 } },
		{ src = find("Zone3Props", "Cactus_4"), n = 6, h = { 3, 5 } }, { src = find("Zone3Props", "Cactus_3"), n = 6, h = { 2, 3 } },
		{ src = find("Zone7Props", "Coral"), n = 3, h = { 7, 10 }, gap = 8 }, { src = find("Zone7Props", "Skeleton V.2"), n = 2, h = { 5, 6 }, gap = 10 },
		{ src = find("Zone1Props", "Model"), n = 4, h = { 4, 6 }, gap = 9 },
	})
	task.wait()
	style(Z.Swamp, Color3.fromRGB(72, 160, 52), Color3.fromRGB(110, 220, 70), true)
	Z.Swamp.Pond.Color = Color3.fromRGB(70, 170, 120)
	decorate(Z.Swamp, {
		{ src = find("Zone4Props", "Tree2"), n = 5, h = { 16, 22 }, gap = 14 }, { src = find("Zone2Props", "Bamboo"), n = 6, h = { 9, 13 } },
		{ src = find("Zone8Props", "Bush"), n = 6, h = { 3, 4.5 }, gap = 7 }, { src = find("Zone4Props", "Grass"), n = 14, h = { 2, 3 }, gap = 3 },
		{ src = find("Zone8Props", "Flower"), n = 8, h = { 3, 4 }, w = true, gap = 3 },
		{ src = find("Zone4Props", "Lilypad"), n = 4, h = { 5, 7 }, w = true, pond = true, y = 0.35 },
	})
	task.wait()
	style(Z.Volcano, Color3.fromRGB(70, 52, 52), Color3.fromRGB(255, 90, 40), true)
	decorate(Z.Volcano, {
		{ src = find("Zone6Props", "volcano"), n = 2, h = { 8, 10 }, gap = 20 }, { src = find("Zone6Props", "BurntTree"), n = 8, h = { 12, 18 }, gap = 9 },
		{ src = find("Zone12Props", "RockPile1"), n = 4, h = { 2.5, 3.5 }, gap = 9 }, { src = find("Zone12Props", "RockPile2"), n = 4, h = { 2, 3 }, gap = 9 },
		{ src = find("Zone12Props", "Cube.018"), n = 5, h = { 7, 11 }, gap = 8 },
	})
	task.wait()
	style(Z.Ice, Color3.fromRGB(228, 242, 255), Color3.fromRGB(110, 200, 255), true)
	local ice = {}
	for _, m in ipairs(PROPS.Zone5Props:GetChildren()) do if m:IsA("Model") then table.insert(ice, { src = m, n = 4, h = { 9, 16 }, gap = 10 }) end end
	table.insert(ice, { src = find("Zone12Props", "Gemstone1"), n = 4, h = { 4, 6 }, tint = Color3.fromRGB(140, 220, 255), mat = Enum.Material.Glass, gap = 8 })
	table.insert(ice, { src = find("Zone12Props", "Gemstone2"), n = 4, h = { 3, 5 }, tint = Color3.fromRGB(180, 235, 255), mat = Enum.Material.Glass, gap = 8 })
	table.insert(ice, { src = find("Zone8Props", "Bush"), n = 6, h = { 3, 4 }, tint = Color3.fromRGB(240, 248, 255), gap = 7 })
	decorate(Z.Ice, ice)
	task.wait()
	style(Z.Void, Color3.fromRGB(58, 34, 104), Color3.fromRGB(180, 100, 255), false)
	decorate(Z.Void, {
		{ src = find("Zone12Props", "Gemstone1"), n = 6, h = { 5, 8 }, tint = Color3.fromRGB(190, 90, 255), mat = Enum.Material.Neon, gap = 9 },
		{ src = find("Zone12Props", "Gemstone2"), n = 6, h = { 4, 6 }, tint = Color3.fromRGB(120, 200, 255), mat = Enum.Material.Neon, gap = 9 },
		{ src = find("Zone12Props", "Cube.018"), n = 5, h = { 8, 13 }, tint = Color3.fromRGB(40, 20, 70), gap = 9 },
		{ src = find("Zone12Props", "RockPile1"), n = 4, h = { 2.5, 3.5 }, tint = Color3.fromRGB(70, 45, 110), gap = 9 },
	})
	-- pads de vente des zones : pad SAE vert
	for _, zf in ipairs(Z:GetChildren()) do
		local sp = zf:FindFirstChild("SellPad")
		if sp then sp.Material = Enum.Material.Neon; sp.Color = Color3.fromRGB(60, 235, 90); sp.Transparency = 0.15 end
	end
	table.insert(log, "zones ok")
end

return table.concat(log, " | ")
