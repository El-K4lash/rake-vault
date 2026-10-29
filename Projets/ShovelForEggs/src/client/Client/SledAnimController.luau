--!strict
-- Client/SledAnimController : anime TOUS les traîneaux visibles (le sien et ceux des autres), 100 % visuel.
--   * le traîneau suit vraiment le sol : hauteur et pente lues au raycast (rampes, bosses), il ne flotte plus
--   * il traîne en virage (retard de lacet), se balance un peu quand on court, s'arrête doucement
--   * corde entre la main gauche et l'avant du traîneau (Beam qui pend)
--   * gerbes de neige derrière les patins + traces dans la neige quand il glisse
--   * chargement : chaque nouveau morceau tombe dans le traîneau avec un petit "pouf"
--   * apparition (entrée dans une zone) / nouveau traîneau acheté : nuage de neige + étincelles
-- Le serveur (SledService) soude le traîneau au joueur (Weld "SledWeld") ; ici on ne fait que changer son C0 en local.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local SNOW = Color3.fromRGB(245, 249, 255)
local rng = Random.new()

type S = {
	Model: Model, Base: BasePart, Weld: Weld, Char: Model, Root: BasePart,
	Yaw: number, Pitch: number, Y: number, Phase: number,
	Spray: { ParticleEmitter }, Trails: { Trail }, Beam: Beam?, Conns: { RBXScriptConnection },
}
local sleds: { [Model]: S } = {}
local lastLevel: { [Player]: number } = {}

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function puff(pos: Vector3, color: Color3, n: number, size: number?)
	local p = Instance.new("Part")
	p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.Transparency = 1
	p.Size = Vector3.new(0.2, 0.2, 0.2); p.CFrame = CFrame.new(pos); p.Parent = workspace
	local e = Instance.new("ParticleEmitter")
	e.Texture = "rbxasset://textures/particles/smoke_main.dds"; e.Color = ColorSequence.new(color)
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, (size or 1) * 0.6), NumberSequenceKeypoint.new(1, (size or 1) * 1.6) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) })
	e.Lifetime = NumberRange.new(0.4, 0.7); e.Speed = NumberRange.new(2, 5); e.SpreadAngle = Vector2.new(180, 180)
	e.Acceleration = Vector3.new(0, 2, 0); e.Rate = 0; e.Parent = p
	e:Emit(n)
	Debris:AddItem(p, 1)
end

local function sparkle(pos: Vector3, color: Color3, n: number)
	local p = Instance.new("Part")
	p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.Transparency = 1
	p.Size = Vector3.new(0.2, 0.2, 0.2); p.CFrame = CFrame.new(pos); p.Parent = workspace
	local e = Instance.new("ParticleEmitter")
	e.Texture = "rbxasset://textures/particles/sparkles_main.dds"; e.Color = ColorSequence.new(color); e.LightEmission = 1
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0) })
	e.Lifetime = NumberRange.new(0.5, 0.9); e.Speed = NumberRange.new(4, 9); e.SpreadAngle = Vector2.new(180, 180)
	e.Acceleration = Vector3.new(0, -8, 0); e.Rate = 0; e.Parent = p
	e:Emit(n)
	Debris:AddItem(p, 1.2)
end

-- un morceau de chargement apparaît : il tombe du ciel dans le traîneau
local function dropIn(lump: BasePart)
	lump.LocalTransparencyModifier = 1
	local ghost = lump:Clone()
	for _, c in ipairs(ghost:GetChildren()) do c:Destroy() end
	ghost.Anchored = true; ghost.Transparency = 0; ghost.LocalTransparencyModifier = 0
	ghost.Parent = workspace
	local t0 = os.clock()
	local D = 0.28
	local conn: RBXScriptConnection
	conn = RunService.RenderStepped:Connect(function()
		local k = math.clamp((os.clock() - t0) / D, 0, 1)
		if not lump.Parent then conn:Disconnect(); ghost:Destroy(); return end
		local target = lump.CFrame
		ghost.CFrame = target + Vector3.new(0, (1 - k * k) * 2.6, 0)
		if k >= 1 then
			conn:Disconnect(); ghost:Destroy()
			lump.LocalTransparencyModifier = 0
			puff(target.Position, lump.Color, 3, 0.5)
		end
	end)
end

