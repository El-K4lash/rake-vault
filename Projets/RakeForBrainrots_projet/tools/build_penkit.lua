-- tools/build_penkit.lua : à lancer UNE fois dans Studio (Edit) avec les modèles du vault chargés dans workspace.VK.
-- Crée ReplicatedStorage.Assets.PenKit : Fence (panneau de clôture HatchingSim "Secured Fence"), GatePost, Sign (cadre RobotSim).
-- Chaque modèle a un PrimaryPart "Root" invisible : au sol, au centre, axe long = Z local. Les pièces ont un attribut Role
-- (Post / Rail / Accent) pour que PenBuilder applique les couleurs du style de clôture.
local RS = game:GetService("ReplicatedStorage")
local assets = RS:WaitForChild("Assets")
local old = assets:FindFirstChild("PenKit"); if old then old:Destroy() end
local kit = Instance.new("Folder"); kit.Name = "PenKit"

local function normalize(src: Model, name: string): Model
	local m = src:Clone()
	m.Name = name
	local cf, sz = m:GetBoundingBox()
	local rot = cf.Rotation
	if sz.X > sz.Z then rot = rot * CFrame.Angles(0, math.pi / 2, 0); sz = Vector3.new(sz.Z, sz.Y, sz.X) end
	local root = Instance.new("Part")
	root.Name = "Root"; root.Transparency = 1; root.CanCollide = false; root.CanQuery = false; root.CanTouch = false
	root.Anchored = true; root.Size = Vector3.new(0.2, 0.2, 0.2)
	root.CFrame = CFrame.new(cf.Position - Vector3.new(0, sz.Y / 2, 0)) * rot
	root.Parent = m
	m.PrimaryPart = root
	-- on le pose à l'origine, axe long = Z
	m:PivotTo(CFrame.new())
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.Anchored = true; d.CastShadow = true end
		if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
	end
	return m
end

-- 1) clôture
local fence = normalize(workspace.VK.HatchingSim_SecuredFence, "Fence")
for _, p in ipairs(fence:GetDescendants()) do
	if p:IsA("BasePart") and p.Name ~= "Root" then
		local grey = p.Color.R < 0.45 and p.Color.G < 0.45
		p:SetAttribute("Role", grey and "Post" or "Rail")
		p.Material = Enum.Material.SmoothPlastic
		local rel = fence.Root.CFrame:ToObjectSpace(p.CFrame)
		if grey then p:SetAttribute("End", rel.Z > 0 and 1 or -1) end
	end
end
fence.Parent = kit

-- 2) poteau d'entrée (le poteau gris en plus grand)
local gp = Instance.new("Model"); gp.Name = "GatePost"
for _, p in ipairs(fence:GetDescendants()) do
	if p:IsA("BasePart") and p:GetAttribute("Role") == "Post" then
		local c = p:Clone(); c.Size = p.Size * Vector3.new(1.5, 1.45, 1.5); c.CFrame = CFrame.new(0, c.Size.Y / 2, 0)
		c:SetAttribute("End", nil); c.Parent = gp; gp.PrimaryPart = c
		break
	end
end
gp.Parent = kit

-- 3) panneau du propriétaire : cadre RobotSim sans le texte 3D ni le feu
local sign = normalize(workspace.VK.RobotSim_Island1Sign, "Sign")
for _, d in ipairs(sign:GetDescendants()) do
	if d.Name == "ThreeDTextObject" or d.Name == "Fire" then d:Destroy() end
end
local panel
for _, p in ipairs(sign:GetDescendants()) do
	if p:IsA("BasePart") and p.Name ~= "Root" then
		if p.Material == Enum.Material.Neon then
			p:SetAttribute("Role", "Accent")
			if p.Size.Y > 3 then panel = p; p.Name = "Panel" end
		else
			p:SetAttribute("Role", "Post"); p.Material = Enum.Material.SmoothPlastic
		end
	end
end
if panel then
	-- le texte (des deux côtés) ; PenBuilder change juste Text
	for _, face in ipairs({ Enum.NormalId.Right, Enum.NormalId.Left }) do
		local sg = Instance.new("SurfaceGui")
		sg.Name = "OwnerSign"; sg.Face = face; sg.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; sg.PixelsPerStud = 50
		sg.LightInfluence = 0; sg.MaxDistance = 250; sg.Parent = panel
		local t = Instance.new("TextLabel")
		t.Name = "Text"; t.BackgroundTransparency = 1; t.Size = UDim2.fromScale(0.92, 0.78); t.Position = UDim2.fromScale(0.04, 0.11)
		t.TextScaled = true; t.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
		t.TextColor3 = Color3.new(1, 1, 1); t.Text = "Free Pen"; t.Parent = sg
		local st = Instance.new("UIStroke"); st.Thickness = 4; st.Color = Color3.fromRGB(27, 42, 53); st.Parent = t
	end
end
sign.Parent = kit

kit.Parent = assets
return "PenKit ok"
