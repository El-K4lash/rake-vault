-- tools/build_fusion.lua : menu "Fusion" (machine de fusion du lobby) dans StarterGui.GUI.Frames + carte "FusionTemplate"
-- dans GUI.Templates, au style K4 des autres menus. À lancer UNE fois dans Studio (Edit).
local SG = game:GetService("StarterGui")
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
local function A(id) return "rbxassetid://" .. tostring(id) end

local K = {
	bgWide = 75109179445868, bg142 = 88161804514908, bg111 = 125192170525130, bg095 = 115755374758946, bg075 = 140424642875537,
	hBlue = 112249404449276, hPurple = 76850939570356, hOrange = 73937030672143, hLime = 129392840226910, hOrange2 = 128952100773355,
	close = 77317040960880,
	rowGreen = 110428657945327, rowBlue = 91846497745427, rowBrown = 73242668214006, rowPurple = 130643378669225, rowBlue2 = 73890163145756,
	rowLong = { green = 94257717489472, blue = 123473196299883, brown = 121813519417734, orange = 90197520262450, magenta = 72255201982128 },
	btnGreen = 72484859487238, btnOrange = 130202638558172, btnBuy = 110981870724664, btnRobux = 138368770576756,
	btnCyan = 72950720650768, btnGreen2 = 95125443680380, btnCash = 107626190343734, btnStripe = 107377020050831,
	btnLime = 118147684330981, btnRed = 139238474736040, btnBlue = 105496683105089,
	boxYellow = 109714672458221, boxLime = 103832055405761,
	hudSquare = 127062449162498, vipSquare = 73646313229415, sqOrange = 131912983081579, sqGray = 121880105502151, sqWhite = 71327065275858,
	grayBar = 103553873357333, barEmpty = 118459934312421, barFill = 110388958961942, barEmpty2 = 96609316302461, barFill2 = 99777151495325,
	iBook = 134306875683469, iBasket = 110119422421461, iRebirth = 102040339566414, iRebirth2 = 119924897613084, iQuest = 102082573689395,
	iGift = 112101874744840, iCrown = 94666332436790, iCrown2 = 81195562015915, iRobux = 104564734060803, iFF = 125369529148044,
	iTicket = 87314586435237, iShoe = 85473564227225, iPin = 134323598185216, iMoney = 103944045008759, iStar = 81193001619814,
	iCheck = 117205930478474, iEgg = 140583595805309, iGold = 101528102752924, iDiamond = 104968358501342, iLava = 130878989653652,
	iRainbow = 106520912211290, iPaw = 101341556251840,
}

-- [ briques ] ---------------------------------------------------------------
local function ratio(parent, r)
	local c = Instance.new("UIAspectRatioConstraint"); c.AspectRatio = r; c.Parent = parent; return c
end
local function frame(parent, name, pos, size)
	local f = Instance.new("Frame"); f.Name = name; f.BackgroundTransparency = 1; f.BorderSizePixel = 0
	f.Position = pos or UDim2.new(); f.Size = size or UDim2.fromScale(1, 1); f.Parent = parent; return f
end
local function img(parent, name, id, pos, size, r)
	local i = Instance.new("ImageLabel"); i.Name = name; i.BackgroundTransparency = 1; i.Image = A(id)
	i.Position = pos or UDim2.new(); i.Size = size or UDim2.fromScale(1, 1); i.Parent = parent
	if r then ratio(i, r) end
	return i
end
local function btn(parent, name, id, pos, size, r)
	local b = Instance.new("ImageButton"); b.Name = name; b.BackgroundTransparency = 1; b.Image = A(id); b.AutoButtonColor = false
	b.Position = pos or UDim2.new(); b.Size = size or UDim2.fromScale(1, 1); b.Parent = parent
	if r then ratio(b, r) end
	local s = Instance.new("UIScale"); s.Name = "Pop"; s.Parent = b
	return b
end
local function txt(parent, name, text, pos, size, color, xa, stroke)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Text = text
	t.Position = pos or UDim2.new(); t.Size = size or UDim2.fromScale(1, 1)
	t.FontFace = FONT; t.TextScaled = true; t.TextWrapped = true; t.TextColor3 = color or Color3.new(1, 1, 1)
	t.TextXAlignment = xa or Enum.TextXAlignment.Center; t.Parent = parent
	local s = Instance.new("UIStroke"); s.Name = "Stroke"; s.Color = Color3.new(0, 0, 0); s.LineJoinMode = Enum.LineJoinMode.Round
	local ok = pcall(function() s.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize end)
	s.Thickness = ok and (stroke or 0.12) or 2.5
	s.Parent = t
	return t
