-- tools/build_nextworld.lua : ajoute le menu "NextWorld" (portail du Void : prochain monde bientôt dispo)
-- dans StarterGui.GUI.Frames, au style K4 des autres menus. À lancer UNE fois dans Studio (Edit).
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


-- [ NEXT WORLD ] ------------------------------------------------------------------
local frames = SG:WaitForChild("GUI"):WaitForChild("Frames")
local old = frames:FindFirstChild("NextWorld"); if old then old:Destroy() end
local w, B = window(frames, "NextWorld", { r = 1.05, h = 0.74, title = "NEW WORLD", header = K.hPurple, icon = K.iStar, bg = K.bg111 })
local ms = Instance.new("UIScale"); ms.Name = "MenuScale"; ms.Parent = w

-- aperçu mystère : panneau sombre dégradé violet, "???" géant, bandeau COMING SOON
local p, s = B(0, 0, 1, 0.34)
local prev = frame(w, "Preview", p, s); prev.BackgroundTransparency = 0; prev.BackgroundColor3 = Color3.new(1, 1, 1); prev.ZIndex = 2
corner(prev, 0.12)
local pg = Instance.new("UIGradient"); pg.Rotation = 90
pg.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 60, 230)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 14, 70)) }); pg.Parent = prev
local ps = Instance.new("UIStroke"); ps.Thickness = 3; ps.Color = Color3.fromRGB(16, 8, 36); ps.Parent = prev
for i = 1, 7 do -- petites étoiles
	local st = img(prev, "Star" .. i, K.iStar, P(0.05 + (i * 0.137) % 0.9, 0.08 + ((i * 0.29) % 0.6)), P(0.06, 0.18), 1)
	st.ImageTransparency = 0.35; st.ZIndex = 3; st.Rotation = i * 23
end
local q = txt(prev, "Mystery", "???", P(0.25, 0.04), P(0.5, 0.62), Color3.new(1, 1, 1), nil, 0.08); q.ZIndex = 4
local qg = Instance.new("UIGradient"); qg.Rotation = 90
qg.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(215, 160, 255)); qg.Parent = q
local rib = img(prev, "Ribbon", K.btnStripe, P(0.18, 0.66), P(0.64, 0.28)); rib.ScaleType = Enum.ScaleType.Stretch; rib.ZIndex = 5
txt(rib, "Text", "COMING SOON!", P(0.08, 0.14), P(0.84, 0.72)).ZIndex = 6

-- texte
p, s = B(0.02, 0.36, 0.96, 0.1)
local desc = txt(w, "Desc", "A new world is opening beyond the Void! Get ready:", p, s, Color3.fromRGB(235, 225, 255))
desc.ZIndex = 2

-- conditions (une ligne par condition) : icône, nom, barre de progression, coche quand c'est bon
local list = frame(w, "Requirements", B(0, 0.47, 1, 0.37))
local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0.05, 0); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = list
local function row(name, label, icon, color, order)
	local r = img(list, name, color, nil, P(1, 0.3)); r.ScaleType = Enum.ScaleType.Stretch; r.LayoutOrder = order; r.ZIndex = 2
	img(r, "Icon", icon, P(0.015, 0.08), P(0.13, 0.84), 1).ZIndex = 3
	txt(r, "Label", label, P(0.14, 0.1), P(0.4, 0.4), nil, Enum.TextXAlignment.Left).ZIndex = 3
	local bar = img(r, "Bar", K.barEmpty2, P(0.14, 0.52), P(0.66, 0.38)); bar.ScaleType = Enum.ScaleType.Stretch; bar.ZIndex = 3
	local f = img(bar, "Fill", K.barFill2, P(0.012, 0.1), P(0.5, 0.8)); f.ScaleType = Enum.ScaleType.Stretch; f.ZIndex = 4
	txt(bar, "Text", "0 / 0", P(0.05, 0.1), P(0.9, 0.8)).ZIndex = 5
	local ok = img(r, "Check", K.iCheck, P(0.84, 0.12), P(0.13, 0.76), 1); ok.ZIndex = 4; ok.Visible = false
	local pc = txt(r, "Percent", "0%", P(0.82, 0.24), P(0.16, 0.52), Color3.fromRGB(255, 220, 120)); pc.ZIndex = 4
end
row("Rebirths", "REBIRTHS", K.iRebirth, K.rowLong.magenta, 1)
row("Money", "MONEY", K.iMoney, K.rowLong.green, 2)
row("Brainrots", "BRAINROTS FOUND", K.iBook, K.rowLong.blue, 3)

-- bas : état + bouton
p, s = B(0.02, 0.855, 0.6, 0.12)
txt(w, "Status", "Unlocks in a future update — stay tuned!", p, s, Color3.fromRGB(200, 190, 230), Enum.TextXAlignment.Left).ZIndex = 2
p, s = B(0.66, 0.85, 0.34, 0.14)
local okb = btn(w, "OkButton", K.btnGreen, p, s); okb.ScaleType = Enum.ScaleType.Stretch; okb.ZIndex = 2
txt(okb, "Text", "OK!", P(0.15, 0.14), P(0.7, 0.72)).ZIndex = 3
return "NextWorld ok"
