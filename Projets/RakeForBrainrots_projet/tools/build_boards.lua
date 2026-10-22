-- tools/build_boards.lua : panneaux de l'enclos (vraies instances dans StarterGui, posées par Client/BoardController
-- sur les parts Pen.UpgradeBoard / Pen.StatsBoard du joueur) + bouton AUTO du HUD. À lancer UNE fois dans Studio (Edit).
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


local Upgrades = require(game.ReplicatedStorage.Shared.Config.Upgrades:Clone())
for _, n in ipairs({ "UpgradeBoardGui", "StatsBoardGui" }) do local o = SG:FindFirstChild(n); if o then o:Destroy() end end

-- look "panneau en bois / ardoise" : pas d'images de GUI, juste de la craie sur l'ardoise de la part
local CHALK = Color3.fromRGB(245, 242, 230)
local CHALK2 = Color3.fromRGB(200, 214, 196)
local YELLOW = Color3.fromRGB(255, 226, 120)
local WOOD = Color3.fromRGB(201, 139, 79)
local WOOD_D = Color3.fromRGB(94, 58, 30)
local function chalk(parent, name, text, pos, size, color, xa)
	local t = txt(parent, name, text, pos, size, color or CHALK, xa)
	local st = t:FindFirstChild("Stroke") :: UIStroke
	if st then st.Color = Color3.fromRGB(30, 46, 38); st.Transparency = 0.35 end
	return t
end
local function line(parent, y)
	local f = frame(parent, "Line", P(0.02, y), P(0.96, 0.004)); f.BackgroundTransparency = 0.55; f.BackgroundColor3 = CHALK
	return f
end
local function surface(name, title)
	local sg = Instance.new("SurfaceGui"); sg.Name = name; sg.Face = Enum.NormalId.Front; sg.ResetOnSpawn = false
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 50; sg.LightInfluence = 0.15
	sg.MaxDistance = 90; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local bg = frame(sg, "Bg") -- transparent : on voit l'ardoise
	chalk(bg, "Title", title, P(0.03, 0.02), P(0.6, 0.13), YELLOW, Enum.TextXAlignment.Left)
	line(bg, 0.16)
	return sg, bg
end

