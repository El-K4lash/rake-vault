-- build_lobby.lua : refait le lobby (Map.Hub) avec les modèles du vault, catégorie Lobby (ServerStorage.Vault.lobby).
-- Remplace les anciens stands Steal an Egg. Tout reste en vraies instances (lancé une fois en Edit).
--   centre        : fontaine (lobby_fountain) sur socle
--   anneau r=40   : SHOP (-95°)  INDEX (95°)  SELL (-52.7°)  FREE EGG (52.7°) ; ROUE (+15.7°)  FUSION (-15.7°)
--   Machine Rebirth (180°) et classements (±138°) : les anciens modèles, remis depuis ServerStorage.OldLobbyBackup
--   entrées       : lampadaires de chaque côté des 9 chemins ; panneau HOW TO PLAY près du spawn
-- Les modèles du vault ont leur face avant en +Z. Les textes (panneaux, écrans) sont des SurfaceGui.
-- Reconstruction partielle : _G.LOBBY_ONLY = { chest = true, center = true } avant le require (nil = tout refaire).
-- Sections : center, stands, chest, old (Rebirth + classements), wheel, fusion, incubator, lamps, info.
local ONLY = _G.LOBBY_ONLY
local function run(sec) return ONLY == nil or ONLY[sec] == true end
local H = workspace.Map.Hub
local V = game.ServerStorage.Vault.lobby
local KIT = game.ReplicatedStorage.Assets.Kit
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
local NAVY = Color3.fromRGB(27, 42, 53)
local log = {}

-- [ OUTILS ] -----------------------------------------------------------------------
local function flat(v) return Vector3.new(v.X, 0, v.Z) end
local function polar(deg, r) local a = math.rad(deg); return Vector3.new(math.sin(a) * r, 0, math.cos(a) * r) end

local function clone(id, name)
	local m = V[id]:Clone(); m.Name = name
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.Anchored = true; d.CanTouch = false end
	end
	return m
end
local function scale(m, k) if k ~= 1 then m:ScaleTo(m:GetScale() * k) end end
local function bottomTo(m, pos)
	local cf, s = m:GetBoundingBox()
	m:PivotTo(m:GetPivot() + (pos - Vector3.new(cf.X, cf.Y - s.Y / 2, cf.Z)))
end
-- pose le modèle au point (deg, r), face avant (+Z du vault) tournée vers "look" (par défaut le centre)
local function place(m, deg, r, y, look)
	local at = polar(deg, r)
	local target = look or Vector3.zero
	local dir = flat(target - at).Unit
	local p = m:GetPivot().Position
	m:PivotTo(CFrame.new(p) * CFrame.Angles(0, math.atan2(dir.X, dir.Z), 0))
	bottomTo(m, at + Vector3.new(0, y or 0.2, 0))
	m.Parent = H
	return at, dir
end
-- même chose quand la face avant du modèle n'est pas +Z (vecteur "front" en coordonnées monde avant placement)
local function placeFront(m, front, deg, r, y, look)
	local at = polar(deg, r)
	local dir = flat((look or Vector3.zero) - at).Unit
	local f = flat(front).Unit
	local p = m:GetPivot()
	local yaw = math.atan2(dir.X, dir.Z) - math.atan2(f.X, f.Z)
	m:PivotTo(CFrame.new(p.Position) * CFrame.Angles(0, yaw, 0) * p.Rotation)
	bottomTo(m, at + Vector3.new(0, y or 0.2, 0))
	m.Parent = H
	return at, dir
end
local SPAWN = Vector3.new(0, 0, 25)
local function prompt(part, clientAction, actionText, objectText, dist)
	local pp = Instance.new("ProximityPrompt"); pp.ActionText = actionText; pp.ObjectText = objectText; pp.HoldDuration = 0
	pp.MaxActivationDistance = dist or 12; pp.RequiresLineOfSight = false; pp.KeyboardKeyCode = Enum.KeyCode.E
	pp:SetAttribute("ClientAction", clientAction); pp.Parent = part
	return pp
end
local function surface(part, face, ppu)
	local sg = Instance.new("SurfaceGui"); sg.Face = face; sg.LightInfluence = 0; sg.Brightness = 1.4
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = ppu or 50; sg.Parent = part
	return sg
end
local function label(parent, name, text, pos, size, color, xa, stroke)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Position = pos; t.Size = size
	t.FontFace = FONT; t.TextScaled = true; t.Text = text; t.TextColor3 = color or Color3.new(1, 1, 1)
	t.TextXAlignment = xa or Enum.TextXAlignment.Center; t.Parent = parent
	local s = Instance.new("UIStroke"); s.Thickness = stroke or 3; s.Color = NAVY; s.LineJoinMode = Enum.LineJoinMode.Round; s.Parent = t
	return t
