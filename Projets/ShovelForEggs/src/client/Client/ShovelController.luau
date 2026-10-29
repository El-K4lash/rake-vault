--!strict
-- Client/ShovelController : la pelle. Clic (ou maintien) = demande "Swing" au serveur (le serveur décide de tout).
-- Animation : lever -> planter -> creuser -> jeter la motte de neige dans la luge. Effets au sol : DigFx (trou en blocs).
-- Les objets trouvés sortent du trou puis volent vers le joueur quand le serveur confirme.
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
local Eggs = require(Shared.Config.Eggs)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)
local DigFx = require(script.Parent.DigFx)

local player = Players.LocalPlayer
local holding = false
local lastSend = 0

local function cooldown(): number
	local d = State.Data
	local cd = Upgrades.ShovelCooldown
	if d then cd = cd / (1 + math.min(d.Runes.Speed or 0, Items.RuneCaps.Speed)) end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	if root then
		local z = Zones.At(root.Position)
		if z and Zones.InPond(z, root.Position) then cd *= Upgrades.PondCooldownMult end
	end
	return cd
end

-- [ ANIMATION DE LA PELLE ] ------------------------------------------------------
-- Chaque frame on recalcule la poignée pour que la lame touche vraiment le sol (raycast) :
-- on lève la pelle, on la plante devant (trou + effets), on la fait basculer pour prendre la neige,
-- puis on jette la motte par-dessus l'épaule dans la luge. La main glisse le long du manche.
local RAISE, STRIKE, SCOOP, TOSS, BACK = 0.10, 0.07, 0.11, 0.15, 0.12
local TOTAL = RAISE + STRIKE + SCOOP + TOSS + BACK
local FAR, MID, NEAR = 0.9, 0.78, 0.55 -- distance de la lame devant le joueur (fraction de la portée)
local LIFT_UP, DIG, TOSS_UP = 2.8, -0.7, 3.0
local swingT: number? = nil
local speed = 1
local impacted, scooped, tossed = false, false, false
local inZone = false -- trou + motte seulement dans une zone de neige (pas dans le lobby ni le chalet)
local ARM_SIGN = 1
local marksFolder = DigFx.Folder
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function ease(x: number): number return 1 - (1 - x) * (1 - x) end
local function easeIn(x: number): number return x * x end
local function lerp(a: number, b: number, k: number): number return a + (b - a) * k end

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
	return Vector3.new(pos.X, pos.Y, pos.Z), Color3.fromRGB(240, 246, 255)
end

local function currentShovel(char: Model): (Tool?, Weld?, BasePart?)
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool:GetAttribute("Shovel") then return nil end
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

-- où atterrit la neige jetée : dans la luge si elle est là, sinon derrière le joueur
local function tossTarget(char: Model, root: BasePart): (Vector3, number)
	local sled = char:FindFirstChild("Sled")
	local load = sled and sled:FindFirstChild("Load") :: BasePart?
	if load then
		local top = load.Position.Y + load.Size.Y / 2
		return Vector3.new(load.Position.X, top + 0.3, load.Position.Z), top
	end
	local g = groundAt(root.Position - root.CFrame.LookVector * 4, char)
	return g + Vector3.new(0, 0.3, 0), g.Y
end

-- place la pelle pour que le bout de la lame soit à `dist` devant le joueur, `lift` au-dessus du sol
-- renvoie le point du sol, sa couleur, le bout de la lame et l'axe du manche
local function placeShovel(char: Model, root: BasePart, tool: Tool, grip: Weld, hand: BasePart, dist: number, lift: number): (Vector3?, Color3?, Vector3?, Vector3?)
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
	return g, gcol, tip, u
end

local function swingAnim(char: Model?)
	-- coup enchaîné avant la fin du précédent : la motte part quand même dans la luge
	if scooped and not tossed then
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		if char and root then
			local to, floor = tossTarget(char, root)
			DigFx.Toss(to, floor)
		else
			DigFx.DropScoop()
		end
	end
	swingT = 0
	impacted, scooped, tossed = false, false, false
	local r = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	inZone = r ~= nil and Zones.At(r.Position) ~= nil
end

