-- gui_k4.lua : construit StarterGui.GUI dans le style du kit K4LSH (images du kit + textes Gotham ExtraBold contour noir).
-- À exécuter UNE fois dans la barre de commande de Studio (Edit). Les GUI restent de vraies instances dans StarterGui.
-- Les noms des enfants suivent ce qu'attendent les contrôleurs (Client/*Controller).
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

-- [ GUI ] -----------------------------------------------------------------------
local old = SG:FindFirstChild("GUI")
if old then
	local ss = game:GetService("ServerStorage")
	local prev = ss:FindFirstChild("GUI_Old"); if prev then prev:Destroy() end
	old.Name = "GUI_Old"; old.Enabled = false; old.Parent = ss
end
local gui = Instance.new("ScreenGui"); gui.Name = "GUI"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true

-- ===== HUD =====
local hud = frame(gui, "HUD")
-- boutons gauche (grille 2 colonnes, carrés du kit)
local left = frame(hud, "Left", P(0.01, 0.3), P(0.1, 0.4))
local grid = Instance.new("UIGridLayout"); grid.CellSize = P(0.47, 0.3); grid.CellPadding = P(0.06, 0.035)
grid.SortOrder = Enum.SortOrder.LayoutOrder; grid.Parent = left
ratio(grid, 0.98)
local function hudBtn(name, label, icon, order, square)
	local b = btn(left, name, square or K.hudSquare); b.LayoutOrder = order
	local i = img(b, "Icon", icon, P(0.1, 0.06), P(0.8, 0.8), 1); i.ZIndex = 2
	local t = txt(b, "Text", label, P(-0.05, 0.72), P(1.1, 0.32)); t.ZIndex = 3
	return b
end
hudBtn("Store", "Shop", K.iBasket, 1) -- ouvre la boutique Robux (le shop des améliorations est sur le stand SHOP)
hudBtn("Index", "Index", K.iBook, 2)
hudBtn("Base", "Base", K.iPaw, 3)
hudBtn("Rebirth", "Rebirth", K.iRebirth, 4)
hudBtn("Leaderboard", "Ranks", K.iCrown, 5, K.vipSquare)
hudBtn("Codes", "Codes", K.iTicket, 6)

-- compteurs en bas à gauche
local labels = frame(hud, "Labels", P(0.01, 0.74), P(0.22, 0.2))
local mb = img(labels, "MoneyBar", K.grayBar, P(0, 0), P(0.72, 0.5)); mb.ImageTransparency = 1
img(mb, "Icon", K.iMoney, P(0, -0.05), P(0.3, 1.1), 1).ZIndex = 2
local money = txt(labels, "Money", "$0", P(0.21, 0.02), P(0.75, 0.46), Color3.fromRGB(150, 255, 120), Enum.TextXAlignment.Left)
money.ZIndex = 3
local bagBar = img(labels, "BagBar", K.barEmpty2, P(0.02, 0.56), P(0.9, 0.2))
local fill = img(bagBar, "Fill", K.barFill2, P(0.012, 0.12), P(0.5, 0.76)); fill.ScaleType = Enum.ScaleType.Stretch; fill.ZIndex = 2
local bag = txt(labels, "Bag", "Bag 0 / 20", P(0.05, 0.545), P(0.84, 0.22)); bag.ZIndex = 3
txt(labels, "Rebirths", "Rebirths: 0", P(0.02, 0.8), P(0.5, 0.17), Color3.fromRGB(220, 180, 255), Enum.TextXAlignment.Left)

-- bouton Collect (bas centre)
local col = btn(hud, "Collect", K.btnGreen, P(0.5, 0.8), P(0.16, 0.08), 2.92)
col.AnchorPoint = Vector2.new(0.5, 0.5); col.Visible = false
txt(col, "Text", "Collect $0", P(0.08, 0.16), P(0.84, 0.66)).ZIndex = 2

