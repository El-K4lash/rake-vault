-- tools/build_admin.lua : construit StarterGui.AdminPanel (vraies instances, style K4 des autres menus).
-- À lancer UNE fois dans Studio (Edit). Logique : Client/AdminController + Server/AdminService.
-- Inspiré du panel admin de "Save Brainrots From Backrooms" (vault) : onglets Joueurs / Give / Serveur / Events / Fun / Logs.
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


-- [ ADMIN PANEL ] ------------------------------------------------------------------
local old = SG:FindFirstChild("AdminPanel"); if old then old:Destroy() end
local gui = Instance.new("ScreenGui"); gui.Name = "AdminPanel"; gui.ResetOnSpawn = false; gui.Enabled = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 20; gui.IgnoreGuiInset = true

local DARK = Color3.fromRGB(24, 28, 46)
local DARK2 = Color3.fromRGB(36, 42, 66)
local LINE = Color3.fromRGB(12, 14, 24)

local function panel(parent, name, pos, size, title)
	local f = frame(parent, name, pos, size); f.BackgroundTransparency = 0; f.BackgroundColor3 = DARK; f.ZIndex = 2
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = f
	local st = Instance.new("UIStroke"); st.Thickness = 2; st.Color = LINE; st.Parent = f
	if title then
		local t = txt(f, "Title", title, P(0.03, 0.01), UDim2.new(0.94, 0, 0, 22), Color3.fromRGB(255, 214, 90), Enum.TextXAlignment.Left)
		t.ZIndex = 3
	end
	return f
end
local function box(parent, name, placeholder, pos, size)
	local b = Instance.new("TextBox"); b.Name = name; b.Position = pos; b.Size = size; b.ClearTextOnFocus = false
	b.BackgroundColor3 = DARK2; b.BorderSizePixel = 0; b.FontFace = FONT; b.TextScaled = true; b.Text = ""
	b.PlaceholderText = placeholder; b.PlaceholderColor3 = Color3.fromRGB(140, 150, 185); b.TextColor3 = Color3.new(1, 1, 1); b.ZIndex = 3
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
	local st = Instance.new("UIStroke"); st.Thickness = 1.5; st.Color = LINE; st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; st.Parent = b
	local pd = Instance.new("UIPadding"); pd.PaddingLeft = UDim.new(0.04, 0); pd.PaddingRight = UDim.new(0.04, 0)
	pd.PaddingTop = UDim.new(0.18, 0); pd.PaddingBottom = UDim.new(0.18, 0); pd.Parent = b
	b.Parent = parent
	return b
end
local function button(parent, name, label, img, pos, size)
	local b = btn(parent, name, img, pos, size); b.ScaleType = Enum.ScaleType.Stretch; b.ZIndex = 3
	local t = txt(b, "Text", label, P(0.08, 0.16), P(0.84, 0.68)); t.ZIndex = 4
	return b
end
local function grid(parent, cell, pad)
	local g = Instance.new("UIGridLayout"); g.CellSize = cell; g.CellPadding = pad or UDim2.fromOffset(6, 6)
	g.SortOrder = Enum.SortOrder.LayoutOrder; g.Parent = parent; return g
end
local function scroller(parent, name, pos, size)
	local s = Instance.new("ScrollingFrame"); s.Name = name; s.Position = pos; s.Size = size; s.BackgroundTransparency = 1
	s.BorderSizePixel = 0; s.ScrollBarThickness = 6; s.ScrollBarImageColor3 = Color3.fromRGB(120, 130, 170)
	s.CanvasSize = UDim2.new(); s.AutomaticCanvasSize = Enum.AutomaticSize.Y; s.ZIndex = 3; s.Parent = parent
	return s
end

local w, B = window(gui, "Main", { r = 1.62, h = 0.84, y = 0.5, title = "ADMIN PANEL", header = K.hOrange2, icon = K.iCrown2, bg = K.bg142 })
w.Size = P(0.86, 0.84)
local ms = Instance.new("UIScale"); ms.Name = "MenuScale"; ms.Parent = w
-- sous-titre (cible sélectionnée) dans l'en-tête
local tg = txt(w.Header, "Target", "No player selected", P(0.5, 0.28), P(0.36, 0.44), Color3.fromRGB(255, 240, 200), Enum.TextXAlignment.Right)
tg.ZIndex = 4

