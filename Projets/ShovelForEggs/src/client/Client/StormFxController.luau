--!strict
-- Client/StormFxController : météo de la montagne (100 % visuel, côté client). Remplace SnowFxController.
--   * Ambiance normale : petite neige fine + gros flocons doux, léger vent.
--   * Annonce (20 s avant) : le ciel se couvre, le vent monte, grondement lointain.
--   * Tempête de neige : blizzard (traînées de neige poussées par le vent, brume au ras du sol, rafales),
--     voile blanc (Atmosphere / nuages / flou), bords de l'écran givrés, éclairs + tonnerre (thundersnow),
--     caméra qui tremble un peu, vent en boucle.
--   * Tempête dorée : lumière chaude, paillettes et flocons dorés, colonnes de lumière dorée qui tombent du ciel
--     autour du joueur, rayons de soleil, bords dorés, jingle.
--   * Fin : tout revient en douceur, éclaircie (rayons de soleil).
-- L'état vient des attributs du workspace posés par le serveur (StormKind / StormEnd / NextStorm) : un joueur qui
-- arrive en pleine tempête la voit tout de suite. Tous les réglages partent des valeurs de Lighting au démarrage.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local sounds = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Sounds")
local rng = Random.new()

-- [ valeurs de base (celles de la place) ] ------------------------------------------------
local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
local rays = Lighting:FindFirstChildOfClass("SunRaysEffect")
local dof = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
local clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")

local B = {
	Bright = Lighting.Brightness, OutAmb = Lighting.OutdoorAmbient,
	AD = atmo and atmo.Density or 0.4, AH = atmo and atmo.Haze or 2, AC = atmo and atmo.Color or Color3.new(1, 1, 1),
	ADecay = atmo and atmo.Decay or Color3.new(1, 1, 1),
	Sat = cc and cc.Saturation or 0, Con = cc and cc.Contrast or 0, Tint = cc and cc.TintColor or Color3.new(1, 1, 1),
	Bloom = bloom and bloom.Intensity or 0.3, Rays = rays and rays.Intensity or 0.05,
	Dof = dof and dof.FarIntensity or 0,
	Cover = clouds and clouds.Cover or 0.5, CDens = clouds and clouds.Density or 0.4, CCol = clouds and clouds.Color or Color3.new(1, 1, 1),
}

-- [ calque écran (vraie instance StarterGui.StormFx, tools/build_storm_fx_gui.lua) ] ---------
local gui = player:WaitForChild("PlayerGui"):WaitForChild("StormFx", 10)
local frost = gui and gui:FindFirstChild("Frost") :: CanvasGroup?
local goldGui = gui and gui:FindFirstChild("Gold") :: CanvasGroup?
local flash = gui and gui:FindFirstChild("Flash") :: Frame?

-- [ particules qui suivent le joueur ] ------------------------------------------------------
local fx = Instance.new("Folder"); fx.Name = "WeatherFx"; fx.Parent = workspace
local function holderPart(name: string, size: Vector3): Part
	local p = Instance.new("Part")
	p.Name = name; p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
	p.Transparency = 1; p.Size = size; p.CastShadow = false
	p.Parent = fx
	return p
end
local sky = holderPart("Sky", Vector3.new(110, 1, 110))       -- au-dessus du joueur : ce qui tombe
local wind = holderPart("Wind", Vector3.new(4, 40, 120))       -- côté "au vent" : ce qui est soufflé
local ground = holderPart("Ground", Vector3.new(90, 2, 90))   -- au ras du sol : brume

local SPARK = "rbxasset://textures/particles/sparkles_main.dds"
local SMOKE = "rbxasset://textures/particles/smoke_main.dds"
local function emitter(parent: Instance, name: string, props: { [string]: any }): ParticleEmitter
	local e = Instance.new("ParticleEmitter")
	e.Name = name; e.Rate = 0
	e.Shape = Enum.ParticleEmitterShape.Box; e.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	for k, v in pairs(props) do (e :: any)[k] = v end
	e.Parent = parent
	return e