local function setup(m: Model)
	if sleds[m] then return end
	local base = m:WaitForChild("Base", 5) :: BasePart?
	local weld = base and base:WaitForChild("SledWeld", 5) :: Weld?
	local char = m.Parent :: Model?
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not (base and weld and char and root) then return end
	local s: S = {
		Model = m, Base = base, Weld = weld, Char = char, Root = root,
		Yaw = 0, Pitch = 0, Y = weld.C0.Position.Y, Phase = 0, Spray = {}, Trails = {}, Beam = nil, Conns = {},
	}
	-- gerbes de neige derrière les patins
	for _, n in ipairs({ "SprayL", "SprayR" }) do
		local a = base:FindFirstChild(n) :: Attachment?
		if a then
			local e = Instance.new("ParticleEmitter")
			e.Texture = "rbxasset://textures/particles/smoke_main.dds"; e.Color = ColorSequence.new(SNOW)
			e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1.2) })
			e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
			e.Lifetime = NumberRange.new(0.35, 0.6); e.Speed = NumberRange.new(2, 5); e.SpreadAngle = Vector2.new(35, 35)
			e.EmissionDirection = Enum.NormalId.Back; e.Acceleration = Vector3.new(0, 3, 0); e.Rate = 0
			e.Parent = a
			table.insert(s.Spray, e)
			local chips = Instance.new("ParticleEmitter")
			chips.Texture = "rbxasset://textures/particles/sparkles_main.dds"; chips.Color = ColorSequence.new(SNOW)
			chips.Size = NumberSequence.new(0.14); chips.Lifetime = NumberRange.new(0.3, 0.5); chips.Speed = NumberRange.new(5, 8)
			chips.SpreadAngle = Vector2.new(30, 40); chips.EmissionDirection = Enum.NormalId.Back; chips.Acceleration = Vector3.new(0, -25, 0)
			chips.Rate = 0; chips.Parent = a
			table.insert(s.Spray, chips)
		end
	end
	-- traces des patins
	for _, side in ipairs({ "L", "R" }) do
		local a0, a1 = base:FindFirstChild("Trail" .. side .. "0") :: Attachment?, base:FindFirstChild("Trail" .. side .. "1") :: Attachment?
		if a0 and a1 then
			local t = Instance.new("Trail")
			t.Attachment0 = a0; t.Attachment1 = a1; t.Lifetime = 1.6; t.MinLength = 0.2; t.FaceCamera = false
			t.Color = ColorSequence.new(Color3.fromRGB(190, 210, 235))
			t.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
			t.Enabled = false; t.Parent = base
			table.insert(s.Trails, t)
		end
	end
	-- corde : main gauche -> avant du traîneau
	local hand = char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm")
	local ropeA = base:FindFirstChild("RopeAttach") :: Attachment?
	if hand and ropeA then
		local ha = hand:FindFirstChild("SledRope") :: Attachment?
		if not ha then
			ha = Instance.new("Attachment"); (ha :: Attachment).Name = "SledRope"
			(ha :: Attachment).Position = Vector3.new(0, -(hand :: BasePart).Size.Y / 2, 0); (ha :: Attachment).Parent = hand
		end
		local b = Instance.new("Beam")
		b.Attachment0 = ha; b.Attachment1 = ropeA; b.Width0 = 0.12; b.Width1 = 0.12; b.Segments = 12
		b.Color = ColorSequence.new(Color3.fromRGB(150, 105, 60)); b.Transparency = NumberSequence.new(0); b.LightInfluence = 1
		b.FaceCamera = true; b.CurveSize0 = -0.6; b.CurveSize1 = 0.4
		b.Parent = base
		s.Beam = b
	end
	-- chargement : chaque morceau qui devient visible tombe dedans
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") and d:GetAttribute("Order") then
			table.insert(s.Conns, d:GetPropertyChangedSignal("Transparency"):Connect(function()
				if d.Transparency < 0.5 then dropIn(d) end
			end))
		end
	end
	-- apparition : nuage de neige, et étincelles si c'est un nouveau traîneau acheté
	local owner = Players:GetPlayerByUserId((m:GetAttribute("Owner") :: number?) or 0)
	local lvl = (m:GetAttribute("Level") :: number?) or 1
	puff(base.Position + Vector3.new(0, 0.6, 0), SNOW, 14, 1.4)
	if owner and lastLevel[owner] and lastLevel[owner] < lvl then
		sparkle(base.Position + Vector3.new(0, 1, 0), Color3.fromRGB(255, 225, 120), 30)
		if owner == player then UI.Play("LevelUp", 0.6) end
	end
	if owner then lastLevel[owner] = lvl end
	sleds[m] = s
	m.AncestryChanged:Connect(function()
		if not m:IsDescendantOf(workspace) then
			for _, c in ipairs(s.Conns) do c:Disconnect() end
			sleds[m] = nil
			-- disparition (sortie de zone) : pouf de neige
			puff(s.Base.Position + Vector3.new(0, 0.6, 0), SNOW, 10, 1.2)
		end
	end)