-- raccourcis en haut au centre : BASE / SELL / ZONES (téléportations)
local quick = frame(hud, "Quick", P(0.5, 0.018), P(0.4, 0.07))
quick.AnchorPoint = Vector2.new(0.5, 0)
local ql = Instance.new("UIListLayout"); ql.FillDirection = Enum.FillDirection.Horizontal; ql.HorizontalAlignment = Enum.HorizontalAlignment.Center
ql.Padding = UDim.new(0.02, 0); ql.SortOrder = Enum.SortOrder.LayoutOrder; ql.Parent = quick
local function quickBtn(name, label, id, order)
	local b = btn(quick, name, id, nil, P(0.3, 1), 3.6); b.LayoutOrder = order
	txt(b, "Text", label, P(0.12, 0.12), P(0.76, 0.72)).ZIndex = 2
end
quickBtn("TpBase", "BASE", K.btnLime, 1)
quickBtn("TpSell", "SELL", K.btnRed, 2)
quickBtn("TpZone", "ZONES", K.btnBlue, 3)

-- ===== FRAMES =====
local frames = frame(gui, "Frames")
local templates = Instance.new("Folder"); templates.Name = "Templates"; templates.Parent = gui

-- ---------- SHOP ----------
do
	local w, B = window(frames, "Shop", { r = 1.12, h = 0.78, title = "SHOP", header = K.hBlue, icon = K.iBasket, bg = K.bg111 })
	local p, s = B(0, 0, 1, 1)
	local sc = Instance.new("ScrollingFrame"); sc.Name = "Scrolling"; sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0
	sc.Position = p; sc.Size = s; sc.ScrollBarThickness = 6; sc.CanvasSize = UDim2.new(); sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sc.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255); sc.Parent = w
	local l = Instance.new("UIListLayout"); l.Padding = UDim.new(0.015, 0); l.HorizontalAlignment = Enum.HorizontalAlignment.Center
	l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = sc
	local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0.01, 0); pad.PaddingBottom = UDim.new(0.02, 0); pad.Parent = sc
	local row = frame(sc, "UpgradesRow", nil, UDim2.new(0.96, 0, 0, 0)); row.AutomaticSize = Enum.AutomaticSize.Y; row.LayoutOrder = 2
	local rl = Instance.new("UIListLayout"); rl.Padding = UDim.new(0, 8); rl.SortOrder = Enum.SortOrder.LayoutOrder; rl.Parent = row
	local function card(name, bgId, order, iconBg)
		local c = img(row, name, bgId, nil, UDim2.new(1, 0, 0, 92)); c.LayoutOrder = order
		local ib = img(c, "IconBox", iconBg, P(0.02, 0.1), P(0.8, 0.8), 1); ib.SizeConstraint = Enum.SizeConstraint.RelativeYY
		local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1; vp.Position = P(0.06, 0.06); vp.Size = P(0.88, 0.88); vp.ZIndex = 2; vp.Parent = ib
		txt(c, "Amount", "...", P(0.27, 0.12), P(0.4, 0.34), nil, Enum.TextXAlignment.Left)
		txt(c, "Desc", "", P(0.27, 0.5), P(0.4, 0.22), Color3.fromRGB(230, 240, 255), Enum.TextXAlignment.Left)
		txt(c, "Level", "", P(0.27, 0.74), P(0.3, 0.16), Color3.fromRGB(255, 230, 120), Enum.TextXAlignment.Left)
		local b = btn(c, "Buy", K.btnBuy, P(0.69, 0.22), P(0.29, 0.56))
		ratio(b, 2.92)
		txt(b, "Label", "$0", P(0.1, 0.14), P(0.8, 0.7)).ZIndex = 2
		return c
	end
	card("RakeCard", K.rowBlue, 1, K.sqOrange)
	card("BagCard", K.rowBrown, 2, K.sqOrange)
	card("SlotCard", K.rowPurple, 3, K.sqOrange)
	local s1 = txt(sc, "Section_Upgrades", "UPGRADES", nil, UDim2.new(0.5, 0, 0, 30), Color3.fromRGB(255, 230, 120)); s1.LayoutOrder = 1
	local s2 = txt(sc, "Hint", "Better rake = more eggs · bigger bag = sell less often · more slots = bigger pen", nil, UDim2.new(0.9, 0, 0, 22), Color3.fromRGB(200, 220, 255)); s2.LayoutOrder = 3
	local s3 = txt(sc, "Section_Fences", "PEN FENCES", nil, UDim2.new(0.5, 0, 0, 30), Color3.fromRGB(255, 230, 120)); s3.LayoutOrder = 4
	local fr = frame(sc, "FencesRow", nil, UDim2.new(0.96, 0, 0, 0)); fr.AutomaticSize = Enum.AutomaticSize.Y; fr.LayoutOrder = 5
	local fg = Instance.new("UIGridLayout"); fg.CellSize = UDim2.new(0.235, 0, 0, 128); fg.CellPadding = UDim2.new(0.018, 0, 0, 8)
	fg.SortOrder = Enum.SortOrder.LayoutOrder; fg.Parent = fr
	local c = img(templates, "FenceTemplate", K.sqWhite, nil, UDim2.fromOffset(120, 154)); c.Visible = false
	c.ScaleType = Enum.ScaleType.Stretch; c.ImageColor3 = Color3.fromRGB(70, 74, 92)
	local sw = frame(c, "Swatch", P(0.12, 0.08), P(0.76, 0.42)); sw.BackgroundTransparency = 0; sw.BackgroundColor3 = Color3.fromRGB(150, 210, 110); sw.ZIndex = 2
	corner(sw, 0.18)
	local st = Instance.new("UIStroke"); st.Thickness = 2; st.Color = Color3.new(0, 0, 0); st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; st.Parent = sw
	for i = 0, 3 do
		local post = frame(sw, "Post" .. i, P(0.06 + i * 0.29, 0.12), P(0.07, 0.8)); post.BackgroundTransparency = 0; post.BackgroundColor3 = Color3.fromRGB(27, 42, 53); post.ZIndex = 4
	end
	for k, y in ipairs({ 0.25, 0.62 }) do
		local rail = frame(sw, "Rail" .. k, P(0.05, y), P(0.9, 0.1)); rail.BackgroundTransparency = 0; rail.BackgroundColor3 = Color3.fromRGB(160, 95, 53); rail.ZIndex = 3
	end
	txt(c, "Name", "Wood Fence", P(0.05, 0.53), P(0.9, 0.13)).ZIndex = 3
	local b = btn(c, "Buy", K.btnBuy, P(0.5, 0.82), P(0.84, 0.2)); b.AnchorPoint = Vector2.new(0.5, 0.5); b.ScaleType = Enum.ScaleType.Stretch; b.ZIndex = 3
	txt(b, "Label", "$0", P(0.08, 0.14), P(0.84, 0.72)).ZIndex = 4
