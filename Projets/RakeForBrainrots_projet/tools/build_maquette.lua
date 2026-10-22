-- tools/build_maquette.lua : reconstruit dans Studio (Edit) la map de la maquette Claude Design
-- "Rake for Brainrots — Map 3D" (île, mer, route, ferme, montagnes, forêt, 5 biomes), pièce par pièce.
-- Les données viennent du convertisseur (scratchpad conv/convert.py) : ServerStorage.MaqData (StringValues).
-- Lobby, enclos et téléporteur du Void ne sont PAS touchés.
-- Usage (barre de commande / MCP) :
--   local B = require(game.ServerStorage.BuildMaquette)
--   B.Prepare()          -- ménage + déplacement des zones aux positions de la maquette
--   B.Chunk(i)           -- construit le morceau i de MaqData (C001, C002...)
--   B.Finish()           -- mer, nettoyage des données
local B = {}

local MAP = workspace:WaitForChild("Map")
local FONT = Font.fromEnum(Enum.Font.LuckiestGuy)
local NAVY = Color3.fromHex("1B2A35")
local ZC = { Beach = 230, Swamp = 360, Volcano = 490, Ice = 620, Void = 750 }
local ZONE_OF = { beach = "Beach", swamp = "Swamp", volcano = "Volcano", ice = "Ice", void = "Void" }

local MATS = { P = Enum.Material.Plastic, S = Enum.Material.SmoothPlastic, N = Enum.Material.Neon, G = Enum.Material.Glass }

local function root(): Folder
	local r = MAP:FindFirstChild("Maquette")
	if not r then r = Instance.new("Folder"); r.Name = "Maquette"; r.Parent = MAP end
	return r :: Folder
end

local function checkerTexture(): Texture?
	local g = MAP:FindFirstChild("Island") and MAP.Island:FindFirstChild("Ground")
	if not g then return nil end
	for _, t in ipairs(g:GetChildren()) do
		if t:IsA("Texture") and t.Face == Enum.NormalId.Top then return t end
	end
	return nil
end

-- [ PRÉPARATION ] ----------------------------------------------------------------------------
function B.Prepare()
	-- ancienne déco
	for _, n in ipairs({ "Scenery", "ZonePath", "Maquette" }) do
		local o = MAP:FindFirstChild(n); if o then o:Destroy() end
	end
	local isl = MAP:FindFirstChild("Island")
	if isl then
		for _, c in ipairs(isl:GetChildren()) do if c.Name ~= "Ground" then c:Destroy() end end
	end
	-- zones : on les place exactement comme dans la maquette (centre z = 230 + 130 i)
	local zones = MAP:FindFirstChild("Zones")
	for _, z in ipairs(zones:GetChildren()) do
		local want = ZC[z.Name]
		if not want then continue end
		for _, n in ipairs({ "Decor", "Fence", "VaultGate", "PondBasin", "Items" }) do
			local o = z:FindFirstChild(n); if o then o:Destroy() end
		end
		for _, c in ipairs(z:GetChildren()) do
			if c.Name == "PondEdge" or c.Name == "GatePost" or c.Name == "GateTop" then c:Destroy() end
		end
		local g = z:FindFirstChild("Ground") :: BasePart
		local dz = want - g.Position.Z
		if math.abs(dz) > 0.01 then
			for _, c in ipairs(z:GetChildren()) do
				if c:IsA("BasePart") then c.CFrame += Vector3.new(0, 0, dz)
				elseif c:IsA("Model") then c:PivotTo(c:GetPivot() + Vector3.new(0, 0, dz)) end
			end
		end
		-- barrière de rebirth = l'ouverture entre les deux piliers de l'arche (piliers à x = ±8.8, 2.2 de large)
		local gate = z:FindFirstChild("Gate") :: BasePart?
		if gate then
			gate.Size = Vector3.new(15.4, 11.4, 1)
			gate.CFrame = CFrame.new(0, 0.5 + 5.7, want - 42)
		end
		local ns = z:FindFirstChild("NameSign")
		if ns then
			for _, c in ipairs(ns:GetChildren()) do if c:IsA("BillboardGui") then c:Destroy() end end
		end
	end
	local r = root()
	for _, n in ipairs({ "ISLAND", "PATHS", "SCATTER", "B_beach", "B_swamp", "B_volcano", "B_ice", "B_void", "Clouds", "Special" }) do
		local f = Instance.new("Folder"); f.Name = n; f.Parent = r
	end
	-- gabarit du cône (pins, sommets) : MeshPart du cône Roblox, redimensionnable
	local old = game.ServerStorage:FindFirstChild("MaqCone"); if old then old:Destroy() end
	local cone = game:GetService("AssetService"):CreateMeshPartAsync("rbxassetid://1033714")
	cone.Name = "MaqCone"; cone.Anchored = true; cone.Parent = game.ServerStorage
	return "prepared"