end

local function watchChar(char: Model)
	local f = char:FindFirstChild("Sled")
	if f and f:IsA("Model") then task.spawn(setup, f) end
	char.ChildAdded:Connect(function(c) if c.Name == "Sled" and c:IsA("Model") then task.spawn(setup, c) end end)
end
local function watchPlayer(p: Player)
	if p.Character then watchChar(p.Character) end
	p.CharacterAdded:Connect(watchChar)
end
for _, p in ipairs(Players:GetPlayers()) do watchPlayer(p) end
Players.PlayerAdded:Connect(watchPlayer)
Players.PlayerRemoving:Connect(function(p) lastLevel[p] = nil end)

-- [ animation ] ---------------------------------------------------------------------
RunService.RenderStepped:Connect(function(dt)
	for m, s in pairs(sleds) do
		local root = s.Root
		if not (root.Parent and s.Weld.Parent) then continue end
		local back = (m:GetAttribute("Back") :: number?) or 4
		local hip = (m:GetAttribute("Hip") :: number?) or 3
		local len = ((m:GetAttribute("Length") :: number?) or 5) * 0.85
		local vel = root.AssemblyLinearVelocity
		local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
		local moving = math.clamp(speed / 16, 0, 1)
		s.Phase += dt * speed * 0.9

		-- retard en virage : le traîneau pivote autour de la corde
		local turn = root.AssemblyAngularVelocity.Y
		local targetYaw = math.clamp(turn * 0.15, -0.5, 0.5)
		s.Yaw += (targetYaw - s.Yaw) * math.min(1, dt * 5)

		-- sol sous l'avant et l'arrière du traîneau (repère du joueur, sans l'inclinaison)
		local flat = CFrame.new(root.Position) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
		local hinge = flat * CFrame.new(0, 0, back - len / 2) * CFrame.Angles(0, s.Yaw, 0)
		local frontP = (hinge * CFrame.new(0, 0, 0.2)).Position
		local backP = (hinge * CFrame.new(0, 0, len - 0.2)).Position
		rayParams.FilterDescendantsInstances = { s.Char }
		local h1 = workspace:Raycast(frontP + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), rayParams)
		local h2 = workspace:Raycast(backP + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), rayParams)
		local floorY = root.Position.Y - hip
		local y1 = h1 and h1.Position.Y or floorY
		local y2 = h2 and h2.Position.Y or floorY
		local targetPitch = math.atan2(y2 - y1, len - 0.4) -- l'arrière plus haut = nez vers le bas
		s.Pitch += (targetPitch - s.Pitch) * math.min(1, dt * 10)
		local targetY = y1 - root.Position.Y + 0.04
		s.Y += (targetY - s.Y) * math.min(1, dt * 14)

		-- balancement quand ça glisse
		local bob = math.abs(math.sin(s.Phase)) * 0.06 * moving
		local roll = math.sin(s.Phase * 0.5) * 0.05 * moving
		local c0 = CFrame.new(0, s.Y + bob, back - len / 2) * CFrame.Angles(0, s.Yaw, 0) * CFrame.Angles(-s.Pitch, 0, roll) * CFrame.new(0, 0, len / 2)
		s.Weld.C0 = c0

		-- neige + traces
		local spray = speed > 3
		for _, e in ipairs(s.Spray) do
			e.Rate = spray and (e.Texture:find("smoke") and 22 or 14) * moving or 0
		end
		for _, t in ipairs(s.Trails) do t.Enabled = speed > 1.5 end
		-- la corde se tend quand on avance
		if s.Beam then s.Beam.CurveSize0 = -0.6 * (1 - moving * 0.8); s.Beam.CurveSize1 = 0.4 * (1 - moving * 0.8) end
	end
end)

return true
