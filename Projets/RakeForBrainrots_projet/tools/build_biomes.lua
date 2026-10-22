-- tools/build_biomes.lua : à lancer dans Studio (Edit), ServerStorage.Vault chargé.
-- Redécore les 5 zones avec les modèles de la constellation "Biomes" du Rake Vault :
-- clôture du biome, portail de zone (arche + panneau), arbres, buissons, fleurs, rochers, cristaux, tas à ratisser,
-- props spéciaux, œuf et coffre du biome. La barrière fonctionnelle "Gate" (attribut Rebirths) est gardée.
local Zones = require(game.ReplicatedStorage.Shared.Config.Zones:Clone())
local V = game.ServerStorage.Vault.biomes
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)

local KEY = { Beach = "beach", Swamp = "swamp", Volcano = "volcano", Ice = "ice", Void = "void" }
local SPECIAL = {
	beach = { "biomes_beach_sp_coral", "biomes_beach_sp_fish" },
	swamp = { "biomes_swamp_sp_mushrooms", "biomes_swamp_sp_fern" },
	volcano = { "biomes_volcano_sp_obsidian", "biomes_volcano_sp_volcano" },
	ice = { "biomes_ice_sp_snowman", "biomes_ice_sp_igloo" },
	void = { "biomes_void_sp_floatisle", "biomes_void_sp_vortex" },
}


-- portail du Void = porte du prochain monde : prompt (ouvre le menu NextWorld côté client) + panneau "COMING SOON"
local function addPortal(m: Model)
	local cf, sz = m:GetBoundingBox()
	local t = Instance.new("Part")
	t.Name = "NextWorldPortal"; t.Anchored = true; t.CanCollide = false; t.CanQuery = false; t.CanTouch = false
	t.Transparency = 1; t.Size = Vector3.new(4, 4, 4); t.CFrame = CFrame.new(cf.Position)
	t.Parent = m
	local pr = Instance.new("ProximityPrompt")
	pr.ActionText = "Look"; pr.ObjectText = "Next World"; pr.HoldDuration = 0; pr.MaxActivationDistance = 16
	pr.RequiresLineOfSight = false; pr:SetAttribute("ClientAction", "NextWorld"); pr.Parent = t
	local light = Instance.new("PointLight"); light.Color = Color3.fromRGB(200, 90, 255); light.Range = 22; light.Brightness = 2; light.Parent = t
	local anchor = Instance.new("Attachment"); anchor.Position = Vector3.new(0, sz.Y / 2 + 2.5, 0); anchor.Parent = t
	local bb = Instance.new("BillboardGui"); bb.Name = "Label"; bb.Adornee = anchor; bb.Size = UDim2.fromScale(14, 4.2)
	bb.LightInfluence = 0; bb.MaxDistance = 180; bb.AlwaysOnTop = false; bb.Parent = t
	local function line(text: string, y: number, h: number, c1: Color3, c2: Color3)
		local l = Instance.new("TextLabel"); l.BackgroundTransparency = 1; l.Size = UDim2.fromScale(1, h); l.Position = UDim2.fromScale(0, y)
		l.Text = text; l.TextScaled = true; l.FontFace = FONT; l.TextColor3 = Color3.new(1, 1, 1); l.Parent = bb
		local st = Instance.new("UIStroke"); st.Thickness = 3; st.Color = Color3.fromRGB(20, 8, 40); st.Parent = l
		local g = Instance.new("UIGradient"); g.Rotation = 90; g.Color = ColorSequence.new(c1, c2); g.Parent = l
	end
	line("NEXT WORLD", 0, 0.55, Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 150, 255))
	line("COMING SOON", 0.58, 0.4, Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 180, 60))
end

local function get(name: string): Model
	local m = V:FindFirstChild(name)
	assert(m, "vault: " .. name)
	return m:Clone()
end

-- rend un modèle purement décoratif (pas de collision : on marche à travers, le râteau ne le "voit" pas)
local function decorate(m: Model, collide: boolean?)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then
			d.Anchored = true; d.CanQuery = false; d.CanTouch = false; d.CanCollide = collide == true
		end
	end
end