end

-- [ CONSTRUCTION ] ----------------------------------------------------------------------------
local cur: Instance? = nil

local function findPath(path: string): Instance
	local node: Instance = MAP
	for _, part in ipairs(string.split(path, "/")) do
		local c = node:FindFirstChild(part)
		if not c then c = Instance.new("Folder"); c.Name = part; c.Parent = node end
		node = c
	end
	return node
end

local function matrixCF(s: string): CFrame
	local e = {}
	for _, v in ipairs(string.split(s, ",")) do table.insert(e, tonumber(v) :: number) end
	-- three.js : colonnes (e1..e3 = axe X, e5..e7 = axe Y, e9..e11 = axe Z, e13..e15 = position)
	return CFrame.new(e[13], e[14], e[15], e[1], e[5], e[9], e[2], e[6], e[10], e[3], e[7], e[11])
end

local function group(line: string)
	local body = string.sub(line, 3)
	local f = string.split(body, "|")
	local name, parentPath, attrs = f[1], f[2], f[3] or ""
	local parent = findPath(parentPath)
	local isModel = string.find(attrs, "Model=1", 1, true) ~= nil
	local g = parent:FindFirstChild(name)
	if not g then
		g = Instance.new(isModel and "Model" or "Folder"); g.Name = name; g.Parent = parent
		for _, kv in ipairs(string.split(attrs, ";")) do
			local k, v = string.match(kv, "^(%w+)=(.*)$")
			if k and k ~= "Model" and k ~= "Pivot" then g:SetAttribute(k, tonumber(v) or v) end
			if k == "Pivot" then g:SetAttribute("PivotCF", v) end
		end
	end
	cur = g
end

local STUD = Enum.SurfaceType.Studs
local function part(f: { string })
	local k = f[1]
	local p: BasePart
	if k == "B" or k == "C" then
		local q = Instance.new("Part")
		if k == "C" then q.Shape = Enum.PartType.Cylinder end
		p = q
	elseif k == "W" then
		p = Instance.new("CornerWedgePart")
	elseif k == "V" then
		p = Instance.new("WedgePart")
	elseif k == "E" then
		p = Instance.new("Part")
		local sm = Instance.new("SpecialMesh"); sm.MeshType = Enum.MeshType.Sphere; sm.Parent = p
	elseif k == "M" then
		p = (game.ServerStorage :: any).MaqCone:Clone()
	else
		return
	end
	local fl = tonumber(f[15]) :: number
	p.Anchored = true
	p.Material = MATS[f[2]] or Enum.Material.Plastic
	p.Color = Color3.fromHex(f[3])
	p.Transparency = tonumber(f[4]) :: number
	p.Size = Vector3.new(tonumber(f[5]) :: number, tonumber(f[6]) :: number, tonumber(f[7]) :: number)
	p.CFrame = CFrame.new(tonumber(f[8]) :: number, tonumber(f[9]) :: number, tonumber(f[10]) :: number,
		tonumber(f[11]) :: number, tonumber(f[12]) :: number, tonumber(f[13]) :: number, tonumber(f[14]) :: number)
	local collide = bit32.band(fl, 1) ~= 0
	p.CanCollide = collide; p.CanQuery = collide; p.CanTouch = false
	p.CastShadow = bit32.band(fl, 2) ~= 0
	if k == "B" and bit32.band(fl, 4) ~= 0 then
		p.TopSurface = STUD; p.BottomSurface = Enum.SurfaceType.Inlet
		p.FrontSurface = STUD; p.BackSurface = STUD; p.LeftSurface = STUD; p.RightSurface = STUD
	else
		p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	end
	p.Parent = cur
end

