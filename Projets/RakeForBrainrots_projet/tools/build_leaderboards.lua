-- tools/build_leaderboards.lua : panneaux de classement du lobby (TOP EARNERS / TOP REBIRTHS) au style du jeu
-- (studs, piliers bleu marine + bagues dorées comme les arches des biomes, en-tête et lignes du kit K4).
-- À lancer UNE fois dans Studio (Edit). Remplace Hub.MoneyLeaderboard / Hub.RebirthsLeaderboard AU MÊME ENDROIT
-- (les panneaux déplacés à la main gardent leur place et leur orientation).
-- Rempli par LeaderboardService : ... "List" > Row1..Row10 > PName / Value / Avatar.
local hub = workspace.Map.Hub
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
local function A(id) return "rbxassetid://" .. tostring(id) end
local NAVY, NAVY2, GOLD = Color3.fromHex("1B2A35"), Color3.fromHex("2E4556"), Color3.fromHex("FFC531")
local K = { hOrange = 73937030672143, hPurple = 76850939570356, iMoney = 103944045008759, iRebirth = 102040339566414,
	rowBlue = 123473196299883, boxYellow = 109714672458221, sqWhite = 71327065275858, sqOrange = 131912983081579 }

local BOARDS = {
	{ Name = "MoneyLeaderboard", Title = "TOP EARNERS", Header = K.hOrange, Icon = K.iMoney, Accent = Color3.fromRGB(255, 200, 40) },
	{ Name = "RebirthsLeaderboard", Title = "TOP REBIRTHS", Header = K.hPurple, Icon = K.iRebirth, Accent = Color3.fromRGB(190, 110, 255) },
}

local STUD = Enum.SurfaceType.Studs
local function part(m, name, size, cf, color, mat, studs)
	local p = Instance.new("Part"); p.Name = name; p.Anchored = true; p.Size = size; p.CFrame = cf; p.Color = color
	p.Material = mat or Enum.Material.Plastic; p.CanTouch = false
	if studs then p.TopSurface = STUD; p.FrontSurface = STUD; p.BackSurface = STUD; p.LeftSurface = STUD; p.RightSurface = STUD
	else p.TopSurface = Enum.SurfaceType.Smooth end
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = m
	return p
end
local function txt(parent, name, text, pos, size, color, xa)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Text = text; t.Position = pos; t.Size = size
	t.FontFace = FONT; t.TextScaled = true; t.TextColor3 = color or Color3.new(1, 1, 1); t.TextXAlignment = xa or Enum.TextXAlignment.Center
	t.Parent = parent
	local s = Instance.new("UIStroke"); s.Color = Color3.new(0, 0, 0); s.Thickness = 3; s.LineJoinMode = Enum.LineJoinMode.Round; s.Parent = t
	return t
end
local function corner(o, r) local c = Instance.new("UICorner"); c.CornerRadius = r; c.Parent = o end

