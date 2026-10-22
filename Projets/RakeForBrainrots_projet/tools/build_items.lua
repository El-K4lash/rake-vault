-- tools/build_items.lua : à lancer UNE fois dans Studio (Edit). Crée ReplicatedStorage.Assets.ItemModels.<ItemId> :
-- le visuel de chaque objet à ratisser (modèles du Rake Vault quand il y en a, sinon fait main en style stud).
-- Pivot de chaque modèle = centre du bas (posé au sol). Taille ≈ Items.Size * 1.6.
local RS = game:GetService("ReplicatedStorage")
local Items = require(RS.Shared.Config.Items)
local V = game.ServerStorage:WaitForChild("Vault")
local old = RS.Assets:FindFirstChild("ItemModels"); if old then old:Destroy() end
local F = Instance.new("Folder"); F.Name = "ItemModels"

local function vault(id)
	for _, f in ipairs(V:GetChildren()) do local m = f:FindFirstChild(id); if m then return m:Clone() end end
	error("vault: " .. id)
end
local function P(m, size, cf, color, opt)
	opt = opt or {}
	local p = Instance.new("Part")
	p.Size = size; p.CFrame = cf; p.Color = color
	p.Material = opt.neon and Enum.Material.Neon or (opt.glass and Enum.Material.Glass or Enum.Material.SmoothPlastic)
	if opt.shape then p.Shape = opt.shape end
	if opt.t then p.Transparency = opt.t end
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	p.Anchored = true; p.Parent = m
	return p
end
local BALL, CYL = Enum.PartType.Ball, Enum.PartType.Cylinder
local A = CFrame.Angles
local R = math.rad

-- met le modèle à la bonne taille (plus grande dimension = target) et le pivot au centre du bas
local function finish(m, id, target)
	local _, sz = m:GetBoundingBox()
	local k = target / math.max(sz.X, sz.Y, sz.Z)
	m:ScaleTo(m:GetScale() * k)
	local cf, s2 = m:GetBoundingBox()
	m.WorldPivot = CFrame.new(cf.Position - Vector3.new(0, s2.Y / 2, 0))
	m:PivotTo(CFrame.new())
	-- pas d'herbe/socle du vault
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false; d.CastShadow = true end
	end
	m.Name = id
	m.Parent = F
end

-- enlève les touffes d'herbe / socle vert que le vault met parfois au pied des modèles
local function stripGrass(m)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then
			local h, s, v = d.Color:ToHSV()
			if h > 0.2 and h < 0.4 and s > 0.5 and d.Position.Y < 0.6 and d.Size.Y < 1.2 then d:Destroy() end
		end
	end
end

local B = {}
-- ===== Beach =====
B.Can = function(m)
	P(m, Vector3.new(2.2, 1.3, 1.3), CFrame.new(0, 0.65, 0) * A(0, 0, 0) , Color3.fromRGB(210, 50, 60), { shape = CYL })
	P(m, Vector3.new(0.12, 1.32, 1.32), CFrame.new(1.1, 0.65, 0), Color3.fromRGB(200, 205, 215), { shape = CYL })
	P(m, Vector3.new(0.12, 1.32, 1.32), CFrame.new(-1.1, 0.65, 0), Color3.fromRGB(200, 205, 215), { shape = CYL })
	P(m, Vector3.new(0.7, 1.34, 1.34), CFrame.new(0.2, 0.65, 0), Color3.new(1, 1, 1), { shape = CYL })
	P(m, Vector3.new(0.2, 0.5, 0.9), CFrame.new(-0.6, 1.25, 0) * A(R(25), 0, 0), Color3.fromRGB(170, 35, 45)) -- bosse