-- sol à studs (+ damier de la maquette)
local function floor(f: { string })
	local tag, col = f[2], Color3.fromHex(f[3])
	local w, d = tonumber(f[4]) :: number, tonumber(f[5]) :: number
	local x, y, z, ry = tonumber(f[6]) :: number, tonumber(f[7]) :: number, tonumber(f[8]) :: number, tonumber(f[9]) :: number
	local p: BasePart
	if tag == "IslandFloor" then
		p = MAP.Island.Ground
		p.Size = Vector3.new(w, 2, d); p.CFrame = CFrame.new(x, y - 1, z)
	elseif string.sub(tag, 1, 10) == "ZoneFloor:" then
		local zf = MAP.Zones:FindFirstChild(ZONE_OF[string.sub(tag, 11)])
		p = zf.Ground
		p.Size = Vector3.new(w, 1, d); p.CFrame = CFrame.new(x, y - 0.5, z)
	else
		local q = Instance.new("Part"); q.Name = "Floor"; q.Anchored = true
		-- dessus à y + 0.06 : au-dessus de la dalle bleu marine de la route (0.38) sans clignoter
		q.Size = Vector3.new(w, 0.2, d); q.CFrame = CFrame.new(x, y - 0.04, z) * CFrame.Angles(0, ry, 0)
		q.CanTouch = false
		local tx = checkerTexture(); if tx then tx:Clone().Parent = q end
		q.Parent = cur
		p = q
	end
	p.Color = col; p.Material = Enum.Material.Plastic
	p.TopSurface = STUD; p.BottomSurface = Enum.SurfaceType.Smooth
end

local function pond(f: { string })
	local zf = MAP.Zones:FindFirstChild(ZONE_OF[f[2]])
	local p = zf:FindFirstChild("Pond") :: Part
	local r, h = tonumber(f[4]) :: number, tonumber(f[5]) :: number
	p.Shape = Enum.PartType.Cylinder
	p.Size = Vector3.new(h, 2 * r, 2 * r)
	p.CFrame = CFrame.new(tonumber(f[6]) :: number, tonumber(f[7]) :: number, tonumber(f[8]) :: number) * CFrame.Angles(0, 0, math.pi / 2)
	p.Color = Color3.fromHex(f[3])
	local glow = f[2] == "volcano" or f[2] == "void"
	p.Material = glow and Enum.Material.Neon or Enum.Material.SmoothPlastic
	p.Reflectance = (f[2] == "ice" and 0.25) or (f[2] == "beach" and 0.12) or 0
	p.CanCollide = false; p.CanTouch = false
	p:SetAttribute("PondFx", f[2])
end

-- nom du biome en grosses lettres "3D" au-dessus de l'arche (7 couches de chaque côté comme la maquette)
local function name3D(f: { string })
	local text, fill = f[2], Color3.fromHex(f[3])
	local x, y, z, h, w = tonumber(f[4]) :: number, tonumber(f[5]) :: number, tonumber(f[6]) :: number, tonumber(f[7]) :: number, tonumber(f[8]) :: number
	local m = Instance.new("Model"); m.Name = "Name_" .. text; m.Parent = findPath("Maquette/Special")
	for _, dir in ipairs({ -1, 1 }) do
		for k = 0, 6 do
			local sh = k == 0 and 1 or (0.5 - k * 0.025)
			local p = Instance.new("Part"); p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
			p.Transparency = 1; p.Size = Vector3.new(w, h, 0.05); p.CastShadow = false
			p.CFrame = CFrame.new(x, y - k * 0.04, z + dir * (0.9 - k * 0.25))
			p.Parent = m
			local sg = Instance.new("SurfaceGui"); sg.Face = dir < 0 and Enum.NormalId.Front or Enum.NormalId.Back
			sg.LightInfluence = 0; sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 40; sg.MaxDistance = 400
			sg.Parent = p
			local t = Instance.new("TextLabel"); t.BackgroundTransparency = 1; t.Size = UDim2.fromScale(1, 1)
			t.Text = text; t.TextScaled = true; t.FontFace = FONT
			t.TextColor3 = Color3.new(fill.R * sh, fill.G * sh, fill.B * sh); t.Parent = sg
			local st = Instance.new("UIStroke"); st.Thickness = 9; st.Color = Color3.new(NAVY.R * sh, NAVY.G * sh, NAVY.B * sh); st.LineJoinMode = Enum.LineJoinMode.Round; st.Parent = t
		end
	end