end
local function P(x, y) return UDim2.fromScale(x, y) end
local function corner(o, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(r or 0.2, 0); c.Parent = o; return c end

-- fenêtre du kit : en-tête coloré + icône + titre, fond sombre, bouton fermer rose
-- renvoie la fenêtre et une fonction B(x,y,w,h) qui place dans la zone de contenu
local function window(parent, name, o)
	local r = o.r
	local w = Instance.new("Frame"); w.Name = name; w.BackgroundTransparency = 1; w.AnchorPoint = Vector2.new(0.5, 0.5)
	w.Position = P(0.5, o.y or 0.49); w.Size = P(o.close == false and 0.92 or 0.72, o.h or 0.68); w.Visible = false; w.Parent = parent -- 0.72 : ne recouvre pas les boutons du HUD
	local c = ratio(w, r); c.AspectType = Enum.AspectType.FitWithinMaxSize
	local hh = math.min(0.2, r / 5.64)          -- hauteur de l'en-tête (fraction de la fenêtre)
	local hw = math.min(1, hh * 5.64 / r)        -- largeur de l'en-tête
	local top = hh * 0.82
	local bgTop = hh * 0.45 -- le fond passe derrière l'en-tête
	local bg = img(w, "Background", o.bg or K.bg142, P(0, bgTop), P(1, 1 - bgTop))
	bg.ScaleType = Enum.ScaleType.Stretch
	local backing = frame(w, "Backing", bg.Position + UDim2.fromOffset(4, 4), bg.Size - UDim2.fromOffset(8, 8))
	backing.BackgroundTransparency = 0; backing.BackgroundColor3 = Color3.fromRGB(28, 34, 58); backing.ZIndex = 0
	corner(backing, 0); (backing:FindFirstChildOfClass("UICorner") :: UICorner).CornerRadius = UDim.new(0, 10)
	-- comme dans le kit K4 : en-tête sur toute la largeur (étiré), la croix posée dessus à droite
	local head = img(w, "Header", o.header, P(0, 0), P(1, hh))
	head.ScaleType = Enum.ScaleType.Stretch
	head.ZIndex = 3
	local ic = img(head, "Icon", o.icon, P(0.018 * hw, 0.06), P(0.17 * hw, 0.88), 1); ic.ZIndex = 4
	local tt = txt(head, "Title", o.title, P(0.19 * hw, 0.24), P(0.62 * hw, 0.52), nil, Enum.TextXAlignment.Left); tt.ZIndex = 4
	if o.close ~= false then
		local cl = btn(w, "Close", K.close, P(0.985, hh * 0.06), UDim2.new(hh * 0.88 * 0.916 / r, 0, hh * 0.88, 0))
		cl.AnchorPoint = Vector2.new(1, 0); cl.ZIndex = 6
		local x = txt(cl, "X", "X", P(0.2, 0.14), P(0.6, 0.66)); x.ZIndex = 7
	end
	local bx, by, bw, bh = 0.035, top + 0.045, 0.93, 1 - top - 0.085
	local function B(x, y, ww, hh2) return P(bx + x * bw, by + y * bh), P(ww * bw, hh2 * bh) end
	return w, B
end


-- [ FUSION ] ----------------------------------------------------------------------
local gui = SG:WaitForChild("GUI")
local frames = gui:WaitForChild("Frames")
local templates = gui:WaitForChild("Templates")
for _, o in ipairs({ frames:FindFirstChild("Fusion"), templates:FindFirstChild("FusionTemplate") }) do if o then o:Destroy() end end
local w, B = window(frames, "Fusion", { r = 1.55, h = 0.76, title = "BRAINROT FUSION", header = K.hPurple, icon = K.iDiamond, bg = K.bg142 })
-- icône de l'en-tête = la vraie machine de fusion du lobby, en 3D (ViewportFrame figée, pas de script)
do
	local head = w:FindFirstChild("Header")
	local oldIcon = head and head:FindFirstChild("Icon")
	local machine = workspace.Map.Hub:FindFirstChild("FusionMachine")
	if oldIcon and machine then
		local vp = Instance.new("ViewportFrame"); vp.Name = "Icon"; vp.BackgroundTransparency = 1
		vp.Position = oldIcon.Position - UDim2.fromScale(0.01, 0.12); vp.Size = UDim2.fromScale(oldIcon.Size.X.Scale * 1.25, 1.2)
		vp.ZIndex = oldIcon.ZIndex; vp.Ambient = Color3.fromRGB(200, 200, 210); vp.LightColor = Color3.new(1, 1, 1); vp.LightDirection = Vector3.new(-0.4, -1, -0.6)
		local ar = Instance.new("UIAspectRatioConstraint"); ar.AspectRatio = 1; ar.Parent = vp
		local world = Instance.new("WorldModel"); world.Parent = vp
		local m = machine:Clone()
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("ProximityPrompt") or d:IsA("BillboardGui") or d:IsA("ParticleEmitter") or d:IsA("PointLight") or d:IsA("LuaSourceContainer") then d:Destroy() end
		end
		local cf, size = m:GetBoundingBox()
		m:PivotTo(CFrame.new() * (cf:Inverse() * m:GetPivot()))
		m.Parent = world
		local touch = m:FindFirstChild("Touch", true)
		local dir = touch and Vector3.new(touch.Position.X, 0, touch.Position.Z).Unit or Vector3.new(0, 0, 1)
		local cam = Instance.new("Camera"); cam.FieldOfView = 30
		local dist = math.max(size.X, size.Y, size.Z) * 2.1
		cam.CFrame = CFrame.lookAt(dir * dist + Vector3.new(0, dist * 0.45, 0) + dir:Cross(Vector3.yAxis) * dist * 0.35, Vector3.new(0, -size.Y * 0.05, 0))
		cam.Parent = vp; vp.CurrentCamera = cam
		vp.Parent = head
		oldIcon:Destroy()
	end
end

-- gauche : mes brainrots groupés (nom + mutation), avec le nombre
local p, s = B(0, 0, 0.58, 0.075)
txt(w, "ListTitle", "YOUR BRAINROTS", p, s, Color3.fromRGB(235, 225, 255), Enum.TextXAlignment.Left).ZIndex = 2
p, s = B(0, 0.085, 0.58, 0.915)
local list = Instance.new("ScrollingFrame"); list.Name = "List"; list.Position = p; list.Size = s
list.BackgroundTransparency = 0.35; list.BackgroundColor3 = Color3.fromRGB(18, 22, 40); list.BorderSizePixel = 0
list.ScrollBarThickness = 6; list.ScrollBarImageColor3 = Color3.new(1, 1, 1); list.CanvasSize = UDim2.new()
list.AutomaticCanvasSize = Enum.AutomaticSize.Y; list.ScrollingDirection = Enum.ScrollingDirection.Y; list.ZIndex = 2; list.Parent = w
corner(list, 0); (list:FindFirstChildOfClass("UICorner") :: UICorner).CornerRadius = UDim.new(0, 10)
local g = Instance.new("UIGridLayout"); g.CellSize = UDim2.new(0.31, 0, 0, 132); g.CellPadding = UDim2.new(0.02, 0, 0, 8)
g.SortOrder = Enum.SortOrder.LayoutOrder; g.HorizontalAlignment = Enum.HorizontalAlignment.Center; g.Parent = list
local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0, 8); pad.PaddingBottom = UDim.new(0, 8); pad.Parent = list
local empty = txt(list, "Empty", "No brainrots yet! Rake the zones and hatch eggs.", P(0.05, 0.4), P(0.9, 0.12), Color3.fromRGB(200, 190, 230))
empty.ZIndex = 3; empty.Visible = false
-- (le texte "Empty" est hors grille : on le sort du layout)
empty.Parent = w; empty.Position = p + UDim2.fromScale(0.05 * s.X.Scale, 0.4 * s.Y.Scale); empty.Size = UDim2.fromScale(s.X.Scale * 0.9, s.Y.Scale * 0.12)

