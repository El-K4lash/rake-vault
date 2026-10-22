--!strict
-- Client/RakeController : l'outil râteau. Clic (ou maintien) = demande "Swing" au serveur.
-- Animation du bras, petit nuage au sol, objets qui volent vers le joueur quand le serveur confirme.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Upgrades = require(Shared.Config.Upgrades)
local Items = require(Shared.Config.Items)
local Zones = require(Shared.Config.Zones)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local holding = false
local lastSend = 0

local function cooldown(): number
	local d = State.Data
	local cd = Upgrades.RakeCooldown
	if d then cd = cd / (1 + math.min(d.Runes.Speed or 0, Items.RuneCaps.Speed)) end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if root then
		local z = Zones.At(root.Position)
		if z and Zones.InPond(z, root.Position) then cd *= Upgrades.PondCooldownMult end
	end
	return cd
end

-- [ ANIMATION DU RÂTEAU ] ------------------------------------------------------
-- Le râteau ne flotte plus : chaque frame du coup on recalcule la poignée pour que le bout des dents touche
-- vraiment le sol (raycast), on le lève, on le plante loin devant puis on le tire vers soi en grattant :
-- poussière qui suit les dents + traces dans le sol. La main glisse le long du manche (comme en vrai).
local RAISE, STRIKE, DRAG, BACK = 0.11, 0.07, 0.24, 0.14
local FAR, NEAR = 1.0, 0.6          -- distance des dents devant le joueur (début / fin du grattage)
local swingT: number? = nil
local ARM_SIGN = 1
local marksFolder = Instance.new("Folder"); marksFolder.Name = "RakeMarks"; marksFolder.Parent = workspace
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function ease(x: number): number return 1 - (1 - x) * (1 - x) end
local function easeIn(x: number): number return x * x end

local function groundAt(pos: Vector3, char: Model): (Vector3, Color3)
	local ignore: { Instance } = { char, marksFolder }
	for _ = 1, 4 do
		rayParams.FilterDescendantsInstances = ignore
		local hit = workspace:Raycast(pos + Vector3.new(0, 5, 0), Vector3.new(0, -14, 0), rayParams)
		if not hit then break end
		local inst = hit.Instance
		if CollectionService:HasTag(inst, "Item") or (inst:IsA("BasePart") and (inst.Transparency > 0.9 or not inst.CanCollide)) then
			table.insert(ignore, inst)
		else
			return hit.Position, inst.Color
		end
	end
	return Vector3.new(pos.X, pos.Y, pos.Z), Color3.fromRGB(200, 170, 120)
end

local function currentRake(char: Model): (Tool?, Weld?, BasePart?)
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool:GetAttribute("Rake") then return nil end
	local hand = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
	local grip = hand and hand:FindFirstChild("RightGrip") :: Weld?
	return tool, grip, hand :: BasePart?
end

-- épaule droite : Motor6D (ancien rig) ou AnimationConstraint (nouveau rig R15) -> on tourne son attachment
local function shoulderOf(char: Model): Instance?
	local upper = char:FindFirstChild("RightUpperArm")
	local m = upper and upper:FindFirstChild("RightShoulder")
	if not m then
		local torso = char:FindFirstChild("Torso")
		m = torso and torso:FindFirstChild("Right Shoulder")
	end
	return m
end
-- bras : on tourne l'épaule (C0 du Motor6D, ou Attachment0 de l'AnimationConstraint du nouveau rig R15)
-- angle > 0 = main vers le bas/l'avant. La base est mémorisée en attribut pour pouvoir la remettre.
local function jointBase(j: Instance): (CFrame?, Attachment?)
	local a0: Attachment? = nil
	if not j:IsA("Motor6D") then a0 = (j :: any).Attachment0 end
	local base = j:GetAttribute("ArmBase") :: CFrame?
	if not base then
		base = if j:IsA("Motor6D") then (j :: any).C0 else (a0 and a0.CFrame)
		if base then j:SetAttribute("ArmBase", base) end
	end
	return base, a0
