-- build_scenery.lua : décor de l'île (Map.Scenery) — montagnes "stud" en terrasses tout autour de l'île et le long
-- de la route des zones, une ferme (moulin, grange, champs) et un camp au bord d'un lac dans les coins du fond,
-- des nuages en blocs dans le ciel. Tout en vraies parts (low-poly, dessus à studs), lancé une fois en Edit.
-- Rien n'est posé dans la zone du lobby/enclos (r < 150) ni sur la route des zones (|x| < 100, z > 140).
local MAP = workspace.Map
local V = game.ServerStorage.Vault
local old = MAP:FindFirstChild("Scenery"); if old then old:Destroy() end
local S = Instance.new("Folder"); S.Name = "Scenery"
local rng = Random.new(2026)
local log = {}

-- [ OUTILS ] -----------------------------------------------------------------------------
local function part(parent, name, size, cf, col, mat)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = col
	p.Material = mat or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Studs; p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent
	return p
end
local function disc(parent, name, d, h, pos, col, mat)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Shape = Enum.PartType.Cylinder
	p.Size = Vector3.new(h, d, d); p.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)); p.Color = col
	p.Material = mat or Enum.Material.SmoothPlastic; p.TopSurface = Enum.SurfaceType.Smooth; p.Parent = parent
	return p
end
local function bottomTo(m, pos)
	local cf, s = m:GetBoundingBox()
	m:PivotTo(m:GetPivot() + (pos - Vector3.new(cf.X, cf.Y - s.Y / 2, cf.Z)))
end
local function prop(id, parent, pos, yawDeg, k)
	local src = V.general:FindFirstChild(id) or V.lobby:FindFirstChild(id)
	if not src then table.insert(log, "!! " .. id); return nil end
	local m = src:Clone()
	for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true end end
	if k and k ~= 1 then m:ScaleTo(m:GetScale() * k) end
	local p = m:GetPivot()
	m:PivotTo(CFrame.new(p.Position) * CFrame.Angles(0, math.rad(yawDeg or 0), 0) * p.Rotation)
	bottomTo(m, pos)
	m.Parent = parent
	return m
end
local KEEPOUT = {} -- zones où l'on retire les arbres existants : { centre, rayon }
local function keep(c, r) table.insert(KEEPOUT, { c, r }) end

