--!strict
-- Client/DigFx : effets au sol quand on pellette (visuel local uniquement, le serveur décide de tout le reste).
--   Impact(pos, groundColor, tier)   -> trou en blocs : bord de neige en voxels à studs qui jaillit, fond en marches
--                                      (surfaces Inlet = "trous" de studs), cubes projetés qui rebondissent,
--                                      onde de choc + aura à la couleur de la pelle (plus forte sur les grosses pelles).
--   Scoop(cf) / Toss(from, to)       -> la motte de neige sur la pelle, lancée dans la luge, qui éclate en cubes.
--   Reveal(pos, color, kind)         -> un objet sort du trou : anneau + rayon de lumière pour les cristaux / charmes.
--   EggBurst(color)                  -> œuf trouvé : colonne de lumière, double anneau, étincelles, au dernier trou.
-- Tout est rangé dans workspace.ShovelMarks (ignoré par les raycasts de la pelle) et nettoyé tout seul.

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

local DigFx = {}
local UI = require(script.Parent.UI)
local sounds = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Sounds")

local folder = workspace:FindFirstChild("ShovelMarks") or Instance.new("Folder")
folder.Name = "ShovelMarks"
folder.Parent = workspace
DigFx.Folder = folder

local SNOW = Color3.fromRGB(248, 251, 255)
local ICE = Color3.fromRGB(170, 220, 255)
local DEEP = Color3.fromRGB(70, 105, 150)
local STUDS = Enum.SurfaceType.Studs
local INLET = Enum.SurfaceType.Inlet
local rng = Random.new()

local MAX_HOLES = 6
local HOLE_LIFE = 2.4
local holes: { { Pos: Vector3, Parts: { BasePart }, Born: number, Dead: boolean } } = {}
DigFx.LastHole = nil :: Vector3?

-- [ outils ] --------------------------------------------------------------------
local function mix(a: Color3, b: Color3, k: number): Color3 return a:Lerp(b, k) end
local function shade(c: Color3, k: number): Color3 return Color3.new(c.R * k, c.G * k, c.B * k) end

local function part(size: Vector3, cf: CFrame, color: Color3, mat: Enum.Material?, top: Enum.SurfaceType?): Part
	local p = Instance.new("Part")
	p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
	p.Size = size; p.CFrame = cf; p.Color = color
	p.Material = mat or Enum.Material.Plastic
	p.TopSurface = top or Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = folder
	return p
end

local function tween(i: Instance, t: number, props: { [string]: any }, style: Enum.EasingStyle?, dir: Enum.EasingDirection?, delay: number?)
	local tw = TweenService:Create(i, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out, 0, false, delay or 0), props)
	tw:Play()
	return tw
end

-- disque plat (cylindre couché) : pour les anneaux d'onde de choc
local function ring(pos: Vector3, d: number, color: Color3, thick: number?): Part
	local p = part(Vector3.new(thick or 0.06, d, d), CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90)), color, Enum.Material.Neon)
	p.Shape = Enum.PartType.Cylinder
	return p
end

-- émetteur de particules jetable (Emit puis supprimé)
local function burst(pos: Vector3, color: Color3, count: number, opts: { [string]: any }?)
	local o = opts or {}
	local holder = part(Vector3.new(0.2, 0.2, 0.2), CFrame.new(pos), color)
	holder.Transparency = 1
	local e = Instance.new("ParticleEmitter")
	e.Texture = o.Texture or "rbxasset://textures/particles/sparkles_main.dds"
	e.Color = ColorSequence.new(color)
	e.LightEmission = o.Light or 0.6
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, o.Size or 0.35), NumberSequenceKeypoint.new(1, 0) })
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
	e.Lifetime = NumberRange.new(o.Life or 0.5, (o.Life or 0.5) * 1.6)
	e.Speed = NumberRange.new(o.Speed or 6, (o.Speed or 6) * 1.6)
	e.SpreadAngle = Vector2.new(o.Spread or 60, o.Spread or 60)
	e.Acceleration = o.Acc or Vector3.new(0, -12, 0)
	e.EmissionDirection = Enum.NormalId.Top
	e.Rate = 0
	e.Parent = holder
	e:Emit(count)
	Debris:AddItem(holder, (o.Life or 0.5) * 1.6 + 0.2)