end
local function ns(a: number, b: number?): NumberSequence
	return NumberSequence.new({ NumberSequenceKeypoint.new(0, a), NumberSequenceKeypoint.new(1, b or a) })
end
local function fade(a: number): NumberSequence
	return NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, a), NumberSequenceKeypoint.new(0.8, a), NumberSequenceKeypoint.new(1, 1) })
end
local WHITE = ColorSequence.new(Color3.fromRGB(248, 252, 255))

-- neige fine (toujours)
local flakes = emitter(sky, "Flakes", {
	Texture = SPARK, Color = WHITE, Size = ns(0.22, 0.16), Transparency = fade(0.2), LightEmission = 0.4,
	Lifetime = NumberRange.new(5, 7), Speed = NumberRange.new(4, 7), Drag = 0.3, SpreadAngle = Vector2.new(20, 20),
	EmissionDirection = Enum.NormalId.Bottom, Acceleration = Vector3.new(0.8, -1.5, 0.4),
	RotSpeed = NumberRange.new(-90, 90), Rotation = NumberRange.new(0, 360),
})
-- gros flocons doux, lents, qui tournoient (au premier plan)
local soft = emitter(sky, "SoftFlakes", {
	Texture = SMOKE, Color = WHITE, Size = ns(0.55, 0.4), Transparency = fade(0.35), LightEmission = 0.2,
	Lifetime = NumberRange.new(6, 9), Speed = NumberRange.new(2, 4), Drag = 0.5, SpreadAngle = Vector2.new(30, 30),
	EmissionDirection = Enum.NormalId.Bottom, Acceleration = Vector3.new(0.6, -0.8, 0.3),
	RotSpeed = NumberRange.new(-40, 40), Rotation = NumberRange.new(0, 360),
})
-- blizzard : traînées étirées dans le sens du vent
local streaks = emitter(wind, "Streaks", {
	Texture = SPARK, Color = WHITE, Size = ns(0.32, 0.22), Transparency = fade(0.15), LightEmission = 0.5,
	Lifetime = NumberRange.new(1.2, 1.8), Speed = NumberRange.new(55, 80), SpreadAngle = Vector2.new(6, 10),
	EmissionDirection = Enum.NormalId.Right, Acceleration = Vector3.new(0, -10, 0),
	Orientation = Enum.ParticleOrientation.VelocityParallel, Squash = ns(-2.2, -1.6),
})
-- blizzard : gros paquets de neige dans le vent
local chunks = emitter(wind, "Chunks", {
	Texture = SMOKE, Color = WHITE, Size = ns(1.2, 2.2), Transparency = fade(0.55), LightEmission = 0.1,
	Lifetime = NumberRange.new(1.6, 2.4), Speed = NumberRange.new(35, 50), SpreadAngle = Vector2.new(10, 15),
	EmissionDirection = Enum.NormalId.Right, RotSpeed = NumberRange.new(-120, 120), Rotation = NumberRange.new(0, 360),
})
-- brume au ras du sol, arrachée par le vent
local mist = emitter(ground, "Mist", {
	Texture = SMOKE, Color = ColorSequence.new(Color3.fromRGB(235, 243, 252)), Size = ns(10, 18), Transparency = fade(0.78),
	LightEmission = 0, Lifetime = NumberRange.new(4, 6), Speed = NumberRange.new(10, 18), SpreadAngle = Vector2.new(15, 5),
	EmissionDirection = Enum.NormalId.Right, RotSpeed = NumberRange.new(-15, 15), Rotation = NumberRange.new(0, 360),
})
-- tempête dorée : flocons dorés + paillettes qui scintillent
local goldFlakes = emitter(sky, "GoldFlakes", {
	Texture = SPARK, Color = ColorSequence.new(Color3.fromRGB(255, 214, 90), Color3.fromRGB(255, 245, 190)),
	Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.5, 0.55), NumberSequenceKeypoint.new(1, 0.1) }),
	Transparency = fade(0.05), LightEmission = 1, Lifetime = NumberRange.new(4, 6), Speed = NumberRange.new(3, 6),
	Drag = 0.4, SpreadAngle = Vector2.new(25, 25), EmissionDirection = Enum.NormalId.Bottom,
	Acceleration = Vector3.new(0.5, -1.2, 0.3), RotSpeed = NumberRange.new(-200, 200), Rotation = NumberRange.new(0, 360),
})
local glitter = emitter(ground, "Glitter", {
	Texture = SPARK, Color = ColorSequence.new(Color3.fromRGB(255, 236, 140)),
	Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.45), NumberSequenceKeypoint.new(1, 0) }),
	Transparency = ns(0), LightEmission = 1, Lifetime = NumberRange.new(0.8, 1.4), Speed = NumberRange.new(0.5, 2),
	SpreadAngle = Vector2.new(180, 180), EmissionDirection = Enum.NormalId.Top,
})