end
local function P(x, y) return UDim2.fromScale(x, y) end
-- texte sur les 2 faces d'une plaque (le vault avait ses textes en texture)
local function plateText(part, text, color)
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local sg = surface(part, face, 60); sg.Name = "Sign" .. face.Name
		label(sg, "Text", text, P(0.06, 0.1), P(0.88, 0.8), color, nil, 4)
	end
end
local function billboard(adornee, text, color, offsetY, sub)
	local bb = Instance.new("BillboardGui"); bb.Name = "Label"; bb.Size = UDim2.fromScale(12, sub and 4 or 3)
	-- toujours visible (les arbres / la vitre de l'incubateur le cachaient), mais seulement d'assez près
	bb.StudsOffset = Vector3.new(0, offsetY, 0); bb.MaxDistance = 140; bb.AlwaysOnTop = true; bb.LightInfluence = 0; bb.Adornee = adornee; bb.Parent = adornee
	label(bb, "Title", text, P(0, 0), P(1, sub and 0.68 or 1), color, nil, 4)
	if sub then label(bb, "Timer", sub, P(0.15, 0.66), P(0.7, 0.34), Color3.new(1, 1, 1), nil, 3) end
	return bb
end
local function anchorAbove(m, extra)
	local cf, s = m:GetBoundingBox()
	local a = Instance.new("Part"); a.Name = "LabelAnchor"; a.Anchored = true; a.CanCollide = false; a.CanQuery = false; a.CanTouch = false
	a.Transparency = 1; a.Size = Vector3.new(1, 1, 1); a.CFrame = CFrame.new(cf.Position + Vector3.new(0, s.Y / 2 + (extra or 0), 0)); a.Parent = m
	return a
end
-- dalle d'interaction devant un stand (ProximityPrompt Action = menu / Sell / Chest)
local function pad(name, at, dir, dist, col, action, objectText, actionText)
	local old = H:FindFirstChild(name); if old then old:Destroy() end
	local k = KIT.Pad:Clone(); k.Name = name; k.Size = Vector3.new(12, k.Size.Y, 12); k.Color = col
	local q = at + dir * dist
	k.CFrame = CFrame.new(q.X, 0.52, q.Z) * CFrame.Angles(0, math.atan2(dir.X, dir.Z), 0); k.CanTouch = true; k.Parent = H
	for _, d in ipairs(k:GetChildren()) do if d:IsA("ProximityPrompt") then d:Destroy() end end
	local pp = Instance.new("ProximityPrompt"); pp.ActionText = actionText; pp.ObjectText = objectText; pp.HoldDuration = 0
	pp.MaxActivationDistance = 10; pp.RequiresLineOfSight = false; pp.KeyboardKeyCode = Enum.KeyCode.E
	pp:SetAttribute("Action", action); pp.Parent = k
	return k
end
local function findPart(m, test)
	for _, p in ipairs(m:GetDescendants()) do if p:IsA("BasePart") and test(p) then return p end end
end

-- [ NETTOYAGE ] (seulement ce que les sections lancées vont refaire) -------------------------
local OWN = {
	center = { "Planter", "PlanterGrass", "CenterPlanter", "CenterStatue", "CenterFountain" },
	stands = { "ShopStand", "IndexStand", "SellStand", "ShopPad", "IndexPad", "SellPad" },
	chest = { "FreeChest", "GroupChest" },
	old = { "RebirthMachine", "RebirthPad", "MoneyLeaderboard", "RebirthsLeaderboard" },
	fusion = { "FusionMachine" }, incubator = { "Incubator" }, lamps = { "Lamps" }, info = { "HowToPlay" },
}
-- les places réglées à la main dans Studio sont gardées : on note le pivot avant de supprimer, on le remet à la fin
local KEEP = {}
for sec, names in pairs(OWN) do
	if run(sec) then
		for _, n in ipairs(names) do
			local o = H:FindFirstChild(n)
			if o then
				if o:IsA("Model") or o:IsA("BasePart") then KEEP[n] = o:GetPivot() end
				o:Destroy()
			end
		end
	end
end
for _, n in ipairs({ "CodesStand", "VipStand", "CodesPad", "StorePad", "Preview" }) do local o = H:FindFirstChild(n); if o then o:Destroy() end end
if run("center") then
	-- fleurs / buissons de l'ancienne jardinière (r < 12)
	for _, d in ipairs(H.Decor:GetChildren()) do
		local ok, piv = pcall(function() return d:GetPivot().Position end)
		if ok and flat(piv).Magnitude < 12 then d:Destroy() end
	end
end
table.insert(log, "clean ok")

-- [ CENTRE ] fontaine du vault (lobby_fountain) sur un socle rond à marches (choix de Hugo : option C) -------------
local function disc(parent, name, d, h, yBottom, col, mat)
	local p = Instance.new("Part"); p.Name = name; p.Shape = Enum.PartType.Cylinder; p.Anchored = true; p.TopSurface = Enum.SurfaceType.Smooth
	p.Size = Vector3.new(h, d, d); p.CFrame = CFrame.new(0, yBottom + h / 2, 0) * CFrame.Angles(0, 0, math.rad(90))
	p.Color = col; p.Material = mat or Enum.Material.SmoothPlastic; p.Parent = parent
	return p
end
if run("center") then
	local m = Instance.new("Model"); m.Name = "CenterFountain"
	disc(m, "Base", 23, 0.8, 0.3, NAVY)
	disc(m, "Step", 20, 0.8, 1.1, Color3.fromRGB(233, 220, 190))
	disc(m, "Trim", 17.2, 0.12, 1.9, Color3.fromRGB(255, 197, 49))
	disc(m, "Top", 16.6, 0.3, 1.9, Color3.fromRGB(105, 208, 20))
	local f = clone("lobby_fountain", "Fountain")
	bottomTo(f, Vector3.new(0, 2.2, 0))
	f.Parent = m
	-- eau qui scintille + lumière bleue douce
	local water = nil
	for _, p in ipairs(f:GetDescendants()) do
		if p:IsA("BasePart") and p.Color.B > 0.8 and p.Color.R < 0.5 and (not water or p.Size.Magnitude > water.Size.Magnitude) then water = p end
	end
	if water then
		local spark = Instance.new("ParticleEmitter"); spark.Name = "Sparkle"; spark.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		spark.Color = ColorSequence.new(Color3.fromRGB(190, 240, 255)); spark.LightEmission = 0.8; spark.Rate = 5
		spark.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(1, 0) })
		spark.Lifetime = NumberRange.new(0.6, 1.2); spark.Speed = NumberRange.new(0.5, 2); spark.SpreadAngle = Vector2.new(60, 60); spark.Parent = water
		local l = Instance.new("PointLight"); l.Color = Color3.fromRGB(140, 220, 255); l.Range = 18; l.Brightness = 0.9; l.Parent = water
	end
	m.WorldPivot = CFrame.new(0, 0, 0)
	m.Parent = H
	local sp = H:FindFirstChild("SpawnLocation")
	if sp then sp.CFrame = CFrame.new(SPAWN.X, 0.6, SPAWN.Z) end
	table.insert(log, "center ok")