-- onglets (colonne de gauche)
local tabs = frame(w, "Tabs", B(0, 0, 0.16, 1))
local tl = Instance.new("UIListLayout"); tl.Padding = UDim.new(0.018, 0); tl.SortOrder = Enum.SortOrder.LayoutOrder; tl.Parent = tabs
local TABS = { { "Players", "PLAYERS", K.iPaw }, { "Give", "GIVE", K.iGift }, { "Server", "SERVER", K.iPin },
	{ "Events", "EVENTS", K.iStar }, { "Fun", "FUN", K.iShoe }, { "Logs", "LOGS", K.iBook }, { "Admins", "ADMINS", K.iCrown } }
for i, t in ipairs(TABS) do
	local b = btn(tabs, t[1], i == 1 and K.btnGreen or K.btnBlue, nil, P(1, 0.124)); b.ScaleType = Enum.ScaleType.Stretch; b.LayoutOrder = i; b.ZIndex = 3
	b:SetAttribute("On", "rbxassetid://" .. K.btnGreen); b:SetAttribute("Off", "rbxassetid://" .. K.btnBlue)
	img(b, "Icon", t[3], P(0.05, 0.12), P(0.3, 0.76), 1).ZIndex = 4
	txt(b, "Text", t[2], P(0.34, 0.2), P(0.62, 0.6), nil, Enum.TextXAlignment.Left).ZIndex = 4
end

local pages = frame(w, "Pages", B(0.175, 0, 0.825, 1))
local function page(name) local p = frame(pages, name); p.Visible = name == "Players"; return p end
local tpl = Instance.new("Folder"); tpl.Name = "Templates"; tpl.Parent = gui