end

-- ---------- CODES ----------
do
	local w, B = window(frames, "Codes", { r = 1.6, h = 0.5, title = "CODES", header = K.hPurple, icon = K.iTicket, bg = K.bg142 })
	local p, s = B(0.05, 0.02, 0.9, 0.22)
	txt(w, "Info", "Enter a code to get free rewards!", p, s, Color3.fromRGB(255, 230, 120))
	p, s = B(0.03, 0.32, 0.6, 0.3)
	local bar = img(w, "InputBar", K.grayBar, p, s); bar.ImageTransparency = 1; bar.BackgroundTransparency = 0; bar.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
	corner(bar, 0.25)
	local bs = Instance.new("UIStroke"); bs.Thickness = 3; bs.Color = Color3.fromRGB(20, 20, 30); bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; bs.Parent = bar
	local tb = Instance.new("TextBox"); tb.Name = "Input"; tb.BackgroundTransparency = 1; tb.FontFace = FONT; tb.TextScaled = true
	tb.PlaceholderText = "CODE HERE"; tb.PlaceholderColor3 = Color3.fromRGB(150, 150, 160); tb.Text = ""; tb.TextColor3 = Color3.fromRGB(40, 40, 50)
	tb.ClearTextOnFocus = false; tb.Position = P(0.08, 0.18); tb.Size = P(0.84, 0.64); tb.ZIndex = 2; tb.Parent = bar
	p, s = B(0.66, 0.3, 0.31, 0.34)
	local rd = btn(w, "Redeem", K.btnGreen, p, s)
	txt(rd, "Label", "REDEEM", P(0.1, 0.15), P(0.8, 0.68)).ZIndex = 2
	p, s = B(0.05, 0.74, 0.9, 0.18)
	txt(w, "Hint", "Follow the game for new codes!", p, s, Color3.fromRGB(200, 220, 255))
