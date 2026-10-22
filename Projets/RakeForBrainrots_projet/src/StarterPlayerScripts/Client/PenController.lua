--!strict
-- Client/PenController
-- * Les brainrots des enclos se baladent (déplacement local, fluide) avec une animation de marche procédurale
--   sur leurs os (jambes/bras qui balancent, corps qui rebondit) — les animations du pack ne sont pas jouables
--   sans être republiées sur ton compte, donc on anime nous-mêmes les Bones.
-- * Timers au-dessus des œufs en incubation.
-- * Outil œuf : clic dans son enclos = pose l'œuf (le serveur vérifie).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local map = workspace:WaitForChild("Map")
local plots = map:WaitForChild("Plots")

-- [ BALADE + MARCHE ] ------------------------------------------------------------
type Walker = {
	model: Model, plot: Model, height: number, pos: Vector3, yaw: number,
	target: Vector3?, wait: number, speed: number, phase: number,
	legs: { { bone: Bone, base: CFrame, side: number, axis: Vector3 } },
	arms: { { bone: Bone, base: CFrame, side: number, axis: Vector3 } },
	body: { bone: Bone, base: CFrame }?,
	moving: number,
	rot: CFrame, -- orientation propre du modèle (le pack est souvent tourné de 90° sur X)
}
local walkers: { [Model]: Walker } = {}
local rng = Random.new()

local function areaOf(plot: Model): BasePart?
	local pen = plot:FindFirstChild("Pen")
	return pen and pen:FindFirstChild("Area") :: BasePart?
end

-- classe les chaînes d'os : sous le centre = jambes, au-dessus = bras/tête
local function rig(w: Walker)
	local root: Bone? = nil
	for _, d in ipairs(w.model:GetDescendants()) do
		if d:IsA("Bone") and not (d.Parent and d.Parent:IsA("Bone")) then root = d; break end
	end
	if not root then return end
	local pv = w.model:GetPivot()
	local center = CFrame.new(pv.Position) * CFrame.Angles(0, (w.model:GetAttribute("Yaw") :: number?) or 0, 0)
	w.body = { bone = root, base = root.Transform }
	for _, chain in ipairs(root:GetChildren()) do
		if chain:IsA("Bone") then
			local rel = center:PointToObjectSpace(chain.WorldPosition)
			local side = rel.X >= 0 and 1 or -1
			-- axe de balancement = axe "droite" du modèle exprimé dans l'espace de l'os
			local axis = chain.WorldCFrame:VectorToObjectSpace(center.RightVector)
			local entry = { bone = chain, base = chain.Transform, side = side, axis = axis }
			if rel.Y < -w.height * 0.12 then
				table.insert(w.legs, entry)
			else
				table.insert(w.arms, entry)
			end
		end
	end
end

local function track(m: Model)
	if walkers[m] or not m:GetAttribute("Wander") then return end
	local plot = m:FindFirstAncestorWhichIsA("Model")
	while plot and plot.Parent ~= plots do plot = plot:FindFirstAncestorWhichIsA("Model") end
	if not plot then return end
	local cf = m:GetPivot()
	local yaw = (m:GetAttribute("Yaw") :: number?) or 0
	local rot = CFrame.Angles(0, -yaw, 0) * cf.Rotation
	local w: Walker = {
		model = m, plot = plot, height = (m:GetAttribute("Height") :: number?) or 4, pos = cf.Position, yaw = yaw,
		target = nil, wait = rng:NextNumber(0.5, 3), speed = rng:NextNumber(3.2, 5.2), phase = rng:NextNumber(0, 6.28),
		legs = {}, arms = {}, body = nil, moving = 0, rot = rot,
	}
	rig(w)
	walkers[m] = w
	m.Destroying:Once(function() walkers[m] = nil end)
end

local function pickTarget(w: Walker)
	local area = areaOf(w.plot)
	if not area then return end
	local p = area.CFrame * CFrame.new(rng:NextNumber(-0.45, 0.45) * area.Size.X, 0, rng:NextNumber(-0.45, 0.45) * area.Size.Z)
	w.target = Vector3.new(p.X, w.pos.Y, p.Z)
end