local out = {}
for _, def in ipairs(BOARDS) do
	local old = hub:FindFirstChild(def.Name)
	local cf0, origin, front
	if old then
		local bcf, bsz = old:GetBoundingBox()
		front = Vector3.new(bcf.LookVector.X, 0, bcf.LookVector.Z).Unit
		origin = Vector3.new(bcf.Position.X, bcf.Position.Y - bsz.Y / 2, bcf.Position.Z)
		old:Destroy()
	else
		front = Vector3.new(0, 0, 1); origin = Vector3.new(-40, 0.2, -34)
	end
	-- repère local : face avant du panneau = -Z local (LookVector = vers le joueur)
	cf0 = CFrame.lookAt(origin, origin + front)
	local L = function(x, y, z) return cf0 * CFrame.new(x, y, z) end
	local m = Instance.new("Model"); m.Name = def.Name

	-- socle à 2 marches
	part(m, "Base", Vector3.new(13, 1, 5), L(0, 0.5, 0), NAVY, nil, true)
	part(m, "Step", Vector3.new(12, 0.4, 4.4), L(0, 1.2, 0), NAVY2, nil, true)
	part(m, "Trim", Vector3.new(13.2, 0.25, 5.2), L(0, 1.0, 0), GOLD)
	-- piliers (comme les arches des biomes) : bagues dorées, chapeau, cube lumineux
	for _, sx in ipairs({ -5.6, 5.6 }) do
		part(m, "Pillar", Vector3.new(1.8, 16.6, 1.8), L(sx, 1.4 + 8.3, 0), NAVY, nil, true)
		for _, y in ipairs({ 4.5, 11.5 }) do part(m, "Band", Vector3.new(2.05, 0.45, 2.05), L(sx, y, 0), GOLD) end
		part(m, "Cap", Vector3.new(2.4, 0.6, 2.4), L(sx, 18.3, 0), NAVY, nil, true)
		local glow = part(m, "Glow", Vector3.new(1.1, 1.1, 1.1), L(sx, 19.15, 0), def.Accent, Enum.Material.Neon)
		glow.CFrame = glow.CFrame * CFrame.Angles(0, math.rad(45), 0)
	end
	-- panneau : fond bleu marine à studs + cadre doré
	part(m, "Backing", Vector3.new(9.6, 15.6, 0.8), L(0, 9.9, 0.25), NAVY, nil, true)
	part(m, "FrameTop", Vector3.new(9.8, 0.4, 0.5), L(0, 17.5, -0.2), GOLD)
	part(m, "FrameBottom", Vector3.new(9.8, 0.4, 0.5), L(0, 2.2, -0.2), GOLD)
	part(m, "FrameL", Vector3.new(0.4, 15.7, 0.5), L(-4.7, 9.85, -0.2), GOLD)
	part(m, "FrameR", Vector3.new(0.4, 15.7, 0.5), L(4.7, 9.85, -0.2), GOLD)
	-- couronne en blocs au sommet
	local cy = 18.9
	part(m, "CrownBase", Vector3.new(3.2, 0.7, 1.0), L(0, cy, 0.1), GOLD)
	for i, x in ipairs({ -1.25, 0, 1.25 }) do
		local h = i == 2 and 1.5 or 1.1
		part(m, "CrownSpike", Vector3.new(0.6, h, 0.8), L(x, cy + 0.35 + h / 2, 0.1), GOLD)
		part(m, "CrownGem", Vector3.new(0.35, 0.35, 0.2), L(x, cy + 0.35 + h - 0.25, -0.35), i == 2 and def.Accent or Color3.fromRGB(255, 70, 90), Enum.Material.Neon)
	end

	-- en-tête : bandeau K4 + icône + titre
	local title = part(m, "LeaderboardTItle", Vector3.new(9.2, 2.0, 0.2), L(0, 16.2, -0.35), NAVY)
	local sgT = Instance.new("SurfaceGui"); sgT.Face = Enum.NormalId.Front; sgT.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	sgT.PixelsPerStud = 50; sgT.LightInfluence = 0; sgT.MaxDistance = 150; sgT.Parent = title
	local head = Instance.new("ImageLabel"); head.Name = "Header"; head.BackgroundTransparency = 1; head.Image = A(def.Header)
	head.ScaleType = Enum.ScaleType.Stretch; head.Size = UDim2.fromScale(1, 1); head.Parent = sgT
	local ic = Instance.new("ImageLabel"); ic.Name = "Icon"; ic.BackgroundTransparency = 1; ic.Image = A(def.Icon)
	ic.Position = UDim2.fromScale(0.02, 0.06); ic.Size = UDim2.fromScale(0.17, 0.88); ic.Parent = head
	local ar = Instance.new("UIAspectRatioConstraint"); ar.AspectRatio = 1; ar.Parent = ic
	txt(head, "Title", def.Title, UDim2.fromScale(0.2, 0.18), UDim2.fromScale(0.76, 0.64), Color3.new(1, 1, 1), Enum.TextXAlignment.Left)

	-- écran du classement : la liste (100 joueurs, défilable) est un SurfaceGui de StarterGui (LbBoard_<clé>),
	-- posé sur cette pièce par Client/LbBoardController (un SurfaceGui ne reçoit la molette / le doigt que dans le PlayerGui)
	part(m, "Leaderboard", Vector3.new(8.9, 12.9, 0.2), L(0, 8.45, -0.3), Color3.fromRGB(16, 22, 44))
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.CanCollide = d.Name == "Base" or d.Name == "Step" or d.Name == "Pillar" or d.Name == "Backing" end
	end
	m.PrimaryPart = m:FindFirstChild("Base")
	m.Parent = hub

	-- [ liste défilable : StarterGui.LbBoard_<clé> ] ------------------------------------------
	local key = def.Name == "MoneyLeaderboard" and "Money" or "Rebirths"
	local oldG = game.StarterGui:FindFirstChild("LbBoard_" .. key); if oldG then oldG:Destroy() end
	local sg = Instance.new("SurfaceGui"); sg.Name = "LbBoard_" .. key; sg.Face = Enum.NormalId.Front; sg.ResetOnSpawn = false
	sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 40; sg.LightInfluence = 0; sg.MaxDistance = 150
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local list = Instance.new("ScrollingFrame"); list.Name = "List"; list.BackgroundTransparency = 1; list.BorderSizePixel = 0
	list.Position = UDim2.fromScale(0.03, 0.02); list.Size = UDim2.fromScale(0.94, 0.96); list.Active = true
	list.ScrollBarThickness = 10; list.ScrollBarImageColor3 = Color3.fromRGB(255, 197, 49); list.ScrollingDirection = Enum.ScrollingDirection.Y
	list.AutomaticCanvasSize = Enum.AutomaticSize.Y; list.CanvasSize = UDim2.new(); list.ElasticBehavior = Enum.ElasticBehavior.Always
	list.Parent = sg
	local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0, 5); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = list
	local pad = Instance.new("UIPadding"); pad.PaddingRight = UDim.new(0, 14); pad.Parent = list
	local RANK = { Color3.fromRGB(255, 197, 49), Color3.fromRGB(205, 215, 230), Color3.fromRGB(230, 140, 70) }
	for i = 1, 100 do
		local row = Instance.new("ImageLabel"); row.Name = "Row" .. i; row.LayoutOrder = i; row.BackgroundTransparency = 1
		row.Image = A(K.sqWhite); row.ImageColor3 = RANK[i] or Color3.fromRGB(58, 74, 140)
		row.ScaleType = Enum.ScaleType.Stretch; row.Size = UDim2.new(1, 0, 0, 44); row.Parent = list
		local badge = Instance.new("Frame"); badge.Name = "Badge"; badge.BackgroundColor3 = i <= 3 and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(20, 26, 50)
		badge.Position = UDim2.fromOffset(5, 5); badge.Size = UDim2.fromOffset(34, 34); badge.Parent = row
		corner(badge, UDim.new(1, 0))
		txt(badge, "Rank", tostring(i), UDim2.fromScale(0.12, 0.18), UDim2.fromScale(0.76, 0.64), i == 1 and Color3.fromRGB(255, 214, 74) or Color3.new(1, 1, 1))
		local av = Instance.new("ImageLabel"); av.Name = "Avatar"; av.BackgroundColor3 = Color3.fromRGB(40, 50, 90); av.Image = ""
		av.Position = UDim2.fromOffset(43, 4); av.Size = UDim2.fromOffset(36, 36); av.Parent = row
		corner(av, UDim.new(1, 0))
		txt(row, "PName", i == 1 and "No data yet" or "-", UDim2.new(0, 84, 0.2, 0), UDim2.new(0.6, -84, 0.6, 0), Color3.new(1, 1, 1), Enum.TextXAlignment.Left)
		txt(row, "Value", "", UDim2.new(0.6, 0, 0.2, 0), UDim2.new(0.38, 0, 0.6, 0), Color3.fromRGB(140, 255, 140), Enum.TextXAlignment.Right)
	end
	sg.Parent = game.StarterGui
	table.insert(out, def.Name .. " @ " .. tostring(origin))
end
return table.concat(out, " | ")