end

-- [ STANDS ] --------------------------------------------------------------------------
-- { nom, id vault, angle, panneau, dalle, couleur dalle, action, objet, bouton, rayon, distance de la dalle }
-- (rayons réglés à la main par Hugo dans Studio)
local STANDS = {
	{ "ShopStand", "lobby_stand_shop", -95, "SHOP", "ShopPad", Color3.fromRGB(255, 205, 0), "Shop", "Shop", "Open Shop", 54.8, 5.3 },
	{ "IndexStand", "lobby_stand_index", 95, "INDEX", "IndexPad", Color3.fromRGB(40, 170, 255), "Index", "Index", "Open Index", 54.1, 4.9 },
	{ "SellStand", "lobby_stand_sell", -52.7, "SELL", "SellPad", Color3.fromRGB(60, 235, 90), "Sell", "Sell", "Sell All", 52.3, 5.9 },
}
for _, s in ipairs(run("stands") and STANDS or {}) do
	local m = clone(s[2], s[1])
	-- texte du panneau : la plaque colorée la plus haute (8 × 2.1)
	local plate = findPart(m, function(p) return p.Position.Y > 12 and math.abs(p.Size.X - 8) < 0.3 and math.abs(p.Size.Y - 2.1) < 0.3 end)
	if plate then plateText(plate, s[4], Color3.new(1, 1, 1)) end
	local at, dir = place(m, s[3], s[10], 0.2)
	pad(s[5], at, dir, s[11], s[6], s[7], s[8], s[9])
end
table.insert(log, "stands ok")

