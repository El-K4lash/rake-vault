--!strict
-- ReplicatedStorage/Shared/Visuals/Models
-- Fabrique les modèles des galaxies et des planètes en BLOCS (style brique avec studs).
-- Chaque planète est une "sphère de briques" : des couches empilées, chacune en forme de croix
-- (octogone en blocs), avec des studs sur le dessus. Puis des détails selon son style :
-- cratères, bandes, continents, nuages, fissures de lave, cristaux, anneaux, lune, visage mignon.
-- Utilisé par le serveur (galaxies sur les spawners / dans l'enclos) et par le client
-- (orbites, Index, inventaire, popup d'éclosion, boutons du HUD).
-- Si un modèle existe dans ReplicatedStorage.Assets.Planets/<Id> (ou Galaxies/<Id>), il est utilisé à la place.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Config = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config")
local Rarities = require(Config.Rarities)
local Galaxies = require(Config.Galaxies)
local Planets = require(Config.Planets)
local Mutations = require(Config.Mutations)

local Models = {}

local STUDS = Enum.SurfaceType.Studs
local INLET = Enum.SurfaceType.Inlet
local SMOOTH = Enum.SurfaceType.Smooth
local INK = Color3.fromRGB(20, 22, 40)

-- [ OUTILS ] -------------------------------------------------------------------

-- une brique : Plastic + studs dessus (sauf Neon / Glass / Ice qui restent lisses)
local function block(parent: Instance, name: string, size: Vector3, cf: CFrame, color: Color3, material: Enum.Material?, transparency: number?): Part
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.CFrame = cf
	p.Color = color
	local mat = material or Enum.Material.Plastic
	p.Material = mat
	p.Transparency = transparency or 0
	p.Anchored = true
	p.CanCollide = false
	p.CanTouch = false
	p.CanQuery = false
	p.CastShadow = false
	if mat == Enum.Material.Plastic then
		p.TopSurface = STUDS
		p.BottomSurface = INLET
	else
		p.TopSurface = SMOOTH
		p.BottomSurface = SMOOTH
	end
	p.Parent = parent
	return p
end

local function sparkles(parent: Instance, color: Color3, rate: number, size: number)
	local att = Instance.new("Attachment")
	att.Parent = parent
	local pe = Instance.new("ParticleEmitter")
	pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	pe.Color = ColorSequence.new(color, Color3.new(1, 1, 1))
	pe.LightEmission = 1
	pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, size), NumberSequenceKeypoint.new(1, 0) })
	pe.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
	pe.Lifetime = NumberRange.new(0.8, 1.6)
	pe.Speed = NumberRange.new(1, 3)
	pe.SpreadAngle = Vector2.new(180, 180)
	pe.Rate = rate
	pe.Parent = att
end

local function lighten(c: Color3, a: number): Color3
	return c:Lerp(Color3.new(1, 1, 1), a)
end
local function darken(c: Color3, a: number): Color3
	return c:Lerp(Color3.new(0, 0, 0), a)
end

-- [ SPHÈRE DE BRIQUES ] --------------------------------------------------------
-- n couches de hauteur u. Chaque couche = 2 blocs croisés (forme octogonale).
-- Renvoie la liste des couches { y, half } (half = demi-largeur) pour poser des détails dessus.
type Layer = { y: number, half: number, index: number }