end
B.Bottle = function(m)
	P(m, Vector3.new(2.0, 1.1, 1.1), CFrame.new(-0.2, 0.55, 0), Color3.fromRGB(120, 200, 240), { shape = CYL, glass = true, t = 0.35 })
	P(m, Vector3.new(0.5, 0.7, 0.7), CFrame.new(1.0, 0.55, 0), Color3.fromRGB(120, 200, 240), { shape = CYL, glass = true, t = 0.35 })
	P(m, Vector3.new(0.3, 0.55, 0.55), CFrame.new(1.35, 0.55, 0), Color3.fromRGB(30, 110, 230), { shape = CYL })
	P(m, Vector3.new(0.8, 1.13, 1.13), CFrame.new(-0.3, 0.55, 0), Color3.new(1, 1, 1), { shape = CYL })
	P(m, Vector3.new(0.5, 1.14, 1.14), CFrame.new(-0.3, 0.55, 0), Color3.fromRGB(255, 80, 80), { shape = CYL })
end
B.Shell = function(m)
	local c1, c2 = Color3.fromRGB(255, 214, 196), Color3.fromRGB(255, 160, 150)
	for i = -3, 3 do
		P(m, Vector3.new(0.38, 0.35, 1.7), CFrame.new(0, 0.2, 0.2) * A(0, R(i * 17), 0) * CFrame.new(0, 0, -0.75) * A(R(-8), 0, 0), i % 2 == 0 and c1 or c2)
	end
	P(m, Vector3.new(0.7, 0.4, 0.5), CFrame.new(0, 0.2, 0.75), c2)
	P(m, Vector3.new(0.5, 0.25, 0.3), CFrame.new(0, 0.2, 1.05), c1)
end
B.Boot = function(m)
	local br, dk = Color3.fromRGB(125, 82, 45), Color3.fromRGB(70, 45, 25)
	P(m, Vector3.new(1.0, 0.3, 2.2), CFrame.new(0, 0.15, 0.2), dk)
	P(m, Vector3.new(1.0, 0.8, 1.6), CFrame.new(0, 0.7, 0.45), br)
	P(m, Vector3.new(1.0, 1.9, 1.0), CFrame.new(0, 1.25, -0.4), br)
	P(m, Vector3.new(1.05, 0.25, 1.05), CFrame.new(0, 2.1, -0.4), dk)
	for i = 0, 2 do P(m, Vector3.new(1.06, 0.1, 0.12), CFrame.new(0, 1.0 + i * 0.32, 0.12), Color3.fromRGB(240, 220, 170)) end
end
B.Pearl = function(m)
	local sh = Color3.fromRGB(150, 120, 190)
	P(m, Vector3.new(0.3, 2.0, 2.0), CFrame.new(0, 0.15, 0) * A(0, 0, R(90)), sh, { shape = CYL })
	P(m, Vector3.new(0.3, 2.0, 2.0), CFrame.new(0, 0.85, -0.55) * A(R(-55), 0, 0) * A(0, 0, R(90)), sh, { shape = CYL })
	P(m, Vector3.new(0.9, 0.9, 0.9), CFrame.new(0, 0.7, 0.1), Color3.fromRGB(250, 245, 255), { shape = BALL, neon = true })
end
-- ===== Swamp =====
B.Frog = function(m)
	local g, g2 = Color3.fromRGB(90, 210, 80), Color3.fromRGB(60, 160, 60)
	P(m, Vector3.new(1.6, 0.9, 1.8), CFrame.new(0, 0.55, 0), g)
	P(m, Vector3.new(1.4, 0.7, 1.0), CFrame.new(0, 1.05, 0.55), g)
	for _, sx in ipairs({ -1, 1 }) do
		P(m, Vector3.new(0.5, 0.5, 0.5), CFrame.new(sx * 0.45, 1.5, 0.75), Color3.new(1, 1, 1))
		P(m, Vector3.new(0.25, 0.3, 0.1), CFrame.new(sx * 0.45, 1.5, 1.0), Color3.new(0.05, 0.05, 0.05))
		P(m, Vector3.new(0.5, 0.4, 1.0), CFrame.new(sx * 0.95, 0.25, -0.35), g2)
		P(m, Vector3.new(0.35, 0.3, 0.5), CFrame.new(sx * 0.8, 0.15, 0.85), g2)
	end
	P(m, Vector3.new(0.9, 0.1, 0.1), CFrame.new(0, 0.82, 1.06), Color3.fromRGB(40, 90, 40))
