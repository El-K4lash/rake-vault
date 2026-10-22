-- GuiBuilder : à exécuter dans Studio (mode Edit). Construit TOUTES les interfaces dans StarterGui,
-- dans le style du kit K4LSH (images du kit + police Gotham ExtraBold + contour noir).
-- Les scripts du jeu ne créent pas d'interface : ils trouvent les éléments par leur nom.
-- Relançable : remplace HUD / Menus / Popups.

local StarterGui = game:GetService("StarterGui")

local IMG = {
	SquareDark = "rbxassetid://127062449162498",
	SquareOrange = "rbxassetid://73646313229415",
	SquarePink = "rbxassetid://77317040960880",
	BarGrey = "rbxassetid://103553873357333",
	BarLight = "rbxassetid://105496683105089",
	BarHeader = "rbxassetid://112249404449276",
	BarGreen = "rbxassetid://118147684330981",
	BarGreen2 = "rbxassetid://72484859487238",
	BarGold = "rbxassetid://130202638558172",
	BarRed = "rbxassetid://139238474736040",
	Body = "rbxassetid://75109179445868",
	Rebirth = "rbxassetid://102040339566414",
	Book = "rbxassetid://102082573689395",
	Shop = "rbxassetid://110119422421461",
	Gift = "rbxassetid://112101874744840",
	Index = "rbxassetid://134306875683469",
	Pencil = "rbxassetid://139929725096333",
	Crown = "rbxassetid://94666332436790",
	Robux = "rbxassetid://97272186997275",
	Gear = "rbxasset://textures/ui/Settings/MenuBarIcons/GameSettingsTab.png",
}
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
local INK = Color3.fromRGB(5, 17, 40)

for _, n in ipairs({ "HUD", "Menus", "Popups" }) do
	local o = StarterGui:FindFirstChild(n)
	if o then o:Destroy() end
end

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end

local function ratio(parent, r)
	return new("UIAspectRatioConstraint", { AspectRatio = r }, parent)
end

local function stroke(parent, th)
	local s = new("UIStroke", { Color = INK, Thickness = th or 0.12, LineJoinMode = Enum.LineJoinMode.Round }, parent)
	pcall(function() s.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize end)
	return s
end

local function text(parent, name, str, pos, size, props)
	local t = new("TextLabel", {
		Name = name, Text = str, Position = pos, Size = size,
		BackgroundTransparency = 1, FontFace = FONT, TextScaled = true,
		TextColor3 = Color3.new(1, 1, 1), ZIndex = 3,
	}, parent)
	if props then for k, v in pairs(props) do if k ~= "StrokeTh" then t[k] = v end end end
	stroke(t, props and props.StrokeTh or 0.12)
	return t
end

local function image(parent, name, img, pos, size, props)
	local i = new("ImageLabel", {
		Name = name, Image = img, Position = pos, Size = size,
		BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Stretch, ZIndex = 2,
	}, parent)
	if props then for k, v in pairs(props) do i[k] = v end end
	return i
end

-- bouton invisible qui couvre son parent (les effets survol/clic sont gérés par le client)
local function hit(parent, name)
	return new("ImageButton", {
		Name = name or "Button", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
		ImageTransparency = 1, ZIndex = 6, AutoButtonColor = false,
	}, parent)
end

-- bouton barre du kit (vert, rouge, or...) avec texte
local function barButton(parent, name, img, label, pos, size, r)
	-- ZIndex 4 : sinon le bouton passe SOUS l'image de fond de la ligne / carte qui le contient
	local f = new("Frame", { Name = name, Position = pos, Size = size, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 4 }, parent)
	if r then ratio(f, r) end
	image(f, "Design", img, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
	text(f, "Label", label, UDim2.fromScale(0.08, 0.14), UDim2.fromScale(0.84, 0.66))
	new("UIScale", { Name = "Pop" }, f)
	hit(f)
	return f
end

local function badge(parent)
	local b = new("Frame", { Name = "Badge", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.88, 0.12), Size = UDim2.fromScale(0.34, 0.34),
		BackgroundColor3 = Color3.fromRGB(255, 50, 70), Visible = false, ZIndex = 8 }, parent)
	ratio(b, 1)
	new("UICorner", { CornerRadius = UDim.new(1, 0) }, b)
	new("UIStroke", { Color = INK, Thickness = 2 }, b)
	text(b, "Label", "!", UDim2.fromScale(0.15, 0.1), UDim2.fromScale(0.7, 0.8), { ZIndex = 9 })
	return b
end

-- ============================================================================ HUD
local hud = new("ScreenGui", { Name = "HUD", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1 }, StarterGui)
pcall(function() hud.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets end)