local function brickSphere(model: Model, d: number, n: number, colorAt: (number, number) -> Color3, material: Enum.Material?, name: string?): { Layer }
	local u = d / n
	local R = d / 2
	local layers = {}
	for i = 1, n do
		local y = (i - (n + 1) / 2) * u
		-- rayon au milieu de la couche, un peu "gonflé" pour un look plus rond
		local r = math.sqrt(math.max(R * R - y * y, (u * 0.6) ^ 2)) * 1.04
		local w = 2 * r
		local narrow = w * 0.62
		local col = colorAt(i, n)
		-- croix SANS chevauchement (sinon les studs du dessus clignotent) :
		-- une barre centrale + 2 morceaux devant / derrière
		local side = (w - narrow) / 2
		block(model, name or "Ball", Vector3.new(w, u, narrow), CFrame.new(0, y, 0), col, material)
		block(model, name or "Ball", Vector3.new(narrow, u, side), CFrame.new(0, y, narrow / 2 + side / 2), col, material)
		block(model, name or "Ball", Vector3.new(narrow, u, side), CFrame.new(0, y, -narrow / 2 - side / 2), col, material)
		table.insert(layers, { y = y, half = r, index = i })
	end
	return layers
end

-- point sur la surface d'une couche, dans une direction (angle autour de Y)
-- la croix a des faces plates à 0°, 90°, 180°, 270° (demi-largeur = half) et des pans à 45° (plus près)
local function surfacePoint(layer: Layer, angle: number): (Vector3, number)
	local a = angle % (math.pi * 2)
	local nearAxis = math.abs(((a + math.pi / 4) % (math.pi / 2)) - math.pi / 4) < math.pi / 8
	local dist = nearAxis and layer.half or layer.half * 0.82
	return Vector3.new(math.sin(a) * dist, layer.y, math.cos(a) * dist), dist
end

-- [ STYLES DES PLANÈTES ] ------------------------------------------------------
-- Style + couleur secondaire de chaque planète (sinon déduit de la rareté).
type Style = { kind: string, second: Color3?, moon: boolean? }
local C = Color3.fromRGB
local STYLE: { [string]: Style } = {
	RockyPebble   = { kind = "rock",    second = C(110, 100, 95) },
	DustBall      = { kind = "desert",  second = C(230, 200, 150) },
	MossyMoon     = { kind = "rock",    second = C(80, 120, 70) },
	ClayOrb       = { kind = "desert",  second = C(150, 80, 60) },
	FoggyRock     = { kind = "cloudy",  second = C(230, 235, 245) },
	OceanBubble   = { kind = "earth",   second = C(70, 200, 90) },
	JungleSphere  = { kind = "jungle",  second = C(20, 110, 40) },
	MintRing      = { kind = "gas",     second = C(200, 255, 230) },
	CoralReef     = { kind = "earth",   second = C(255, 200, 150) },
	LimeComet     = { kind = "ice",     second = C(240, 255, 200) },
	CrystalCore   = { kind = "crystal", second = C(220, 245, 255) },
	NeonStorm     = { kind = "gas",     second = C(0, 140, 160) },
	AmethystGiant = { kind = "gas",     second = C(220, 170, 255) },
	VoidJelly     = { kind = "void",    second = C(200, 90, 255) },
	PlasmaPearl   = { kind = "gas",     second = C(255, 220, 255), moon = true },
	GoldenSaturn  = { kind = "gas",     second = C(255, 240, 180) },
	SunForge      = { kind = "lava",    second = C(255, 230, 80) },
	HoneyNova     = { kind = "hive",    second = C(200, 130, 20) },
	CrownWorld    = { kind = "crystal", second = C(255, 210, 60), moon = true },
	AmberTitan    = { kind = "gas",     second = C(255, 210, 120), moon = true },
	CrimsonEye    = { kind = "eye",     second = C(255, 230, 230) },
	BloodMoon     = { kind = "rock",    second = C(90, 0, 15) },
	HeartNebula   = { kind = "candy",   second = C(255, 200, 225) },
	InfernoPrime  = { kind = "lava",    second = C(255, 200, 40), moon = true },
	RoseQuasar    = { kind = "star",    second = C(255, 180, 210) },
	PrismSingularity = { kind = "crystal", second = C(255, 255, 255) },
	RainbowAbyss  = { kind = "gas",     second = C(255, 255, 255) },
	CosmicEgg     = { kind = "egg",     second = C(255, 255, 255) },
	OmegaStar     = { kind = "star",    second = C(255, 255, 255), moon = true },
	TheGlitch     = { kind = "glitch",  second = C(0, 255, 230) },
}