-- [ sons ] -----------------------------------------------------------------------------
local function loopSound(name: string): Sound?
	local tpl = sounds:FindFirstChild(name) :: Sound?
	if not tpl then return nil end
	local s = tpl:Clone(); s.Name = "Weather_" .. name; s.Looped = true; s.Volume = 0
	s.Parent = SoundService
	s:Play()
	return s
end
local windLoop = loopSound("Blizzard")
local function oneShot(name: string, vol: number, pitch: number?)
	if UI.Sfx == false then return end
	local tpl = sounds:FindFirstChild(name) :: Sound?
	if not tpl then return end
	local s = tpl:Clone(); s.Volume = vol; s.PlaybackSpeed = pitch or 1; s.Parent = SoundService
	s:Play()
	s.Ended:Once(function() s:Destroy() end)
	task.delay(12, function() if s.Parent then s:Destroy() end end)
end

-- [ état ] -----------------------------------------------------------------------------
local S, G = 0, 0          -- niveaux actuels : tempête de neige (0..1), tempête dorée (0..1)
local flashK = 0           -- éclair en cours (0..1)
local raysBoost = 0        -- éclaircie / début de tempête dorée
local lastKind = workspace:GetAttribute("StormKind") or ""
local windDir = Vector3.new(1, 0, 0.35).Unit
local nextThunder, nextGust, nextPillar = os.clock() + 8, os.clock() + 4, 0

local function targets(): (number, number)
	local kind = workspace:GetAttribute("StormKind")
	if kind == "Snow" then return 1, 0 end
	if kind == "Golden" then return 0.25, 1 end
	local nextAt = workspace:GetAttribute("NextStorm") :: number?
	if nextAt then
		local left = nextAt - workspace:GetServerTimeNow()
		if left > 0 and left <= 20 then return 0.45 * (1 - left / 20), 0 end -- le ciel se couvre pendant l'annonce
	end
	return 0, 0
end

local function lerpC(a: Color3, b: Color3, k: number): Color3 return a:Lerp(b, math.clamp(k, 0, 1)) end

-- éclair : flash blanc qui scintille + tonnerre un peu après
local function lightning()
	flashK = 1
	if flash then
		task.spawn(function()
			for _, t in ipairs({ 0.45, 0.85, 0.6, 1 }) do
				flash.BackgroundTransparency = t
				task.wait(0.06)
			end
		end)
	end
	task.delay(rng:NextNumber(0.3, 1.2), function() oneShot("Thunder", 0.5, rng:NextNumber(0.85, 1.05)) end)
end

