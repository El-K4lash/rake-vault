--!strict
-- Client/MapFxController : animations de la map (copie des animations de la maquette 3D) — 100 % côté client.
--   * fumée des volcans (bouffées qui montent, grossissent et s'effacent)
--   * bulles lumineuses du Void (flottent de haut en bas)
--   * anneaux néon du Void (tournent sur eux-mêmes)
--   * pales du moulin de la ferme, nuages qui dérivent
--   * ponds du Volcano / Void qui pulsent, écume de la mer qui respire
local RunService = game:GetService("RunService")

local map = workspace:WaitForChild("Map")
local maq = map:WaitForChild("Maquette", 30)
if not maq then return true end
local special = maq:WaitForChild("Special")

local fx = Instance.new("Folder")
fx.Name = "MapFx"
fx.Parent = workspace

-- [ FUMÉE ] -------------------------------------------------------------------------------
type Puff = { p: BasePart, o: Vector3, t: number }
local puffs: { Puff } = {}
for _, s in ipairs(special:GetChildren()) do
	if s.Name == "SmokeSource" and s:IsA("BasePart") then
		for j = 0, 2 do
			local p = Instance.new("Part")
			p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
			p.Material = Enum.Material.SmoothPlastic
			p.Color = Color3.fromHex("F4EEE9")
			p.Size = Vector3.new(1, 1, 1)
			p.Parent = fx
			table.insert(puffs, { p = p, o = s.Position, t = j / 3 })
		end
	end
end

-- [ BULLES ] ------------------------------------------------------------------------------
type Bubble = { p: BasePart, base: Vector3, amp: number, sp: number, ph: number }
local bubbles: { Bubble } = {}
for _, b in ipairs(special:GetChildren()) do
	if b.Name == "Bubble" and b:IsA("BasePart") then
		table.insert(bubbles, { p = b, base = b.Position, amp = b:GetAttribute("Amp") or 1, sp = b:GetAttribute("Sp") or 1, ph = b:GetAttribute("Ph") or 0 })
	end
end

-- [ MODÈLES QUI TOURNENT / DÉRIVENT ] ------------------------------------------------------
type Spin = { m: Model, base: CFrame, kind: string, i: number }
local spins: { Spin } = {}
local function addSpin(m: Instance, kind: string, i: number)
	if not m:IsA("Model") then return end
	local base: CFrame
	local pv = m:GetAttribute("PivotCF")
	if typeof(pv) == "string" then
		local e = {}
		for _, v in ipairs(string.split(pv, ",")) do table.insert(e, tonumber(v) :: number) end
		base = CFrame.new(e[13], e[14], e[15], e[1], e[5], e[9], e[2], e[6], e[10], e[3], e[7], e[11])
		m.WorldPivot = base
	else
		local cf = m:GetBoundingBox()
		base = cf
		m.WorldPivot = base
	end
	table.insert(spins, { m = m, base = base, kind = kind, i = i })
end
local ringI = 0
for _, d in ipairs(maq:GetDescendants()) do
	if d:IsA("Model") then
		local a = d:GetAttribute("Anim")
		if a == "Spin3d" then addSpin(d, "blades", 0)
		elseif a == "Cloud" then addSpin(d, "cloud", (d:GetAttribute("Index") :: number?) or 0)
		elseif a == "SpinRing" then addSpin(d, "ring", ringI); ringI += 1 end
	end
end

-- [ PONDS + ÉCUME ] -----------------------------------------------------------------------
local ponds: { [string]: BasePart } = {}
for _, z in ipairs(map:WaitForChild("Zones"):GetChildren()) do
	local p = z:FindFirstChild("Pond")
	if p and p:IsA("BasePart") then
		local k = p:GetAttribute("PondFx")
		if k == "volcano" or k == "void" then ponds[k :: string] = p end
	end
end
local foams: { BasePart } = {}
for _, f in ipairs(special:GetChildren()) do
	if f.Name == "Foam" and f:IsA("BasePart") then table.insert(foams, f) end
end

local function hsl(h: number, s: number, l: number): Color3
	local function f(n: number): number
		local k = (n + h * 12) % 12
		local a = s * math.min(l, 1 - l)
		return l - a * math.max(-1, math.min(k - 3, 9 - k, 1))
	end
	return Color3.new(f(0), f(8), f(4))
end

local time = 0
RunService.RenderStepped:Connect(function(dt: number)
	dt = math.min(dt, 0.05)
	time += dt
	for _, pf in ipairs(puffs) do
		pf.t += dt * 0.28
		if pf.t > 1 then pf.t -= 1 end
		local s = (0.8 + pf.t * 2.6) * 1.55
		pf.p.Size = Vector3.new(s, s, s)
		pf.p.CFrame = CFrame.new(pf.o + Vector3.new(math.sin(pf.t * 6) * 0.6, pf.t * 11, pf.t * 1.5)) * CFrame.Angles(pf.t * 2, pf.t * 3, 0)
		pf.p.Transparency = 1 - 0.75 * (1 - pf.t)
	end
	for _, b in ipairs(bubbles) do
		b.p.Position = b.base + Vector3.new(0, math.sin(time * b.sp + b.ph) * b.amp, 0)
	end
	for _, s in ipairs(spins) do
		if s.kind == "blades" then
			s.m:PivotTo(s.base * CFrame.Angles(0, 0, time * 0.7))
		elseif s.kind == "cloud" then
			local x = s.base.X + time * (3 + (s.i % 3))
			x = ((x + 800) % 1600) - 800
			s.m:PivotTo(CFrame.new(x, s.base.Y, s.base.Z))
		else
			s.m:PivotTo(s.base * CFrame.Angles(time * (0.4 + s.i * 0.1), time * 0.3, 0))
		end
	end
	if ponds.volcano then ponds.volcano.Color = hsl(0.07 + math.sin(time * 2) * 0.012, 1, 0.5 + math.sin(time * 2.6) * 0.04) end
	if ponds.void then ponds.void.Color = hsl(0.77, 1, 0.62 + math.sin(time * 1.8) * 0.06) end
	local fo = 1 - (0.55 + math.sin(time * 1.5) * 0.2)
	for _, f in ipairs(foams) do f.Transparency = fo end
end)

return true