local armBent = false
local IDLE_DIST, IDLE_LIFT, IDLE_PITCH = 0.97, 0.3, 0 -- au repos : la lame posée juste devant les pieds
RunService:BindToRenderStep("ShovelSwing", Enum.RenderPriority.Character.Value + 2, function(dt)
	local char = player.Character
	if not char then return end
	local tool, grip, hand = currentShovel(char)
	local root = char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local shoulder = shoulderOf(char)
	if not (tool and grip and hand and root) then
		if swingT or armBent then
			swingT = nil
			armBent = false
			if shoulder then armReset(shoulder) end
			DigFx.DropScoop()
		end
		return
	end
	armBent = true
	if not swingT then
		if shoulder then armPitch(shoulder, IDLE_PITCH * ARM_SIGN) end
		placeShovel(char, root, tool, grip, hand, IDLE_DIST, IDLE_LIFT)
		return
	end
	swingT += dt * speed * ((player:GetAttribute("ShovelSlow") :: number?) or 1) -- ShovelSlow : ralenti pour debug
	local t = swingT :: number
	local t1, t2, t3, t4 = RAISE, RAISE + STRIKE, RAISE + STRIKE + SCOOP, RAISE + STRIKE + SCOOP + TOSS
	-- bras : se lève, frappe vers le sol, bascule, remonte pour jeter
	local pitch = IDLE_PITCH
	if t < t1 then pitch += -35 * ease(t / t1)
	elseif t < t2 then pitch += lerp(-35, 40, easeIn((t - t1) / STRIKE))
	elseif t < t3 then pitch += lerp(40, 15, (t - t2) / SCOOP)
	elseif t < t4 then pitch += lerp(15, -40, ease((t - t3) / TOSS))
	else pitch += lerp(-40, 0, ease(math.min(1, (t - t4) / BACK))) end
	if shoulder then armPitch(shoulder, pitch * ARM_SIGN) end
	if t >= TOTAL then
		swingT = nil
		placeShovel(char, root, tool, grip, hand, IDLE_DIST, IDLE_LIFT)
		return
	end
	-- trajectoire de la lame
	local dist, lift
	if t < t1 then
		local k = ease(t / t1); dist = lerp(IDLE_DIST, FAR, k); lift = lerp(IDLE_LIFT, IDLE_LIFT + LIFT_UP, k)
	elseif t < t2 then
		dist = FAR; lift = lerp(IDLE_LIFT + LIFT_UP, DIG, easeIn((t - t1) / STRIKE))
	elseif t < t3 then
		local k = ease((t - t2) / SCOOP); dist = lerp(FAR, MID, k); lift = lerp(DIG, 0.6, k)
	elseif t < t4 then
		local k = ease((t - t3) / TOSS); dist = lerp(MID, NEAR, k); lift = lerp(0.6, TOSS_UP, k)
	else
		local k = ease(math.min(1, (t - t4) / BACK)); dist = lerp(NEAR, IDLE_DIST, k); lift = lerp(TOSS_UP, IDLE_LIFT, k)
	end
	local g, gcol, tip, u = placeShovel(char, root, tool, grip, hand, dist, lift)
	if not (g and gcol and tip and u) then return end
	-- la lame touche le sol : le trou se creuse
	if not inZone then return end
	if not impacted and t >= t2 - 0.01 then
		impacted = true
		local lvl = math.clamp((tool:GetAttribute("Shovel") :: number?) or 1, 1, #Upgrades.Shovels)
		DigFx.Impact(g, gcol, lvl, Upgrades.Shovels[lvl].Color, root.CFrame.LookVector)
	end
	-- la motte de neige posée sur la lame
	if t >= t2 and t < t4 then
		scooped = true
		local look = (root.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
		DigFx.Scoop(CFrame.lookAt(tip - u * 0.35 + Vector3.new(0, 0.35, 0), tip - u * 0.35 + Vector3.new(0, 0.35, 0) + look), gcol)
	elseif scooped and not tossed and t >= t4 then
		tossed = true
		local to, floor = tossTarget(char, root)
		DigFx.Toss(to, floor)
	end
end)

local function trySwing()
	local now = os.clock()
	if now - lastSend < cooldown() then return end
	lastSend = now
	State.Send("Swing")
	-- l'animation tient dans le cooldown (pelle plus rapide = animation plus rapide)
	speed = math.max(1, TOTAL / math.max(0.15, cooldown()))
	swingAnim(player.Character)
end

local function hookTool(tool: Tool)
	if not tool:GetAttribute("Shovel") then return end
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

-- objets qui sortent du trou puis volent vers le joueur ; œuf trouvé = gros effet au dernier trou
State.Event.Event:Connect(function(name, payload)
	if name == "EggFound" and type(payload) == "table" and not payload.Chest then
		local def = Eggs.ById[payload.Egg]
		DigFx.EggBurst(def and def.Color or Color3.fromRGB(255, 220, 120))
		return
	end
	if name ~= "Harvested" or type(payload) ~= "table" then return end
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
		DigFx.Reveal(it.Pos - Vector3.new(0, 0.5, 0), def.Color, def.Kind)
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