-- ===== PLAYERS =====
do
	local pg = page("Players")
	local left = panel(pg, "ListPanel", P(0, 0), P(0.38, 1), "PLAYERS")
	box(left, "Search", "Search...", UDim2.new(0.04, 0, 0, 28), UDim2.new(0.92, 0, 0, 30))
	local list = scroller(left, "List", UDim2.new(0.03, 0, 0, 66), UDim2.new(0.94, 0, 1, -72))
	local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 5); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = list
	-- modèle de ligne joueur
	local row = btn(tpl, "PlayerRow", K.rowLong.blue, nil, UDim2.new(0.97, 0, 0, 50)); row.ScaleType = Enum.ScaleType.Stretch
	row:SetAttribute("On", "rbxassetid://" .. K.rowLong.green); row:SetAttribute("Off", "rbxassetid://" .. K.rowLong.blue)
	local av = img(row, "Avatar", 0, P(0.03, 0.12), P(0.76, 0.76)); av.SizeConstraint = Enum.SizeConstraint.RelativeYY; av.Image = ""
	av.BackgroundTransparency = 0; av.BackgroundColor3 = DARK2; corner(av, 1); av.ZIndex = 2
	txt(row, "PName", "Player", P(0.25, 0.1), P(0.72, 0.46), nil, Enum.TextXAlignment.Left).ZIndex = 2
	txt(row, "Info", "$0 · 0 rebirths", P(0.25, 0.56), P(0.72, 0.34), Color3.fromRGB(220, 255, 220), Enum.TextXAlignment.Left).ZIndex = 2

	local right = panel(pg, "Selected", P(0.4, 0), P(0.6, 1), "SELECTED PLAYER")
	local hd = frame(right, "Head", UDim2.new(0.03, 0, 0, 28), UDim2.new(0.94, 0, 0.14, 0))
	local big = img(hd, "Avatar", 0, P(0, 0.02), P(0.96, 0.96)); big.SizeConstraint = Enum.SizeConstraint.RelativeYY; big.Image = ""
	big.BackgroundTransparency = 0; big.BackgroundColor3 = DARK2; corner(big, 1); big.ZIndex = 3
	txt(hd, "PName", "—", P(0.2, 0.02), P(0.78, 0.55), nil, Enum.TextXAlignment.Left).ZIndex = 3
	txt(hd, "Sub", "Select a player on the left", P(0.2, 0.58), P(0.78, 0.38), Color3.fromRGB(170, 180, 215), Enum.TextXAlignment.Left).ZIndex = 3
	-- stats modifiables
	local stats = frame(right, "Stats", P(0.03, 0.22), P(0.94, 0.42))
	local sl = Instance.new("UIListLayout"); sl.Padding = UDim.new(0.025, 0); sl.SortOrder = Enum.SortOrder.LayoutOrder; sl.Parent = stats
	for i, s in ipairs({ { "Money", "MONEY", K.iMoney }, { "Rebirths", "REBIRTHS", K.iRebirth }, { "Slots", "SLOTS", K.iPaw }, { "Rake", "RAKE LVL", K.iShoe }, { "Bag", "BAG LVL", K.iBasket } }) do
		local r = img(stats, s[1], K.rowLong.magenta, nil, P(1, 0.18)); r.ScaleType = Enum.ScaleType.Stretch; r.LayoutOrder = i; r.ZIndex = 3
		img(r, "Icon", s[3], P(0.015, 0.08), P(0.12, 0.84), 1).ZIndex = 4
		txt(r, "Label", s[2], P(0.1, 0.18), P(0.24, 0.64), nil, Enum.TextXAlignment.Left).ZIndex = 4
		txt(r, "Value", "0", P(0.34, 0.18), P(0.22, 0.64), Color3.fromRGB(255, 240, 160)).ZIndex = 4
		local tb = box(r, "Input", "new value", P(0.57, 0.14), P(0.24, 0.72)); tb.ZIndex = 4
		button(r, "Set", "SET", K.btnGreen, P(0.82, 0.08), P(0.17, 0.84)).ZIndex = 4
	end
	-- actions
	box(right, "Reason", "Reason (kick / ban)...", P(0.03, 0.665), P(0.94, 0.065))
	local acts = frame(right, "Actions", P(0.03, 0.75), P(0.94, 0.24))
	grid(acts, UDim2.new(0.235, 0, 0.44, 0), UDim2.new(0.02, 0, 0.08, 0))
	for i, a in ipairs({ { "TpTo", "TP TO", K.btnBlue }, { "Bring", "BRING", K.btnBlue }, { "Freeze", "FREEZE", K.btnCyan }, { "Unfreeze", "UNFREEZE", K.btnCyan },
		{ "Kick", "KICK", K.btnOrange }, { "Ban", "BAN", K.btnRed }, { "Reset", "RESET DATA", K.btnRed }, { "Refresh", "REFRESH", K.btnGreen2 } }) do
		local b = button(acts, a[1], a[2], a[3]); b.LayoutOrder = i
	end
end