local animClock = 0
RunService.RenderStepped:Connect(function(dt)
	dt = math.min(dt, 0.1)
	local camPos = workspace.CurrentCamera.CFrame.Position
	animClock += dt
	for m, w in pairs(walkers) do
		if not m.Parent then walkers[m] = nil; continue end
		local far = (w.pos - camPos).Magnitude > 160
		-- décision : attendre / marcher
		if w.target then
			local d = w.target - w.pos
			local flat = Vector3.new(d.X, 0, d.Z)
			if flat.Magnitude < 0.6 then
				w.target = nil
				w.wait = rng:NextNumber(1, 4)
			else
				local dir = flat.Unit
				local wantYaw = math.atan2(-dir.X, -dir.Z)
				local dy = (wantYaw - w.yaw + math.pi) % (2 * math.pi) - math.pi
				w.yaw += dy * math.min(1, dt * 6)
				if math.abs(dy) < 0.6 then
					w.pos += dir * math.min(flat.Magnitude, w.speed * dt)
				end
			end
			w.moving = math.min(1, w.moving + dt * 4)
		else
			w.wait -= dt
			w.moving = math.max(0, w.moving - dt * 3)
			if w.wait <= 0 then pickTarget(w) end
		end
		if far then
			m:PivotTo(CFrame.new(w.pos) * CFrame.Angles(0, w.yaw, 0) * w.rot)
			continue
		end
		-- rebond du corps + petit dandinement
		w.phase += dt * (6 + w.speed * 1.4) * (0.35 + w.moving * 0.65)
		local hop = math.abs(math.sin(w.phase)) * 0.35 * w.moving + math.sin(animClock * 2 + w.phase) * 0.05
		local waddle = math.sin(w.phase) * 0.09 * w.moving
		m:PivotTo(CFrame.new(w.pos + Vector3.new(0, hop, 0)) * CFrame.Angles(0, w.yaw, 0) * CFrame.Angles(0, 0, waddle) * w.rot)
		-- os : jambes alternées, bras opposés
		local swing = math.sin(w.phase)
		for _, l in ipairs(w.legs) do
			l.bone.Transform = l.base * CFrame.fromAxisAngle(l.axis, swing * l.side * 0.55 * w.moving)
		end
		for _, a in ipairs(w.arms) do
			local idle = math.sin(animClock * 1.6 + a.side) * 0.08
			a.bone.Transform = a.base * CFrame.fromAxisAngle(a.axis, -swing * a.side * 0.35 * w.moving + idle)
		end
	end
end)

local function scan(inst: Instance)
	if inst:IsA("Model") and inst:GetAttribute("Wander") then task.defer(track, inst) end
end
for _, d in ipairs(plots:GetDescendants()) do scan(d) end
plots.DescendantAdded:Connect(scan)

-- [ TIMERS DES ŒUFS ] -------------------------------------------------------------
local eggBase: { [Model]: CFrame } = setmetatable({}, { __mode = "k" }) :: any
task.spawn(function()
	while true do
		local now = workspace:GetServerTimeNow()
		for _, d in ipairs(plots:GetDescendants()) do
			if d:IsA("Model") and d:GetAttribute("EggUid") then
				local hatchAt = d:GetAttribute("HatchAt") :: number?
				local gui = d:FindFirstChild("EggTimer")
				local t = gui and gui:FindFirstChild("Timer") :: TextLabel?
				if t and hatchAt then
					local left = math.max(0, hatchAt - now)
					t.Text = left > 0 and ("Hatching in " .. Format.Time(left)) or "Hatching!"
					t.TextColor3 = left > 0 and Color3.new(1, 1, 1) or Color3.fromRGB(150, 255, 120)
					-- l'œuf tremble quand il va éclore
					if left < 6 then
						local base = eggBase[d]
						if not base then base = d:GetPivot(); eggBase[d] = base end
						d:PivotTo(base * CFrame.Angles(math.sin(os.clock() * 25) * 0.08, 0, math.cos(os.clock() * 21) * 0.08))
					end
				end
			end
		end
		task.wait(0.25)
	end
end)

-- [ OUTIL ŒUF ] -------------------------------------------------------------------
local function hookTool(tool: Instance)
	if not tool:IsA("Tool") or not tool:GetAttribute("EggId") or tool:GetAttribute("Hooked") then return end
	tool:SetAttribute("Hooked", true)
	tool.Activated:Connect(function()
		local mouse = player:GetMouse()
		local hit = mouse.Hit and mouse.Hit.Position
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not hit and root then hit = root.Position end
		-- clic trop loin : on pose à ses pieds
		if root and hit and (hit - root.Position).Magnitude > 40 then hit = root.Position end
		if hit then State.Send("PlaceEgg", tool:GetAttribute("EggId"), hit) end
	end)
end
local function watch(container: Instance)
	for _, t in ipairs(container:GetChildren()) do hookTool(t) end
	container.ChildAdded:Connect(hookTool)
end
watch(player:WaitForChild("Backpack"))
player.CharacterAdded:Connect(function(c) watch(c) end)
if player.Character then watch(player.Character) end
player.ChildAdded:Connect(function(c) if c:IsA("Backpack") then watch(c) end end)

-- [ ÉVÉNEMENTS ] --------------------------------------------------------------------
State.Event.Event:Connect(function(name, payload)
	if name == "EggPlaced" then
		UI.Play("Success", 0.4)
	end
end)

return true