-- enfoncement dans le sol (fraction de la hauteur) : les dômes / rochers du vault sont exportés en sphères entières,
-- leur moitié basse ferait "flotter" le modèle
local SINK = { boulder = 0.28, rock = 0.22, bush = 0.25, igloo = 0.33, pile = 0.12, sp_snowman = 0.04, sp_obsidian = 0.1,
	sp_volcano = 0.08, crystal = 0.08, egg = 0.0, chest = 0.0, sp_mushrooms = 0.05, sp_fern = 0.05, sp_coral = 0.08, sp_floatisle = 0.0 }
local function sinkOf(name: string): number
	for k, v in pairs(SINK) do if string.sub(name, -#k) == k then return v end end
	return 0
end

-- pose un modèle : bas de la boîte au sol en `pos` (moins l'enfoncement), rotation Y `ry`, échelle `s`
local function put(m: Model, pos: Vector3, ry: number, s: number?, parent: Instance)
	if s and s ~= 1 then m:ScaleTo(m:GetScale() * s) end
	m:PivotTo(CFrame.new(m:GetPivot().Position) * CFrame.Angles(0, ry, 0))
	local cf, sz = m:GetBoundingBox()
	local sink = sinkOf(m.Name) * sz.Y
	m:PivotTo(m:GetPivot() + (pos - Vector3.new(cf.Position.X, cf.Position.Y - sz.Y / 2 + sink, cf.Position.Z)))
	m.Parent = parent
	return m
end

-- tourne un modèle (autour de son centre) pour que la pièce "repère" (serrure du coffre, nez du bonhomme...)
-- soit du côté de `target`
local function face(m: Model, target: Vector3, isMarker: (BasePart) -> boolean)
	local marker
	for _, p in ipairs(m:GetDescendants()) do if p:IsA("BasePart") and isMarker(p) then marker = p; break end end
	if not marker then return end
	local cf = m:GetBoundingBox()
	local c = cf.Position
	local off = (marker.Position - c) * Vector3.new(1, 0, 1)
	local want = (target - c) * Vector3.new(1, 0, 1)
	if off.Magnitude < 0.05 or want.Magnitude < 0.05 then return end
	local a = math.atan2(-want.Z, want.X) - math.atan2(-off.Z, off.X)
	m:PivotTo(CFrame.new(c) * CFrame.Angles(0, a, 0) * CFrame.new(c):Inverse() * m:GetPivot())
end
local function isLock(p: BasePart): boolean
	local h, s, v = p.Color:ToHSV()
	return p.Size.Magnitude < 1.6 and h > 0.1 and h < 0.17 and s > 0.6 and v > 0.85
end
local function isNose(p: BasePart): boolean
	local h, s = p.Color:ToHSV()
	return p.Size.Magnitude < 1.5 and h > 0.03 and h < 0.12 and s > 0.6
end

-- un tronçon de clôture du biome entre a et b (au sol), étiré à la bonne longueur
local function fenceSeg(tpl: Model, a: Vector3, b: Vector3, parent: Instance)
	local m = tpl:Clone()
	local _, sz = m:GetBoundingBox()
	local long = math.max(sz.X, sz.Z)
	local ry = sz.Z > sz.X and math.pi / 2 or 0
	local len = (b - a).Magnitude
	m:ScaleTo(m:GetScale() * (len / long))
	local dir = (b - a).Unit
	local ang = math.atan2(-dir.Z, dir.X)
	m:PivotTo(CFrame.new(m:GetPivot().Position) * CFrame.Angles(0, ry, 0))
	local cf0 = m:GetBoundingBox()
	-- rotation autour du centre
	m:PivotTo(CFrame.new(cf0.Position) * CFrame.Angles(0, ang, 0) * CFrame.new(cf0.Position):Inverse() * m:GetPivot())
	local cf, s2 = m:GetBoundingBox()
	local mid = (a + b) / 2
	m:PivotTo(m:GetPivot() + (mid - Vector3.new(cf.Position.X, cf.Position.Y - s2.Y / 2, cf.Position.Z)))
	decorate(m, true)
	m.Parent = parent
end

local function fenceLine(tpl: Model, a: Vector3, b: Vector3, parent: Instance)
	local len = (b - a).Magnitude
	if len < 2 then return end
	local n = math.max(1, math.round(len / 20))
	for i = 0, n - 1 do fenceSeg(tpl, a:Lerp(b, i / n), a:Lerp(b, (i + 1) / n), parent) end
end

local out = {}
for _, z in ipairs(workspace.Map.Zones:GetChildren()) do
	local key = KEY[z.Name]
	local def = Zones.ById[z.Name]
	if not key or not def then continue end
	local C = Vector3.new(def.Center.X, 0, def.Center.Z)
	local H = def.Size / 2
	local P = def.PondSize / 2
	local rng = Random.new(#z.Name * 97 + def.Order)
	local hasBack = def.Order < 5

	-- ménage : ancienne déco, ancienne clôture, anciens poteaux / linteau du portail
	for _, n in ipairs({ "Decor", "Fence", "VaultGate" }) do local o = z:FindFirstChild(n); if o then o:Destroy() end end
	for _, c in ipairs(z:GetChildren()) do if c.Name == "GatePost" or c.Name == "GateTop" then c:Destroy() end end
	local decor = Instance.new("Folder"); decor.Name = "Decor"; decor.Parent = z
	-- le sol de la zone passe juste au-dessus de l'herbe de l'île (sinon les deux se chevauchent et clignotent)
	local ground = z:FindFirstChild("Ground") :: BasePart?
	if ground then ground.Position = Vector3.new(ground.Position.X, -0.96, ground.Position.Z) end
	local fence = Instance.new("Model"); fence.Name = "Fence"; fence.Parent = z

	-- clôture : avant (portail au milieu), côtés, fond (sortie vers la zone suivante)
	local ft = get("biomes_" .. key .. "_fence")
	local GW, BW = 14, 7
	fenceLine(ft, C + Vector3.new(-H, 0, -H), C + Vector3.new(-GW, 0, -H), fence)
	fenceLine(ft, C + Vector3.new(GW, 0, -H), C + Vector3.new(H, 0, -H), fence)
	fenceLine(ft, C + Vector3.new(H, 0, -H), C + Vector3.new(H, 0, H), fence)
	fenceLine(ft, C + Vector3.new(-H, 0, H), C + Vector3.new(-H, 0, -H), fence)
	if hasBack then
		fenceLine(ft, C + Vector3.new(H, 0, H), C + Vector3.new(BW, 0, H), fence)
		fenceLine(ft, C + Vector3.new(-BW, 0, H), C + Vector3.new(-H, 0, H), fence)
	else
		fenceLine(ft, C + Vector3.new(H, 0, H), C + Vector3.new(-H, 0, H), fence)
	end

	-- portail de zone (arche du vault) autour de la barrière "Gate"
	local gate = z:FindFirstChild("Gate") :: BasePart?
	local arch = get("biomes_" .. key .. "_gate")
	arch.Name = "VaultGate"
	local _, asz = arch:GetBoundingBox()
	local s = 28 / math.max(asz.X, asz.Z)
	put(arch, C + Vector3.new(0, 0, -H), asz.Z > asz.X and math.pi / 2 or 0, s, z)
	decorate(arch, false)
	-- panneau de l'arche : nom de la zone
	local board, best = nil, 0
	for _, p in ipairs(arch:GetDescendants()) do
		if p:IsA("BasePart") then
			local area = p.Size.X * p.Size.Y
			if p.Size.Z < 1.6 and p.Size.X > 6 and area > best and p.Position.Y > 6 then board, best = p, area end
		end
	end
	if board then
		for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
			local sg = Instance.new("SurfaceGui"); sg.Name = "ZoneSign"; sg.Face = face; sg.LightInfluence = 0
			sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 30; sg.MaxDistance = 250; sg.Parent = board
			local t = Instance.new("TextLabel"); t.BackgroundTransparency = 1; t.Size = UDim2.fromScale(0.92, 0.8); t.Position = UDim2.fromScale(0.04, 0.1)
			t.TextScaled = true; t.FontFace = FONT; t.TextColor3 = Color3.new(1, 1, 1); t.Text = string.upper(def.Name); t.Parent = sg
			local st = Instance.new("UIStroke"); st.Thickness = 3; st.Color = Color3.fromRGB(20, 16, 30); st.Parent = t
		end
	end
	if gate then gate.Size = Vector3.new(18, 12, 1); gate.CFrame = CFrame.new(C + Vector3.new(0, 6, -H)) end

	-- déco : composition aérée (plus de semis au hasard) — groupes dans les coins, un peu sur les côtés,
	-- l'œuf à l'entrée, le coffre près de la sortie, quelques pierres au bord du pond. Le centre reste libre pour ratisser.
	local placed: { Vector3 } = {}
	local function at(name: string, p: Vector3, ry: number, scale: number?): Model
		local m = get(name); put(m, p, ry, scale, decor); decorate(m, false); table.insert(placed, p)
		return m
	end
	local entrance = C + Vector3.new(0, 0, -H)
	local b = "biomes_" .. key .. "_"
	local function L(x: number, zz: number): Vector3 return C + Vector3.new(x, 0, zz) end
	local r = function() return rng:NextNumber(0, math.pi * 2) end
	-- coins avant : arbre + rocher + buisson
	for _, sx in ipairs({ -1, 1 }) do
		at(b .. "tree", L(sx * (H - 8), -H + 8), r(), 1.25)
		at(b .. "boulder", L(sx * (H - 17), -H + 6), r(), 0.75)
		at(b .. "bush", L(sx * (H - 6), -H + 17), r(), 1.0)
	end
	-- coin arrière gauche : le gros prop du biome ; arrière droit : arbre + coffre tourné vers le centre
	local big = at(SPECIAL[key][2], L(-(H - 11), H - 11), key == "void" and math.rad(-45) or r(), key == "void" and 1.25 or 1.15)
	if key == "void" then addPortal(big) end
	at(b .. "bush", L(-(H - 22), H - 5), r(), 0.9)
	at(b .. "tree", L(H - 8, H - 8), r(), 1.25)
	face(at(b .. "chest", L(H - 20, H - 7), 0, 1.1), C, isLock)
	-- milieu des côtés : petit arbre + fleurs
	at(b .. "tree_small", L(-(H - 6), 2), r(), 1.1)
	at(b .. "flowers", L(-(H - 7), -9), r(), 0.8)
	at(b .. "tree_small", L(H - 6, -2), r(), 1.1)
	at(b .. "rock", L(H - 6, 9), r(), 0.9)
	-- entrée : l'œuf du biome sur son nid (à gauche), un prop du biome à droite
	at(b .. "egg", L(-12, -H + 7), 0.3, 1.3)
	if key == "ice" then
		face(at("biomes_ice_sp_snowman", L(12, -H + 8), 0, 1.2), entrance + Vector3.new(0, 0, -10), isNose)
	else
		at(SPECIAL[key][1], L(12, -H + 8), r(), key == "void" and 0.5 or 1.0)
	end
	-- bord du pond : cristaux sur deux coins, petits rochers sur les deux autres
	local pc = P + 3.5
	at(b .. "crystal", L(-pc, -pc), r(), 0.8)
	at(b .. "crystal", L(pc, pc), r(), 0.8)
	at(b .. "rock", L(pc, -pc), r(), 0.6)
	at(b .. "rock", L(-pc, pc), r(), 0.6)
	-- allée en dalles de l'entrée au pond (et du pond à la sortie)
	local function slabs(z0: number, z1: number)
		local n = math.floor(math.abs(z1 - z0) / 3.2)
		for i = 0, n - 1 do
			local zz = z0 + (z1 - z0) * (i + 0.5) / n
			local p = Instance.new("Part")
			p.Name = "Slab"; p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Size = Vector3.new(rng:NextNumber(3.2, 4.2), 0.16, 2.4)
			p.CFrame = CFrame.new(L(rng:NextNumber(-0.4, 0.4), zz) + Vector3.new(0, 0.1, 0)) * CFrame.Angles(0, rng:NextNumber(-0.12, 0.12), 0)
			local gcol = ground and ground.Color or Color3.new(0.6, 0.6, 0.6)
			local h, sat, v = gcol:ToHSV()
			p.Color = Color3.fromHSV(h, sat * 0.6, math.clamp(v * (v > 0.5 and 0.82 or 1.35), 0, 1))
			p.Material = Enum.Material.SmoothPlastic
			p.Parent = decor
		end
	end
	slabs(-H + 1, -P - 2)
	if hasBack then slabs(P + 2, H - 1) end
	local n = 0; for _, d in ipairs(z:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
	table.insert(out, z.Name .. "=" .. n)
	task.wait()
end
return table.concat(out, " ")