end

local function special(f: { string })
	local k = f[1]
	local sp = findPath("Maquette/Special")
	if k == "SMOKE" then
		local p = Instance.new("Part"); p.Name = "SmokeSource"; p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
		p.Transparency = 1; p.Size = Vector3.new(0.2, 0.2, 0.2); p.Position = Vector3.new(tonumber(f[2]) :: number, tonumber(f[3]) :: number, tonumber(f[4]) :: number)
		p.Parent = sp
	elseif k == "BUB" then
		local p = Instance.new("Part"); p.Name = "Bubble"; p.Shape = Enum.PartType.Ball; p.Anchored = true
		p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
		local s = tonumber(f[5]) :: number
		p.Size = Vector3.new(2 * s, 2 * s, 2 * s); p.Position = Vector3.new(tonumber(f[2]) :: number, tonumber(f[3]) :: number, tonumber(f[4]) :: number)
		p.Material = Enum.Material.Neon; p.Color = Color3.fromHex(f[9]); p.Transparency = 1 - (tonumber(f[10]) :: number) + 0.2
		p:SetAttribute("BaseY", tonumber(f[3])); p:SetAttribute("Amp", tonumber(f[6])); p:SetAttribute("Sp", tonumber(f[7])); p:SetAttribute("Ph", tonumber(f[8]))
		p.Parent = sp
	elseif k == "LIGHT" then
		local p = Instance.new("Part"); p.Name = "Light"; p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
		p.Transparency = 1; p.Size = Vector3.new(0.2, 0.2, 0.2); p.Position = Vector3.new(tonumber(f[5]) :: number, tonumber(f[6]) :: number, tonumber(f[7]) :: number)
		local l = Instance.new("PointLight"); l.Color = Color3.fromHex(f[2]); l.Brightness = (tonumber(f[3]) :: number) * 1.6
		l.Range = math.min(60, tonumber(f[4]) :: number); l.Shadows = false; l.Parent = p
		p.Parent = sp
	elseif k == "SEA" then
		local kind = f[2]
		if kind == "foam" then
			local p = Instance.new("Part"); p.Name = "Foam"; p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Size = Vector3.new(tonumber(f[4]) :: number, 0.1, tonumber(f[5]) :: number)
			p.Position = Vector3.new(tonumber(f[6]) :: number, (tonumber(f[7]) :: number) - 0.05, tonumber(f[8]) :: number)
			p.Material = Enum.Material.SmoothPlastic; p.Color = Color3.new(1, 1, 1); p.Transparency = 0.4
			p.Parent = sp
		elseif kind == "water" then
			B.Sea()
		end
	elseif k == "CHEST" then
		-- coffre du biome : modèle du Vault (biomes_<id>_chest) à la place du coffre de la maquette
		local src = game.ServerStorage.Vault.biomes:FindFirstChild("biomes_" .. f[2] .. "_chest")
		if src then
			local m = src:Clone(); m.Name = "Chest_" .. f[2]
			local x, y, z, ry = tonumber(f[3]) :: number, tonumber(f[4]) :: number, tonumber(f[5]) :: number, tonumber(f[6]) :: number
			-- serrure (petite pièce dorée) tournée vers l'entrée du biome, comme le coffre de la maquette
			local cf0 = m:GetBoundingBox()
			local lock
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then
					local hh, ss, vv = d.Color:ToHSV()
					if d.Size.Magnitude < 1.6 and hh > 0.1 and hh < 0.17 and ss > 0.6 and vv > 0.85 then lock = d; break end
				end
			end
			local a0 = 0
			if lock then
				local off = (lock.Position - cf0.Position) * Vector3.new(1, 0, 1)
				if off.Magnitude > 0.05 then a0 = math.atan2(off.X, off.Z) end
			end
			-- direction voulue = axe +Z local de la maquette tourné de ry
			m:PivotTo(CFrame.new(cf0.Position) * CFrame.Angles(0, ry - a0, 0) * CFrame.new(cf0.Position):Inverse() * m:GetPivot())
			local cf, sz = m:GetBoundingBox()
			m:PivotTo(m:GetPivot() + (Vector3.new(x, y, z) - Vector3.new(cf.Position.X, cf.Position.Y - sz.Y / 2, cf.Position.Z)))
			for _, d in ipairs(m:GetDescendants()) do
				if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false end
			end
			m.Parent = findPath("Maquette/B_" .. f[2])
		end
	elseif k == "NAME" then
		name3D(f)
	elseif k == "F" then
		floor(f)
	elseif k == "POND" then
		pond(f)
	end
