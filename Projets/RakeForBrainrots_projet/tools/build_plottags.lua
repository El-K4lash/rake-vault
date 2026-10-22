-- tools/build_plottags.lua : étiquettes des bases (vraies instances, style K4). À lancer UNE fois (Edit).
-- StarterGui.PlotTags.Templates :
--   * Tag        : BillboardGui au-dessus du portail de chaque base : tête du joueur + pseudo ;
--                  sur SA base : "YOUR BASE" en vert + flèche qui rebondit
--   * BoardCover : SurfaceGui posé sur les panneaux UPGRADES / MY STATS des bases DES AUTRES (sinon ils sont vides) :
--                  tête du propriétaire + "<pseudo>'s PEN"
-- Remplis / posés par Client/PlotTagController.
local SG = game:GetService("StarterGui")
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
local function P(x, y) return UDim2.fromScale(x, y) end
local function corner(o, r) local c = Instance.new("UICorner"); c.CornerRadius = r; c.Parent = o end
local function txt(parent, name, text, pos, size, color, th)
	local t = Instance.new("TextLabel"); t.Name = name; t.BackgroundTransparency = 1; t.Text = text; t.Position = pos; t.Size = size
	t.FontFace = FONT; t.TextScaled = true; t.TextColor3 = color or Color3.new(1, 1, 1); t.Parent = parent
	local s = Instance.new("UIStroke"); s.Color = Color3.new(0, 0, 0); s.Thickness = th or 3; s.LineJoinMode = Enum.LineJoinMode.Round; s.Parent = t
	return t
end

local old = SG:FindFirstChild("PlotTags"); if old then old:Destroy() end
local gui = Instance.new("ScreenGui"); gui.Name = "PlotTags"; gui.ResetOnSpawn = false; gui.Enabled = true
local T = Instance.new("Folder"); T.Name = "Templates"; T.Parent = gui

-- [ Tag ] --------------------------------------------------------------------------
-- taille en studs (rapetisse avec la distance), visible jusqu'à 120 studs
local bb = Instance.new("BillboardGui"); bb.Name = "Tag"; bb.Enabled = false; bb.Size = UDim2.fromScale(7, 4.6)
bb.AlwaysOnTop = true; bb.LightInfluence = 0; bb.MaxDistance = 120; bb.ResetOnSpawn = false; bb.Parent = T
local holder = Instance.new("Frame"); holder.Name = "Holder"; holder.BackgroundTransparency = 1; holder.Size = P(1, 1); holder.Parent = bb
local av = Instance.new("ImageLabel"); av.Name = "Avatar"; av.BackgroundColor3 = Color3.fromRGB(40, 50, 90); av.AnchorPoint = Vector2.new(0.5, 0)
av.Position = P(0.5, 0); av.Size = P(0.4, 0.58); av.Image = ""; av.Parent = holder
corner(av, UDim.new(1, 0))
local ar = Instance.new("UIAspectRatioConstraint"); ar.AspectRatio = 1; ar.Parent = av
local st = Instance.new("UIStroke"); st.Name = "Ring"; st.Thickness = 4; st.Color = Color3.fromRGB(255, 255, 255); st.Parent = av
txt(holder, "Title", "Player", P(0, 0.58), P(1, 0.25), Color3.new(1, 1, 1), 3)
txt(holder, "Sub", "", P(0.15, 0.82), P(0.7, 0.16), Color3.fromRGB(200, 210, 230), 2)

-- [ BoardCover ] -------------------------------------------------------------------
local sg = Instance.new("SurfaceGui"); sg.Name = "BoardCover"; sg.Enabled = false; sg.Face = Enum.NormalId.Front
sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 50; sg.LightInfluence = 0; sg.MaxDistance = 150
sg.ResetOnSpawn = false; sg.Parent = T
local bg = Instance.new("Frame"); bg.Name = "Bg"; bg.Size = P(1, 1); bg.BackgroundColor3 = Color3.fromRGB(22, 30, 54); bg.Parent = sg
local g = Instance.new("UIGradient"); g.Rotation = 90
g.Color = ColorSequence.new(Color3.fromRGB(40, 54, 96), Color3.fromRGB(18, 24, 44)); g.Parent = bg
local cav = Instance.new("ImageLabel"); cav.Name = "Avatar"; cav.BackgroundColor3 = Color3.fromRGB(50, 64, 110); cav.AnchorPoint = Vector2.new(0.5, 0)
cav.Position = P(0.5, 0.1); cav.Size = P(0.5, 0.5); cav.Parent = bg
corner(cav, UDim.new(1, 0))
local car = Instance.new("UIAspectRatioConstraint"); car.AspectRatio = 1; car.Parent = cav
local cs = Instance.new("UIStroke"); cs.Thickness = 6; cs.Color = Color3.fromRGB(255, 197, 49); cs.Parent = cav
txt(bg, "Title", "Player's PEN", P(0.05, 0.64), P(0.9, 0.18), Color3.fromRGB(255, 214, 74), 4)
txt(bg, "Sub", "UPGRADES", P(0.15, 0.82), P(0.7, 0.12), Color3.fromRGB(200, 210, 230), 3)

gui.Parent = SG
return "PlotTags ok"