-- droite : 3 emplacements -> flèche -> résultat, puis bouton FUSE
local right = frame(w, "Panel", B(0.61, 0, 0.39, 1))
right.ZIndex = 2
local slots = frame(right, "Slots", P(0, 0.02), P(1, 0.22))
for i = 1, 3 do
	local sl = img(slots, "Slot" .. i, K.sqWhite, P((i - 1) * 0.34, 0), P(0.32, 1)); sl.ScaleType = Enum.ScaleType.Stretch
	sl.ImageColor3 = Color3.fromRGB(70, 74, 110); sl.ZIndex = 3
	local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1; vp.Position = P(0.08, 0.08); vp.Size = P(0.84, 0.84)
	vp.ZIndex = 4; vp.Parent = sl
	local q = txt(sl, "Q", "+", P(0.3, 0.2), P(0.4, 0.6), Color3.fromRGB(200, 200, 230)); q.ZIndex = 5
	-- clic sur un emplacement rempli = on le vide
	local cb = Instance.new("TextButton"); cb.Name = "Click"; cb.BackgroundTransparency = 1; cb.Text = ""; cb.Size = P(1, 1); cb.ZIndex = 8; cb.Parent = sl
	local x = txt(sl, "Remove", "X", P(0.72, 0.02), P(0.26, 0.26), Color3.fromRGB(255, 110, 110)); x.ZIndex = 7; x.Visible = false