end

-- mer : dégradé turquoise -> bleu profond (comme le plan à couleurs de sommets de la maquette)
function B.Sea()
	local sea = findPath("Maquette/Special/Sea")
	sea:ClearAllChildren()
	local CZ, HALF = 315, 510
	local cS, cM, cD = Color3.fromHex("7FF5EC"), Color3.fromHex("2FD3DC"), Color3.fromHex("1590C8")
	local function colorAt(d: number): Color3
		local t = math.min(1, d / 420)
		if t < 0.2 then return cS:Lerp(cM, t / 0.2) end
		return cM:Lerp(cD, (t - 0.2) / 0.8)
	end
	local function rect(x0: number, x1: number, z0: number, z1: number, col: Color3)
		-- découpe en morceaux <= 2000 studs
		local nx = math.ceil((x1 - x0) / 2000); local nz = math.ceil((z1 - z0) / 2000)
		for i = 0, nx - 1 do
			for j = 0, nz - 1 do
				local a0, a1 = x0 + (x1 - x0) * i / nx, x0 + (x1 - x0) * (i + 1) / nx
				local b0, b1 = z0 + (z1 - z0) * j / nz, z0 + (z1 - z0) * (j + 1) / nz
				local p = Instance.new("Part"); p.Name = "Water"; p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
				p.CastShadow = false; p.Material = Enum.Material.SmoothPlastic; p.Reflectance = 0.08
				p.Size = Vector3.new(a1 - a0, 1, b1 - b0); p.CFrame = CFrame.new((a0 + a1) / 2, -4.5, (b0 + b1) / 2)
				p.Color = col; p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
				p.Parent = sea
			end
		end
	end
	local edges = { 0, 14, 28, 42, 56, 70, 84, 126, 168, 210, 252, 294, 336, 378, 420, 1500 }
	local inner = HALF + 13
	for i = 1, #edges - 1 do
		local d0, d1 = edges[i], edges[i + 1]
		local col = colorAt((d0 + d1) / 2)
		local r0, r1 = inner + d0, inner + d1
		rect(-r1, r1, CZ - r1, CZ - r0, col)      -- nord
		rect(-r1, r1, CZ + r0, CZ + r1, col)      -- sud
		rect(-r1, -r0, CZ - r0, CZ + r0, col)     -- ouest
		rect(r0, r1, CZ - r0, CZ + r0, col)       -- est
	end
	-- sous l'île (au cas où on voit à travers le sable)
	rect(-inner, inner, CZ - inner, CZ + inner, cS)
end

function B.Chunk(i: number)
	local data = game.ServerStorage:FindFirstChild("MaqData")
	local sv = data and data:FindFirstChild(string.format("C%03d", i)) :: StringValue?
	if not sv then return "no chunk " .. i end
	-- le groupe courant est mémorisé dans l'attribut "Group" du morceau (une ligne G au début sinon)
	local n = 0
	for _, line in ipairs(string.split(sv.Value, "\n")) do
		if #line < 2 then continue end
		local c1 = string.sub(line, 1, 2)
		if c1 == "G " then
			group(line)
		else
			local f = string.split(line, ",")
			local k = f[1]
			if k == "B" or k == "C" or k == "W" or k == "M" or k == "V" or k == "E" then
				part(f); n += 1
			else
				special(f)
			end
		end
		if n % 3000 == 0 then task.wait() end
	end
	return "chunk " .. i .. " : " .. n .. " parts"
end

function B.Finish()
	local d = game.ServerStorage:FindFirstChild("MaqData"); if d then d:Destroy() end
	local cone = game.ServerStorage:FindFirstChild("MaqCone"); if cone then cone:Destroy() end
	local n = 0
	for _, x in ipairs(root():GetDescendants()) do if x:IsA("BasePart") then n += 1 end end
	return "maquette : " .. n .. " parts"
end

return B