-- ===== UPGRADES =====
do
	local sg, bg = surface("UpgradeBoardGui", "UPGRADES")
	chalk(bg, "Sub", "resets on rebirth", P(0.6, 0.06), P(0.37, 0.06), CHALK2, Enum.TextXAlignment.Right)
	local list = frame(bg, "List", P(0.02, 0.18), P(0.96, 0.8))
	local l = Instance.new("UIListLayout"); l.SortOrder = Enum.SortOrder.LayoutOrder; l.Parent = list
	for i, u in ipairs(Upgrades.BaseUpgrades) do
		local r = frame(list, u.Id, nil, P(1, 1 / #Upgrades.BaseUpgrades)); r.LayoutOrder = i
		chalk(r, "Name", string.upper(u.Name), P(0.01, 0.1), P(0.44, 0.46), CHALK, Enum.TextXAlignment.Left)
		chalk(r, "Desc", u.Desc, P(0.01, 0.56), P(0.44, 0.32), CHALK2, Enum.TextXAlignment.Left)
		chalk(r, "Level", "Lv 0/" .. u.Max, P(0.46, 0.1), P(0.2, 0.42), YELLOW)
		chalk(r, "Value", u.Show(0), P(0.46, 0.54), P(0.2, 0.34), CHALK2)
		-- bouton = petite planche de bois
		local b = Instance.new("TextButton"); b.Name = "Buy"; b.Text = ""; b.AutoButtonColor = false
		b.Position = P(0.69, 0.14); b.Size = P(0.3, 0.72); b.BackgroundColor3 = WOOD; b.BorderSizePixel = 0; b.Parent = r
		local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b
		local st = Instance.new("UIStroke"); st.Thickness = 3; st.Color = WOOD_D; st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; st.Parent = b
		local sc = Instance.new("UIScale"); sc.Name = "Pop"; sc.Parent = b
		txt(b, "Text", "$0", P(0.06, 0.14), P(0.88, 0.72))
		if i < #Upgrades.BaseUpgrades then
			local f = frame(r, "Line", P(0, 0.995), P(1, 0.005)); f.BackgroundTransparency = 0.75; f.BackgroundColor3 = CHALK
		end
	end
	sg.Parent = SG
end

-- ===== STATS =====
do
	local sg, bg = surface("StatsBoardGui", "MY STATS")
	chalk(bg, "Sub", "Player", P(0.6, 0.05), P(0.37, 0.08), CHALK2, Enum.TextXAlignment.Right)
	local grid = frame(bg, "Grid", P(0.03, 0.19), P(0.94, 0.79))
	-- 3 colonnes de 6 : argent | râteau & déplacement | œufs & base (avec les effets des upgrades)
	local g = Instance.new("UIGridLayout"); g.CellSize = P(0.31, 1 / 6 - 0.012); g.CellPadding = P(0.035, 0.012)
	g.SortOrder = Enum.SortOrder.LayoutOrder; g.FillDirection = Enum.FillDirection.Vertical; g.Parent = grid
	local cells = {
		{ "Money", "MONEY" }, { "IncomeSec", "INCOME" }, { "MoneyMult", "MONEY BOOST" },
		{ "Earned", "TOTAL EARNED" }, { "Rebirths", "REBIRTHS" }, { "Brainrots", "BRAINROTS" },
		{ "Rake", "RAKE" }, { "RakePower", "PER SWING" }, { "Luck", "RAKE LUCK" },
		{ "Found", "RAKED / FOUND" }, { "Bag", "BAG" }, { "WalkSpeed", "WALK SPEED" },
		{ "EggLuck", "EGG LUCK" }, { "Eggs", "EGGS" }, { "Hatching", "HATCHING" },
		{ "HatchTime", "HATCH TIME" }, { "AutoRake", "AUTO RAKE" }, { "PenSlots", "PEN SLOTS" },
	}
	for i, c in ipairs(cells) do
		local f = frame(grid, c[1]); f.LayoutOrder = i
		chalk(f, "Label", c[2], P(0, 0.02), P(1, 0.4), CHALK2, Enum.TextXAlignment.Left)
		chalk(f, "Value", "0", P(0, 0.42), P(1, 0.54), CHALK, Enum.TextXAlignment.Left)
	end
	sg.Parent = SG
end

-- ===== bouton AUTO : juste au-dessus de la hotbar, visible seulement râteau en main =====
-- Holder ancré comme la barre (bas-centre) avec son propre UIScale "Fit" -> suit la taille de la hotbar.
do
	local hud = SG:WaitForChild("GUI"):WaitForChild("HUD")
	local o = hud:FindFirstChild("AutoRake"); if o then o:Destroy() end
	local hb = SG:WaitForChild("Hotbar")
	local oh = hb:FindFirstChild("AutoHolder"); if oh then oh:Destroy() end
	local holder = Instance.new("Frame"); holder.Name = "AutoHolder"; holder.BackgroundTransparency = 1
	holder.AnchorPoint = Vector2.new(0.5, 1); holder.Position = UDim2.new(0.5, 0, 1, -10); holder.Size = UDim2.fromOffset(140, 132)
	holder.Parent = hb
	local fit = Instance.new("UIScale"); fit.Name = "Fit"; fit.Parent = holder
	local b = btn(holder, "AutoRake", K.btnRed, P(0, 0), P(1, 1)); b.ScaleType = Enum.ScaleType.Stretch; b.Visible = false
	b.AnchorPoint = Vector2.new(0.5, 0); b.Position = UDim2.new(0.5, 0, 0, 0); b.Size = UDim2.fromOffset(132, 50)
	b:SetAttribute("On", "rbxassetid://" .. K.btnGreen); b:SetAttribute("Off", "rbxassetid://" .. K.btnRed)
	txt(b, "Text", "AUTO: OFF", P(0.08, 0.16), P(0.84, 0.68)).ZIndex = 2
end
return "Boards ok"