end

-- ---------- grilles Index / Base ----------
local function gridWindow(name, o)
	local w, B = window(frames, name, o)
	-- onglets à gauche
	local p, s = B(0, 0, 0.19, 1)
	local bt = frame(w, "Buttons", p, s)
	local bl = Instance.new("UIListLayout"); bl.Padding = UDim.new(#o.tabs > 5 and 0.018 or 0.025, 0); bl.SortOrder = Enum.SortOrder.LayoutOrder; bl.Parent = bt
	for i, t in ipairs(o.tabs) do
		local b = btn(bt, t[1], t[3], nil, P(1, #o.tabs > 5 and 0.122 or 0.16)); b.LayoutOrder = i
		b.ScaleType = Enum.ScaleType.Stretch
		local ic = img(b, "Icon", t[4], P(0.03, 0.08), P(0.3, 0.84), 1); ic.ZIndex = 2
		txt(b, "Text", t[2], P(0.3, 0.2), P(0.66, 0.6)).ZIndex = 2
	end
	-- barre de progression
	p, s = B(0.215, 0, 0.5, 0.085)
	local pr = img(w, "Progress", K.barEmpty2, p, s); pr.ScaleType = Enum.ScaleType.Stretch
	local f = img(pr, "Fill", K.barFill2, P(0.01, 0.12), P(0.5, 0.76)); f.ScaleType = Enum.ScaleType.Stretch; f.ZIndex = 2
	txt(pr, "Text", "0 / 0", P(0.05, 0.08), P(0.9, 0.84)).ZIndex = 3
	p, s = B(0.215, 0.095, 0.55, 0.06)
	txt(w, "Total", "", p, s, Color3.fromRGB(255, 220, 90), Enum.TextXAlignment.Left)
	-- bouton à droite (récompense / équiper)
	p, s = B(0.77, -0.01, 0.23, 0.165)
	local rw = btn(w, "IndexReward", o.rewardImg, p, s); rw.ScaleType = Enum.ScaleType.Stretch
	img(rw, "Icon", o.rewardIcon, P(0.03, 0.08), P(0.3, 0.84), 1).ZIndex = 2
	txt(rw, "Top", o.rewardTop, P(0.33, 0.12), P(0.64, 0.4)).ZIndex = 2
	txt(rw, "Label", o.rewardLabel, P(0.33, 0.52), P(0.64, 0.34), Color3.fromRGB(255, 255, 200)).ZIndex = 2
	-- grille
	p, s = B(0.215, 0.18, 0.785, 0.82)
	local sc = Instance.new("ScrollingFrame"); sc.Name = "Scrolling"; sc.BackgroundTransparency = 1; sc.BorderSizePixel = 0
	sc.Position = p; sc.Size = s; sc.ScrollBarThickness = 6; sc.CanvasSize = UDim2.new(); sc.AutomaticCanvasSize = Enum.AutomaticSize.Y; sc.Parent = w
	local gl = Instance.new("UIGridLayout"); gl.CellSize = UDim2.new(0.185, 0, 0, 146); gl.CellPadding = UDim2.new(0.018, 0, 0, 8)
	gl.SortOrder = Enum.SortOrder.LayoutOrder; gl.Parent = sc
	local pd = Instance.new("UIPadding"); pd.PaddingTop = UDim.new(0, 4); pd.PaddingLeft = UDim.new(0, 4); pd.Parent = sc
	return w
end

local function cardTemplate(name)
	local c = img(templates, name, K.sqWhite, nil, UDim2.fromOffset(120, 150)); c.Visible = false
	c.ScaleType = Enum.ScaleType.Stretch; c.ImageColor3 = Color3.fromRGB(70, 74, 92)
	local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1; vp.Position = P(0.1, 0.17); vp.Size = P(0.8, 0.42); vp.ZIndex = 2; vp.Parent = c
	local tag = frame(c, "Tag", P(0.1, 0.045), P(0.8, 0.12)); tag.BackgroundTransparency = 0; tag.BackgroundColor3 = Color3.fromRGB(176, 182, 196); tag.ZIndex = 3
	corner(tag, 0.4)
	local ts = Instance.new("UIStroke"); ts.Thickness = 1.5; ts.Color = Color3.new(0, 0, 0); ts.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; ts.Parent = tag
	txt(tag, "Text", "COMMON", P(0.05, 0.1), P(0.9, 0.8)).ZIndex = 4
	local q = txt(c, "Unknown", "?", P(0.3, 0.25), P(0.4, 0.35), Color3.fromRGB(230, 230, 240)); q.ZIndex = 3; q.Visible = false
	local bottom = frame(c, "Bottom", P(0.05, 0.72), P(0.9, 0.25))
	txt(bottom, "Name", "Name", P(0, 0), P(1, 0.55)).ZIndex = 3
	txt(bottom, "Income", "$0/s", P(0.1, 0.55), P(0.8, 0.42), Color3.fromRGB(150, 255, 120)).ZIndex = 3
	return c
end

do
	gridWindow("Index", { r = 1.55, h = 0.78, title = "INDEX", header = K.hOrange, icon = K.iBook, bg = K.bg142,
		tabs = { { "Normal", "NORMAL", K.btnGreen, K.iEgg }, { "Gold", "GOLD", K.btnOrange, K.iGold }, { "Diamond", "DIAMOND", K.btnCyan, K.iDiamond },
			{ "Lava", "LAVA", K.btnRed, K.iLava }, { "Galaxy", "GALAXY", K.btnBlue, K.iStar }, { "Rainbow", "RAINBOW", K.btnStripe, K.iRainbow },
			{ "Hacker", "HACKER", K.btnLime, K.iFF } },
		rewardImg = K.boxYellow, rewardIcon = K.iGift, rewardTop = "ZONE REWARD", rewardLabel = "+5% LUCK" })
	cardTemplate("IndexTemplate")
end

do
	gridWindow("Base", { r = 1.55, h = 0.78, title = "MY BASE", header = K.hLime, icon = K.iPaw, bg = K.bg142,
		tabs = { { "All", "ALL", K.btnGreen, K.iStar }, { "Equipped", "PLACED", K.btnCyan, K.iCheck }, { "Unequipped", "STORED", K.btnOrange, K.iPaw } },
		rewardImg = K.boxLime, rewardIcon = K.iStar, rewardTop = "EQUIP BEST", rewardLabel = "best in slots" })
	local c = cardTemplate("BaseTemplate")
	local click = Instance.new("TextButton"); click.Name = "Click"; click.BackgroundTransparency = 1; click.Text = ""; click.Size = P(1, 0.7); click.ZIndex = 5; click.Parent = c
	local sell = btn(c, "Sell", K.btnRed, P(0.5, 0.655), P(0.84, 0.11)); sell.AnchorPoint = Vector2.new(0.5, 0.5); sell.ZIndex = 6
	sell.ScaleType = Enum.ScaleType.Stretch
	txt(sell, "Label", "SELL", P(0.08, 0.12), P(0.84, 0.76)).ZIndex = 7
	local badge = img(c, "Badge", K.iCheck, P(0.97, 0.16), P(0.26, 0.2), 1); badge.AnchorPoint = Vector2.new(1, 0); badge.ZIndex = 6; badge.Visible = false
	local eq = frame(c, "Equipped"); eq.Visible = false
end

-- ---------- REBIRTH (comme le kit) ----------
do
	local w, B = window(frames, "Rebirth", { r = 1.137, h = 0.7, title = "REBIRTH", header = K.hPurple, icon = K.iRebirth2, bg = K.bg142 })
	local stats = frame(w, "Stats", P(0, 0.2), P(1, 0.32))
	local function side(name, label, x)
		local f = frame(stats, name, P(x, 0), P(0.4, 1))
		txt(f, "Text", label, P(0.1, 0), P(0.8, 0.26))
		local m = img(f, "Money", K.btnCash, P(0.03, 0.32), P(0.94, 0.62))
		m.ScaleType = Enum.ScaleType.Stretch
		img(m, "Image", K.iMoney, P(0.04, 0.08), P(0.32, 0.84), 1).ZIndex = 2
		txt(m, "Text", "x1.00 money", P(0.34, 0.2), P(0.62, 0.6)).ZIndex = 2
	end
	side("Before", "NOW", 0.05)
	side("After", "AFTER", 0.55)
	local ar = frame(stats, "Arrows", P(0.45, 0.42), P(0.1, 0.45))
	img(ar, "Image", K.iFF, P(0, 0), P(1, 1), 1)
	local boost = txt(w, "RebirthBoost", "", P(0.06, 0.53), P(0.88, 0.1), Color3.fromRGB(255, 255, 255))
	local g = Instance.new("UIGradient"); g.Rotation = 90
	g.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(190, 255, 170)); g.Parent = boost
	local bar = img(w, "Bar", K.barEmpty, P(0.04, 0.655), P(0.92, 0.11)); bar.ScaleType = Enum.ScaleType.Stretch
	local pr = img(bar, "Progress", K.barFill, P(0.012, 0.1), P(0.5, 0.8)); pr.ScaleType = Enum.ScaleType.Stretch; pr.ZIndex = 2
	txt(bar, "Text", "$0 / $5K", P(0.05, 0.12), P(0.9, 0.76)).ZIndex = 3
	local rb = btn(w, "RebirthButton", K.btnCyan, P(0.08, 0.8), P(0.4, 0.14)); rb.ScaleType = Enum.ScaleType.Stretch
	txt(rb, "Text", "REBIRTH!", P(0.12, 0.12), P(0.76, 0.76)).ZIndex = 2
	local sk = btn(w, "SkipButton", K.btnGreen2, P(0.52, 0.8), P(0.4, 0.14)); sk.ScaleType = Enum.ScaleType.Stretch
	txt(sk, "Text", "CLOSE", P(0.15, 0.12), P(0.7, 0.76)).ZIndex = 2
end

-- ---------- LEADERBOARD ----------
do
	local w, B = window(frames, "Leaderboard", { r = 0.95, h = 0.78, title = "TOP PLAYERS", header = K.hOrange2, icon = K.iCrown2, bg = K.bg095 })
	local p, s = B(0, 0, 1, 0.1)
	local tabs = frame(w, "Tabs", p, s)
	local tl = Instance.new("UIListLayout"); tl.FillDirection = Enum.FillDirection.Horizontal; tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tl.Padding = UDim.new(0.04, 0); tl.Parent = tabs
	local t1 = btn(tabs, "Tab_Money", K.btnBuy, nil, P(0.44, 1)); t1.ScaleType = Enum.ScaleType.Stretch
	txt(t1, "Text", "MONEY", P(0.1, 0.15), P(0.8, 0.7)).ZIndex = 2
	local t2 = btn(tabs, "Tab_Rebirths", K.btnCyan, nil, P(0.44, 1)); t2.ScaleType = Enum.ScaleType.Stretch
	txt(t2, "Text", "REBIRTHS", P(0.1, 0.15), P(0.8, 0.7)).ZIndex = 2
	p, s = B(0, 0.12, 1, 0.74)
	local rows = Instance.new("ScrollingFrame"); rows.Name = "Rows"; rows.BackgroundTransparency = 1; rows.BorderSizePixel = 0
	rows.Position = p; rows.Size = s; rows.ScrollBarThickness = 6; rows.CanvasSize = UDim2.new(); rows.AutomaticCanvasSize = Enum.AutomaticSize.Y; rows.Parent = w
	local rl = Instance.new("UIListLayout"); rl.Padding = UDim.new(0, 6); rl.SortOrder = Enum.SortOrder.LayoutOrder; rl.HorizontalAlignment = Enum.HorizontalAlignment.Center; rl.Parent = rows
	local rt = img(rows, "RowTemplate", K.rowLong.orange, nil, UDim2.new(0.97, 0, 0, 56)); rt.Visible = false
	txt(rt, "Rank", "#1", P(0.03, 0.2), P(0.12, 0.6))
	local av = img(rt, "Avatar", 0, P(0.16, 0.1), P(0.8, 0.8)); av.SizeConstraint = Enum.SizeConstraint.RelativeYY; av.Image = ""
	av.BackgroundTransparency = 0; av.BackgroundColor3 = Color3.fromRGB(40, 30, 20); corner(av, 1)
	txt(rt, "PlayerName", "Player", P(0.33, 0.22), P(0.4, 0.56), nil, Enum.TextXAlignment.Left)
	txt(rt, "Score", "0", P(0.72, 0.22), P(0.25, 0.56), Color3.fromRGB(150, 255, 120), Enum.TextXAlignment.Right)
	p, s = B(0.1, 0.4, 0.8, 0.08)
	txt(w, "Empty", "Loading...", p, s, Color3.fromRGB(200, 200, 210))
	p, s = B(0.02, 0.88, 0.96, 0.12)
	local mine = img(w, "Mine", K.btnStripe, p, s); mine.ScaleType = Enum.ScaleType.Stretch
	txt(mine, "Text", "You: $0", P(0.05, 0.15), P(0.9, 0.7)).ZIndex = 2
end

-- ---------- POPUP (brainrot trouvé) ----------
do
	local w = window(frames, "Popup", { r = 0.95, h = 0.56, y = 0.44, title = "NEW BRAINROT!", header = K.hOrange, icon = K.iGift, bg = K.bg095, close = false })
	local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1; vp.Position = P(0.1, 0.2); vp.Size = P(0.8, 0.48); vp.ZIndex = 2; vp.Parent = w
	txt(w, "Name", "Name", P(0.06, 0.68), P(0.88, 0.11)).ZIndex = 3
	txt(w, "Rarity", "Common", P(0.1, 0.79), P(0.8, 0.08)).ZIndex = 3
	txt(w, "Income", "+$1/s", P(0.1, 0.87), P(0.8, 0.08), Color3.fromRGB(150, 255, 120)).ZIndex = 3
end

-- ---------- BANNIÈRE + NOTIFICATIONS ----------
do
	local bn = frame(frames, "Banner", P(0.5, 0.22), P(0.6, 0.14)); bn.AnchorPoint = Vector2.new(0.5, 0.5); bn.Visible = false
	txt(bn, "NewLevel", "BEACH", P(0, 0), P(1, 0.62))
	txt(bn, "NewSpeed", "", P(0.1, 0.62), P(0.8, 0.36), Color3.fromRGB(230, 230, 240))
	local nt = frame(frames, "Notifications", P(0.5, 0.75), P(0.6, 0.2)); nt.AnchorPoint = Vector2.new(0.5, 1)
	local nl = Instance.new("UIListLayout"); nl.HorizontalAlignment = Enum.HorizontalAlignment.Center; nl.Padding = UDim.new(0, 2); nl.VerticalAlignment = Enum.VerticalAlignment.Bottom; nl.Parent = nt
	local tpl = txt(templates, "NotificationTemplate", "", nil, P(1, 0.22)); tpl.Visible = false
end

gui.Parent = SG
return "GUI K4 ok : " .. #gui:GetDescendants() .. " instances"