-- [ COFFRE FREE EGG ] coffre doré du vault (general_chest_gold) + œuf du jeu dessus, sur un socle rond ------------
if run("chest") then
	local m = Instance.new("Model"); m.Name = "FreeChest"
	disc(m, "Base", 13, 0.7, 0, NAVY)
	disc(m, "Step", 11.4, 0.6, 0.7, Color3.fromRGB(233, 220, 190))
	disc(m, "Trim", 11.6, 0.12, 1.2, Color3.fromRGB(255, 197, 49))
	local c = V.Parent.general.general_chest_gold:Clone(); c.Name = "Chest"
	for _, d in ipairs(c:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = true end end
	c:ScaleTo(c:GetScale() * 1.9)
	bottomTo(c, Vector3.new(0, 1.3, 0))
	c.Parent = m
	-- un œuf du jeu posé sur le couvercle (choix de Hugo : option 4)
	local eggs = game.ReplicatedStorage.Assets:FindFirstChild("Eggs")
	local eggSrc = eggs and eggs:FindFirstChild("Beach")
	if eggSrc then
		local cf, cs = c:GetBoundingBox()
		local e = eggSrc:Clone(); e.Name = "Egg"
		for _, d in ipairs(e:GetDescendants()) do
			if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false end
			if d:IsA("LuaSourceContainer") then d:Destroy() end
		end
		local _, es = e:GetBoundingBox()
		e:ScaleTo(e:GetScale() * 5 / es.Y)
		bottomTo(e, Vector3.new(0, cf.Y + cs.Y / 2 - 0.4, 0))
		e.Parent = m
	end
	local body = nil
	for _, p in ipairs(c:GetDescendants()) do
		if p:IsA("BasePart") and (not body or p.Size.Magnitude > body.Size.Magnitude) then body = p end
	end
	local spark = Instance.new("ParticleEmitter"); spark.Name = "Sparkles"; spark.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	spark.Color = ColorSequence.new(Color3.fromRGB(255, 230, 120)); spark.LightEmission = 1; spark.Rate = 6
	spark.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0) })
	spark.Lifetime = NumberRange.new(0.8, 1.4); spark.Speed = NumberRange.new(1, 3); spark.SpreadAngle = Vector2.new(180, 180); spark.Parent = body
	local l = Instance.new("PointLight"); l.Color = Color3.fromRGB(255, 210, 110); l.Range = 16; l.Brightness = 1.3; l.Parent = body
	m.WorldPivot = CFrame.new(0, 0, 0)
	place(m, 52.7, 40, 0.2)
	local pp = Instance.new("ProximityPrompt"); pp.ActionText = "Open"; pp.ObjectText = "Free Egg Chest"; pp.HoldDuration = 0.4
	pp.MaxActivationDistance = 12; pp.RequiresLineOfSight = false; pp:SetAttribute("Action", "Chest"); pp.Parent = body
	billboard(anchorAbove(m, 0), "FREE EGG!", Color3.fromRGB(255, 225, 80), 2.5, "every 10 min")
	table.insert(log, "chest ok")
end

-- [ MACHINE REBIRTH + CLASSEMENTS ] : les anciens modèles (préférés), remis tels quels depuis ServerStorage.OldLobbyBackup
if run("old") then
	local bk = game.ServerStorage:FindFirstChild("OldLobbyBackup")
	for _, n in ipairs({ "RebirthMachine", "RebirthPad", "MoneyLeaderboard", "RebirthsLeaderboard" }) do
		local src = bk and bk:FindFirstChild(n)
		if src then src:Clone().Parent = H else table.insert(log, "!! " .. n .. " absent de OldLobbyBackup") end
	end
	table.insert(log, "rebirth/boards (anciens) ok")
end

-- [ ROUE DE LA FORTUNE ] : construite à part par tools/build_wheel.lua (roue low-poly faite main, 8 parts + icônes).

-- [ MACHINE DE FUSION ] (-17°) : Pet Machine (Rebirth Champions X, bibliothèque) ------------------------------------
if run("fusion") then
	local src = V:FindFirstChild("RebirthChampionsX_PetMachine")
	if src then
		local m = src:Clone(); m.Name = "FusionMachine"
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("LuaSourceContainer") or d:IsA("BillboardGui") or d:IsA("StringValue") then d:Destroy()
			elseif d:IsA("ParticleEmitter") then d.Enabled = false
			elseif d:IsA("BasePart") then d.Anchored = true; d.CanTouch = false end
		end
		scale(m, 0.75)
		local touch = m:FindFirstChild("Touch", true) :: BasePart?
		local cf = m:GetBoundingBox()
		local front = touch and (touch.Position - cf.Position) or Vector3.new(0, 0, 1)
		placeFront(m, front, -17, 41, 0.2)
		local core = touch or m:FindFirstChildWhichIsA("BasePart", true)
		prompt(core, "Fusion", "Open", "Brainrot Fusion", 14)
		billboard(anchorAbove(m, 0), "FUSION", Color3.fromRGB(215, 140, 255), 2.6, "3 same = better mutation")
		table.insert(log, "fusion ok")
	else
		table.insert(log, "!! modèle de fusion absent (Vault.lobby.RebirthChampionsX_PetMachine)")
	end