-- [ haut : argent ]
local top = new("Frame", { Name = "Top", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0.01), Size = UDim2.fromScale(0.34, 0.15), BackgroundTransparency = 1 }, hud)
ratio(top, 3.4)
image(top, "MoneyIcon", "", UDim2.fromScale(0, 0.04), UDim2.fromScale(0.2, 0.62), { Visible = false })
text(top, "Money", "$0", UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.62), { TextColor3 = Color3.fromRGB(120, 255, 90) })
text(top, "Income", "+$0/s", UDim2.fromScale(0.15, 0.6), UDim2.fromScale(0.7, 0.32), { TextColor3 = Color3.fromRGB(255, 255, 255) })
local boosts = new("Frame", { Name = "Boosts", Position = UDim2.fromScale(0, 0.95), Size = UDim2.fromScale(1, 0.3), BackgroundTransparency = 1 }, top)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0.02, 0) }, boosts)
for _, b in ipairs({ { "Money", IMG.BarGreen2, "x2 $" }, { "Luck", IMG.BarLight, "x2 LUCK" } }) do
	local f = new("Frame", { Name = b[1], Size = UDim2.fromScale(0.3, 1), BackgroundTransparency = 1, Visible = false }, boosts)
	image(f, "Design", b[2], UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
	text(f, "Label", b[3] .. " 0s", UDim2.fromScale(0.06, 0.12), UDim2.fromScale(0.88, 0.7))
end

-- [ gauche : 2 colonnes de boutons carrés comme le kit ]
local left = new("Frame", { Name = "Left", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0.01, 0.52), Size = UDim2.fromScale(0.14, 0.5), BackgroundTransparency = 1 }, hud)
ratio(left, 0.62)
new("UIGridLayout", { CellSize = UDim2.fromScale(0.47, 0.3), CellPadding = UDim2.fromScale(0.06, 0.04), SortOrder = Enum.SortOrder.LayoutOrder }, left)
local leftButtons = {
	{ "VIP", IMG.Crown, "VIP", true },
	{ "Daily", IMG.Gift, "Rewards" },
	{ "Index", IMG.Index, "Index" },
	{ "Rebirth", IMG.Rebirth, "Rebirth" },
	{ "Codes", IMG.Pencil, "Codes" },
	{ "Settings", IMG.Gear, "Settings" },
}
for i, b in ipairs(leftButtons) do
	local f = new("Frame", { Name = b[1], BackgroundTransparency = 1, LayoutOrder = i }, left)
	image(f, "Design", b[4] and IMG.SquareOrange or IMG.SquareDark, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
	image(f, "Icon", b[2], UDim2.fromScale(0.1, 0.04), UDim2.fromScale(0.8, 0.8), { ZIndex = 3 })
	ratio(f.Icon, 1)
	text(f, "Label", b[3], UDim2.fromScale(-0.1, 0.72), UDim2.fromScale(1.2, 0.36), { ZIndex = 4 })
	new("UIScale", { Name = "Pop" }, f)
	badge(f)
	hit(f)
end

-- [ bas : Sell / Base / Shop ]
local bottom = new("Frame", { Name = "Bottom", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.985), Size = UDim2.fromScale(0.5, 0.1), BackgroundTransparency = 1 }, hud)
ratio(bottom, 11)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0.03, 0), SortOrder = Enum.SortOrder.LayoutOrder }, bottom)
for i, b in ipairs({ { "Sell", IMG.BarRed, "SELL" }, { "Base", IMG.BarGreen, "BASE" }, { "Shop", IMG.BarLight, "SHOP" } }) do
	local f = barButton(bottom, b[1], b[2], b[3], UDim2.fromScale(0, 0), UDim2.fromScale(0.3, 1), nil)
	f.AnchorPoint = Vector2.new(0, 0)
	f.LayoutOrder = i
	ratio(f, 3.4)
end