end

-- son 3D joué à une position (coupé si le joueur a désactivé les effets sonores)
local function sfx3d(name: string, pos: Vector3, vol: number?, pitch: number?)
	if UI.Sfx == false then return end
	local tpl = sounds:FindFirstChild(name) :: Sound?
	if not tpl then return end
	local holder = part(Vector3.new(0.2, 0.2, 0.2), CFrame.new(pos), Color3.new(1, 1, 1))
	holder.Transparency = 1
	local s = tpl:Clone()
	if vol then s.Volume = vol end
	s.PlaybackSpeed = pitch or rng:NextNumber(0.9, 1.12)
	s.RollOffMaxDistance = 80; s.RollOffMinDistance = 8
	s.Parent = holder
	s:Play()
	Debris:AddItem(holder, math.max(1.5, s.TimeLength + 0.2))
end
DigFx.Sfx = sfx3d

-- [ petites physiques maison (pas de vraie physique : rien ne pousse le joueur) ] -------
type Chunk = { P: BasePart, V: Vector3, Spin: Vector3, Floor: number, Bounces: number, T: number, Life: number, Rest: boolean }
local chunks: { Chunk } = {}
local G = 70

local function fling(p: BasePart, vel: Vector3, floorY: number, life: number?)
	table.insert(chunks, {
		P = p, V = vel, Spin = Vector3.new(rng:NextNumber(-12, 12), rng:NextNumber(-12, 12), rng:NextNumber(-12, 12)),
		Floor = floorY, Bounces = 0, T = 0, Life = life or 1.1, Rest = false,
	})
end