-- colonne de lumière dorée qui tombe du ciel près du joueur (tempête dorée)
local function goldPillar(center: Vector3)
	local a = rng:NextNumber(0, math.pi * 2)
	local d = rng:NextNumber(12, 45)
	local pos = center + Vector3.new(math.cos(a) * d, 0, math.sin(a) * d)
	local hit = workspace:Raycast(pos + Vector3.new(0, 60, 0), Vector3.new(0, -140, 0))
	local y = hit and hit.Position.Y or center.Y
	local beam = Instance.new("Part")
	beam.Anchored = true; beam.CanCollide = false; beam.CanQuery = false; beam.CanTouch = false; beam.CastShadow = false
	beam.Material = Enum.Material.Neon; beam.Color = Color3.fromRGB(255, 214, 90); beam.Transparency = 1
	beam.Size = Vector3.new(1.6, 120, 1.6); beam.CFrame = CFrame.new(pos.X, y + 60, pos.Z)
	beam.Parent = fx
	local ring = Instance.new("Part")
	ring.Anchored = true; ring.CanCollide = false; ring.CanQuery = false; ring.CanTouch = false; ring.CastShadow = false
	ring.Shape = Enum.PartType.Cylinder; ring.Material = Enum.Material.Neon; ring.Color = Color3.fromRGB(255, 230, 140)
	ring.Size = Vector3.new(0.08, 2, 2); ring.CFrame = CFrame.new(pos.X, y + 0.15, pos.Z) * CFrame.Angles(0, 0, math.rad(90))
	ring.Transparency = 0.2
	ring.Parent = fx
	TweenService:Create(beam, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { Transparency = 0.35 }):Play()
	TweenService:Create(beam, TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.5), { Transparency = 1, Size = Vector3.new(0.2, 120, 0.2) }):Play()
	TweenService:Create(ring, TweenInfo.new(1.4), { Size = Vector3.new(0.08, 14, 14), Transparency = 1 }):Play()
	task.delay(2.9, function() beam:Destroy(); ring:Destroy() end)
end

-- début / fin de tempête
workspace:GetAttributeChangedSignal("StormKind"):Connect(function()
	local kind = workspace:GetAttribute("StormKind") or ""
	if kind == lastKind then return end
	if kind == "Snow" then
		streaks:Emit(220); chunks:Emit(40)
		oneShot("Gust", 0.6); oneShot("Whoosh", 0.4, 0.8)
		task.delay(0.4, lightning)
	elseif kind == "Golden" then
		raysBoost = 1
		if flash then
			flash.BackgroundColor3 = Color3.fromRGB(255, 225, 140); flash.BackgroundTransparency = 0.35
			TweenService:Create(flash, TweenInfo.new(1.2), { BackgroundTransparency = 1 }):Play()
			task.delay(1.3, function() if flash then flash.BackgroundColor3 = Color3.fromRGB(235, 245, 255) end end)
		end
		-- coupe la musique de fond pendant le jingle (MusicController)
		local jingle = sounds:FindFirstChild("GoldenJingle") :: Sound?
		local jl = (jingle and jingle.TimeLength > 0) and jingle.TimeLength or 26
		SoundService:SetAttribute("MusicDuckUntil", workspace:GetServerTimeNow() + math.min(jl, 12) + 0.5)
		oneShot("GoldenJingle", 0.45)
		oneShot("Fireworks", 0.4)
	elseif lastKind ~= "" then
		raysBoost = 0.7 -- éclaircie
		oneShot("Success", 0.3, 0.8)
	end
	lastKind = kind
end)