-- [ droite : Galaxies / Planètes (icône 3D dans un ViewportFrame) ]
local right = new("Frame", { Name = "Right", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(0.99, 0.5), Size = UDim2.fromScale(0.08, 0.34), BackgroundTransparency = 1 }, hud)
ratio(right, 0.5)
new("UIListLayout", { Padding = UDim.new(0.04, 0), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }, right)
-- icônes dessinées dans Figma (Config/UIAssets) ; tant qu'elles ne sont pas uploadées : modèle 3D
local UIAssets = require(game:GetService("ReplicatedStorage").Shared.Config.UIAssets)
for i, b in ipairs({ { "Galaxies", "Galaxies", UIAssets.IconGalaxies, "0/6" }, { "Planets", "Planets", UIAssets.IconPlanets, "0" } }) do
	local f = new("Frame", { Name = b[1], Size = UDim2.fromScale(1, 0.48), BackgroundTransparency = 1, LayoutOrder = i }, right)
	ratio(f, 1)
	image(f, "Design", IMG.SquareDark, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
	new("ViewportFrame", { Name = "View", Position = UDim2.fromScale(0.08, 0.02), Size = UDim2.fromScale(0.84, 0.78), BackgroundTransparency = 1, ZIndex = 3, LightDirection = Vector3.new(-1, -1, -1), Ambient = Color3.fromRGB(200, 200, 220), Visible = b[3] == 0 }, f)
	image(f, "Icon", b[3] ~= 0 and ("rbxassetid://" .. b[3]) or "", UDim2.fromScale(0.06, -0.02), UDim2.fromScale(0.88, 0.88), { ZIndex = 3, ScaleType = Enum.ScaleType.Fit, Visible = b[3] ~= 0 })
	text(f, "Label", b[2], UDim2.fromScale(-0.15, 0.72), UDim2.fromScale(1.3, 0.34), { ZIndex = 4 })
	text(f, "Count", b[4], UDim2.fromScale(0.5, -0.05), UDim2.fromScale(0.55, 0.28), { ZIndex = 5, TextColor3 = Color3.fromRGB(255, 230, 120) })
	new("UIScale", { Name = "Pop" }, f)
	badge(f)
	hit(f)
end

-- ============================================================================ MENUS
local menus = new("ScreenGui", { Name = "Menus", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 5 }, StarterGui)
pcall(function() menus.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets end)

-- panneau du kit : barre de titre + croix + corps sombre
local function panel(name, title, icon, headerImg, w, r)
	local p = new("Frame", { Name = name, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.52), Size = UDim2.fromScale(w, 0.8), BackgroundTransparency = 1, Visible = false }, menus)
	ratio(p, r)
	new("UIScale", { Name = "Open" }, p)
	local headerH = 0.13
	local body = new("Frame", { Name = "Body", Position = UDim2.fromScale(0, headerH - 0.01), Size = UDim2.fromScale(1, 1 - headerH + 0.01),
		BackgroundColor3 = Color3.fromRGB(52, 66, 82), BackgroundTransparency = 0.08, ZIndex = 1 }, p)
	new("UIStroke", { Color = INK, Thickness = 4 }, body)
	local inner = new("Frame", { Name = "Inner", Position = UDim2.fromScale(0.012, 0.015), Size = UDim2.fromScale(0.976, 0.97), BackgroundTransparency = 1, ZIndex = 1 }, body)
	new("UIStroke", { Color = Color3.fromRGB(150, 170, 185), Thickness = 2, Transparency = 0.3 }, inner)
	new("Frame", { Name = "Content", Position = UDim2.fromScale(0.03, 0.04), Size = UDim2.fromScale(0.94, 0.92), BackgroundTransparency = 1, ZIndex = 2 }, body)
	local header = image(p, "Header", headerImg or IMG.BarHeader, UDim2.fromScale(0, 0), UDim2.fromScale(1, headerH), { ZIndex = 3 })
	image(header, "Icon", icon, UDim2.fromScale(0.02, -0.1), UDim2.fromScale(0.15, 1.2), { ZIndex = 4, ScaleType = Enum.ScaleType.Fit })
	text(header, "Title", title, UDim2.fromScale(0.17, 0.18), UDim2.fromScale(0.55, 0.64), { ZIndex = 4, TextXAlignment = Enum.TextXAlignment.Left })
	local close = new("Frame", { Name = "Close", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(0.985, 0.5), Size = UDim2.fromScale(0.09, 0.88), BackgroundTransparency = 1 }, header)
	ratio(close, 0.92)
	image(close, "Design", IMG.SquarePink, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), { ZIndex = 5 })
	text(close, "X", "X", UDim2.fromScale(0.22, 0.14), UDim2.fromScale(0.56, 0.7), { ZIndex = 6 })
	new("UIScale", { Name = "Pop" }, close)
	hit(close)
	return p, p.Body.Content
end