-- [ GALAXIE ] ----------------------------------------------------------------
-- Cœur en briques lumineuses + bras en spirale faits de cubes + étoiles + disque en croix.
-- Taille ~ 7 studs * scale.
function Models.Galaxy(galaxyId: string, scale: number?): Model
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local custom = assets and assets:FindFirstChild("Galaxies") and assets.Galaxies:FindFirstChild(galaxyId)
	if custom and custom:IsA("Model") then
		local m = custom:Clone()
		if scale and scale ~= 1 then m:ScaleTo(scale) end
		CollectionService:AddTag(m, "Spin")
		return m
	end

	local s = scale or 1
	local g = Galaxies.ById[galaxyId]
	local rarity = Rarities.Info[g and g.Rarity or "Common"]
	local color = rarity.Color
	local order = rarity.Order
	local model = Instance.new("Model")
	model.Name = galaxyId
	local rng = Random.new(#galaxyId * 31 + order)

	-- cœur : petite sphère de briques néon + noyau blanc
	local coreD = (1.5 + order * 0.08) * s
	local center = block(model, "Core", Vector3.one * coreD * 0.55, CFrame.new(), Color3.new(1, 1, 1), Enum.Material.Neon)
	model.PrimaryPart = center
	brickSphere(model, coreD, 5, function(i, n)
		return lighten(color, 0.25 + 0.1 * math.abs(i - (n + 1) / 2))
	end, Enum.Material.Neon, "Core")

	-- halo de petits cubes autour du cœur
	for i = 1, 8 do
		local a = i / 8 * math.pi * 2
		local r = coreD * 0.85
		block(model, "Arm", Vector3.one * 0.22 * s, CFrame.new(math.cos(a) * r, 0, math.sin(a) * r) * CFrame.Angles(0, a, math.rad(45)),
			Color3.new(1, 1, 1), Enum.Material.Neon)
	end

	-- bras en spirale (2 bras, 3 dès Épique)
	local arms = order >= 3 and 3 or 2
	local perArm = 8
	for arm = 0, arms - 1 do
		for i = 1, perArm do
			local t = i / perArm
			local angle = arm * (math.pi * 2 / arms) + t * math.pi * 1.5
			local r = (1.1 + t * 2.5) * s
			local size = (0.75 - t * 0.45) * s
			local cube = block(model, "Arm", Vector3.one * size,
				CFrame.new(math.cos(angle) * r, (rng:NextNumber() - 0.5) * 0.25 * s, math.sin(angle) * r)
					* CFrame.Angles(rng:NextNumber() * 3, rng:NextNumber() * 3, rng:NextNumber() * 3),
				color:Lerp(Color3.new(1, 1, 1), t * 0.55), Enum.Material.Neon, t * 0.25)
			cube.Name = "Arm"
		end
	end

	-- étoiles éparpillées (petits cubes blancs)
	for _ = 1, 10 do
		local a = rng:NextNumber() * math.pi * 2
		local r = rng:NextNumber(1.2, 3.8) * s
		block(model, "Star", Vector3.one * 0.14 * s, CFrame.new(math.cos(a) * r, rng:NextNumber(-0.4, 0.4) * s, math.sin(a) * r),
			Color3.new(1, 1, 1), Enum.Material.Neon)
	end

	-- disque : 2 plaques croisées très transparentes (octogone)
	local dw = 7.6 * s
	block(model, "Disc", Vector3.new(dw, 0.12 * s, dw * 0.62), CFrame.new(), rarity.Dark, Enum.Material.Neon, 0.7)
	local dside = (dw - dw * 0.62) / 2
	block(model, "Disc", Vector3.new(dw * 0.62, 0.12 * s, dside), CFrame.new(0, 0, dw * 0.31 + dside / 2), rarity.Dark, Enum.Material.Neon, 0.7)
	block(model, "Disc", Vector3.new(dw * 0.62, 0.12 * s, dside), CFrame.new(0, 0, -dw * 0.31 - dside / 2), rarity.Dark, Enum.Material.Neon, 0.7)

	-- raretés hautes : anneau doré incliné en blocs
	if order >= 4 then
		local tilt = CFrame.Angles(math.rad(70), 0, math.rad(15))
		for i = 1, 14 do
			local a = i / 14 * math.pi * 2
			local r = coreD * 1.25
			block(model, "Ring", Vector3.new(0.45 * s, 0.18 * s, 0.25 * s), tilt * CFrame.new(math.cos(a) * r, 0, math.sin(a) * r) * CFrame.Angles(0, -a, 0),
				i % 2 == 0 and C(255, 215, 80) or C(255, 245, 200), Enum.Material.Neon)
		end
	end

	local light = Instance.new("PointLight")
	light.Color = color
	light.Range = 10 * s
	light.Brightness = 1.6
	light.Parent = center
	sparkles(center, color, 4 + order * 2, 0.35 * s)

	if rarity.Rainbow then model:SetAttribute("Rainbow", true) end
	model:SetAttribute("Spin", 0.6 + order * 0.12)
	CollectionService:AddTag(model, "Spin")
	return model
end

-- [ PLANÈTE ] ----------------------------------------------------------------
function Models.Planet(planetId: string, mutationId: string?, size: number?): Model
	local d = size or 3
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local custom = assets and assets:FindFirstChild("Planets") and assets.Planets:FindFirstChild(planetId)
	local p = Planets.ById[planetId]
	local rarity = Rarities.Info[p and p.Rarity or "Common"]
	local look = p and p.Look or {}
	local style: Style = STYLE[planetId] or { kind = "rock" }
	local model: Model

	local base: Color3 = look.Color or rarity.Color
	local second: Color3 = style.second or lighten(base, 0.4)
	if look.Rainbow then
		base = C(255, 120, 200)
	end
	local material = Enum.Material.Plastic
	if mutationId == "Golden" then
		base = C(255, 200, 50); second = C(255, 235, 140)
	elseif mutationId == "Frozen" then
		base = base:Lerp(C(170, 230, 255), 0.7); second = C(235, 250, 255)
	end

	if custom and custom:IsA("Model") then
		model = custom:Clone()
		model:ScaleTo(d / math.max(model:GetExtentsSize().X, 0.01))
	else
		model = Instance.new("Model")
		local rng = Random.new(#planetId * 97 + string.byte(planetId, 1))
		local n = 7
		local u = d / n
		local kind = style.kind

		-- couleur de chaque couche selon le style
		local function layerColor(i: number, count: number): Color3
			if kind == "gas" or kind == "candy" or kind == "hive" then
				-- bandes : une couche sur deux plus claire
				return i % 2 == 0 and second or base
			elseif kind == "star" or kind == "lava" then
				local mid = math.abs(i - (count + 1) / 2) / count
				return base:Lerp(second, 0.6 - mid)
			elseif kind == "egg" then
				return Color3.fromHSV((i / count) * 0.8, 0.45, 1)
			end
			-- roches : légère variation de teinte d'une couche à l'autre
			return i % 2 == 0 and darken(base, 0.08) or base
		end

		local mat = material
		if kind == "star" then mat = Enum.Material.Neon end
		if mutationId == "Frozen" then mat = Enum.Material.Plastic end
		local layers = brickSphere(model, d, n, layerColor, mat, "Ball")
		local core = block(model, "Core", Vector3.one * d * 0.5, CFrame.new(), base, Enum.Material.Plastic, 1)
		model.PrimaryPart = core

		-- calottes polaires (bloc plat au sommet / en bas)
		local function cap(layer: Layer, color: Color3, mat2: Enum.Material?)
			local w = layer.half * 1.25
			local y = layer.y + u * 0.5 * math.sign(layer.y)
			local nw = w * 0.62
			local side = (w - nw) / 2
			block(model, "Spot", Vector3.new(w, u * 0.35, nw), CFrame.new(0, y, 0), color, mat2)
			block(model, "Spot", Vector3.new(nw, u * 0.35, side), CFrame.new(0, y, nw / 2 + side / 2), color, mat2)
			block(model, "Spot", Vector3.new(nw, u * 0.35, side), CFrame.new(0, y, -nw / 2 - side / 2), color, mat2)
		end

		-- taches posées sur la surface (cratères, continents, nuages...)
		local function patch(count: number, color: Color3, w: number, h: number, mat2: Enum.Material?, nameIt: string?, sink: number?)
			for _ = 1, count do
				local layer = layers[rng:NextInteger(2, n - 1)]
				local a = rng:NextNumber() * math.pi * 2
				-- on évite la face avant (le visage)
				if math.abs(((a + math.pi) % (math.pi * 2)) - math.pi) < 0.7 then a += math.pi end
				local pos, dist = surfacePoint(layer, a)
				local out = Vector3.new(math.sin(a), 0, math.cos(a))
				local cf = CFrame.lookAt(pos + out * (u * (0.12 - (sink or 0))), pos + out * 2) * CFrame.new(0, (rng:NextNumber() - 0.5) * u * 0.6, 0)
				block(model, nameIt or "Spot", Vector3.new(w * u * rng:NextNumber(0.8, 1.3), h * u, u * 0.4), cf, color, mat2)
				local _ = dist
			end
		end

		if kind == "rock" or kind == "desert" then
			patch(5, darken(base, 0.3), 1.1, 0.9, nil, "Spot")
			patch(3, lighten(second, 0.1), 0.8, 0.5, nil, "Spot")
		elseif kind == "earth" or kind == "jungle" then
			patch(kind == "jungle" and 7 or 5, second, 1.6, 1.0, nil, "Land")
			patch(3, Color3.new(1, 1, 1), 1.4, 0.45, nil, "Cloud")
			cap(layers[n], Color3.new(1, 1, 1))
			cap(layers[1], Color3.new(1, 1, 1))
		elseif kind == "cloudy" then
			patch(7, second, 1.8, 0.6, nil, "Cloud")
		elseif kind == "ice" then
			cap(layers[n], second)
			cap(layers[1], second)
			patch(4, lighten(base, 0.5), 0.9, 0.9, Enum.Material.Ice, "Spot")
		elseif kind == "lava" then
			patch(7, second, 1.2, 0.3, Enum.Material.Neon, "Lava")
			patch(3, darken(base, 0.5), 1.0, 0.9, nil, "Spot")
		elseif kind == "void" then
			patch(6, second, 0.6, 0.6, Enum.Material.Neon, "Spot")
		elseif kind == "hive" then
			patch(6, second, 0.9, 0.9, nil, "Spot")
		elseif kind == "candy" then
			patch(6, Color3.new(1, 1, 1), 0.5, 0.5, nil, "Spot")
		elseif kind == "gas" then
			-- grosse tempête
			patch(1, darken(second, 0.2), 1.8, 1.0, nil, "Spot")
		end

		-- pointes de cristal
		if kind == "crystal" or look.Crystals then
			for i = 1, 6 do
				local layer = layers[(i % 2 == 0) and n or rng:NextInteger(2, n - 1)]
				local a = rng:NextNumber() * math.pi * 2
				local pos = surfacePoint(layer, a)
				local out = (pos.Unit + Vector3.new(0, 0.6, 0)).Unit
				local len = u * rng:NextNumber(1.4, 2.4)
				block(model, "Crystal", Vector3.new(u * 0.55, len, u * 0.55),
					CFrame.lookAt(pos + out * len * 0.35, pos + out * 3) * CFrame.Angles(math.rad(90), 0, math.rad(45)),
					lighten(second, 0.2), Enum.Material.Neon, 0.1)
			end
		end

		-- œil géant (Crimson Eye) : remplace le visage
		local face = true
		if kind == "eye" then
			face = false
			local z = layers[4].half
			block(model, "Spot", Vector3.new(u * 3.2, u * 2.2, u * 0.3), CFrame.new(0, 0, z + u * 0.1), second)
			block(model, "Spot", Vector3.new(u * 1.4, u * 1.4, u * 0.3), CFrame.new(0, 0, z + u * 0.25), C(255, 200, 0), Enum.Material.Neon)
			block(model, "Eye", Vector3.new(u * 0.7, u * 0.9, u * 0.3), CFrame.new(0, 0, z + u * 0.4), INK)
		end

		-- étoile : rayons en blocs
		if kind == "star" then
			for i = 1, 8 do
				local a = i / 8 * math.pi * 2
				block(model, "Ring", Vector3.new(u * 0.6, u * 0.6, u * 2.2),
					CFrame.Angles(0, a, 0) * CFrame.new(0, 0, d * 0.62) * CFrame.Angles(math.rad(45), 0, 0),
					second, Enum.Material.Neon)
			end
		end

		-- œuf cosmique : coquille craquée en zigzag
		if kind == "egg" then
			for i = 1, 10 do
				local a = i / 10 * math.pi * 2
				local layer = layers[(i % 2 == 0) and 5 or 4]
				local pos = surfacePoint(layer, a)
				block(model, "Spot", Vector3.new(u * 0.9, u * 0.3, u * 0.3), CFrame.lookAt(pos * 1.04, pos * 2), Color3.new(1, 1, 1), Enum.Material.Neon)
			end
		end

		-- glitch : cubes décalés magenta / cyan
		if kind == "glitch" or look.Glitch then
			for i = 1, 9 do
				local v = rng:NextUnitVector() * d * rng:NextNumber(0.35, 0.65)
				block(model, "Glitch", Vector3.new(u * rng:NextNumber(0.6, 1.8), u * rng:NextNumber(0.3, 0.8), u * 0.5), CFrame.new(v),
					i % 2 == 0 and C(255, 0, 200) or C(0, 255, 230), Enum.Material.Neon)
			end
			model:SetAttribute("Glitch", true)
		end

		-- anneau en briques (studs dessus), 2 couleurs alternées
		if look.Ring then
			local tilt = CFrame.Angles(math.rad(18), 0, math.rad(10))
			local segs = 18
			local r = d * 0.86
			local segLen = 2 * math.pi * r / segs * 1.02
			for i = 1, segs do
				local a = (i / segs) * math.pi * 2
				block(model, "Ring", Vector3.new(segLen, u * 0.35, u * 1.3),
					tilt * CFrame.new(math.cos(a) * r, 0, math.sin(a) * r) * CFrame.Angles(0, -a + math.pi / 2, 0),
					i % 2 == 0 and lighten(base, 0.45) or second)
			end
		end

		-- petite lune en briques
		if style.moon then
			local m = Instance.new("Model")
			m.Name = "Moon"
			brickSphere(m, d * 0.28, 3, function(i) return i % 2 == 0 and C(200, 200, 215) or C(170, 170, 185) end, nil, "Spot")
			m:PivotTo(CFrame.new(d * 0.75, d * 0.42, -d * 0.2))
			m.Parent = model
		end

		-- halo lumineux pour les raretés hautes
		if look.Glow or rarity.Order >= 4 then
			local hw = d * 1.15
			block(model, "Glow", Vector3.new(hw, hw * 0.92, hw * 0.62), CFrame.new(), lighten(base, 0.3), Enum.Material.Neon, 0.85)
			block(model, "Glow", Vector3.new(hw * 0.62, hw * 0.92, hw), CFrame.new(), lighten(base, 0.3), Enum.Material.Neon, 0.85)
		end

		if look.Tail then
			sparkles(core, base, 10, d * 0.2)
		end

		-- visage mignon en blocs : yeux, reflets, joues, bouche
		if face then
			local zMid = layers[4].half
			for _, side in ipairs({ -1, 1 }) do
				block(model, "Eye", Vector3.new(u * 0.75, u * 1.15, u * 0.3), CFrame.new(side * u * 1.05, u * 0.3, zMid + u * 0.08), INK)
				block(model, "Glint", Vector3.new(u * 0.3, u * 0.3, u * 0.12), CFrame.new(side * u * 1.05 + u * 0.15, u * 0.6, zMid + u * 0.26), Color3.new(1, 1, 1), Enum.Material.Neon)
				block(model, "Cheek", Vector3.new(u * 0.65, u * 0.35, u * 0.2), CFrame.new(side * u * 1.9, -u * 0.35, zMid - u * 0.02), C(255, 120, 160))
			end
			block(model, "Mouth", Vector3.new(u * 0.7, u * 0.22, u * 0.2), CFrame.new(0, -u * 0.5, zMid + u * 0.06), INK)
			block(model, "Mouth", Vector3.new(u * 0.22, u * 0.22, u * 0.2), CFrame.new(-u * 0.45, -u * 0.38, zMid + u * 0.06), INK)
			block(model, "Mouth", Vector3.new(u * 0.22, u * 0.22, u * 0.2), CFrame.new(u * 0.45, -u * 0.38, zMid + u * 0.06), INK)
		end

		-- mutations : glaçons (Frozen), braises (Fire)
		if mutationId == "Frozen" then
			for i = 1, 6 do
				local a = i / 6 * math.pi * 2
				block(model, "Spot", Vector3.new(u * 0.4, u * 1.2, u * 0.4), CFrame.new(math.sin(a) * d * 0.3, -d * 0.48, math.cos(a) * d * 0.3), C(220, 245, 255), Enum.Material.Ice, 0.2)
			end
		elseif mutationId == "Fire" then
			patch(5, C(255, 140, 20), 0.9, 0.4, Enum.Material.Neon, "Lava")
		elseif mutationId == "Golden" then
			patch(4, C(255, 250, 200), 0.5, 0.5, Enum.Material.Neon, "Spot")
		end

		if look.Rainbow then model:SetAttribute("Rainbow", true) end
	end

	model.Name = planetId
	local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")

	-- effets de mutation
	if root then
		if mutationId == "Golden" then
			sparkles(root, C(255, 220, 80), 8, d * 0.15)
		elseif mutationId == "Frozen" then
			sparkles(root, C(200, 240, 255), 8, d * 0.15)
		elseif mutationId == "Fire" then
			local fire = Instance.new("Fire")
			fire.Size = d * 1.4
			fire.Heat = 4
			fire.Color = C(255, 120, 20)
			fire.SecondaryColor = C(255, 220, 60)
			fire.Parent = root
		elseif mutationId == "Rainbow" then
			model:SetAttribute("Rainbow", true)
			sparkles(root, Color3.new(1, 1, 1), 12, d * 0.15)
		end
		if rarity.Order >= 3 then
			local light = Instance.new("PointLight")
			light.Color = base
			light.Range = d * 3
			light.Brightness = 1.2
			light.Parent = root
		end
	end

	model:SetAttribute("PlanetId", planetId)
	model:SetAttribute("Mutation", mutationId or "")
	model:SetAttribute("Spin", 0.5)
	CollectionService:AddTag(model, "Spin")
	return model
end

-- couleur d'une mutation (pour les textes)
function Models.MutationColor(mutationId: string?): Color3?
	local m = mutationId and Mutations.ById[mutationId]
	return m and m.Color or nil
end

-- outils réutilisés par le MapBuilder (même style de briques partout)
Models.Block = block
Models.BrickSphere = brickSphere

return Models
