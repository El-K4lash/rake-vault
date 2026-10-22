-- build_hotbar.lua : barre d'inventaire (1..9) inspirée de lib/systems/CustomHotbar, au style K4 du jeu.
-- Vraies instances dans StarterGui.Hotbar ; Client/HotbarController ne fait que remplir / animer.
local SG = game.StarterGui
local old = SG:FindFirstChild("Hotbar"); if old then old:Destroy() end
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
local SQ = "rbxassetid://71327065275858" -- carré blanc du kit K4 (teinté)
local gui = Instance.new("ScreenGui"); gui.Name = "Hotbar"; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true; gui.DisplayOrder = 2
local bar = Instance.new("Frame"); bar.Name = "Bar"; bar.BackgroundTransparency = 1; bar.AnchorPoint = Vector2.new(0.5, 1)
bar.Position = UDim2.new(0.5, 0, 1, -10); bar.Size = UDim2.fromOffset(9 * 70, 74); bar.Parent = gui
local ll = Instance.new("UIListLayout"); ll.FillDirection = Enum.FillDirection.Horizontal; ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
ll.VerticalAlignment = Enum.VerticalAlignment.Bottom; ll.Padding = UDim.new(0, 6); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = bar
local sc = Instance.new("UIScale"); sc.Name = "Fit"; sc.Parent = bar
local function txt(parent, name, text, pos, size, xa)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Text = text; t.Position = pos; t.Size = size
	t.FontFace = FONT; t.TextScaled = true; t.TextColor3 = Color3.new(1, 1, 1); t.TextXAlignment = xa or Enum.TextXAlignment.Center; t.ZIndex = 4; t.Parent = parent
	local s = Instance.new("UIStroke"); s.Thickness = 2; s.LineJoinMode = Enum.LineJoinMode.Round; s.Parent = t
	return t
end
for i = 1, 9 do
	local b = Instance.new("ImageButton"); b.Name = "Slot" .. i; b.LayoutOrder = i; b.Size = UDim2.fromOffset(64, 64)
	b.BackgroundTransparency = 1; b.Image = SQ; b.ScaleType = Enum.ScaleType.Stretch; b.ImageColor3 = Color3.fromRGB(70, 74, 92)
	b.AutoButtonColor = false; b.Visible = false; b.Parent = bar
	local pop = Instance.new("UIScale"); pop.Name = "Pop"; pop.Parent = b
	local sel = Instance.new("UIStroke"); sel.Name = "Sel"; sel.Thickness = 3; sel.Color = Color3.fromRGB(120, 255, 120)
	sel.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; sel.Enabled = false; sel.Parent = b
	local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 10); c.Parent = b
	local vp = Instance.new("ViewportFrame"); vp.Name = "View"; vp.BackgroundTransparency = 1; vp.Position = UDim2.fromScale(0.03, 0.02)
	vp.Size = UDim2.fromScale(0.94, 0.8); vp.ZIndex = 3; vp.Parent = b
	local key = txt(b, "Key", tostring(i), UDim2.fromScale(0.05, 0.03), UDim2.fromScale(0.3, 0.3), Enum.TextXAlignment.Left)
	key.TextColor3 = Color3.fromRGB(255, 230, 120)
	txt(b, "Count", "", UDim2.fromScale(0.45, 0.03), UDim2.fromScale(0.5, 0.28), Enum.TextXAlignment.Right).TextColor3 = Color3.fromRGB(150, 255, 120)
	txt(b, "ToolName", "", UDim2.fromScale(0.04, 0.74), UDim2.fromScale(0.92, 0.22))
end
gui.Parent = SG
return "Hotbar ok " .. #gui:GetDescendants()
