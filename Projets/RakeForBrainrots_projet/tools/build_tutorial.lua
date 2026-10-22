-- tools/build_tutorial.lua : tutoriel des nouveaux joueurs, au style K4 du jeu. À lancer UNE fois dans Studio (Edit).
-- Vraies instances dans StarterGui.Tutorial ; Client/TutorialController ne fait que remplir / animer / afficher.
--   Welcome  : fenêtre d'accueil (mascotte 3D, 3 atouts du jeu, START / SKIP)
--   Card     : carte d'étape en haut de l'écran (icône, STEP x / 7, titre, consigne, barre de progression, NEXT, fermer)
--   Pointer  : épingle K4 qui rebondit + anneau lumineux autour du bouton à toucher
--   Done     : fenêtre de fin (récompense, confettis, LET'S GO!)
--   Templates.Marker : panneau 3D (BillboardGui) posé sur l'objectif dans le monde
local SG = game:GetService("StarterGui")
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
local function A(id) return "rbxassetid://" .. tostring(id) end

local K = {
	bg142 = 88161804514908, bg111 = 125192170525130, bg095 = 115755374758946, bg075 = 140424642875537,
	hLime = 129392840226910, hOrange = 73937030672143, hBlue = 112249404449276,
	close = 77317040960880,
	btnGreen = 72484859487238, btnRed = 139238474736040, btnOrange = 130202638558172,
	boxYellow = 109714672458221, sqOrange = 131912983081579, sqWhite = 71327065275858,
	iStar = 81193001619814, iCrown = 94666332436790, iMoney = 103944045008759, iEgg = 140583595805309, iRebirth = 102040339566414,
	iPin = 134323598185216,
}

-- [ briques ] ---------------------------------------------------------------
local function P(x, y) return UDim2.fromScale(x, y) end
local function ratio(parent, r)
	local c = Instance.new("UIAspectRatioConstraint"); c.AspectRatio = r; c.Parent = parent; return c
end
local function corner(o, r) local c = Instance.new("UICorner"); c.CornerRadius = r or UDim.new(0.2, 0); c.Parent = o; return c end
local function frame(parent, name, pos, size)
	local f = Instance.new("Frame"); f.Name = name; f.BackgroundTransparency = 1; f.BorderSizePixel = 0
	f.Position = pos or UDim2.new(); f.Size = size or P(1, 1); f.Parent = parent; return f
end
local function img(parent, name, id, pos, size, r)
	local i = Instance.new("ImageLabel"); i.Name = name; i.BackgroundTransparency = 1; i.Image = A(id)
	i.Position = pos or UDim2.new(); i.Size = size or P(1, 1); i.Parent = parent
	if r then ratio(i, r) end
	return i
end
local function btn(parent, name, id, pos, size, r)
	local b = Instance.new("ImageButton"); b.Name = name; b.BackgroundTransparency = 1; b.Image = A(id); b.AutoButtonColor = false
	b.Position = pos or UDim2.new(); b.Size = size or P(1, 1); b.Parent = parent
	if r then ratio(b, r) end
	local s = Instance.new("UIScale"); s.Name = "Pop"; s.Parent = b
	return b
end
local function txt(parent, name, text, pos, size, color, xa, stroke)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Text = text
	t.Position = pos or UDim2.new(); t.Size = size or P(1, 1)
	t.FontFace = FONT; t.TextScaled = true; t.TextWrapped = true; t.TextColor3 = color or Color3.new(1, 1, 1)
	t.TextXAlignment = xa or Enum.TextXAlignment.Center; t.Parent = parent
	local s = Instance.new("UIStroke"); s.Name = "Stroke"; s.Color = Color3.new(0, 0, 0); s.LineJoinMode = Enum.LineJoinMode.Round
	local ok = pcall(function() s.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize end)
	s.Thickness = ok and (stroke or 0.12) or 2.5
	s.Parent = t
	return t
end

-- fenêtre du kit K4 (même construction que les autres menus)
local function window(parent, name, o)
	local r = o.r
	local w = Instance.new("Frame"); w.Name = name; w.BackgroundTransparency = 1; w.AnchorPoint = Vector2.new(0.5, 0.5)
	w.Position = P(0.5, o.y or 0.5); w.Size = P(0.8, o.h or 0.66); w.Visible = false; w.ZIndex = 2; w.Parent = parent
	local c = ratio(w, r); c.AspectType = Enum.AspectType.FitWithinMaxSize
	local hh = math.min(0.2, r / 5.64)
	local hw = math.min(1, hh * 5.64 / r)
	local top = hh * 0.82
	local bgTop = hh * 0.45
	local bg = img(w, "Background", o.bg or K.bg142, P(0, bgTop), P(1, 1 - bgTop))
	bg.ScaleType = Enum.ScaleType.Stretch
	local backing = frame(w, "Backing", bg.Position + UDim2.fromOffset(4, 4), bg.Size - UDim2.fromOffset(8, 8))
	backing.BackgroundTransparency = 0; backing.BackgroundColor3 = Color3.fromRGB(28, 34, 58); backing.ZIndex = 0
	corner(backing, UDim.new(0, 10))
	local head = img(w, "Header", o.header, P(0, 0), P(1, hh))
	head.ScaleType = Enum.ScaleType.Stretch; head.ZIndex = 3
	local ic = img(head, "Icon", o.icon, P(0.018 * hw, 0.06), P(0.17 * hw, 0.88), 1); ic.ZIndex = 4
	local tt = txt(head, "Title", o.title, P(0.19 * hw, 0.24), P(0.7 * hw, 0.52), nil, Enum.TextXAlignment.Left); tt.ZIndex = 4
	local sc = Instance.new("UIScale"); sc.Name = "Pop"; sc.Parent = w
	local bx, by, bw, bh = 0.04, top + 0.06, 0.92, 1 - top - 0.11
	local function B(x, y, ww, hh2) return P(bx + x * bw, by + y * bh), P(ww * bw, hh2 * bh) end
	return w, B
end

local function button(parent, name, id, text, pos, size, r)
	local b = btn(parent, name, id, pos, size, r); b.ZIndex = 4
	local t = txt(b, "Text", text, P(0.08, 0.18), P(0.84, 0.6)); t.ZIndex = 5
	return b
end

-- [ ÉCRAN ] -------------------------------------------------------------------
local old = SG:FindFirstChild("Tutorial"); if old then old:Destroy() end
local gui = Instance.new("ScreenGui"); gui.Name = "Tutorial"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 15; gui.Enabled = true

local dim = frame(gui, "Dim"); dim.BackgroundTransparency = 0.45; dim.BackgroundColor3 = Color3.fromRGB(8, 10, 24); dim.Visible = false; dim.ZIndex = 1

-- [ WELCOME ] -----------------------------------------------------------------
do
	local w, B = window(gui, "Welcome", { r = 1.5, h = 0.66, title = "WELCOME!", header = K.hLime, icon = K.iStar })
	-- mascotte 3D sur un fond rayonnant
	local p, s = B(0, 0, 0.36, 0.78)
	-- fond rayonnant (CanvasGroup : les rayons tournés restent coupés aux bords arrondis)
	local box = Instance.new("CanvasGroup"); box.Name = "MascotBox"; box.Position = p; box.Size = s; box.ZIndex = 3
	box.BackgroundColor3 = Color3.new(1, 1, 1); box.BackgroundTransparency = 0; box.Parent = w
	corner(box, UDim.new(0.08, 0))
	local bg = Instance.new("UIGradient"); bg.Rotation = 90
	bg.Color = ColorSequence.new(Color3.fromRGB(255, 214, 74), Color3.fromRGB(255, 140, 40)); bg.Parent = box
	local rays = frame(box, "Rays", P(0.5, 0.5), P(1.8, 1.8)); rays.AnchorPoint = Vector2.new(0.5, 0.5); rays.ZIndex = 3
	ratio(rays, 1)
	for i = 0, 7 do
		local ray = frame(rays, "Ray" .. i, P(0.5, 0.5), P(0.1, 1)); ray.AnchorPoint = Vector2.new(0.5, 0.5)
		ray.BackgroundTransparency = 0.72; ray.BackgroundColor3 = Color3.new(1, 1, 1); ray.Rotation = i * 22.5; ray.ZIndex = 3
	end
	local frameStroke = frame(w, "MascotFrame", p, s); frameStroke.ZIndex = 5
	corner(frameStroke, UDim.new(0.08, 0))
	local fs = Instance.new("UIStroke"); fs.Thickness = 3; fs.Color = Color3.fromRGB(30, 20, 10); fs.Parent = frameStroke
	-- (ViewportFrame hors du CanvasGroup : elle ne s'y affiche pas)
	local vp = Instance.new("ViewportFrame"); vp.Name = "Mascot"; vp.BackgroundTransparency = 1; vp.Position = p; vp.Size = s
	vp.ZIndex = 4; vp.Ambient = Color3.fromRGB(210, 210, 220); vp.LightColor = Color3.new(1, 1, 1); vp.Parent = w
	local game_ = txt(w, "GameName", "RAKE FOR BRAINROTS", B(0.39, 0.0, 0.61, 0.15)); game_.TextColor3 = Color3.fromRGB(255, 214, 74); game_.ZIndex = 4
	game_.TextXAlignment = Enum.TextXAlignment.Left
	local pB, sB = B(0.39, 0.17, 0.61, 0.3)
	local body = txt(w, "Body", "Rake the zones, sell your loot and fill your pen with rare brainrots that earn money for you!",
		pB, sB, Color3.fromRGB(235, 240, 255), Enum.TextXAlignment.Left, 0.08)
	body.ZIndex = 4
	-- trois atouts : cases du kit K4 (comme les boutons du HUD) : carré coloré, icône, nom en bas
	local pF, sF = B(0.39, 0.47, 0.61, 0.3)
	local feats = frame(w, "Features", pF, sF); feats.ZIndex = 4
	local items = {
		{ K.iMoney, "SELL", K.sqOrange, Color3.new(1, 1, 1) },
		{ K.iEgg, "HATCH", K.sqWhite, Color3.fromRGB(90, 170, 255) },
		{ K.iRebirth, "REBIRTH", K.sqWhite, Color3.fromRGB(190, 110, 255) },
	}
	for i, it in ipairs(items) do
		local tile = img(feats, "Tile" .. i, it[3], P((i - 1) * 0.345, 0), P(0.31, 1)); tile.ZIndex = 4
		tile.ScaleType = Enum.ScaleType.Stretch; tile.ImageColor3 = it[4]
		local c = ratio(tile, 1); c.AspectType = Enum.AspectType.FitWithinMaxSize
		local ic = img(tile, "Icon", it[1], P(0.5, 0.08), P(0.72, 0.72), 1); ic.AnchorPoint = Vector2.new(0.5, 0); ic.ZIndex = 5
		local t = txt(tile, "Text", it[2], P(-0.05, 0.7), P(1.1, 0.3)); t.ZIndex = 6
	end
	local pS, sS = B(0.39, 0.8, 0.4, 0.2)
	button(w, "Start", K.btnGreen, "START TUTORIAL", pS, sS)
	local pK, sK = B(0.81, 0.8, 0.19, 0.2)
	button(w, "Skip", K.btnRed, "SKIP", pK, sK)
end

-- [ CARD ] (étape en cours) -----------------------------------------------------
do
	-- à droite de l'écran, à mi-hauteur : ne gêne ni les boutons du haut (flèche) ni la hotbar
	local card = frame(gui, "Card", P(0.985, 0.3), P(0.36, 0.17)); card.AnchorPoint = Vector2.new(1, 0); card.Visible = false; card.ZIndex = 5
	local c = ratio(card, 4.1); c.AspectType = Enum.AspectType.FitWithinMaxSize
	local sc = Instance.new("UIScale"); sc.Name = "Pop"; sc.Parent = card
	local bg = img(card, "Background", K.bg095, P(0, 0), P(1, 1)); bg.ScaleType = Enum.ScaleType.Stretch; bg.ZIndex = 5
	local back = frame(card, "Backing", UDim2.fromOffset(4, 4), UDim2.new(1, -8, 1, -8)); back.BackgroundTransparency = 0
	back.BackgroundColor3 = Color3.fromRGB(28, 34, 58); back.ZIndex = 4; corner(back, UDim.new(0, 10))
	-- bandeau coloré à gauche + icône de l'étape
	local iconBox = img(card, "IconBox", K.sqOrange, P(0.022, 0.12), P(0.2, 0.76), 1); iconBox.ScaleType = Enum.ScaleType.Stretch; iconBox.ZIndex = 6
	local icon = img(iconBox, "Icon", K.iPin, P(0.14, 0.12), P(0.72, 0.72)); icon.ZIndex = 7
	local step = txt(card, "Step", "STEP 1 / 7", P(0.235, 0.09), P(0.34, 0.17), Color3.fromRGB(140, 210, 255), Enum.TextXAlignment.Left, 0.1); step.ZIndex = 6
	local title = txt(card, "Title", "EQUIP YOUR RAKE", P(0.235, 0.25), P(0.6, 0.26), Color3.fromRGB(255, 214, 74), Enum.TextXAlignment.Left); title.ZIndex = 6
	local body = txt(card, "Body", "Click your rake in the hotbar (or press 1).", P(0.235, 0.52), P(0.52, 0.22), Color3.fromRGB(235, 240, 255), Enum.TextXAlignment.Left, 0.08)
	body.ZIndex = 6
	-- barre de progression
	local bar = frame(card, "Bar", P(0.235, 0.78), P(0.52, 0.11)); bar.BackgroundTransparency = 0; bar.BackgroundColor3 = Color3.fromRGB(14, 18, 34); bar.ZIndex = 6
	corner(bar, UDim.new(1, 0)); local bs = Instance.new("UIStroke"); bs.Color = Color3.new(0, 0, 0); bs.Thickness = 2; bs.Parent = bar
	local fill = frame(bar, "Fill", P(0, 0), P(0.3, 1)); fill.BackgroundTransparency = 0; fill.BackgroundColor3 = Color3.new(1, 1, 1); fill.ZIndex = 7
	corner(fill, UDim.new(1, 0))
	local g = Instance.new("UIGradient"); g.Color = ColorSequence.new(Color3.fromRGB(120, 255, 110), Color3.fromRGB(40, 190, 90)); g.Rotation = 90; g.Parent = fill
	local shine = frame(fill, "Shine", P(0, 0.08), P(1, 0.35)); shine.BackgroundTransparency = 0.55; shine.BackgroundColor3 = Color3.new(1, 1, 1); shine.ZIndex = 8
	corner(shine, UDim.new(1, 0))
	local pt = txt(bar, "Text", "1 / 7", P(0, -0.15), P(1, 1.3), nil, nil, 0.14); pt.ZIndex = 9
	-- NEXT (étapes d'information) + coche quand l'étape est validée
	local nxt = button(card, "Next", K.btnGreen, "NEXT", P(0.78, 0.5), P(0.19, 0.34)); nxt.ZIndex = 6; nxt.Visible = false
	local check = frame(card, "Check", P(0.8, 0.14), P(0.16, 0.72)); check.ZIndex = 9; check.Visible = false
	ratio(check, 1)
	local cb = frame(check, "Bg", P(0, 0), P(1, 1)); cb.BackgroundTransparency = 0; cb.BackgroundColor3 = Color3.fromRGB(70, 210, 90); cb.ZIndex = 9
	corner(cb, UDim.new(1, 0)); local cs = Instance.new("UIStroke"); cs.Thickness = 3; cs.Color = Color3.new(0, 0, 0); cs.Parent = cb
	local ct = txt(check, "Text", "OK!", P(0.1, 0.25), P(0.8, 0.5)); ct.ZIndex = 10
	-- fermer (= passer le tutoriel)
	local cl = btn(card, "Close", K.close, P(1.01, -0.14), P(0.075, 0.34), 0.916); cl.AnchorPoint = Vector2.new(1, 0); cl.ZIndex = 9
	local x = txt(cl, "X", "X", P(0.2, 0.14), P(0.6, 0.66)); x.ZIndex = 10
end

-- [ POINTER ] (flèche + anneau autour d'un bouton) ------------------------------
do
	local ring = frame(gui, "Ring", P(0, 0), UDim2.fromOffset(80, 80)); ring.Visible = false; ring.ZIndex = 20
	corner(ring, UDim.new(0, 14))
	local rs = Instance.new("UIStroke"); rs.Name = "Stroke"; rs.Thickness = 4; rs.Color = Color3.fromRGB(255, 214, 74); rs.Parent = ring
	local rg = Instance.new("UIGradient"); rg.Color = ColorSequence.new(Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 160, 40)); rg.Parent = rs
	local glow = frame(ring, "Glow", P(0, 0), P(1, 1)); glow.BackgroundTransparency = 0.8; glow.BackgroundColor3 = Color3.fromRGB(255, 220, 100); glow.ZIndex = 20
	corner(glow, UDim.new(0, 14))

	-- pointeur : l'icône « épingle » du kit K4 (pointe vers le bas) ; tournée de 180° pour pointer vers le haut
	local pin = img(gui, "Pointer", K.iPin, P(0, 0), UDim2.fromOffset(96, 96)); pin.AnchorPoint = Vector2.new(0.5, 1)
	pin.Visible = false; pin.ZIndex = 21
end

-- [ DONE ] ---------------------------------------------------------------------
do
	local w, B = window(gui, "Done", { r = 1.6, h = 0.56, title = "TUTORIAL COMPLETE!", header = K.hOrange, icon = K.iCrown })
	local p, s = B(0.2, 0.0, 0.6, 0.36)
	local rew = img(w, "Reward", K.boxYellow, p, s); rew.ScaleType = Enum.ScaleType.Stretch; rew.ZIndex = 3
	local ic = img(rew, "Icon", K.iMoney, P(0.06, 0.1), P(0.3, 0.8), 1); ic.ZIndex = 4
	local amount = txt(rew, "Amount", "+$500", P(0.32, 0.16), P(0.62, 0.68), Color3.fromRGB(120, 255, 130)); amount.ZIndex = 4
	local pB, sB = B(0.04, 0.42, 0.92, 0.3)
	local body = txt(w, "Body", "You're ready! Rebirth to unlock the Swamp, the Volcano, the Ice and the Void.", pB, sB,
		Color3.fromRGB(235, 240, 255), nil, 0.08)
	body.ZIndex = 4
	local pG, sG = B(0.27, 0.78, 0.46, 0.22)
	button(w, "Go", K.btnGreen, "LET'S GO!", pG, sG)
	-- confettis (pièces fixes, animées par le contrôleur)
	local conf = frame(gui, "Confetti", P(0, 0), P(1, 1)); conf.ZIndex = 30; conf.Visible = false
	local cols = { Color3.fromRGB(255, 90, 120), Color3.fromRGB(255, 214, 74), Color3.fromRGB(110, 230, 120), Color3.fromRGB(110, 190, 255), Color3.fromRGB(190, 120, 255) }
	for i = 1, 36 do
		local c = frame(conf, "C" .. i, P((i - 1) / 36, -0.05), UDim2.fromOffset(12, 18)); c.BackgroundTransparency = 0
		c.BackgroundColor3 = cols[(i - 1) % #cols + 1]; c.ZIndex = 30
		corner(c, UDim.new(0.2, 0))
	end
end

-- [ TEMPLATES ] : panneau 3D posé sur l'objectif ----------------------------------
do
	local t = Instance.new("Folder"); t.Name = "Templates"; t.Parent = gui
	local bb = Instance.new("BillboardGui"); bb.Name = "Marker"; bb.Size = UDim2.fromOffset(230, 150); bb.AlwaysOnTop = true
	bb.LightInfluence = 0; bb.StudsOffsetWorldSpace = Vector3.new(0, 5, 0); bb.MaxDistance = 2000; bb.ResetOnSpawn = false
	bb.ClipsDescendants = false; bb.Enabled = false -- modèle éteint : sinon il s'affiche au centre de la map (0, 0, 0)
	bb.Parent = t
	local holder = frame(bb, "Holder", P(0, 0), P(1, 1))
	local label = txt(holder, "Label", "BEACH", P(0, 0), P(1, 0.3), Color3.fromRGB(255, 214, 74), nil, 0.14)
	local dist = txt(holder, "Dist", "24m", P(0.25, 0.29), P(0.5, 0.18), Color3.new(1, 1, 1), nil, 0.14)
	local pin = img(holder, "Icon", K.iPin, P(0.5, 0.48), P(0.36, 0.52), 1); pin.AnchorPoint = Vector2.new(0.5, 0)
	local _ = label; local _2 = dist
end

gui.Parent = SG
return "Tutorial ok " .. #gui:GetDescendants()