RunService.Heartbeat:Connect(function(dt)
	for i = #chunks, 1, -1 do
		local c = chunks[i]
		c.T += dt
		local p = c.P
		if not p.Parent then table.remove(chunks, i); continue end
		if not c.Rest then
			c.V -= Vector3.new(0, G * dt, 0)
			local pos = p.Position + c.V * dt
			local half = p.Size.Y / 2
			if pos.Y - half <= c.Floor and c.V.Y < 0 then
				pos = Vector3.new(pos.X, c.Floor + half, pos.Z)
				c.Bounces += 1
				if c.Bounces >= 2 or math.abs(c.V.Y) < 6 then
					c.Rest = true
				else
					c.V = Vector3.new(c.V.X * 0.45, -c.V.Y * 0.35, c.V.Z * 0.45)
					c.Spin *= 0.4
				end
			end
			local rot = p.CFrame - p.CFrame.Position
			if c.Rest then
				-- posé à plat (on garde juste l'orientation horizontale)
				local _, y, _ = rot:ToEulerAnglesYXZ()
				p.CFrame = CFrame.new(pos) * CFrame.Angles(0, y, 0)
			else
				p.CFrame = CFrame.new(pos) * rot * CFrame.Angles(c.Spin.X * dt, c.Spin.Y * dt, c.Spin.Z * dt)
			end
		end
		if c.T >= c.Life then
			table.remove(chunks, i)
			tween(p, 0.35, { Size = p.Size * 0.15, Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			Debris:AddItem(p, 0.4)
		end
	end
end)

-- [ trou ] ------------------------------------------------------------------------
local function closeHole(h: any, fast: boolean?)
	if h.Dead then return end
	h.Dead = true
	local t = fast and 0.15 or 0.55
	for _, p in ipairs(h.Parts) do
		if not p.Parent then continue end
		if p:GetAttribute("Rim") then
			-- le bord retombe dans le trou (la neige se remet)
			tween(p, t, { Size = p.Size * Vector3.new(0.4, 0.05, 0.4), Position = p.Position - Vector3.new(0, p.Size.Y * 0.5, 0), Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		else
			tween(p, t, { Size = p.Size * Vector3.new(0.2, 1, 0.2), Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		end
		Debris:AddItem(p, t + 0.05)
	end
end

task.spawn(function()
	while true do
		task.wait(0.25)
		if Players.LocalPlayer:GetAttribute("DigFreeze") then continue end -- debug : garder les trous pour les captures
		local now = os.clock()
		for i = #holes, 1, -1 do
			local h = holes[i]
			if h.Dead then table.remove(holes, i)
			elseif now - h.Born > HOLE_LIFE then closeHole(h); table.remove(holes, i) end
		end
	end
end)

-- Impact : `pos` = point du sol touché, `ground` = couleur du sol, `tier` = niveau de la pelle (1..12), `accent` = sa couleur
function DigFx.Impact(pos: Vector3, ground: Color3, tier: number, accent: Color3, look: Vector3?)
	-- pas de trous empilés : un nouveau coup au même endroit remplace l'ancien
	for i = #holes, 1, -1 do
		local h = holes[i]
		if (h.Pos - pos).Magnitude < 1.8 or #holes >= MAX_HOLES then closeHole(h, true); table.remove(holes, i) end
	end
	local power = math.clamp((tier - 1) / 11, 0, 1)          -- 0 (pelle en bois) -> 1 (pelle du Père Noël)
	local S = 2.8 + power * 1.3                               -- taille du trou
	local fwd = (look and Vector3.new(look.X, 0, look.Z).Magnitude > 0.01) and Vector3.new(look.X, 0, look.Z).Unit or Vector3.new(0, 0, -1)
	local base = CFrame.lookAt(pos, pos + fwd)                -- repère du trou, aligné sur le joueur
	local snowTop = mix(ground, SNOW, 0.55)
	local parts: { BasePart } = {}
	local function keep(p: BasePart) table.insert(parts, p); return p end

	-- 1) fond du trou en marches (illusion de profondeur) : 4 carrés de plus en plus sombres, surface Inlet (trous de studs)
	local steps = {
		{ k = 0.80, c = mix(shade(mix(ground, ICE, 0.35), 0.86), SNOW, 0.1), y = 0.020 },
		{ k = 0.60, c = shade(mix(ground, ICE, 0.55), 0.70),                 y = 0.032 },
		{ k = 0.42, c = mix(Color3.fromRGB(95, 135, 185), accent, 0.1 * power), y = 0.044 },
		{ k = 0.24, c = mix(DEEP, accent, 0.2 * power),                      y = 0.056 },
	}
	for i, st in ipairs(steps) do
		local p = keep(part(Vector3.new(0.05, 0.05, 0.05), base * CFrame.new(0, st.y, 0) * CFrame.Angles(0, (i % 2) * 0.06, 0), st.c, Enum.Material.SmoothPlastic, INLET))
		tween(p, 0.1 + i * 0.03, { Size = Vector3.new(S * st.k, 0.06, S * st.k) }, Enum.EasingStyle.Back)
	end
	-- éclat qui brille au fond (glace / aura) sur les pelles à partir de la dorée
	if tier >= 4 then
		local glow = keep(part(Vector3.new(0.05, 0.05, 0.05), base * CFrame.new(0, 0.068, 0), accent, Enum.Material.Neon))
		glow.Transparency = 0.25
		tween(glow, 0.15, { Size = Vector3.new(S * 0.14, 0.04, S * 0.14) }, Enum.EasingStyle.Back)
		tween(glow, 1.4, { Transparency = 0.8 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0.25)
	end

	-- 2) bord du cratère : 2 anneaux de voxels de neige à studs qui jaillissent du sol
	--    (anneau intérieur plus haut = lèvre du trou, plus haut du côté où la neige est rejetée)
	local function rimBlock(a: number, r: number, w: number, hgt: number, col: Color3, delay: number)
		local off = Vector3.new(math.sin(a) * r, 0, math.cos(a) * r)
		local target = base * CFrame.new(off + Vector3.new(0, hgt / 2, 0)) * CFrame.Angles(0, a + rng:NextNumber(-0.3, 0.3), 0)
		local p = keep(part(Vector3.new(w * 0.2, 0.05, w * 0.2), base * CFrame.new(off), col, Enum.Material.Plastic, STUDS))
		p:SetAttribute("Rim", true)
		tween(p, 0.16, { Size = Vector3.new(w, hgt, w), CFrame = target }, Enum.EasingStyle.Back, Enum.EasingDirection.Out, delay)
	end
	local nIn = 10 + math.floor(power * 4)
	for i = 1, nIn do
		local a = (i / nIn) * math.pi * 2 + rng:NextNumber(-0.12, 0.12)
		local hgt = rng:NextNumber(0.5, 0.9) * (1 + power * 0.35)
		if math.cos(a) > 0.3 then hgt *= 1.3 end -- côté joueur : la neige est rejetée vers lui
		local col = (i % 4 == 0) and mix(snowTop, ICE, 0.4) or (i % 3 == 0 and shade(snowTop, 0.9) or snowTop)
		rimBlock(a, S * 0.47 + rng:NextNumber(-0.04, 0.08), rng:NextNumber(0.55, 0.8) * (1 + power * 0.25), hgt, col, i * 0.006)
	end
	local nOut = 12 + math.floor(power * 6)
	for i = 1, nOut do
		local a = (i / nOut) * math.pi * 2 + math.pi / nOut + rng:NextNumber(-0.15, 0.15)
		local col = (i % 5 == 0) and mix(snowTop, ICE, 0.3) or mix(snowTop, ground, 0.25)
		rimBlock(a, S * 0.66 + rng:NextNumber(-0.05, 0.2), rng:NextNumber(0.4, 0.65), rng:NextNumber(0.2, 0.45), col, 0.04 + i * 0.005)
	end

	-- 3) cubes de neige projetés hors du trou (vraie trajectoire + rebond)
	local nChunks = 6 + math.floor(power * 4)
	for i = 1, nChunks do
		local a = rng:NextNumber(0, math.pi * 2)
		local dir = Vector3.new(math.sin(a), 0, math.cos(a))
		local s = rng:NextNumber(0.3, 0.6)
		local col = (i % 3 == 0) and ICE or snowTop
		local p = part(Vector3.new(s, s, s), CFrame.new(pos + dir * 0.5 + Vector3.new(0, 0.4, 0)) * CFrame.Angles(rng:NextNumber(0, 6), rng:NextNumber(0, 6), 0), col, Enum.Material.Plastic, STUDS)
		p.BottomSurface = STUDS
		fling(p, dir * rng:NextNumber(7, 13) + Vector3.new(0, rng:NextNumber(14, 22), 0), pos.Y, rng:NextNumber(0.9, 1.4))
	end
	-- cubes colorés à la couleur de la pelle (aura) sur les pelles à partir de la dorée
	if tier >= 4 then
		for _ = 1, 2 + math.floor(power * 4) do
			local a = rng:NextNumber(0, math.pi * 2)
			local dir = Vector3.new(math.sin(a), 0, math.cos(a))
			local p = part(Vector3.new(0.28, 0.28, 0.28), CFrame.new(pos + Vector3.new(0, 0.5, 0)), accent, Enum.Material.Neon)
			fling(p, dir * rng:NextNumber(5, 9) + Vector3.new(0, rng:NextNumber(18, 26), 0), pos.Y, 0.9)
		end
	end

	sfx3d("Dig", pos, 0.6 + power * 0.25, rng:NextNumber(0.95, 1.15) - power * 0.1)
	if tier >= 9 then sfx3d("Whoosh", pos, 0.3, 1.2) end

	-- 4) poudre de neige + éclats
	burst(pos + Vector3.new(0, 0.3, 0), SNOW, 16, { Texture = "rbxasset://textures/particles/smoke_main.dds", Size = 1.1, Speed = 4, Life = 0.5, Spread = 80, Acc = Vector3.new(0, 4, 0), Light = 0 })
	burst(pos + Vector3.new(0, 0.3, 0), ICE, 10, { Size = 0.3, Speed = 9, Life = 0.4, Spread = 50, Acc = Vector3.new(0, -35, 0) })

	-- 5) onde de choc + aura (couleur de la pelle)
	local r1 = ring(pos + Vector3.new(0, 0.07, 0), S * 0.6, mix(SNOW, accent, 0.35 + power * 0.5))
	r1.Transparency = 0.25
	tween(r1, 0.4, { Size = Vector3.new(0.06, S * (2.2 + power), S * (2.2 + power)), Transparency = 1 })
	Debris:AddItem(r1, 0.45)
	if tier >= 4 then
		local r2 = ring(pos + Vector3.new(0, 0.09, 0), S * 0.4, accent, 0.05)
		r2.Transparency = 0.15
		tween(r2, 0.55, { Size = Vector3.new(0.05, S * (3 + power * 1.5), S * (3 + power * 1.5)), Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.06)
		Debris:AddItem(r2, 0.7)
		burst(pos + Vector3.new(0, 0.4, 0), accent, 6 + math.floor(power * 14), { Size = 0.4, Speed = 7, Life = 0.6, Spread = 40, Acc = Vector3.new(0, -6, 0), Light = 1 })
		-- halo lumineux qui pulse dans le trou
		local holder = keep(part(Vector3.new(0.2, 0.2, 0.2), base * CFrame.new(0, 0.6, 0), accent))
		holder.Transparency = 1
		local light = Instance.new("PointLight")
		light.Color = accent; light.Range = 6 + power * 6; light.Brightness = 3; light.Shadows = false
		light.Parent = holder
		tween(light, 0.9, { Brightness = 0 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0.15)
	end
	if tier >= 9 then
		-- grosses pelles : colonne de lumière qui monte du trou
		local beam = part(Vector3.new(S * 0.35, 0.2, S * 0.35), base * CFrame.new(0, 0.1, 0), accent, Enum.Material.Neon)
		beam.Transparency = 0.3
		tween(beam, 0.35, { Size = Vector3.new(S * 0.08, 7 + power * 4, S * 0.08), CFrame = base * CFrame.new(0, (7 + power * 4) / 2, 0), Transparency = 1 })
		Debris:AddItem(beam, 0.4)
	end

	-- 6) petit tremblement de caméra
	local char = Players.LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		local amp = 0.08 + power * 0.1
		task.spawn(function()
			for k = 1, 3 do
				hum.CameraOffset = Vector3.new(rng:NextNumber(-amp, amp), rng:NextNumber(-amp, amp), 0) * (1 - (k - 1) / 3)
				task.wait(0.03)
			end
			hum.CameraOffset = Vector3.zero
		end)
	end

	table.insert(holes, { Pos = pos, Parts = parts, Born = os.clock(), Dead = false })
	DigFx.LastHole = pos
end

-- [ motte de neige sur la pelle, lancée dans la luge ] ---------------------------
local scoop: BasePart? = nil
function DigFx.Scoop(cf: CFrame, color: Color3)
	if not scoop or not scoop.Parent then
		scoop = part(Vector3.new(0.9, 0.55, 0.9), cf, mix(color, SNOW, 0.6), Enum.Material.Plastic, STUDS)
		local cap = part(Vector3.new(0.6, 0.35, 0.6), cf * CFrame.new(0.05, 0.4, -0.05), SNOW, Enum.Material.Plastic, STUDS);
		(cap :: any).Name = "Cap"
		cap.Parent = scoop
	end
	local s = scoop :: BasePart
	s.CFrame = cf
	local cap = s:FindFirstChild("Cap") :: BasePart?
	if cap then cap.CFrame = cf * CFrame.new(0.05, 0.4, -0.05) end
end

function DigFx.Toss(target: Vector3?, floorY: number)
	local s = scoop
	scoop = nil
	if not s or not s.Parent then return end
	local from = s.Position
	local to = target or (from + Vector3.new(0, -1, 0))
	-- trajectoire en cloche vers la luge (ou derrière le joueur)
	local T = 0.38
	local g = Vector3.new(0, -G, 0)
	local v0 = (to - from - 0.5 * g * T * T) / T
	local t0 = os.clock()
	local cap = s:FindFirstChild("Cap") :: BasePart?
	local conn: RBXScriptConnection
	conn = RunService.RenderStepped:Connect(function()
		local t = os.clock() - t0
		if not s.Parent then conn:Disconnect(); return end
		if t >= T then
			conn:Disconnect()
			local hit = s.Position
			s:Destroy()
			sfx3d("SnowLand", hit, 0.35, rng:NextNumber(1.0, 1.25))
			-- la motte éclate en petits cubes à studs + poudre
			for _ = 1, 5 do
				local a = rng:NextNumber(0, math.pi * 2)
				local q = rng:NextNumber(0.22, 0.4)
				local p = part(Vector3.new(q, q, q), CFrame.new(hit), (rng:NextNumber() < 0.3) and ICE or SNOW, Enum.Material.Plastic, STUDS)
				fling(p, Vector3.new(math.sin(a) * 5, rng:NextNumber(8, 13), math.cos(a) * 5), math.max(floorY, hit.Y - 1.2), 0.6)
			end
			burst(hit, SNOW, 8, { Texture = "rbxasset://textures/particles/smoke_main.dds", Size = 0.8, Speed = 2, Life = 0.4, Spread = 90, Acc = Vector3.new(0, 2, 0), Light = 0 })
			return
		end
		local p = from + v0 * t + 0.5 * g * t * t
		local cf = CFrame.new(p) * CFrame.Angles(t * 9, t * 5, 0)
		s.CFrame = cf
		if cap then cap.CFrame = cf * CFrame.new(0.05, 0.4, -0.05) end
	end)
end

function DigFx.DropScoop()
	if scoop and scoop.Parent then scoop:Destroy() end
	scoop = nil
end

-- [ objet / œuf qui sort du trou ] ------------------------------------------------
function DigFx.Reveal(pos: Vector3, color: Color3, kind: string)
	local special = kind == "Rare" or kind == "Charm"
	local rr = ring(pos + Vector3.new(0, 0.12, 0), 0.8, mix(color, SNOW, 0.2))
	rr.Transparency = 0.2
	tween(rr, 0.35, { Size = Vector3.new(0.05, special and 5 or 3, special and 5 or 3), Transparency = 1 })
	Debris:AddItem(rr, 0.4)
	if special then
		local beam = part(Vector3.new(0.8, 0.2, 0.8), CFrame.new(pos), color, Enum.Material.Neon)
		beam.Transparency = 0.2
		tween(beam, 0.5, { Size = Vector3.new(0.15, 9, 0.15), CFrame = CFrame.new(pos + Vector3.new(0, 4.5, 0)), Transparency = 1 })
		Debris:AddItem(beam, 0.55)
		burst(pos + Vector3.new(0, 0.6, 0), color, 14, { Size = 0.45, Speed = 8, Life = 0.6, Spread = 35, Acc = Vector3.new(0, -8, 0), Light = 1 })
	end
end

function DigFx.EggBurst(color: Color3)
	local pos = DigFx.LastHole
	if not pos then
		local char = Players.LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		if not root then return end
		pos = root.Position - Vector3.new(0, 3, 0)
	end
	local p0 = pos :: Vector3
	sfx3d("Fireworks", p0, 0.35, 1.1)
	-- colonne de lumière + 2 anneaux + étincelles + flash
	local beam = part(Vector3.new(2.4, 0.2, 2.4), CFrame.new(p0), color, Enum.Material.Neon)
	beam.Transparency = 0.15
	tween(beam, 0.7, { Size = Vector3.new(0.4, 22, 0.4), CFrame = CFrame.new(p0 + Vector3.new(0, 11, 0)), Transparency = 1 })
	Debris:AddItem(beam, 0.75)
	for k = 0, 1 do
		local r = ring(p0 + Vector3.new(0, 0.1 + k * 0.02, 0), 1.5, k == 0 and color or SNOW)
		r.Transparency = 0.1
		tween(r, 0.6, { Size = Vector3.new(0.06, 12 + k * 4, 12 + k * 4), Transparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, k * 0.12)
		Debris:AddItem(r, 0.8)
	end
	burst(p0 + Vector3.new(0, 1, 0), color, 40, { Size = 0.55, Speed = 14, Life = 0.9, Spread = 30, Acc = Vector3.new(0, -14, 0), Light = 1 })
	burst(p0 + Vector3.new(0, 1, 0), SNOW, 20, { Size = 0.4, Speed = 10, Life = 0.7, Spread = 80, Acc = Vector3.new(0, -20, 0), Light = 0.5 })
	local holder = part(Vector3.new(0.2, 0.2, 0.2), CFrame.new(p0 + Vector3.new(0, 2, 0)), color)
	holder.Transparency = 1
	local light = Instance.new("PointLight")
	light.Color = color; light.Range = 16; light.Brightness = 5; light.Shadows = false
	light.Parent = holder
	tween(light, 1.2, { Brightness = 0 })
	Debris:AddItem(holder, 1.3)
end

return DigFx
