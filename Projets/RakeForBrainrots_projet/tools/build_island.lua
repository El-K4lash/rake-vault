-- build_island.lua : la map façon maquette Claude Design ("Rake for Brainrots · Map 3D").
-- Île agrandie (1020 × 1060, bord néon vert), forêt dense de gros arbres low-poly, collines en terrasses,
-- montagne enneigée avec cascade + lac, 3 lacs à nénuphars, ferme à l'est (champs, grange, silo, moulin) reliée
-- par un chemin de terre, ponton + bateau à l'ouest, îlots à palmiers et rochers dans la mer, taches d'herbe, nuages.
-- Coordonnées de la maquette : (x, z) -> chez nous (x, z - 65) (les biomes y sont à z = 230 + 130 i, ici 165 + 130 i).
-- Lancé une fois en Edit. Remplace Map.Scenery et Map.Island.Trees.
local MAP = workspace.Map
local I = MAP.Island
local V = game.ServerStorage.Vault
local DZ = -65
local rng = Random.new(315)
local log = {}
local PI = math.pi
local function rr(a, b) return rng:NextNumber(a, b) end
local function pick(t) return t[rng:NextInteger(1, #t)] end
local function hex(h) return Color3.fromHex(h) end

-- [ 1. ÎLE AGRANDIE ] -------------------------------------------------------------------------------
local XH, Z0, Z1 = 510, -230, 830
local CZ, ZH = (Z0 + Z1) / 2, (Z1 - Z0) / 2
do
	local g = I.Ground
	g.Size = Vector3.new(XH * 2, 8, ZH * 2); g.Position = Vector3.new(0, -4, CZ)
	local s = I.Sand
	s.Size = Vector3.new(XH * 2 + 26, 2, ZH * 2 + 26); s.Position = Vector3.new(0, -7.5, CZ)
	for _, n in ipairs({ "GroundZones", "SandZones" }) do local o = I:FindFirstChild(n); if o then o:Destroy() end end
	local rim = I.Rim
	local tpl = rim:FindFirstChildWhichIsA("BasePart")
	local col, mat = tpl and tpl.Color or Color3.fromRGB(0, 231, 0), tpl and tpl.Material or Enum.Material.Neon
	rim:ClearAllChildren()
	local function strip(size, pos)
		local p = Instance.new("Part"); p.Name = "Rim"; p.Anchored = true; p.Size = size; p.Position = pos; p.Color = col; p.Material = mat
		p.CanCollide = false; p.Parent = rim
	end
	strip(Vector3.new(2.4, 1.2, ZH * 2), Vector3.new(-XH, 0.6, CZ)); strip(Vector3.new(2.4, 1.2, ZH * 2), Vector3.new(XH, 0.6, CZ))
	strip(Vector3.new(XH * 2 + 2.4, 1.2, 2.4), Vector3.new(0, 0.6, Z0)); strip(Vector3.new(XH * 2 + 2.4, 1.2, 2.4), Vector3.new(0, 0.6, Z1))
	I.Trees:ClearAllChildren()
	table.insert(log, "île 1020x1060")
end

-- [ OUTILS ] ---------------------------------------------------------------------------------------
local old = MAP:FindFirstChild("Scenery"); if old then old:Destroy() end
local S = Instance.new("Folder"); S.Name = "Scenery"
local CUR = S
local function folder(name) local f = Instance.new("Folder"); f.Name = name; f.Parent = S; CUR = f; return f end
local CHECK = I.Ground:FindFirstChildWhichIsA("Texture")
-- B(x, yb, z, w, h, d, couleur, ry, deco) : bloc posé par le bas (comme la maquette)
local function B(x, yb, z, w, h, d, c, ry, deco, parent)
	local p = Instance.new("Part"); p.Anchored = true; p.Size = Vector3.new(w, h, d)
	p.CFrame = CFrame.new(x, yb + h / 2, z) * CFrame.Angles(0, ry or 0, 0); p.Color = c
	p.Material = Enum.Material.SmoothPlastic; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	if deco then p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false end
	p.Parent = parent or CUR
	return p
end
-- cylindre vertical posé par le bas
local function C(x, yb, z, r, h, c, parent, mat)
	local p = Instance.new("Part"); p.Anchored = true; p.Shape = Enum.PartType.Cylinder; p.Size = Vector3.new(h, r * 2, r * 2)
	p.CFrame = CFrame.new(x, yb + h / 2, z) * CFrame.Angles(0, 0, PI / 2); p.Color = c
	p.Material = mat or Enum.Material.SmoothPlastic; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = parent or CUR
	return p
end
local function checker(p)
	if CHECK then local t = CHECK:Clone(); t.Face = Enum.NormalId.Right; t.Parent = p end
end
local function tint(c, k) return k >= 0 and c:Lerp(Color3.new(1, 1, 1), k) or c:Lerp(Color3.new(0, 0, 0), -k) end

local FLOWERS = { hex("FF5DA2"), hex("FFD23F"), hex("FFFFFF"), hex("B46BFF"), hex("FF7A3D"), hex("4FC3FF") }
local LEAF = { hex("4CC71E"), hex("3DBA1C"), hex("58CF22"), hex("34B11A") }
local LEAF2 = { hex("6ADB2C"), hex("7BE33B"), hex("5ED62A") }
local TR1, TR2 = hex("8A5A33"), hex("6E4426")
local ROCKC = { hex("C9A36A"), hex("B98B57"), hex("A8764A") }

-- gros arbre low-poly (7 blocs)
local function tree(x, z, s, yb, leaf, leaf2)
	s = s or 1; yb = yb or 0; leaf = leaf or pick(LEAF); leaf2 = leaf2 or pick(LEAF2)
	local m = Instance.new("Model"); m.Name = "Tree"
	local r0 = rr(0, 0.5)
	B(x, yb, z, 1.9 * s, 3 * s, 1.9 * s, TR1, 0, false, m)
	B(x, yb + 3 * s, z, 1.5 * s, 3.2 * s, 1.5 * s, TR1, 0, false, m)
	B(x, yb + 5.4 * s, z, 7 * s, 4 * s, 7 * s, leaf, r0, false, m)
	B(x + 2.7 * s, yb + 5.9 * s, z + 1.2 * s, 3.6 * s, 3.2 * s, 3.6 * s, tint(leaf, -0.12), r0 + 0.3, true, m)
	B(x - 2.6 * s, yb + 6.3 * s, z - 1.4 * s, 3.4 * s, 3 * s, 3.4 * s, leaf2, r0 - 0.2, true, m)
	B(x + 0.3 * s, yb + 9.0 * s, z - 0.2 * s, 5.2 * s, 3.4 * s, 5.2 * s, leaf2, r0 + 0.6, true, m)
	B(x - 0.2 * s, yb + 12.0 * s, z + 0.2 * s, 3 * s, 2.4 * s, 3 * s, leaf, r0 + 0.2, true, m)
	if rng:NextNumber() < 0.45 then
		local fc = pick({ hex("FF4D6D"), hex("FFD23F"), hex("FF8AD0") })
		for i = 1, 3 do
			local a = rr(0, PI * 2)
			B(x + math.cos(a) * 3.45 * s, yb + rr(6, 8.6) * s, z + math.sin(a) * 3.45 * s, 0.6 * s, 0.6 * s, 0.6 * s, fc, a, true, m)
		end
	end
	m.Parent = CUR
	return m
end
local function pine(x, z, s, yb)
	s = s or 1; yb = yb or 0
	local m = Instance.new("Model"); m.Name = "Pine"
	B(x, yb, z, 1 * s, 2.4 * s, 1 * s, TR2, 0, false, m)
	local ry = rr(0, PI)
	for i, w in ipairs({ 6, 4.6, 3.2, 1.8 }) do
		B(x, yb + (1.6 + (i - 1) * 2.1) * s, z, w * s, 2.2 * s, w * s, i % 2 == 1 and hex("2E8B57") or hex("3AA86A"), ry + i * 0.4, i > 1, m)
		B(x, yb + (1.6 + (i - 1) * 2.1 + 2.0) * s, z, w * 0.7 * s, 0.35 * s, w * 0.7 * s, hex("F4F8FF"), ry + i * 0.4, true, m)
	end
	m.Parent = CUR
end
local function bush(x, z, s, yb)
	s = s or 1; yb = yb or 0
	local c, c2 = hex("2FB52A"), hex("4CD13A")
	B(x, yb, z, 2.8 * s, 1.8 * s, 2.6 * s, c, rr(0, PI))
	B(x + 0.9 * s, yb + 0.15 * s, z + 0.7 * s, 1.8 * s, 1.9 * s, 1.8 * s, c2, rr(0, PI), true)
	B(x + 0.2 * s, yb + 1.5 * s, z - 0.1 * s, 1.6 * s, 1.2 * s, 1.6 * s, c, rr(0, PI), true)
	if rng:NextNumber() < 0.6 then
		local dc = pick({ hex("FF4D6D"), hex("FFFFFF"), hex("FFD23F"), hex("B46BFF") })
		for i = 1, 3 do B(x + rr(-1.2, 1.2) * s, yb + rr(1.1, 2.2) * s, z + rr(-1.2, 1.2) * s, 0.45 * s, 0.45 * s, 0.45 * s, dc, rr(0, PI), true) end
	end
end
local function flower(x, z, c, yb)
	yb = yb or 0
	B(x, yb, z, 0.18, 1.2, 0.18, hex("3E9E1E"), 0, true)
	B(x, yb + 1.15, z, 0.95, 0.22, 0.95, c, PI / 4, true)
	B(x, yb + 1.25, z, 0.38, 0.24, 0.38, c == FLOWERS[2] and hex("FF7A3D") or hex("FFE14D"), 0, true)
end
local function rock(x, z, s, c, yb)
	yb = yb or 0; c = c or pick(ROCKC)
	local p = B(x, yb, z, 1.6 * s, 1.1 * s, 1.4 * s, c, rr(0, PI))
	p.CFrame = p.CFrame * CFrame.Angles(rr(-0.15, 0.15), 0, rr(-0.15, 0.15))
	B(x + 1.1 * s, yb, z + 0.5 * s, 0.9 * s, 0.7 * s, 0.9 * s, tint(c, -0.1), rr(0, PI), true)
	B(x + 0.1 * s, yb + 1.0 * s, z, 0.9 * s, 0.4 * s, 0.8 * s, tint(c, 0.18), rr(0, PI), true)
end
local function bamboo(x, z, n, yb)
	yb = yb or 0
	for i = 1, n do
		local bx, bz, h = x + rr(-1.6, 1.6), z + rr(-1.6, 1.6), rr(7, 12.5)
		local p = C(bx, yb, bz, 0.3, h, i % 2 == 0 and hex("8FD14F") or hex("7FC447"))
		p.CanCollide = false
		B(bx + 0.6, yb + h - 0.8, bz, 1.7, 0.12, 0.55, hex("6CC63A"), rr(0, PI * 2), true)
	end
end

-- zones à garder libres (lobby + enclos, route, biomes, et ce qu'on pose)
local ZONESC = { 165, 295, 425, 555, 692 }
local zones = {}
local function free(x, z)
	if math.abs(x) > XH - 16 or z < Z0 + 16 or z > Z1 - 16 then return false end
	if math.sqrt(x * x + z * z) < 168 then return false end
	if math.abs(x) < 26 and z > 0 and z < 770 then return false end
	for _, zc in ipairs(ZONESC) do if math.abs(x) < 62 and math.abs(z - zc) < 64 then return false end end
	for _, q in ipairs(zones) do if (Vector2.new(x - q[1], z - q[2])).Magnitude < q[3] then return false end end
	return true
end

-- [ 2. COLLINES EN TERRASSES + MONTAGNE ] -----------------------------------------------------------------
folder("Hills")
local function hill(x, z, r, lv, o)
	o = o or {}
	table.insert(zones, { x, z, r + 12 })
	local m = Instance.new("Folder"); m.Name = "Hill"; m.Parent = S.Hills
	local prev = CUR; CUR = m
	local y = 0
	for i = 0, lv - 1 do
		local r0, r1, h = r * (1 - i / (lv + 0.7)), r * (1 - (i + 1) / (lv + 0.7)), o.h or 4.8
		local snow = o.snow and i >= lv - 2
		C(x, y, z, r0, h, i % 2 == 1 and hex("C9773D") or hex("B5672D"))
		local cap = C(x, y + h, z, r0 * 0.985, 0.7, snow and hex("FFFFFF") or (i % 2 == 1 and hex("69D014") or hex("5CC213")))
		if not snow then checker(cap) end
		local top = y + h + 0.7
		for j = 1, math.max(4, math.floor(r0 / 9)) do
			local a = rr(0, PI * 2)
			rock(x + math.cos(a) * r0 * 0.97, z + math.sin(a) * r0 * 0.97, rr(0.9, 1.8), nil, y + rr(0.5, 2))
		end
		if not snow then
			local ringR = (r0 + r1) / 2
			local nT = math.max(2, math.floor((r0 - r1) * ringR / 75))
			for j = 1, nT do
				local a, rd = rr(0, PI * 2), rr(r1 + 3, r0 - 4)
				if rd > r1 then tree(x + math.cos(a) * rd, z + math.sin(a) * rd, rr(0.75, 1.1), top) end
			end
			for j = 1, math.floor(nT / 2) do
				local a, rd = rr(0, PI * 2), rr(r1 + 2, r0 - 2)
				flower(x + math.cos(a) * rd, z + math.sin(a) * rd, pick(FLOWERS), top)
			end
		else
			for j = 1, 4 do
				local a, rd = rr(0, PI * 2), rr(r1 + 3, r0 - 3)
				pine(x + math.cos(a) * rd, z + math.sin(a) * rd, rr(0.8, 1.1), top)
			end
		end
		y += h + 0.7
	end
	CUR = prev
	return y
end
-- montagne enneigée à l'ouest, cascade vers un lac
local MX, MZ = -340, 140 + DZ
local mTop = hill(MX, MZ, 110, 7, { snow = true, h = 5.2 })
CUR = S.Hills
B(MX, mTop, MZ, 14, 5, 14, hex("FFFFFF"), PI / 8)
B(MX, mTop + 5, MZ, 8, 3.5, 8, hex("FFFFFF"), PI / 4)
do
	local fall = Instance.new("Folder"); fall.Name = "Waterfall"; fall.Parent = S.Hills
	for i = 6, 0, -1 do
		local r0, yTop = 110 * (1 - i / 7.7), (i + 1) * 5.9
		local stepR = 110 * (1 - (i + 1) / 7.7)
		local col = B(MX + r0 - 2 + 1.2, i * 5.9, MZ, 3.4, yTop - i * 5.9 + 0.2, 9, hex("5FE3F5"), 0, true, fall)
		col.Material = Enum.Material.Glass; col.Transparency = 0.15
		local top = B(MX + (r0 + stepR) / 2, yTop + 0.05, MZ, r0 - stepR + 1, 0.4, 9, hex("5FE3F5"), 0, true, fall)
		top.Material = Enum.Material.Glass; top.Transparency = 0.1
		for j = 1, 3 do B(MX + r0 + 0.6, i * 5.9, MZ + rr(-4, 4), 1.1, 0.6, 1.1, hex("FFFFFF"), rr(0, PI), true, fall) end
	end
end
-- lacs
folder("Lakes")
local function lake(x, z, r)
	table.insert(zones, { x, z, r + 10 })
	C(x, 0, z, r + 4, 0.35, hex("F6E0A8"))
	local w = C(x, 0.05, z, r, 0.4, hex("2FC8E0")); w.Reflectance = 0.08
	local n = math.floor(r * 0.6)
	for j = 0, n - 1 do
		local a = j / n * PI * 2
		B(x + math.cos(a) * (r + 2.2), 0.3, z + math.sin(a) * (r + 2.2), rr(3.6, 4.6), rr(1, 1.5), rr(1.8, 2.4), j % 2 == 1 and hex("C9A36A") or hex("B98B57"), -a + PI / 2)
	end
	for j = 1, math.floor(r * 0.3) do
		local a, d = rr(0, PI * 2), rr(r + 4.5, r + 7)
		local cx, cz = x + math.cos(a) * d, z + math.sin(a) * d
		B(cx, 0, cz, 0.2, rr(2.5, 3.4), 0.2, hex("3E9E1E"), 0, true)
		B(cx, 2.4, cz, 0.45, 1.1, 0.45, hex("7A4A26"), 0, true)
	end
	for j = 1, math.floor(r / 3) do
		local a, d = rr(0, PI * 2), rr(2, r - 3)
		local pad = C(x + math.cos(a) * d, 0.45, z + math.sin(a) * d, 1.5, 0.1, hex("2E9E3A")); pad.CanCollide = false
		if j % 3 == 0 then B(x + math.cos(a) * d + 0.3, 0.55, z + math.sin(a) * d, 0.35, 0.25, 0.35, hex("FF7BC0"), 0, true) end
	end
end
lake(MX + 135, MZ + 10, 26)
lake(-300, 560 + DZ, 34)
lake(360, 520 + DZ, 30)
for _, h in ipairs({ { -410, 760, 70, 4 }, { -230, -110, 42, 3 }, { 420, -100, 62, 4 }, { 430, 720, 72, 4 }, { 240, 690, 38, 3 }, { -180, 380, 34, 2 } }) do
	hill(h[1], h[2] + DZ, h[3], h[4])
end
table.insert(log, "collines + montagne + lacs")

-- [ 3. FERME (est) + chemin de terre depuis la route des zones ] -------------------------------------------
folder("Farm")
local function prop(id, x, z, yawRad, k, yb)
	local src = V.general:FindFirstChild(id) or V.lobby:FindFirstChild(id) or V.biomes:FindFirstChild(id)
	if not src then table.insert(log, "!! " .. id); return nil end
	local m = src:Clone()
	for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true end end
	if k and k ~= 1 then m:ScaleTo(m:GetScale() * k) end
	local p = m:GetPivot()
	m:PivotTo(CFrame.new(p.Position) * CFrame.Angles(0, yawRad or 0, 0) * p.Rotation)
	local cf, s = m:GetBoundingBox()
	m:PivotTo(m:GetPivot() + (Vector3.new(x, yb or 0, z) - Vector3.new(cf.X, cf.Y - s.Y / 2, cf.Z)))
	m.Parent = CUR
	return m
end
local FX, FZ = 300, 200 + DZ
table.insert(zones, { FX, FZ, 120 })
prop("general_field_wheat", FX - 60, FZ + 40, 0, 1.65)
prop("general_field_carrot", FX - 15, FZ + 40, 0, 1.65)
prop("general_field_cabbage", FX - 60, FZ + 80, 0, 1.65)
prop("general_field_pumpkin", FX - 15, FZ + 80, 0, 1.65)
prop("general_field_wheat", FX + 50, FZ + 70, PI / 2, 1.8)
prop("general_barn_red", FX + 30, FZ - 30, PI + 0.3, 1)
prop("general_silo", FX + 58, FZ - 40, 0, 0.9)
prop("general_windmill", FX - 70, FZ - 30, 0.5, 1)
prop("general_hay", FX + 8, FZ - 8, 0.3, 1); prop("general_hay", FX + 13, FZ - 4, -0.2, 1); prop("general_hay", FX + 10, FZ - 6, 0.1, 1, 3.6)
prop("general_scarecrow", FX - 38, FZ + 60, 0.4, 1.2)
prop("general_tractor", FX - 5, FZ + 10, 1.2, 1.1)
prop("general_trough", FX + 40, FZ + 5, 0.2, 1)
for i = 0, 5 do prop("lobby_lamp", FX - 90 + i * 32, FZ + 8, 0, 0.8) end
-- chemin de terre (bord bleu marine comme les chemins des enclos)
do
	local a, b = Vector3.new(10, 0, 300 + DZ), Vector3.new(225, 0, 265 + DZ)
	local dir = (b - a).Unit
	local len = (b - a).Magnitude
	local cf = CFrame.lookAt((a + b) / 2, (a + b) / 2 + dir)
	local edge = B(0, 0, 0, 10.6, 0.36, len, hex("1B2A35")); edge.CFrame = cf + Vector3.new(0, 0.18, 0)
	local dirt = B(0, 0, 0, 8, 0.4, len + 0.2, hex("E2914A")); dirt.CFrame = cf + Vector3.new(0, 0.22, 0)
	if CHECK then local t = CHECK:Clone(); t.Face = Enum.NormalId.Top; t.Parent = dirt end
	for t = 0, 1.001, 0.08 do table.insert(zones, { a.X + (b.X - a.X) * t, a.Z + (b.Z - a.Z) * t, 9 }) end
end
table.insert(log, "ferme")

-- [ 4. CÔTE : ponton, bateau, îlots, rochers dans l'eau ] --------------------------------------------------
folder("Coast")
do
	local px, pz = -XH - 8, 470 + DZ
	prop("general_dock", px, pz, PI / 2, 1.3, -6.2)
	prop("general_boat", px - 26, pz + 14, 0.3, 1, -9.2)
	prop("general_barrels", -XH + 6, pz - 6, 0.4, 1)
	prop("general_crates", -XH + 8, pz + 7, 1.1, 1)
end
local function islet(x, z, r)
	C(x, -13, z, r + 5, 6, hex("F6E0A8"))
	local g = C(x, -7, z, r, 1.8, hex("69D014")); checker(g)
	for i = 1, 3 do prop("biomes_beach_tree", x + rr(-r / 2, r / 2), z + rr(-r / 2, r / 2), rr(0, PI * 2), rr(1.2, 1.5), -5.2) end
	rock(x + r * 0.6, z - r * 0.5, 1.8, hex("C9A36A"), -5.2)
	bush(x - r * 0.4, z + r * 0.3, 1, -5.2)
end
islet(-650, -40 + DZ, 20); islet(690, 380 + DZ, 26); islet(-630, 860 + DZ, 16); islet(560, -260 + DZ, 14)
for i = 0, 39 do
	local side, t, off = i % 4, rr(-XH, XH), rr(30, 90)
	local x, z
	if side < 2 then x = t; z = side == 0 and (Z0 - off) or (Z1 + off) else x = side == 2 and (-XH - off) or (XH + off); z = CZ + t end
	rock(x, z, rr(1.5, 3.5), pick({ hex("C9A36A"), hex("B98B57"), hex("D9B47A") }), -9.5)
end
table.insert(log, "côte")

-- [ 5. TACHES D'HERBE ] ----------------------------------------------------------------------------------
folder("GrassPatches")
for i = 1, 340 do
	local x, z = rr(-XH, XH), rr(Z0, Z1)
	if free(x, z) then B(x, 0, z, rr(8, 26), 0.08, rr(8, 26), pick({ hex("5FC714"), hex("76D91E"), hex("62CC18"), hex("7EDF2A") }), rr(0, PI), true) end
end

-- [ 6. FORÊT : arbres en bosquets, buissons, fleurs, bambous, rochers ] ------------------------------------
folder("Forest")
do
	local placed, tries = 0, 0
	while placed < 330 and tries < 9000 do
		tries += 1
		local x, z = rr(-XH + 16, XH - 16), rr(Z0 + 16, Z1 - 16)
		if free(x, z) then
			placed += 1
			local r = rng:NextNumber()
			if r < 0.55 then
				for j = 0, rng:NextInteger(0, 3) do
					local tx, tz = x + (j > 0 and rr(-13, 13) or 0), z + (j > 0 and rr(-13, 13) or 0)
					if j == 0 or free(tx, tz) then tree(tx, tz, rr(0.8, 1.4)) end
				end
			elseif r < 0.68 then bush(x, z, rr(0.9, 1.4)); bush(x + 3, z + 1.5, rr(0.7, 1.0))
			elseif r < 0.85 then for j = 1, 5 do flower(x + rr(-3, 3), z + rr(-3, 3), pick(FLOWERS)) end
			elseif r < 0.93 then bamboo(x, z, rng:NextInteger(3, 5))
			else rock(x, z, rr(1.4, 2.6)) end
		end
	end
	table.insert(log, "forêt " .. placed)
end

-- [ 7. NUAGES ] ---------------------------------------------------------------------------------------------
folder("Clouds")
for i = 1, 16 do
	local c = Vector3.new(rr(-700, 700), rr(150, 210), rr(-300, 950) + DZ)
	local m = Instance.new("Model"); m.Name = "Cloud"
	for j = 1, rng:NextInteger(4, 7) do
		local p = B(c.X + rr(-22, 22), c.Y + rr(-2, 4), c.Z + rr(-10, 10), rr(14, 26), rr(6, 11), rr(12, 20), j % 3 == 0 and hex("EEF7FF") or hex("FFFFFF"), 0, true, m)
		p.Transparency = 0.06
	end
	m.Parent = CUR
end

S.Parent = MAP
local n = 0
for _, d in ipairs(S:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
return table.concat(log, " | ") .. " | parts " .. n