end

-- [ INCUBATEUR ] (+30°, près du spawn) : super éclosion de l'œuf en main ----------------------------------------
if run("incubator") then
	local m = clone("lobby_incubator", "Incubator")
	scale(m, 1.15)
	place(m, 30, 26, 0.3, SPAWN)
	local big = nil
	for _, p in ipairs(m:GetDescendants()) do
		if p:IsA("BasePart") and (not big or p.Size.Magnitude > big.Size.Magnitude) then big = p end
	end
	prompt(big, "Incubator", "Super Hatch", "Incubator", 12)
	billboard(anchorAbove(m, 0), "SUPER HATCH", Color3.fromRGB(120, 255, 170), 2.4, "x3 mutation luck!")
	table.insert(log, "incubator ok")
end

-- [ LAMPADAIRES ] aux entrées des 9 chemins (8 enclos + route des zones) ----------------------
if run("lamps") then
	local folder = Instance.new("Folder"); folder.Name = "Lamps"; folder.Parent = H
	local angles = { 0 }
	for _, p in ipairs(H.PenPaths:GetChildren()) do
		if p:IsA("BasePart") and p.Name == "Path" then table.insert(angles, math.deg(math.atan2(p.Position.X, p.Position.Z))) end
	end
	for _, a in ipairs(angles) do
		local radial = polar(a, 1)
		local side = Vector3.new(radial.Z, 0, -radial.X)
		for _, sgn in ipairs({ -1, 1 }) do
			local m = clone("lobby_lamp", "Lamp")
			local at = radial * 49.5 + side * sgn * 7
			local p = m:GetPivot().Position
			m:PivotTo(CFrame.new(p) * CFrame.Angles(0, math.atan2(-radial.X, -radial.Z), 0))
			bottomTo(m, at + Vector3.new(0, 0.2, 0))
			for _, b in ipairs(m:GetDescendants()) do
				if b:IsA("BasePart") and b.Material == Enum.Material.Neon then
					local l = Instance.new("PointLight"); l.Color = Color3.fromRGB(255, 220, 140); l.Range = 9; l.Brightness = 0.35; l.Shadows = false; l.Parent = b
				end
			end
			m.Parent = folder
		end
	end
	table.insert(log, "lamps ok (" .. #angles .. " chemins)")
end

-- [ PANNEAU HOW TO PLAY ] près du spawn, tourné vers le spawn --------------------------
if run("info") then
	local m = clone("lobby_info", "HowToPlay")
	place(m, -30, 26, 0.3, SPAWN)
	local panel = findPart(m, function(p) return math.abs(p.Size.X - 14) < 0.3 and math.abs(p.Size.Y - 9.4) < 0.3 end)
	if panel then
		local sg = surface(panel, Enum.NormalId.Back, 40); sg.Name = "InfoGui"
		local bg = Instance.new("Frame"); bg.Size = UDim2.fromScale(1, 1); bg.BackgroundColor3 = Color3.fromRGB(40, 62, 54); bg.Parent = sg
		local st = Instance.new("UIStroke"); st.Thickness = 10; st.Color = Color3.fromRGB(201, 139, 79); st.Parent = bg
		label(bg, "Title", "HOW TO PLAY", P(0.05, 0.04), P(0.9, 0.2), Color3.fromRGB(255, 220, 80), nil, 4)
		local steps = {
			"1. Rake the zones to find items & eggs",
			"2. Sell your bag at the SELL stand",
			"3. Hatch eggs, put brainrots in your pen",
			"4. Rebirth to unlock new zones!",
		}
		for i, t in ipairs(steps) do
			label(bg, "Step" .. i, t, P(0.06, 0.27 + (i - 1) * 0.17), P(0.88, 0.14), Color3.fromRGB(245, 240, 225), Enum.TextXAlignment.Left, 3)
		end
	end
	table.insert(log, "info ok")
end

for n, cf in pairs(KEEP) do
	local o = H:FindFirstChild(n)
	if o and (o:IsA("Model") or o:IsA("BasePart")) then o:PivotTo(cf) end
end
return table.concat(log, " | ")
