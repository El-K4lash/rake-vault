-- tools/build_wheelwin.lua : fenêtre "YOU WON!" de la roue du lobby (vraies instances, style K4). À lancer UNE fois (Edit).
-- StarterGui.WheelWin : Dim, Rays (rayons qui tournent derrière), Card (en-tête, case de l'icône du gain, nom, montant,
-- bouton CLAIM!), Confetti. Animée par Client/LobbyController quand le serveur donne le gain (fin du tour).
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
	iPin = 134323598185216, iLuck = 81193001619814,
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


local old = SG:FindFirstChild("WheelWin"); if old then old:Destroy() end
local gui = Instance.new("ScreenGui"); gui.Name = "WheelWin"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.DisplayOrder = 14; gui.Enabled = false

local dim = frame(gui, "Dim"); dim.BackgroundTransparency = 0.5; dim.BackgroundColor3 = Color3.fromRGB(8, 10, 24); dim.ZIndex = 1

-- rayons lumineux derrière la carte
local rays = frame(gui, "Rays", P(0.5, 0.47), P(0.9, 0.9)); rays.AnchorPoint = Vector2.new(0.5, 0.5); rays.ZIndex = 2
ratio(rays, 1)
for i = 0, 11 do
	local r = frame(rays, "Ray" .. i, P(0.5, 0.5), P(0.07, 1)); r.AnchorPoint = Vector2.new(0.5, 0.5); r.Rotation = i * 15
	r.BackgroundTransparency = 0.45; r.BackgroundColor3 = Color3.fromRGB(255, 230, 120); r.ZIndex = 2
	local g = Instance.new("UIGradient"); g.Rotation = 90
	g.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.35, 0.2), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(0.65, 0.2), NumberSequenceKeypoint.new(1, 1) })
	g.Parent = r
end

-- carte
local w, B = window(gui, "Card", { r = 1.05, h = 0.62, y = 0.5, title = "YOU WON!", header = K.hOrange, icon = K.iStar })
w.Visible = true
do
	local p, s = B(0.29, 0.0, 0.42, 0.44)
	local box = img(w, "IconBox", K.sqWhite, p, s); box.ScaleType = Enum.ScaleType.Stretch; box.ZIndex = 4
	local c = ratio(box, 1); c.AspectType = Enum.AspectType.FitWithinMaxSize
	-- centrée (la contrainte carrée la collait à gauche de sa zone)
	box.AnchorPoint = Vector2.new(0.5, 0); box.Position = UDim2.new(0.5, 0, p.Y.Scale, p.Y.Offset)
	local ic = img(box, "Icon", K.iMoney, P(0.12, 0.12), P(0.76, 0.76)); ic.ZIndex = 5
	local sc = Instance.new("UIScale"); sc.Name = "Pop"; sc.Parent = box
	local pN, sN = B(0, 0.47, 1, 0.13)
	local name = txt(w, "RewardName", "BIG MONEY", pN, sN, Color3.fromRGB(255, 200, 40)); name.ZIndex = 5
	local pA, sA = B(0, 0.6, 1, 0.18)
	local amount = txt(w, "Amount", "+$12.5K", pA, sA, Color3.fromRGB(120, 255, 130)); amount.ZIndex = 5
	local pC, sC = B(0.22, 0.81, 0.56, 0.19)
	button(w, "Claim", K.btnGreen, "CLAIM!", pC, sC)
end

-- confettis (pièces fixes, animées par le contrôleur)
local conf = frame(gui, "Confetti", P(0, 0), P(1, 1)); conf.ZIndex = 30
local cols = { Color3.fromRGB(255, 90, 120), Color3.fromRGB(255, 214, 74), Color3.fromRGB(110, 230, 120), Color3.fromRGB(110, 190, 255), Color3.fromRGB(190, 120, 255) }
for i = 1, 40 do
	local c = frame(conf, "C" .. i, P((i - 1) / 40, -0.05), UDim2.fromOffset(12, 18)); c.BackgroundTransparency = 0
	c.BackgroundColor3 = cols[(i - 1) % #cols + 1]; c.ZIndex = 30
	corner(c, UDim.new(0.2, 0))
end

gui.Parent = SG
return "WheelWin ok " .. #gui:GetDescendants()