end
B.Lilypad = function(m)
	P(m, Vector3.new(0.2, 2.6, 2.6), CFrame.new(0, 0.1, 0) * A(0, 0, R(90)), Color3.fromRGB(60, 170, 70), { shape = CYL })
	P(m, Vector3.new(0.22, 2.0, 2.0), CFrame.new(0, 0.11, 0) * A(0, 0, R(90)), Color3.fromRGB(80, 195, 85), { shape = CYL })
	P(m, Vector3.new(0.9, 0.24, 0.35), CFrame.new(0.75, 0.12, 0), Color3.fromRGB(60, 140, 200)) -- encoche (eau)
	for i = 0, 4 do P(m, Vector3.new(0.35, 0.5, 0.2), CFrame.new(-0.3, 0.42, -0.2) * A(0, R(i * 72), 0) * CFrame.new(0, 0, -0.22) * A(R(-30), 0, 0), Color3.fromRGB(255, 140, 200)) end
	P(m, Vector3.new(0.25, 0.25, 0.25), CFrame.new(-0.3, 0.55, -0.2), Color3.fromRGB(255, 230, 90), { shape = BALL, neon = true })
end
-- ===== Volcano =====
B.Ember = function(m)
	local rk = Color3.fromRGB(55, 40, 40)
	P(m, Vector3.new(1.4, 1.0, 1.2), CFrame.new(0, 0.5, 0) * A(0, R(20), R(8)), rk)
	P(m, Vector3.new(0.9, 0.8, 0.9), CFrame.new(0.5, 0.75, 0.3) * A(R(15), R(40), 0), rk)
	P(m, Vector3.new(1.42, 0.12, 0.2), CFrame.new(0, 0.7, 0.3) * A(0, R(20), R(20)), Color3.fromRGB(255, 120, 30), { neon = true })
	P(m, Vector3.new(0.12, 0.6, 0.6), CFrame.new(-0.55, 0.6, 0) * A(R(30), R(20), 0), Color3.fromRGB(255, 170, 40), { neon = true })
	P(m, Vector3.new(0.5, 0.5, 0.5), CFrame.new(0.1, 1.1, -0.2), Color3.fromRGB(255, 120, 30), { shape = BALL, neon = true })
end
-- ===== Ice =====
B.IceCube = function(m)
	P(m, Vector3.new(1.7, 1.7, 1.7), CFrame.new(0, 0.85, 0) * A(0, R(15), 0), Color3.fromRGB(190, 235, 255), { glass = true, t = 0.3 })
	P(m, Vector3.new(1.0, 1.0, 1.0), CFrame.new(0, 0.85, 0) * A(R(10), R(40), 0), Color3.new(1, 1, 1), { t = 0.4 })
	P(m, Vector3.new(1.75, 0.15, 1.75), CFrame.new(0, 1.72, 0) * A(0, R(15), 0), Color3.fromRGB(240, 250, 255))
end
B.Snowball = function(m)
	P(m, Vector3.new(1.6, 1.6, 1.6), CFrame.new(0, 0.8, 0), Color3.fromRGB(250, 252, 255), { shape = BALL })
	P(m, Vector3.new(0.6, 0.6, 0.6), CFrame.new(0.9, 0.3, 0.3), Color3.fromRGB(240, 246, 255), { shape = BALL })
	P(m, Vector3.new(0.45, 0.45, 0.45), CFrame.new(-0.7, 0.22, -0.6), Color3.fromRGB(235, 243, 255), { shape = BALL })