local function scroller(parent, name, pos, size)
	local s = new("ScrollingFrame", { Name = name, Position = pos, Size = size, BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 6, ScrollBarImageColor3 = Color3.fromRGB(220, 230, 240), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 2 }, parent)
	new("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 6) }, s)
	return s
end

-- carte "barre grise" teintée (couleur de rareté via ImageColor3)
local function card(parent, name, size)
	local c = new("Frame", { Name = name, Size = size, BackgroundTransparency = 1, Visible = false }, parent)
	image(c, "Design", IMG.BarGrey, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
	new("UIScale", { Name = "Pop" }, c)
	return c
end

-- [ GALAXIES : l'enclos ]
do
	local p, c = panel("Galaxies", "INCUBATOR", IMG.Book, nil, 0.5, 1.45)
	text(c, "Slots", "0/6 GALAXIES", UDim2.fromScale(0, 0), UDim2.fromScale(0.45, 0.09), { TextXAlignment = Enum.TextXAlignment.Left })
	text(c, "Queue", "", UDim2.fromScale(0.45, 0.01), UDim2.fromScale(0.55, 0.07), { TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Color3.fromRGB(255, 220, 120) })
	local list = scroller(c, "List", UDim2.fromScale(0, 0.11), UDim2.fromScale(1, 0.72))
	new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	local t = card(list, "Template", UDim2.new(1, 0, 0, 86))
	t.Design.Image = IMG.BarGrey
	new("ViewportFrame", { Name = "View", Position = UDim2.fromScale(0.02, 0.06), Size = UDim2.fromScale(0.16, 0.88), BackgroundTransparency = 1, ZIndex = 3 }, t)
	text(t, "GalaxyName", "Galaxy", UDim2.fromScale(0.2, 0.08), UDim2.fromScale(0.45, 0.34), { TextXAlignment = Enum.TextXAlignment.Left })
	text(t, "Rarity", "COMMON", UDim2.fromScale(0.2, 0.42), UDim2.fromScale(0.3, 0.2), { TextXAlignment = Enum.TextXAlignment.Left })
	local bar = new("Frame", { Name = "Bar", Position = UDim2.fromScale(0.2, 0.66), Size = UDim2.fromScale(0.45, 0.24), BackgroundColor3 = Color3.fromRGB(5, 6, 8), ZIndex = 3 }, t)
	new("UIStroke", { Color = INK, Thickness = 2 }, bar)
	new("Frame", { Name = "Fill", Size = UDim2.fromScale(0.4, 1), BackgroundColor3 = Color3.fromRGB(150, 240, 60), BorderSizePixel = 0, ZIndex = 4 }, bar)
	new("UIGradient", { Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(166, 238, 42)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(106, 240, 122)), ColorSequenceKeypoint.new(1, Color3.fromRGB(166, 238, 42)) }) }, bar.Fill)
	text(bar, "Time", "0s", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), { ZIndex = 5 })
	local hb = barButton(t, "Hatch", IMG.BarGreen, "HATCH", UDim2.fromScale(0.8, 0.3), UDim2.fromScale(0.3, 0.5), nil)
	hb.Position = UDim2.fromScale(0.83, 0.32); hb.Size = UDim2.fromScale(0.3, 0.46)
	local sk = barButton(t, "Skip", IMG.BarGold, "SKIP", UDim2.fromScale(0.83, 0.76), UDim2.fromScale(0.22, 0.36), nil)
	image(sk, "Robux", IMG.Robux, UDim2.fromScale(0.08, 0.12), UDim2.fromScale(0.22, 0.76), { ZIndex = 4, ScaleType = Enum.ScaleType.Fit })
	text(c, "Empty", "Buy galaxies on your spawners!\nThey hatch here into planets.", UDim2.fromScale(0.05, 0.3), UDim2.fromScale(0.9, 0.25), { Visible = false, TextColor3 = Color3.fromRGB(200, 210, 230) })
	barButton(c, "HatchAll", IMG.BarGreen, "HATCH ALL", UDim2.fromScale(0.27, 0.92), UDim2.fromScale(0.42, 0.13), nil)
	local sa = barButton(c, "SkipAll", IMG.BarGold, "SKIP ALL", UDim2.fromScale(0.74, 0.92), UDim2.fromScale(0.42, 0.13), nil)
	image(sa, "Robux", IMG.Robux, UDim2.fromScale(0.05, 0.15), UDim2.fromScale(0.16, 0.7), { ZIndex = 4, ScaleType = Enum.ScaleType.Fit })
end