end
local function armPitch(j: Instance, deg: number)
	local base, a0 = jointBase(j)
	if not base then return end
	local v = base * CFrame.Angles(math.rad(deg), 0, 0)
	if j:IsA("Motor6D") then (j :: any).C0 = v elseif a0 then a0.CFrame = v end
end
local function armReset(j: Instance) armPitch(j, 0) end

-- poussière qui suit les dents
local dustAtt = Instance.new("Attachment")
local dust = Instance.new("ParticleEmitter")
dust.Texture = "rbxasset://textures/particles/smoke_main.dds"
dust.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1.4) })
dust.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
dust.Lifetime = NumberRange.new(0.35, 0.6)
dust.Speed = NumberRange.new(1.5, 4)
dust.SpreadAngle = Vector2.new(70, 70)
dust.Acceleration = Vector3.new(0, 3, 0)
dust.Rate = 0
dust.Parent = dustAtt
local chips = Instance.new("ParticleEmitter") -- petits graviers projetés
chips.Texture = "rbxasset://textures/particles/sparkles_main.dds"
chips.Size = NumberSequence.new(0.18)
chips.Lifetime = NumberRange.new(0.25, 0.45)
chips.Speed = NumberRange.new(6, 10)
chips.SpreadAngle = Vector2.new(35, 35)
chips.Acceleration = Vector3.new(0, -40, 0)
chips.Rate = 0
chips.Parent = dustAtt
local dustHolder = Instance.new("Part")
dustHolder.Name = "RakeDust"; dustHolder.Anchored = true; dustHolder.CanCollide = false; dustHolder.CanQuery = false; dustHolder.CanTouch = false
dustHolder.Transparency = 1; dustHolder.Size = Vector3.new(0.2, 0.2, 0.2)
dustHolder.Parent = marksFolder
dustAtt.Parent = dustHolder

-- traces de dents dans le sol (s'effacent)
local function scratch(a: Vector3, b: Vector3, right: Vector3, col: Color3, width: number)
	local len = (b - a).Magnitude
	if len < 0.3 then return end
	local dark = Color3.new(col.R * 0.62, col.G * 0.62, col.B * 0.62)
	for k = -2, 2 do
		local off = right * (k * width / 5)
		local p = Instance.new("Part")
		p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
		p.Material = Enum.Material.SmoothPlastic
		p.Color = dark
		p.Size = Vector3.new(0.16, 0.04, len)
		p.CFrame = CFrame.lookAt((a + b) / 2 + off + Vector3.new(0, 0.03, 0), b + off + Vector3.new(0, 0.03, 0))
		p.Parent = marksFolder
		TweenService:Create(p, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.5), { Transparency = 1 }):Play()
		Debris:AddItem(p, 2.3)
	end
end

local lastMark: Vector3? = nil
local function swingAnim()
	swingT = 0
	lastMark = nil
end