end
-- ===== Void =====
B.Stardust = function(m)
	P(m, Vector3.new(1.6, 0.35, 1.6), CFrame.new(0, 0.17, 0), Color3.fromRGB(120, 70, 170), { shape = BALL })
	local cols = { Color3.fromRGB(240, 200, 255), Color3.fromRGB(150, 220, 255), Color3.fromRGB(255, 240, 160) }
	for i = 1, 9 do
		local a = i * 2.4
		local r = 0.25 + (i % 3) * 0.22
		P(m, Vector3.new(0.3, 0.3, 0.3), CFrame.new(math.cos(a) * r, 0.35 + (i % 4) * 0.12, math.sin(a) * r), cols[i % 3 + 1], { shape = BALL, neon = true })
	end
end
B.Asteroid = function(m)
	local c, d = Color3.fromRGB(110, 92, 130), Color3.fromRGB(70, 58, 85)
	P(m, Vector3.new(1.9, 1.7, 1.8), CFrame.new(0, 0.85, 0), c, { shape = BALL })
	P(m, Vector3.new(0.6, 0.6, 0.6), CFrame.new(0.55, 1.35, 0.6), d, { shape = BALL })
	P(m, Vector3.new(0.5, 0.5, 0.5), CFrame.new(-0.7, 0.9, 0.55), d, { shape = BALL })
	P(m, Vector3.new(0.45, 0.45, 0.45), CFrame.new(0.2, 0.6, -0.85), d, { shape = BALL })
	P(m, Vector3.new(0.3, 0.3, 0.3), CFrame.new(-0.4, 1.55, -0.3), Color3.fromRGB(220, 140, 255), { shape = BALL, neon = true })
end
B.BlackHole = function(m)
	P(m, Vector3.new(1.4, 1.4, 1.4), CFrame.new(0, 1.0, 0), Color3.fromRGB(8, 4, 16), { shape = BALL })
	P(m, Vector3.new(0.12, 2.6, 2.6), CFrame.new(0, 1.0, 0) * A(0, 0, R(90)) * A(R(18), 0, 0), Color3.fromRGB(200, 90, 255), { shape = CYL, neon = true, t = 0.15 })
	P(m, Vector3.new(0.14, 2.0, 2.0), CFrame.new(0, 1.0, 0) * A(0, 0, R(90)) * A(R(18), 0, 0), Color3.fromRGB(255, 160, 255), { shape = CYL, neon = true, t = 0.3 })
	P(m, Vector3.new(1.55, 1.55, 1.55), CFrame.new(0, 1.0, 0), Color3.fromRGB(150, 60, 255), { shape = BALL, neon = true, t = 0.75 })
end

-- ===== modèles du vault =====
local FROM = {
	Coin = "general_coins", Mushroom = "biomes_swamp_sp_mushrooms", Obsidian = "biomes_volcano_sp_obsidian",
	FireOpal = "general_gem_ruby", Crystal = "biomes_ice_crystal", FrozenGem = "general_gem_diamond",
	Nebula = "biomes_void_crystal", Chest = "general_chest_gold",
	RuneGreen = "general_gem_emerald", RuneRed = "general_gem_ruby", RuneBlue = "general_gem_sapphire", RunePurple = "general_gem_amethyst",
}

local out = {}
for id, def in pairs(Items.ById) do
	local m
	if FROM[id] then
		m = vault(FROM[id]); stripGrass(m)
		if string.find(FROM[id], "gem_") then
			-- les gemmes du vault sont posées sur un rocher gris : on ne garde que la pierre précieuse
			for _, d in ipairs(m:GetChildren()) do
				if d:IsA("BasePart") then local _, s, v = d.Color:ToHSV(); if s < 0.2 and v < 0.9 and d.Position.Y < 1.6 then d:Destroy() end end
			end
		end
	elseif B[id] then
		m = Instance.new("Model"); B[id](m)
	end
	if m then
		local target = def.Size * (def.Kind == "Rune" and 1.5 or def.Kind == "Rare" and 1.7 or 1.6)
		finish(m, id, target)
		local n = 0; for _, d in ipairs(m:GetDescendants()) do if d:IsA("BasePart") then n += 1 end end
		table.insert(out, id .. "=" .. n)
	else
		table.insert(out, id .. "=MISSING")
	end
end
F.Parent = RS.Assets
return table.concat(out, " ")