-- ===== GIVE =====
do
	local pg = page("Give")
	local bp = panel(pg, "Brainrots", P(0, 0), P(0.62, 1), "GIVE BRAINROT")
	box(bp, "Search", "Search brainrot...", UDim2.new(0.03, 0, 0, 28), UDim2.new(0.94, 0, 0, 30))
	local g = scroller(bp, "Grid", UDim2.new(0.03, 0, 0, 66), UDim2.new(0.94, 0, 0.62, -66))
	grid(g, UDim2.new(0.31, 0, 0, 46), UDim2.fromOffset(6, 6))
	local card = btn(tpl, "BrainrotCard", K.rowBlue, nil, UDim2.new(0, 100, 0, 46)); card.ScaleType = Enum.ScaleType.Stretch
	card:SetAttribute("On", "rbxassetid://" .. K.rowGreen); card:SetAttribute("Off", "rbxassetid://" .. K.rowBlue)
	txt(card, "BName", "Brainrot", P(0.05, 0.08), P(0.9, 0.52)).ZIndex = 2
	txt(card, "Rarity", "Common", P(0.05, 0.6), P(0.9, 0.32), Color3.fromRGB(200, 200, 200)).ZIndex = 2
	txt(bp, "MutTitle", "MUTATION", P(0.03, 0.635), P(0.5, 0.05), Color3.fromRGB(255, 214, 90), Enum.TextXAlignment.Left).ZIndex = 3
	local muts = scroller(bp, "Mutations", P(0.03, 0.69), P(0.94, 0.12))
	muts.AutomaticCanvasSize = Enum.AutomaticSize.X; muts.ScrollingDirection = Enum.ScrollingDirection.X
	local mlay = Instance.new("UIListLayout"); mlay.FillDirection = Enum.FillDirection.Horizontal; mlay.Padding = UDim.new(0, 6)
	mlay.SortOrder = Enum.SortOrder.LayoutOrder; mlay.Parent = muts
	local chip = btn(tpl, "Chip", K.btnBlue, nil, UDim2.new(0, 96, 0.82, 0)); chip.ScaleType = Enum.ScaleType.Stretch
	chip:SetAttribute("On", "rbxassetid://" .. K.btnGreen); chip:SetAttribute("Off", "rbxassetid://" .. K.btnBlue)
	txt(chip, "Text", "Normal", P(0.08, 0.18), P(0.84, 0.64)).ZIndex = 2
	box(bp, "Count", "Count (1)", P(0.03, 0.84), P(0.3, 0.12))
	button(bp, "GiveBrainrot", "GIVE BRAINROT", K.btnGreen, P(0.36, 0.83), P(0.61, 0.14))

	local ep = panel(pg, "Eggs", P(0.64, 0), P(0.36, 0.48), "GIVE EGGS")
	local eg = frame(ep, "List", UDim2.new(0.04, 0, 0, 28), UDim2.new(0.92, 0, 0.56, -28))
	grid(eg, UDim2.new(0.31, 0, 0.44, 0), UDim2.new(0.03, 0, 0.08, 0))
	box(ep, "Count", "Count (1)", P(0.04, 0.66), P(0.4, 0.2))
	button(ep, "GiveEgg", "GIVE", K.btnGreen, P(0.48, 0.64), P(0.48, 0.24))

	local mp = panel(pg, "Money", P(0.64, 0.5), P(0.36, 0.5), "QUICK GIVE")
	local mq = frame(mp, "Buttons", UDim2.new(0.04, 0, 0, 30), UDim2.new(0.92, 0, 1, -38))
	grid(mq, UDim2.new(0.48, 0, 0.3, 0), UDim2.new(0.04, 0, 0.05, 0))
	for i, m in ipairs({ { "M1K", "+$1K" }, { "M1M", "+$1M" }, { "M1B", "+$1B" }, { "M1T", "+$1T" }, { "R1", "+1 REBIRTH" }, { "Runes", "MAX RUNES" } }) do
		local b = button(mq, m[1], m[2], i <= 4 and K.btnCash or K.btnCyan); b.LayoutOrder = i
	end
end

-- ===== SERVER =====
do
	local pg = page("Server")
	local an = panel(pg, "Announce", P(0, 0), P(1, 0.3), "ANNOUNCEMENT (all players)")
	box(an, "Message", "Type your message...", UDim2.new(0.02, 0, 0, 30), UDim2.new(0.74, 0, 1, -40))
	button(an, "Send", "SEND", K.btnGreen, UDim2.new(0.78, 0, 0, 30), UDim2.new(0.2, 0, 1, -40))
	local ga = panel(pg, "GiveAll", P(0, 0.33), P(0.49, 0.3), "GIVE MONEY TO EVERYONE")
	box(ga, "Amount", "Amount (ex: 1M, 500K)", UDim2.new(0.04, 0, 0, 30), UDim2.new(0.56, 0, 1, -40))
	button(ga, "Give", "GIVE ALL", K.btnCash, UDim2.new(0.63, 0, 0, 30), UDim2.new(0.34, 0, 1, -40))
	local ub = panel(pg, "Unban", P(0.51, 0.33), P(0.49, 0.3), "UNBAN")
	box(ub, "Name", "Username or UserId", UDim2.new(0.04, 0, 0, 30), UDim2.new(0.56, 0, 1, -40))
	button(ub, "Do", "UNBAN", K.btnOrange, UDim2.new(0.63, 0, 0, 30), UDim2.new(0.34, 0, 1, -40))
	local qa = panel(pg, "Quick", P(0, 0.66), P(1, 0.34), "QUICK ACTIONS")
	local q = frame(qa, "Buttons", UDim2.new(0.02, 0, 0, 32), UDim2.new(0.96, 0, 1, -42))
	grid(q, UDim2.new(0.235, 0, 0.9, 0), UDim2.new(0.02, 0, 0, 0))
	for i, a in ipairs({ { "SaveAll", "SAVE ALL", K.btnGreen }, { "RespawnAll", "RESPAWN ALL", K.btnBlue }, { "RefillItems", "REFILL ZONES", K.btnCyan }, { "Shutdown", "SHUTDOWN", K.btnRed } }) do
		local b = button(q, a[1], a[2], a[3]); b.LayoutOrder = i
	end