-- [ MONTAGNES ] terrasses de blocs : roche, chaque marche coiffée d'herbe, neige au sommet -------------------
local ROCK = { Color3.fromRGB(138, 122, 104), Color3.fromRGB(122, 108, 92), Color3.fromRGB(150, 134, 114) }
local GRASS = { Color3.fromRGB(106, 199, 42), Color3.fromRGB(92, 182, 38), Color3.fromRGB(120, 210, 60) }
local SNOW = Color3.fromRGB(244, 248, 255)
local mountains = Instance.new("Folder"); mountains.Name = "Mountains"; mountains.Parent = S
local function mountain(c, r, h)
	local m = Instance.new("Model"); m.Name = "Mountain"
	local step = 5
	local n = math.max(2, math.floor(h / step))
	local snowFrom = h >= 38 and math.floor(n * 0.7) or n + 1
	local off = Vector3.zero
	for i = 0, n - 1 do
		local f = 1 - (i / n) * 0.82
		local y = i * step
		-- 2 ou 3 blocs décalés par étage : silhouette irrégulière, comme une vraie montagne low-poly
		for b = 1, (i < n - 1 and 3 or 1) do
			local w = 2 * r * f * rng:NextNumber(0.62, 0.95)
			local d = 2 * r * f * rng:NextNumber(0.55, 0.9)
			local o = off + Vector3.new(rng:NextNumber(-0.22, 0.22) * r * f, 0, rng:NextNumber(-0.22, 0.22) * r * f)
			local yaw = math.rad(rng:NextInteger(0, 5) * 15)
			local snowy = i >= snowFrom
			local body = part(m, "Rock", Vector3.new(w, step, d), CFrame.new(c + o + Vector3.new(0, y + step / 2, 0)) * CFrame.Angles(0, yaw, 0),
				snowy and Color3.fromRGB(205, 214, 228) or ROCK[rng:NextInteger(1, #ROCK)])
			body.TopSurface = Enum.SurfaceType.Smooth
			part(m, snowy and "Snow" or "Grass", Vector3.new(w + 0.6, 0.8, d + 0.6), CFrame.new(c + o + Vector3.new(0, y + step + 0.4, 0)) * CFrame.Angles(0, yaw, 0),
				snowy and SNOW or GRASS[rng:NextInteger(1, #GRASS)])
		end
		off = off + Vector3.new(rng:NextNumber(-0.08, 0.08) * r, 0, rng:NextNumber(-0.08, 0.08) * r)
	end
	m.Parent = mountains
	keep(c, r * 1.05)
	return m
end
-- bord du fond (z = -210), bords gauche/droite (x = ±210), coins avant, et vallée de la route des zones
local edge = {
	{ -185, -220, 26, 44 }, { -128, -224, 30, 56 }, { -70, -218, 24, 40 }, { -15, -226, 32, 62 }, { 42, -219, 25, 42 },
	{ 98, -224, 30, 54 }, { 150, -219, 22, 36 }, { 196, -222, 27, 46 },
	{ -222, -150, 26, 48 }, { -218, -92, 22, 34 }, { -224, -35, 30, 58 }, { -219, 25, 24, 40 }, { -224, 85, 28, 50 },
	{ -218, 140, 22, 34 }, { -222, 195, 28, 52 },
	{ 222, -150, 26, 48 }, { 218, -92, 22, 34 }, { 224, -35, 30, 58 }, { 219, 25, 24, 40 }, { 224, 85, 28, 50 },
	{ 218, 140, 22, 34 }, { 222, 195, 28, 52 },
	{ -165, 222, 24, 40 }, { 165, 222, 24, 40 },
}
for _, e in ipairs(edge) do mountain(Vector3.new(e[1], 0, e[2]), e[3], e[4]) end
-- vallée des zones : collines plus basses des deux côtés de la route (zones en |x| < 45, bord en |x| = 130)
for z = 250, 750, 70 do
	for _, sx in ipairs({ -1, 1 }) do
		local zz = z + rng:NextNumber(-12, 12)
		mountain(Vector3.new(sx * rng:NextNumber(112, 120), 0, zz), rng:NextNumber(12, 16), rng:NextNumber(18, 34))
	end
end
table.insert(log, "mountains " .. #mountains:GetChildren())

-- [ FERME ] coin du fond à gauche : grange, silo, moulin, champs, foin, épouvantail, tracteur -----------------------
do
	local F = Vector3.new(-152, 0, -152)
	local farm = Instance.new("Model"); farm.Name = "Farm"
	local face = math.deg(math.atan2(-F.X, -F.Z)) -- vers le centre de l'île
	local function at(dx, dz) return F + Vector3.new(dx, 0, dz) end
	prop("general_barn_red", farm, at(-14, -14), face, 0.9)
	prop("general_silo", farm, at(-32, -2), 0, 0.85)
	prop("general_windmill", farm, at(14, -26), face, 0.8)
	prop("general_field_wheat", farm, at(-6, 16), face, 1)
	prop("general_field_carrot", farm, at(18, 8), face, 1)
	prop("general_field_pumpkin", farm, at(-26, 24), face, 1)
	prop("general_scarecrow", farm, at(-6, 16), face + 20, 1.1)
	prop("general_tractor", farm, at(4, -6), face + 70, 1)
	prop("general_hay", farm, at(-24, -26), 15, 1)
	prop("general_hay", farm, at(-18, -30), 80, 1)
	prop("general_hay", farm, at(30, 22), 40, 1)
	prop("general_trough", farm, at(28, -8), face, 1)
	prop("general_well", farm, at(32, 30), face, 0.9)
	for i, o in ipairs({ { 0, 40, 0 }, { 20, 40, 0 }, { -20, 40, 0 }, { 42, 20, 90 }, { 42, 0, 90 } }) do
		prop("general_fence_wood", farm, at(o[1], o[2]), face + o[3], 1)
	end
	farm.Parent = S
	keep(F, 52)
	table.insert(log, "farm ok")
end

-- [ LAC + CAMP ] coin du fond à droite : lac, ponton, bateau, tentes, feu de camp -----------------------------------
do
	local C = Vector3.new(152, 0, -150)
	local camp = Instance.new("Model"); camp.Name = "LakeCamp"
	disc(camp, "Shore", 50, 0.3, C + Vector3.new(0, 0.12, 0), Color3.fromRGB(246, 224, 168))
	disc(camp, "Water", 44, 0.3, C + Vector3.new(0, 0.2, 0), Color3.fromRGB(64, 182, 255), Enum.Material.Glass).Transparency = 0.15
	disc(camp, "Deep", 26, 0.3, C + Vector3.new(0, 0.22, 0), Color3.fromRGB(40, 140, 230), Enum.Material.Glass).Transparency = 0.1
	local face = math.deg(math.atan2(-C.X, -C.Z))
	local function at(dx, dz) return C + Vector3.new(dx, 0, dz) end
	prop("general_dock", camp, at(-14, 14), face, 1)
	local boat = prop("general_boat", camp, at(4, -4), face + 60, 0.7)
	if boat then boat:PivotTo(boat:GetPivot() + Vector3.new(0, -0.6, 0)) end
	prop("general_tent_red", camp, at(-34, -14), face - 30, 1)
	prop("general_tent_blue", camp, at(-30, -30), face, 1)
	prop("general_tent_green", camp, at(-14, -36), face + 30, 1)
	prop("general_campfire", camp, at(-24, -26), 0, 1)
	prop("general_barrels", camp, at(-40, -28), 30, 1)
	prop("general_flag_yellow", camp, at(-40, -4), face, 1)
	prop("general_stones", camp, at(20, 24), 25, 1)
	camp.Parent = S
	keep(C, 50)
	table.insert(log, "camp ok")
end

-- [ PETITS PLUS ] rochers et cristaux au pied des montagnes, fleurs ----------------------------------------------------
do
	local extras = Instance.new("Folder"); extras.Name = "Extras"; extras.Parent = S
	local gems = { "general_gem_amethyst", "general_gem_emerald", "general_gem_sapphire", "general_gem_ruby", "general_gem_topaz" }
	for i, e in ipairs(edge) do
		if i % 2 == 0 then
			local c = Vector3.new(e[1], 0, e[2])
			local toCenter = (Vector3.zero - c) * Vector3.new(1, 0, 1)
			local p = c + toCenter.Unit * (e[3] + 6) + Vector3.new(rng:NextNumber(-8, 8), 0, rng:NextNumber(-8, 8))
			if i % 4 == 0 then prop(gems[rng:NextInteger(1, #gems)], extras, p, rng:NextInteger(0, 359), 1.3)
			else prop("general_stones", extras, p, rng:NextInteger(0, 359), 0.9) end
		end
	end
end

-- [ NUAGES ] gros blocs blancs dans le ciel -----------------------------------------------------------------------------
do
	local clouds = Instance.new("Folder"); clouds.Name = "Clouds"; clouds.Parent = S
	for i = 1, 16 do
		local c = Vector3.new(rng:NextNumber(-320, 320), rng:NextNumber(95, 140), rng:NextNumber(-320, 820))
		local m = Instance.new("Model"); m.Name = "Cloud"
		for b = 1, rng:NextInteger(3, 5) do
			local s = Vector3.new(rng:NextNumber(14, 26), rng:NextNumber(5, 9), rng:NextNumber(10, 18))
			local p = part(m, "Puff", s, CFrame.new(c + Vector3.new(rng:NextNumber(-14, 14), rng:NextNumber(-2, 3), rng:NextNumber(-8, 8))), Color3.fromRGB(255, 255, 255))
			p.CanCollide = false; p.CanQuery = false; p.CastShadow = false; p.TopSurface = Enum.SurfaceType.Smooth
		end
		m.Parent = clouds
	end
end

-- arbres existants sous les nouveaux éléments : retirés
local removed = 0
for _, t in ipairs(MAP.Island.Trees:GetChildren()) do
	local ok, piv = pcall(function() return t:GetPivot().Position end)
	if ok then
		local p = Vector3.new(piv.X, 0, piv.Z)
		for _, k in ipairs(KEEPOUT) do
			if (p - k[1]).Magnitude < k[2] then t:Destroy(); removed += 1; break end
		end
	end
end
S.Parent = MAP
return table.concat(log, " | ") .. " | arbres retirés " .. removed