-- [ PLANÈTES : inventaire ]
do
	local p, c = panel("Planets", "PLANETS", IMG.Index, nil, 0.62, 1.7)
	text(c, "Slots", "EQUIPPED 0/3", UDim2.fromScale(0, 0), UDim2.fromScale(0.3, 0.08), { TextXAlignment = Enum.TextXAlignment.Left })
	text(c, "Total", "+$0/s", UDim2.fromScale(0.3, 0), UDim2.fromScale(0.25, 0.08), { TextColor3 = Color3.fromRGB(120, 255, 90) })
	barButton(c, "EquipBest", IMG.BarGreen, "EQUIP BEST", UDim2.fromScale(0.68, 0.045), UDim2.fromScale(0.2, 0.1), nil)
	barButton(c, "SellAll", IMG.BarRed, "SELL ALL", UDim2.fromScale(0.89, 0.045), UDim2.fromScale(0.2, 0.1), nil)
	local grid = scroller(c, "Grid", UDim2.fromScale(0, 0.11), UDim2.fromScale(0.64, 0.89))
	new("UIGridLayout", { CellSize = UDim2.new(0.235, 0, 0, 120), CellPadding = UDim2.new(0.015, 0, 0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
	local t = card(grid, "Template", UDim2.new(0, 100, 0, 120))
	new("ViewportFrame", { Name = "View", Position = UDim2.fromScale(0.1, 0.06), Size = UDim2.fromScale(0.8, 0.56), BackgroundTransparency = 1, ZIndex = 3 }, t)
	text(t, "PlanetName", "Planet", UDim2.fromScale(0.04, 0.6), UDim2.fromScale(0.92, 0.18))
	text(t, "Income", "$1/s", UDim2.fromScale(0.04, 0.78), UDim2.fromScale(0.92, 0.16), { TextColor3 = Color3.fromRGB(140, 255, 110) })
	text(t, "Mutation", "", UDim2.fromScale(0.04, 0.02), UDim2.fromScale(0.7, 0.15), { TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5 })
	local eq = new("Frame", { Name = "Equipped", AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(0.97, 0.03), Size = UDim2.fromScale(0.24, 0.24), BackgroundColor3 = Color3.fromRGB(70, 220, 90), Visible = false, ZIndex = 5 }, t)
	ratio(eq, 1); new("UICorner", { CornerRadius = UDim.new(0.3, 0) }, eq); new("UIStroke", { Color = INK, Thickness = 2 }, eq)
	text(eq, "Check", "E", UDim2.fromScale(0.15, 0.1), UDim2.fromScale(0.7, 0.8), { ZIndex = 6 })
	text(t, "Lock", "LOCK", UDim2.fromScale(0.04, 0.16), UDim2.fromScale(0.4, 0.12), { Visible = false, TextColor3 = Color3.fromRGB(255, 220, 90), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5 })
	hit(t)
	-- détail de la planète choisie
	local d = new("Frame", { Name = "Detail", Position = UDim2.fromScale(0.66, 0.11), Size = UDim2.fromScale(0.34, 0.89), BackgroundColor3 = Color3.fromRGB(30, 42, 56), BackgroundTransparency = 0.2, ZIndex = 2 }, c)
	new("UIStroke", { Color = INK, Thickness = 3 }, d)
	new("ViewportFrame", { Name = "View", Position = UDim2.fromScale(0.15, 0.02), Size = UDim2.fromScale(0.7, 0.36), BackgroundTransparency = 1, ZIndex = 3 }, d)
	text(d, "PlanetName", "Select a planet", UDim2.fromScale(0.05, 0.38), UDim2.fromScale(0.9, 0.08))
	text(d, "Rarity", "", UDim2.fromScale(0.05, 0.46), UDim2.fromScale(0.9, 0.06))
	text(d, "Mutation", "", UDim2.fromScale(0.05, 0.52), UDim2.fromScale(0.9, 0.05))
	text(d, "Income", "", UDim2.fromScale(0.05, 0.57), UDim2.fromScale(0.9, 0.07), { TextColor3 = Color3.fromRGB(140, 255, 110) })
	barButton(d, "Equip", IMG.BarGreen, "EQUIP", UDim2.fromScale(0.5, 0.71), UDim2.fromScale(0.86, 0.1), nil)
	barButton(d, "Lock", IMG.BarLight, "LOCK", UDim2.fromScale(0.5, 0.82), UDim2.fromScale(0.86, 0.09), nil)
	barButton(d, "Sell", IMG.BarRed, "SELL", UDim2.fromScale(0.5, 0.93), UDim2.fromScale(0.86, 0.09), nil)
	text(c, "Empty", "No planets yet!\nHatch galaxies to get planets.", UDim2.fromScale(0.02, 0.35), UDim2.fromScale(0.6, 0.2), { Visible = false, TextColor3 = Color3.fromRGB(200, 210, 230) })
end

-- [ SHOP ]
do
	local p, c = panel("Shop", "SHOP", IMG.Shop, nil, 0.62, 1.7)
	local tabs = new("Frame", { Name = "Tabs", Size = UDim2.fromScale(0.2, 1), BackgroundTransparency = 1 }, c)
	new("UIListLayout", { Padding = UDim.new(0.02, 0), SortOrder = Enum.SortOrder.LayoutOrder }, tabs)
	for i, tdef in ipairs({ { "Featured", IMG.BarGold }, { "Passes", IMG.BarLight }, { "Boosts", IMG.BarGreen }, { "Cash", IMG.BarGreen2 }, { "Galaxies", IMG.BarRed } }) do
		local f = new("Frame", { Name = tdef[1], Size = UDim2.fromScale(1, 0.15), BackgroundTransparency = 1, LayoutOrder = i }, tabs)
		image(f, "Design", tdef[2], UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
		text(f, "Label", string.upper(tdef[1]), UDim2.fromScale(0.08, 0.15), UDim2.fromScale(0.84, 0.65))
		new("UIScale", { Name = "Pop" }, f)
		hit(f)
	end
	local list = scroller(c, "List", UDim2.fromScale(0.22, 0), UDim2.fromScale(0.78, 1))
	new("UIGridLayout", { CellSize = UDim2.new(0.31, 0, 0, 190), CellPadding = UDim2.new(0.02, 0, 0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	local t = card(list, "Template", UDim2.new(0, 160, 0, 190))
	new("ViewportFrame", { Name = "View", Position = UDim2.fromScale(0.2, 0.05), Size = UDim2.fromScale(0.6, 0.4), BackgroundTransparency = 1, ZIndex = 3 }, t)
	image(t, "Icon", "", UDim2.fromScale(0.25, 0.06), UDim2.fromScale(0.5, 0.38), { ZIndex = 3, ScaleType = Enum.ScaleType.Fit })
	text(t, "ItemName", "Item", UDim2.fromScale(0.05, 0.46), UDim2.fromScale(0.9, 0.13))
	text(t, "Desc", "", UDim2.fromScale(0.06, 0.59), UDim2.fromScale(0.88, 0.15), { TextColor3 = Color3.fromRGB(230, 235, 245), StrokeTh = 0.1 })
	local buy = barButton(t, "Buy", IMG.BarGold, "0", UDim2.fromScale(0.5, 0.86), UDim2.fromScale(0.8, 0.2), nil)
	image(buy, "Robux", IMG.Robux, UDim2.fromScale(0.08, 0.15), UDim2.fromScale(0.2, 0.7), { ZIndex = 4, ScaleType = Enum.ScaleType.Fit })
	local odds = barButton(t, "Odds", IMG.BarLight, "ODDS", UDim2.fromScale(0.82, 0.08), UDim2.fromScale(0.32, 0.12), nil)
	odds.Visible = false
end

-- [ UPGRADES ]
do
	local p, c = panel("Upgrades", "UPGRADES", IMG.Pencil, nil, 0.5, 1.5)
	for i, u in ipairs({ { "Luck", "LUCK" }, { "Spawners", "SPAWNERS" }, { "HatchSpeed", "HATCH SPEED" } }) do
		local row = new("Frame", { Name = u[1], Position = UDim2.fromScale(0, (i - 1) * 0.33), Size = UDim2.fromScale(1, 0.3), BackgroundTransparency = 1 }, c)
		image(row, "Design", IMG.BarGrey, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), { ImageColor3 = Color3.fromRGB(150, 175, 255) })
		text(row, "Title", u[2], UDim2.fromScale(0.04, 0.1), UDim2.fromScale(0.5, 0.3), { TextXAlignment = Enum.TextXAlignment.Left })
		text(row, "Level", "LV 0/10", UDim2.fromScale(0.04, 0.42), UDim2.fromScale(0.3, 0.2), { TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Color3.fromRGB(255, 230, 120) })
		text(row, "Effect", "x1.00 -> x1.15", UDim2.fromScale(0.04, 0.64), UDim2.fromScale(0.55, 0.24), { TextXAlignment = Enum.TextXAlignment.Left })
		local b = barButton(row, "Buy", IMG.BarGreen, "$0", UDim2.fromScale(0.8, 0.5), UDim2.fromScale(0.34, 0.55), nil)
	end
end

-- [ REBIRTH ]
do
	local p, c = panel("Rebirth", "REBIRTH", IMG.Rebirth, nil, 0.42, 1.5)
	text(c, "Before", "x1", UDim2.fromScale(0.05, 0.08), UDim2.fromScale(0.35, 0.22), { TextColor3 = Color3.fromRGB(120, 255, 90) })
	text(c, "Arrow", ">", UDim2.fromScale(0.42, 0.1), UDim2.fromScale(0.16, 0.18))
	text(c, "After", "x1.5", UDim2.fromScale(0.6, 0.08), UDim2.fromScale(0.35, 0.22), { TextColor3 = Color3.fromRGB(120, 255, 90) })
	text(c, "Info", "Money multiplier forever + 1 equip slot.\nYour money resets. You keep your planets!", UDim2.fromScale(0.03, 0.34), UDim2.fromScale(0.94, 0.18), { TextColor3 = Color3.fromRGB(230, 200, 255), StrokeTh = 0.1 })
	local bar = new("Frame", { Name = "Bar", Position = UDim2.fromScale(0.08, 0.56), Size = UDim2.fromScale(0.84, 0.12), BackgroundColor3 = Color3.fromRGB(5, 6, 8), ZIndex = 3 }, c)
	new("UIStroke", { Color = INK, Thickness = 3 }, bar)
	new("Frame", { Name = "Fill", Size = UDim2.fromScale(0.3, 1), BackgroundColor3 = Color3.fromRGB(150, 240, 60), BorderSizePixel = 0, ZIndex = 4 }, bar)
	text(bar, "Label", "$0 / $10M", UDim2.fromScale(0, 0.05), UDim2.fromScale(1, 0.9), { ZIndex = 5 })
	barButton(c, "Do", IMG.BarGreen, "REBIRTH", UDim2.fromScale(0.5, 0.84), UDim2.fromScale(0.6, 0.2), nil)
end

-- [ INDEX ]
do
	local p, c = panel("Index", "INDEX", IMG.Index, nil, 0.62, 1.7)
	local tabs = new("Frame", { Name = "Tabs", Size = UDim2.fromScale(1, 0.1), BackgroundTransparency = 1 }, c)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0.01, 0), SortOrder = Enum.SortOrder.LayoutOrder }, tabs)
	for i, r in ipairs({ "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret" }) do
		local f = new("Frame", { Name = r, Size = UDim2.fromScale(0.158, 1), BackgroundTransparency = 1, LayoutOrder = i }, tabs)
		image(f, "Design", IMG.BarGrey, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
		text(f, "Label", string.upper(r), UDim2.fromScale(0.06, 0.15), UDim2.fromScale(0.88, 0.65))
		new("UIScale", { Name = "Pop" }, f)
		hit(f)
	end
	text(c, "Progress", "0/5 DISCOVERED", UDim2.fromScale(0, 0.12), UDim2.fromScale(0.5, 0.08), { TextXAlignment = Enum.TextXAlignment.Left })
	local cl = barButton(c, "Claim", IMG.BarGold, "CLAIM +5%", UDim2.fromScale(0.84, 0.16), UDim2.fromScale(0.3, 0.1), nil)
	local grid = scroller(c, "Grid", UDim2.fromScale(0, 0.23), UDim2.fromScale(1, 0.77))
	new("UIGridLayout", { CellSize = UDim2.new(0.18, 0, 0, 150), CellPadding = UDim2.new(0.02, 0, 0, 10), SortOrder = Enum.SortOrder.LayoutOrder }, grid)
	local t = card(grid, "Template", UDim2.new(0, 120, 0, 150))
	new("ViewportFrame", { Name = "View", Position = UDim2.fromScale(0.1, 0.05), Size = UDim2.fromScale(0.8, 0.58), BackgroundTransparency = 1, ZIndex = 3 }, t)
	text(t, "Unknown", "?", UDim2.fromScale(0.25, 0.1), UDim2.fromScale(0.5, 0.45), { Visible = false, ZIndex = 4 })
	text(t, "PlanetName", "???", UDim2.fromScale(0.04, 0.64), UDim2.fromScale(0.92, 0.16))
	text(t, "Income", "", UDim2.fromScale(0.04, 0.8), UDim2.fromScale(0.92, 0.14), { TextColor3 = Color3.fromRGB(140, 255, 110) })
	local mut = new("Frame", { Name = "Mutations", Position = UDim2.fromScale(0.06, 0.04), Size = UDim2.fromScale(0.25, 0.5), BackgroundTransparency = 1, ZIndex = 5 }, t)
	new("UIListLayout", { Padding = UDim.new(0.04, 0) }, mut)
	for _, m in ipairs({ { "Golden", Color3.fromRGB(255, 205, 50) }, { "Frozen", Color3.fromRGB(140, 220, 255) }, { "Fire", Color3.fromRGB(255, 110, 30) }, { "Rainbow", Color3.fromRGB(255, 120, 230) } }) do
		local dot = new("Frame", { Name = m[1], Size = UDim2.fromScale(0.6, 0.2), BackgroundColor3 = m[2], BackgroundTransparency = 0.85, ZIndex = 5 }, mut)
		ratio(dot, 1); new("UICorner", { CornerRadius = UDim.new(1, 0) }, dot); new("UIStroke", { Color = INK, Thickness = 1.5 }, dot)
	end
end

-- [ DAILY ]
do
	local p, c = panel("Daily", "DAILY REWARDS", IMG.Gift, nil, 0.6, 1.9)
	local row = new("Frame", { Name = "Days", Size = UDim2.fromScale(1, 0.7), BackgroundTransparency = 1 }, c)
	new("UIGridLayout", { CellSize = UDim2.fromScale(0.235, 0.46), CellPadding = UDim2.fromScale(0.02, 0.06), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center }, row)
	for i = 1, 7 do
		local f = new("Frame", { Name = "Day" .. i, BackgroundTransparency = 1, LayoutOrder = i }, row)
		image(f, "Design", IMG.BarGrey, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1))
		text(f, "Day", "DAY " .. i, UDim2.fromScale(0.05, 0.05), UDim2.fromScale(0.9, 0.22))
		image(f, "Icon", IMG.Gift, UDim2.fromScale(0.3, 0.27), UDim2.fromScale(0.4, 0.4), { ZIndex = 3, ScaleType = Enum.ScaleType.Fit })
		text(f, "Reward", "", UDim2.fromScale(0.05, 0.7), UDim2.fromScale(0.9, 0.24))
		text(f, "Done", "CLAIMED", UDim2.fromScale(0.05, 0.38), UDim2.fromScale(0.9, 0.24), { Visible = false, TextColor3 = Color3.fromRGB(120, 255, 90), ZIndex = 5 })
	end
	text(c, "Timer", "", UDim2.fromScale(0, 0.74), UDim2.fromScale(1, 0.09), { TextColor3 = Color3.fromRGB(255, 220, 120) })
	barButton(c, "Claim", IMG.BarGreen, "CLAIM", UDim2.fromScale(0.5, 0.91), UDim2.fromScale(0.4, 0.15), nil)
end

-- [ CODES ]
do
	local p, c = panel("Codes", "CODES", IMG.Pencil, nil, 0.4, 1.7)
	text(c, "Info", "Enter a code to get free rewards!", UDim2.fromScale(0.05, 0.02), UDim2.fromScale(0.9, 0.16), { TextColor3 = Color3.fromRGB(220, 230, 245) })
	local box = new("Frame", { Name = "Box", Position = UDim2.fromScale(0.08, 0.24), Size = UDim2.fromScale(0.84, 0.25), BackgroundColor3 = Color3.fromRGB(20, 26, 36), ZIndex = 2 }, c)
	new("UIStroke", { Color = INK, Thickness = 3 }, box)
	local tb = new("TextBox", { Name = "Input", Size = UDim2.fromScale(0.94, 0.8), Position = UDim2.fromScale(0.03, 0.1), BackgroundTransparency = 1, FontFace = FONT, TextScaled = true,
		PlaceholderText = "CODE HERE", Text = "", TextColor3 = Color3.new(1, 1, 1), PlaceholderColor3 = Color3.fromRGB(120, 130, 150), ClearTextOnFocus = false, ZIndex = 3 }, box)
	text(c, "Result", "", UDim2.fromScale(0.05, 0.52), UDim2.fromScale(0.9, 0.14), { TextColor3 = Color3.fromRGB(120, 255, 90) })
	barButton(c, "Redeem", IMG.BarGreen, "REDEEM", UDim2.fromScale(0.5, 0.84), UDim2.fromScale(0.55, 0.24), nil)
end

-- [ SETTINGS ]
do
	local p, c = panel("Settings", "SETTINGS", IMG.Gear, nil, 0.4, 1.4)
	for i, s in ipairs({ { "Music", "MUSIC" }, { "Sfx", "SOUND EFFECTS" }, { "LowGfx", "LOW GRAPHICS" }, { "AutoHatch", "AUTO HATCH" } }) do
		local row = new("Frame", { Name = s[1], Position = UDim2.fromScale(0, (i - 1) * 0.25), Size = UDim2.fromScale(1, 0.22), BackgroundTransparency = 1 }, c)
		text(row, "Title", s[2], UDim2.fromScale(0.02, 0.1), UDim2.fromScale(0.6, 0.8), { TextXAlignment = Enum.TextXAlignment.Left })
		barButton(row, "Toggle", IMG.BarGreen, "ON", UDim2.fromScale(0.82, 0.5), UDim2.fromScale(0.32, 0.86), nil)
	end
end

-- [ CHANCES d'une galaxie (obligatoire avant achat Robux) ]
do
	local p, c = panel("Odds", "ODDS", IMG.Book, nil, 0.4, 1.1)
	p.ZIndex = 10
	text(c, "GalaxyName", "Galaxy", UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.1))
	local list = scroller(c, "List", UDim2.fromScale(0, 0.12), UDim2.fromScale(1, 0.88))
	new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	local t = new("Frame", { Name = "Template", Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Visible = false }, list)
	text(t, "PlanetName", "Planet", UDim2.fromScale(0, 0), UDim2.fromScale(0.65, 1), { TextXAlignment = Enum.TextXAlignment.Left })
	text(t, "Chance", "0%", UDim2.fromScale(0.65, 0), UDim2.fromScale(0.35, 1), { TextXAlignment = Enum.TextXAlignment.Right })
end

-- ============================================================================ POPUPS
local pops = new("ScreenGui", { Name = "Popups", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 10, IgnoreGuiInset = true }, StarterGui)

-- notifications (pile en haut)
local notes = new("Frame", { Name = "Notifications", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0.2), Size = UDim2.fromScale(0.5, 0.3), BackgroundTransparency = 1 }, pops)
new("UIListLayout", { Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }, notes)
text(notes, "Template", "Message", UDim2.fromScale(0, 0), UDim2.new(1, 0, 0, 34), { Visible = false })

-- éclosion
do
	local h = new("Frame", { Name = "Hatch", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, Visible = false, ZIndex = 20 }, pops)
	local rays = image(h, "Rays", "rbxassetid://14578914621", UDim2.fromScale(0.5, 0.45), UDim2.fromScale(0.8, 0.8), { AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 21, ImageTransparency = 0.3 })
	ratio(rays, 1)
	new("ViewportFrame", { Name = "View", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.45), Size = UDim2.fromScale(0.36, 0.5), BackgroundTransparency = 1, ZIndex = 22 }, h)
	ratio(h.View, 1)
	text(h, "New", "NEW!", UDim2.fromScale(0.58, 0.18), UDim2.fromScale(0.14, 0.07), { ZIndex = 24, TextColor3 = Color3.fromRGB(255, 230, 60), Rotation = 12 })
	text(h, "Rarity", "COMMON", UDim2.fromScale(0.25, 0.67), UDim2.fromScale(0.5, 0.06), { ZIndex = 23 })
	text(h, "PlanetName", "Planet", UDim2.fromScale(0.2, 0.73), UDim2.fromScale(0.6, 0.1), { ZIndex = 23 })
	text(h, "Mutation", "", UDim2.fromScale(0.3, 0.12), UDim2.fromScale(0.4, 0.07), { ZIndex = 23 })
	text(h, "Income", "+$1/s", UDim2.fromScale(0.3, 0.83), UDim2.fromScale(0.4, 0.06), { ZIndex = 23, TextColor3 = Color3.fromRGB(140, 255, 110) })
	text(h, "Tap", "Tap to continue", UDim2.fromScale(0.35, 0.91), UDim2.fromScale(0.3, 0.04), { ZIndex = 23, TextColor3 = Color3.fromRGB(200, 200, 220) })
	hit(h, "Button").ZIndex = 30
end

-- gains hors ligne
do
	local o = new("Frame", { Name = "Offline", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.36, 0.3), BackgroundTransparency = 1, Visible = false, ZIndex = 15 }, pops)
	ratio(o, 1.8)
	local b = new("Frame", { Name = "Body", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(52, 66, 82), ZIndex = 15 }, o)
	new("UIStroke", { Color = INK, Thickness = 4 }, b)
	image(o, "Header", IMG.BarHeader, UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.24), { ZIndex = 16 })
	text(o.Header, "Title", "WELCOME BACK!", UDim2.fromScale(0.05, 0.15), UDim2.fromScale(0.9, 0.7), { ZIndex = 17 })
	text(o, "Info", "While you were away you earned", UDim2.fromScale(0.05, 0.3), UDim2.fromScale(0.9, 0.14), { ZIndex = 16 })
	text(o, "Amount", "$0", UDim2.fromScale(0.05, 0.45), UDim2.fromScale(0.9, 0.22), { ZIndex = 16, TextColor3 = Color3.fromRGB(120, 255, 90) })
	local ok = barButton(o, "Ok", IMG.BarGreen, "COLLECT", UDim2.fromScale(0.5, 0.84), UDim2.fromScale(0.5, 0.2), nil)
	ok.ZIndex = 16
	for _, d in ipairs(ok:GetDescendants()) do if d:IsA("GuiObject") then d.ZIndex += 15 end end
end

return "GUI construite"