end

-- ===== EVENTS =====
do
	local pg = page("Events")
	local function ev(name, title, icon, x)
		local p = panel(pg, name, P(x, 0), P(0.49, 0.78), title)
		img(p, "Icon", icon, P(0.36, 0.1), P(0.28, 0.26), 1).ZIndex = 3
		txt(p, "Status", "Not active", P(0.05, 0.38), P(0.9, 0.09), Color3.fromRGB(170, 180, 215)).ZIndex = 3
		local m = frame(p, "Mults", P(0.05, 0.5), P(0.9, 0.15))
		grid(m, UDim2.new(0.3, 0, 1, 0), UDim2.new(0.05, 0, 0, 0))
		for i, k in ipairs({ 2, 3, 5 }) do
			local c = button(m, "x" .. k, "x" .. k, i == 1 and K.btnGreen or K.btnBlue); c.LayoutOrder = i
			c:SetAttribute("On", "rbxassetid://" .. K.btnGreen); c:SetAttribute("Off", "rbxassetid://" .. K.btnBlue)
		end
		box(p, "Minutes", "Minutes (10)", P(0.05, 0.69), P(0.9, 0.1))
		button(p, "Start", "START", K.btnGreen, P(0.05, 0.83), P(0.9, 0.13))
	end
	ev("Luck", "LUCK EVENT", K.iStar, 0)
	ev("Money", "MONEY EVENT", K.iMoney, 0.51)
	local st = panel(pg, "Stop", P(0, 0.81), P(1, 0.19))
	txt(st, "Info", "Events apply to everyone on this server and are announced.", P(0.03, 0.2), P(0.62, 0.6), Color3.fromRGB(200, 205, 230), Enum.TextXAlignment.Left).ZIndex = 3
	button(st, "StopAll", "STOP ALL", K.btnRed, P(0.68, 0.15), P(0.3, 0.7))
end

-- ===== FUN =====
do
	local pg = page("Fun")
	local sp = panel(pg, "Speed", P(0, 0), P(0.49, 0.3), "WALK SPEED")
	box(sp, "Value", "16 = normal", UDim2.new(0.04, 0, 0, 30), UDim2.new(0.56, 0, 1, -40))
	button(sp, "Set", "SET", K.btnGreen, UDim2.new(0.63, 0, 0, 30), UDim2.new(0.34, 0, 1, -40))
	local jp = panel(pg, "Jump", P(0.51, 0), P(0.49, 0.3), "JUMP POWER")
	box(jp, "Value", "50 = normal", UDim2.new(0.04, 0, 0, 30), UDim2.new(0.56, 0, 1, -40))
	button(jp, "Set", "SET", K.btnGreen, UDim2.new(0.63, 0, 0, 30), UDim2.new(0.34, 0, 1, -40))
	local sz = panel(pg, "Size", P(0, 0.33), P(1, 0.3), "SIZE")
	local sb = frame(sz, "Buttons", UDim2.new(0.02, 0, 0, 32), UDim2.new(0.96, 0, 1, -42))
	grid(sb, UDim2.new(0.235, 0, 0.9, 0), UDim2.new(0.02, 0, 0, 0))
	for i, a in ipairs({ { "Tiny", "TINY" }, { "Normal", "NORMAL" }, { "Big", "BIG" }, { "Giant", "GIANT" } }) do
		local b = button(sb, a[1], a[2], i == 2 and K.btnGreen or K.btnCyan); b.LayoutOrder = i
	end
	local fx = panel(pg, "Actions", P(0, 0.66), P(1, 0.34), "ACTIONS")
	local fb = frame(fx, "Buttons", UDim2.new(0.02, 0, 0, 32), UDim2.new(0.96, 0, 1, -42))
	grid(fb, UDim2.new(0.235, 0, 0.9, 0), UDim2.new(0.02, 0, 0, 0))
	for i, a in ipairs({ { "Fling", "FLING", K.btnOrange }, { "Heal", "HEAL", K.btnGreen }, { "BringAll", "BRING ALL", K.btnBlue }, { "ResetChar", "RESPAWN", K.btnCyan } }) do
		local b = button(fb, a[1], a[2], a[3]); b.LayoutOrder = i
	end