end
local arrow = txt(right, "Arrow", "▼", P(0.4, 0.25), P(0.2, 0.09), Color3.fromRGB(255, 220, 80)); arrow.ZIndex = 3
local res = img(right, "Result", K.sqWhite, P(0.22, 0.35), P(0.56, 0.36)); res.ScaleType = Enum.ScaleType.Stretch
res.ImageColor3 = Color3.fromRGB(120, 70, 200); res.ZIndex = 3
local rs = Instance.new("UIStroke"); rs.Thickness = 3; rs.Color = Color3.fromRGB(255, 220, 80); rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; rs.Parent = res
local rvp = Instance.new("ViewportFrame"); rvp.Name = "View"; rvp.BackgroundTransparency = 1; rvp.Position = P(0.1, 0.16); rvp.Size = P(0.8, 0.62); rvp.ZIndex = 4; rvp.Parent = res
local rtag = frame(res, "Tag", P(0.1, 0.03), P(0.8, 0.13)); rtag.BackgroundTransparency = 0; rtag.BackgroundColor3 = Color3.fromRGB(255, 204, 51); rtag.ZIndex = 5
corner(rtag, 0.4)
txt(rtag, "Text", "GOLD", P(0.05, 0.08), P(0.9, 0.84)).ZIndex = 6
local rq = txt(res, "Mystery", "?", P(0.25, 0.2), P(0.5, 0.52), Color3.fromRGB(255, 220, 80)); rq.ZIndex = 5; rq.Visible = false
txt(res, "Name", "Pick 3 brainrots", P(0.05, 0.78), P(0.9, 0.11)).ZIndex = 5
txt(res, "Income", "", P(0.1, 0.88), P(0.8, 0.1), Color3.fromRGB(120, 255, 140)).ZIndex = 5
local info = txt(right, "Info", "3 identical = better mutation (100%). 3 different = random brainrot, maybe rarer!", P(0.02, 0.73), P(0.96, 0.11), Color3.fromRGB(225, 215, 255))
info.ZIndex = 3
local fb = btn(right, "FuseButton", K.btnGreen, P(0.12, 0.86), P(0.76, 0.13)); fb.ScaleType = Enum.ScaleType.Stretch; fb.ZIndex = 3
fb:SetAttribute("On", A(K.btnGreen)); fb:SetAttribute("Off", A(K.btnRed))
txt(fb, "Text", "FUSE!", P(0.1, 0.14), P(0.8, 0.72)).ZIndex = 4

-- carte d'un groupe de brainrots (clonée par Client/FusionController)
local c = img(templates, "FusionTemplate", K.sqWhite, nil, UDim2.fromOffset(120, 132)); c.ScaleType = Enum.ScaleType.Stretch
c.ImageColor3 = Color3.fromRGB(64, 70, 104); c.Visible = false
local cb = Instance.new("TextButton"); cb.Name = "Click"; cb.BackgroundTransparency = 1; cb.Text = ""; cb.Size = P(1, 1); cb.ZIndex = 8; cb.Parent = c
local sel = Instance.new("UIStroke"); sel.Name = "Selected"; sel.Thickness = 3; sel.Color = Color3.fromRGB(255, 220, 80); sel.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sel.Enabled = false; sel.Parent = c
local tag = frame(c, "Tag", P(0.08, 0.04), P(0.84, 0.13)); tag.BackgroundTransparency = 0; tag.BackgroundColor3 = Color3.fromRGB(230, 230, 240); tag.ZIndex = 3
corner(tag, 0.4)
txt(tag, "Text", "NORMAL", P(0.05, 0.08), P(0.9, 0.84)).ZIndex = 4
local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1; vp.Position = P(0.1, 0.18); vp.Size = P(0.8, 0.5); vp.ZIndex = 3; vp.Parent = c
txt(c, "Name", "Name", P(0.05, 0.69), P(0.9, 0.14)).ZIndex = 4
local cnt = txt(c, "Count", "x1", P(0.55, 0.84), P(0.4, 0.13), Color3.fromRGB(255, 220, 80), Enum.TextXAlignment.Right); cnt.ZIndex = 4
local ok = txt(c, "Ready", "READY", P(0.05, 0.84), P(0.45, 0.13), Color3.fromRGB(120, 255, 140), Enum.TextXAlignment.Left); ok.ZIndex = 4
return "Fusion ok"