-- [ boucle ] ---------------------------------------------------------------------------
local t0 = os.clock()
RunService.RenderStepped:Connect(function(dt)
	local cam = workspace.CurrentCamera
	if not cam then return end
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local base = root and root.Position or cam.CFrame.Position
	local now = os.clock()

	-- niveaux qui glissent vers la cible (montée ~4 s, descente ~5 s)
	local tS, tG = targets()
	S += (tS - S) * math.min(1, dt * (tS > S and 0.35 or 0.25))
	G += (tG - G) * math.min(1, dt * (tG > G and 0.6 or 0.3))
	flashK = math.max(0, flashK - dt * 3)
	raysBoost = math.max(0, raysBoost - dt * 0.25)

	-- le vent tourne lentement
	local wa = math.sin((now - t0) * 0.05) * 0.6 + 0.3
	windDir = Vector3.new(math.cos(wa), 0, math.sin(wa))
	local windCF = CFrame.lookAt(Vector3.zero, Vector3.new(windDir.Z, 0, -windDir.X)) -- axe X (RightVector) = direction du vent

	-- placement des émetteurs
	sky.CFrame = CFrame.new(base + Vector3.new(0, 28, 0))
	wind.CFrame = CFrame.new(base - windDir * 55 + Vector3.new(0, 10, 0)) * windCF
	ground.CFrame = CFrame.new(base - windDir * 30 + Vector3.new(0, -2, 0)) * windCF

	-- particules
	flakes.Rate = 26 + 40 * S
	flakes.Acceleration = windDir * (0.8 + 10 * S) + Vector3.new(0, -1.5 - 4 * S, 0)
	soft.Rate = 7 * (1 - G) + 6 * S
	soft.Acceleration = windDir * (0.6 + 8 * S) + Vector3.new(0, -0.8, 0)
	streaks.Rate = 260 * S * S
	chunks.Rate = 26 * S * S
	mist.Rate = 10 * S
	goldFlakes.Rate = 45 * G
	glitter.Rate = 30 * G

	-- lumière
	if atmo then
		atmo.Density = B.AD + 0.3 * S
		atmo.Haze = B.AH + 2.5 * S + 0.3 * G
		atmo.Color = lerpC(lerpC(B.AC, Color3.fromRGB(205, 216, 230), S), Color3.fromRGB(255, 226, 168), G * 0.55)
		atmo.Decay = lerpC(lerpC(B.ADecay, Color3.fromRGB(120, 138, 168), S), Color3.fromRGB(255, 176, 96), G * 0.7)
	end
	Lighting.Brightness = B.Bright * (1 - 0.35 * S) + 0.5 * G + 1.6 * flashK
	Lighting.OutdoorAmbient = lerpC(lerpC(B.OutAmb, Color3.fromRGB(150, 165, 192), S), Color3.fromRGB(205, 180, 140), G * 0.5)
	if cc then
		cc.Saturation = B.Sat - 0.28 * S + 0.18 * G
		cc.Contrast = B.Con + 0.08 * S + 0.05 * G
		cc.TintColor = lerpC(lerpC(B.Tint, Color3.fromRGB(214, 230, 255), S), Color3.fromRGB(255, 236, 205), G)
		cc.Brightness = 0.25 * flashK
	end
	if bloom then bloom.Intensity = B.Bloom + 0.5 * G + 0.8 * flashK end
	if rays then rays.Intensity = B.Rays * (1 - S) + 0.18 * G + 0.25 * raysBoost end
	if dof then dof.FarIntensity = B.Dof + 0.3 * S end
	if clouds then
		clouds.Cover = math.min(0.95, B.Cover + 0.42 * S)
		clouds.Density = math.min(1, B.CDens + 0.45 * S)
		clouds.Color = lerpC(lerpC(B.CCol, Color3.fromRGB(150, 160, 178), S), Color3.fromRGB(255, 218, 150), G)
	end

	-- écran
	if frost then frost.GroupTransparency = 1 - 0.8 * S * (0.92 + 0.08 * math.sin(now * 1.7)) end
	if goldGui then goldGui.GroupTransparency = 1 - 0.55 * G * (0.85 + 0.15 * math.sin(now * 2.4)) end

	-- son du vent (léger en temps normal, fort en tempête)
	if windLoop then windLoop.Volume = (UI.Sfx == false) and 0 or (0.04 + 0.34 * S) end

	-- caméra qui tremble un peu dans le blizzard
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum and S > 0.3 then
		local a = 0.06 * (S - 0.3)
		hum.CameraOffset = Vector3.new(math.noise(now * 6, 1) * a * 3, math.noise(now * 6, 2) * a * 2, 0)
	end

	-- évènements aléatoires
	if S > 0.8 and now > nextThunder then
		nextThunder = now + rng:NextNumber(7, 14)
		lightning()
	end
	if S > 0.5 and now > nextGust then
		nextGust = now + rng:NextNumber(4, 9)
		streaks:Emit(120); chunks:Emit(18)
		oneShot("Gust", 0.35 * S, rng:NextNumber(0.85, 1.15))
	end
	if G > 0.6 and now > nextPillar then
		nextPillar = now + rng:NextNumber(0.5, 1.1)
		goldPillar(base)
	end
end)

-- au cas où on quitte une tempête : la caméra se remet droite
workspace:GetAttributeChangedSignal("StormKind"):Connect(function()
	if (workspace:GetAttribute("StormKind") or "") == "" then
		task.delay(6, function()
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then hum.CameraOffset = Vector3.zero end
		end)
	end
end)

return true