end

-- ===== LOGS =====
do
	local pg = page("Logs")
	local lp = panel(pg, "Panel", P(0, 0), P(1, 1), "ADMIN LOGS (this server)")
	local l = scroller(lp, "List", UDim2.new(0.02, 0, 0, 30), UDim2.new(0.96, 0, 1, -38))
	local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 3); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = l
	local line = txt(tpl, "LogLine", "[12:00] Admin did something", nil, UDim2.new(1, -8, 0, 22), Color3.fromRGB(225, 230, 245), Enum.TextXAlignment.Left)
	line.TextScaled = false; line.TextSize = 16
end

-- ===== ADMINS (propriétaires seulement : onglet caché pour les autres) =====
do
	local pg = page("Admins")
	local add = panel(pg, "Add", P(0, 0), P(1, 0.3), "ADD AN ADMIN (owners only)")
	box(add, "Name", "Username or UserId", UDim2.new(0.02, 0, 0, 30), UDim2.new(0.44, 0, 1, -40))
	button(add, "AddName", "ADD", K.btnGreen, UDim2.new(0.48, 0, 0, 30), UDim2.new(0.2, 0, 1, -40))
	button(add, "AddSelected", "ADD SELECTED", K.btnCyan, UDim2.new(0.7, 0, 0, 30), UDim2.new(0.28, 0, 1, -40))
	local lp = panel(pg, "ListPanel", P(0, 0.33), P(1, 0.67), "ADMINS (they can't add admins or act on owners)")
	local l = scroller(lp, "List", UDim2.new(0.02, 0, 0, 30), UDim2.new(0.96, 0, 1, -38))
	local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 5); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = l
	local row = img(tpl, "AdminRow", K.rowLong.orange, nil, UDim2.new(0.98, 0, 0, 50)); row.ScaleType = Enum.ScaleType.Stretch
	local av = img(row, "Avatar", 0, P(0.015, 0.12), P(0.76, 0.76)); av.SizeConstraint = Enum.SizeConstraint.RelativeYY; av.Image = ""
	av.BackgroundTransparency = 0; av.BackgroundColor3 = DARK2; corner(av, 1); av.ZIndex = 2
	txt(row, "PName", "Player", P(0.12, 0.12), P(0.6, 0.46), nil, Enum.TextXAlignment.Left).ZIndex = 2
	txt(row, "Info", "UserId", P(0.12, 0.58), P(0.6, 0.32), Color3.fromRGB(255, 240, 200), Enum.TextXAlignment.Left).ZIndex = 2
	local rm = button(row, "Remove", "REMOVE", K.btnRed, P(0.78, 0.12), P(0.2, 0.76)); rm.ZIndex = 3
end

-- bouton d'ouverture (HUD), visible seulement pour les admins
-- en haut à gauche, juste au-dessus du bouton Shop (même taille que les boutons du HUD)
local open = btn(gui, "OpenButton", K.sqOrange, P(0.01, 0.293), P(0.047, 0.12), 1); open.AnchorPoint = Vector2.new(0, 1); open.ZIndex = 2
img(open, "Icon", K.iCrown2, P(0.14, 0.06), P(0.72, 0.62), 1).ZIndex = 3
txt(open, "Text", "Admin", P(0.05, 0.66), P(0.9, 0.3)).ZIndex = 3

for _, t in ipairs(tpl:GetChildren()) do if t:IsA("GuiObject") then t.Visible = false end end -- modèles cachés
gui.Parent = SG
local n = 0; for _ in ipairs(gui:GetDescendants()) do n += 1 end
return "AdminPanel ok (" .. n .. " instances)"