-- place le râteau pour que le bout des dents soit à `dist` devant le joueur, `lift` au-dessus du sol
local function placeRake(char: Model, root: BasePart, tool: Tool, grip: Weld, hand: BasePart, dist: number, lift: number): (Vector3?, Color3?)
	local look = (root.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
	local right = (root.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
	local H = (hand.CFrame * grip.C0).Position
	local tipY = (tool:GetAttribute("HeadY") :: number?) or (tool:GetAttribute("TipY") :: number?) or 3.6
	local botY = (tool:GetAttribute("BottomY") :: number?) or -3.6
	-- dist est une fraction de la portée max, mesurée depuis la main : à 1 la main tient le bout du manche
	local teeth = (tool:GetAttribute("TeethLen") :: number?) or 0.8
	local g0 = groundAt(root.Position + look * 3, char)
	local headH = lift + 0.05 + teeth * 0.7
	local dy = math.max(0.5, H.Y - (g0.Y + headH))
	local reach = (tipY - botY) - 0.5
	local hmax = math.sqrt(math.max(1, reach * reach - dy * dy))
	local Hflat = Vector3.new(H.X, root.Position.Y, H.Z)
	local g, gcol = groundAt(Hflat + look * math.clamp(dist * hmax, 1, 9), char)
	local tip = g + Vector3.new(0, lift + 0.05 + teeth * 0.7, 0)
	local u = tip - H
	if u.Magnitude < 0.5 then return nil end
	u = u.Unit
	-- le manche passe dans la main : la main glisse entre le bas du manche et la tête
	local center = tip - u * tipY
	if (H - center):Dot(u) < botY + 0.4 then center = H - u * (botY + 0.4) end
	local x = right - u * right:Dot(u)
	if x.Magnitude < 0.05 then x = Vector3.xAxis end
	local D = CFrame.fromMatrix(center, x.Unit, u)
	grip.C1 = D:Inverse() * hand.CFrame * grip.C0
	return g, gcol
end

local armBent = false
local IDLE_DIST, IDLE_LIFT, IDLE_PITCH = 0.97, 0.3, 0 -- au repos : les dents posées juste devant les pieds
RunService:BindToRenderStep("RakeSwing", Enum.RenderPriority.Character.Value + 2, function(dt)
	local char = player.Character
	if not char then return end
	local tool, grip, hand = currentRake(char)
	local root = char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local shoulder = shoulderOf(char)
	if not (tool and grip and hand and root) then
		if swingT or armBent then
			swingT = nil
			armBent = false
			if shoulder then armReset(shoulder) end
			dust.Enabled = false
		end
		return
	end
	armBent = true
	if not swingT then
		-- au repos : bras baissé, râteau tenu en biais, tête posée au sol devant (il ne flotte plus)
		if shoulder then armPitch(shoulder, IDLE_PITCH * ARM_SIGN) end
		placeRake(char, root, tool, grip, hand, IDLE_DIST, IDLE_LIFT)
		return
	end
	swingT += dt * ((player:GetAttribute("RakeSlow") :: number?) or 1) -- RakeSlow : ralenti pour debug
	local t = swingT :: number
	local total = RAISE + STRIKE + DRAG + BACK
	-- bras : se tend vers le sol pendant le coup
	local pitch = IDLE_PITCH
	if t < RAISE then pitch += -35 * ease(t / RAISE)
	elseif t < RAISE + STRIKE then pitch += -35 + 75 * easeIn((t - RAISE) / STRIKE)
	elseif t < RAISE + STRIKE + DRAG then pitch += 40 - 40 * ((t - RAISE - STRIKE) / DRAG) end
	if shoulder then armPitch(shoulder, pitch * ARM_SIGN) end
	if t >= total then
		swingT = nil
		dust.Enabled = false
		placeRake(char, root, tool, grip, hand, IDLE_DIST, IDLE_LIFT)
		return
	end
	-- trajectoire des dents : lever -> planter loin -> gratter vers soi -> reposer
	local dist, lift, dragging = FAR, 0, false
	if t < RAISE then
		local k = ease(t / RAISE); dist = IDLE_DIST + (FAR - IDLE_DIST) * k; lift = IDLE_LIFT + 2.8 * k
	elseif t < RAISE + STRIKE then
		dist = FAR; lift = (IDLE_LIFT + 2.8) * (1 - easeIn((t - RAISE) / STRIKE))
	elseif t < RAISE + STRIKE + DRAG then
		dist = FAR + (NEAR - FAR) * ((t - RAISE - STRIKE) / DRAG); dragging = true
	else
		local k = ease((t - RAISE - STRIKE - DRAG) / BACK); dist = NEAR + (IDLE_DIST - NEAR) * k; lift = IDLE_LIFT * k
	end
	local g, gcol = placeRake(char, root, tool, grip, hand, dist, lift)
	if not (g and gcol) then return end
	local right = (root.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
	dustHolder.Position = g + Vector3.new(0, 0.2, 0)
	dust.Color = ColorSequence.new(gcol)
	chips.Color = ColorSequence.new(Color3.new(gcol.R * 0.75, gcol.G * 0.75, gcol.B * 0.75))
	if dragging then
		dust.Enabled = true
		dust.Rate = 60
		chips:Emit(1)
		if lastMark then scratch(lastMark, g, right, gcol, 2.2) end
		lastMark = g
	else
		dust.Enabled = false
		if t >= RAISE and lift < 0.4 and not lastMark then
			dust:Emit(14); chips:Emit(8)
			lastMark = g
		end
	end
end)

local function trySwing()
	local now = os.clock()
	if now - lastSend < cooldown() then return end
	lastSend = now
	State.Send("Swing")
	swingAnim()
end

local function hookTool(tool: Tool)
	if not tool:GetAttribute("Rake") then return end
	tool.Activated:Connect(function()
		holding = true
		trySwing()
	end)
	tool.Deactivated:Connect(function() holding = false end)
	tool.Unequipped:Connect(function() holding = false end)
end

local function watch(container: Instance)
	for _, t in ipairs(container:GetChildren()) do if t:IsA("Tool") then hookTool(t) end end
	container.ChildAdded:Connect(function(t) if t:IsA("Tool") then hookTool(t) end end)
end
watch(player:WaitForChild("Backpack"))
player.CharacterAdded:Connect(function(c) watch(c) end)
if player.Character then watch(player.Character) end

-- maintien : répète le coup
RunService.Heartbeat:Connect(function()
	if holding then trySwing() end
end)

-- objets qui volent vers le joueur
State.Event.Event:Connect(function(name, payload)
	if name ~= "Harvested" then return end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if not root then return end
	local models = ReplicatedStorage:WaitForChild("Assets"):FindFirstChild("ItemModels")
	for i, it in ipairs(payload) do
		local def = Items.ById[it.Id]
		if not def then continue end
		local tpl = models and models:FindFirstChild(it.Id) :: Model?
		local m: Model
		if tpl then
			m = tpl:Clone()
		else
			m = Instance.new("Model")
			local p = Instance.new("Part")
			p.Size = Vector3.new(def.Size, def.Size, def.Size) * 0.8
			p.Shape = def.Shape == "Ball" and Enum.PartType.Ball or (def.Shape == "Cylinder" and Enum.PartType.Cylinder or Enum.PartType.Block)
			p.Color = def.Color
			p.Material = def.Neon and Enum.Material.Neon or Enum.Material.Plastic
			p.Parent = m
		end
		for _, d in ipairs(m:GetDescendants()) do
			if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false end
		end
		local start = CFrame.new(it.Pos - Vector3.new(0, 0.6, 0))
		m:PivotTo(start)
		m.Parent = workspace
		-- petit saut puis aspiré vers le joueur en rapetissant
		local dur = 0.42 + i * 0.05
		local t0 = os.clock()
		local spin = math.random() * 6
		local conn
		conn = RunService.RenderStepped:Connect(function()
			local k = math.clamp((os.clock() - t0) / dur, 0, 1)
			if not m.Parent or not root.Parent or k >= 1 then
				conn:Disconnect(); m:Destroy(); return
			end
			local target = root.Position + Vector3.new(0, 0.8, 0)
			local pos = start.Position:Lerp(target, k * k) + Vector3.new(0, math.sin(k * math.pi) * 2.2, 0)
			m:PivotTo(CFrame.new(pos) * CFrame.Angles(0, spin + k * 9, k * 2))
			pcall(function() m:ScaleTo(math.max(0.05, 1 - k * 0.85)) end)
		end)
	end
end)

return true
