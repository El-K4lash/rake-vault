--!strict
-- Client/LobbyController : les machines du lobby (Map.Hub).
--   * coffre FREE EGG : compte à rebours perso au-dessus du coffre (data.ChestAt).
--   * roue (prompt ClientAction = "Wheel") : demande un tour au serveur, fait tourner le disque 3D (Wheel.Disk,
--     pivot Disk.Axis) jusqu'au segment gagné, puis affiche le gain. Timer du prochain tour gratuit (data.SpinAt).
--   * incubateur (ClientAction = "Incubator") : super éclosion de l'œuf en main (prix affiché sur le prompt).
--   * machine de fusion : effets quand une fusion réussit (le menu est géré par FusionController).
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Lobby = require(Shared.Config.Lobby)
local Eggs = require(Shared.Config.Eggs)
local Format = require(Shared.Util.Format)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local hub = workspace:WaitForChild("Map"):WaitForChild("Hub")
local W = Lobby.Wheel

local function fmt(sec: number): string
	sec = math.max(0, math.floor(sec))
	if sec >= 3600 then return string.format("%d:%02d:%02d", sec // 3600, (sec % 3600) // 60, sec % 60) end
	return string.format("%d:%02d", sec // 60, sec % 60)
end
local function now(): number return workspace:GetServerTimeNow() end

-- éclair + étincelles à un endroit (effets locaux)
local function burst(pos: Vector3, color: Color3, n: number?)
	local a = Instance.new("Part")
	a.Anchored = true; a.CanCollide = false; a.CanQuery = false; a.CanTouch = false; a.Transparency = 1
	a.Size = Vector3.new(0.2, 0.2, 0.2); a.Position = pos; a.Parent = workspace
	local att = Instance.new("Attachment"); att.Parent = a
	local sp = Instance.new("ParticleEmitter")
	sp.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	sp.Color = ColorSequence.new(color, Color3.new(1, 1, 1)); sp.LightEmission = 1; sp.Rate = 0
	sp.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0) })
	sp.Lifetime = NumberRange.new(0.6, 1); sp.Speed = NumberRange.new(8, 16); sp.SpreadAngle = Vector2.new(180, 180)
	sp.Acceleration = Vector3.new(0, -10, 0); sp.Parent = att
	sp:Emit(n or 40)
	local l = Instance.new("PointLight"); l.Color = color; l.Range = 20; l.Brightness = 5; l.Parent = a
	TweenService:Create(l, TweenInfo.new(0.8), { Brightness = 0 }):Play()
	game:GetService("Debris"):AddItem(a, 1.5)
end

-- [ TIMERS AU-DESSUS DES MACHINES ] ------------------------------------------------------
local function setTimer(model: Instance?, text: string, color: Color3)
	local t = model and model:FindFirstChild("Timer", true) :: TextLabel?
	if t then t.Text = text; t.TextColor3 = color end
end
task.spawn(function()
	while true do
		local d = State.Data
		local left = (d and d.ChestAt or 0) - now()
		if left > 0 then setTimer(hub:FindFirstChild("FreeChest"), "ready in " .. fmt(left), Color3.new(1, 1, 1))
		else setTimer(hub:FindFirstChild("FreeChest"), "READY! Press E", Color3.fromRGB(120, 255, 140)) end
		local sl = (d and d.SpinAt or 0) - now()
		if sl > 0 then setTimer(hub:FindFirstChild("Wheel"), "next free spin " .. fmt(sl), Color3.new(1, 1, 1))
		else setTimer(hub:FindFirstChild("Wheel"), "FREE SPIN READY!", Color3.fromRGB(120, 255, 140)) end
		task.wait(0.5)
	end
end)

-- [ ROUE ] ---------------------------------------------------------------------------------
local spinning = false
local wheelAngle = 0 -- angle actuel du disque (degrés, repère de la roue)
local base: CFrame? = nil

local function disk(): (Model?, BasePart?)
	local w = hub:FindFirstChild("Wheel")
	local d = w and w:FindFirstChild("Disk") :: Model?
	return d, d and d:FindFirstChild("Axis") :: BasePart?
end

-- [ CLIQUET ] le pointeur rouge en haut : chaque séparateur qui passe le pousse sur le côté, puis il revient
-- en rebondissant (ressort amorti), comme une vraie roue de fête foraine.
local flap = 0      -- angle actuel du pointeur (degrés)
local flapVel = 0
local flapParts: { [BasePart]: CFrame } = {}
local flapPivot: CFrame? = nil
local function initFlap()
	local w = hub:FindFirstChild("Wheel")
	if flapPivot then
		local ok = false
		for p in pairs(flapParts) do if p.Parent then ok = true end end
		if ok then return end
		flapPivot = nil; flapParts = {}
	end
	if not w then return end
	local cap = w:FindFirstChild("PointerCap") :: BasePart?
	local _, axis = disk()
	if not cap or not axis then return end
	flapPivot = CFrame.new(cap.Position) * axis.CFrame.Rotation
	for _, p in ipairs(w:GetChildren()) do
		if p:IsA("BasePart") and (p.Name == "Pointer" or p:IsA("WedgePart")) then flapParts[p] = (flapPivot :: CFrame):ToObjectSpace(p.CFrame) end
	end
end
local function kick()
	initFlap()
	flap = -32; flapVel = 0 -- le disque tourne dans le sens anti-horaire : la pointe part vers la gauche
end
RunService.RenderStepped:Connect(function(dt)
	if not flapPivot or (math.abs(flap) < 0.05 and math.abs(flapVel) < 0.05) then return end
	dt = math.min(dt, 1 / 30)
	flapVel += (-420 * flap - 12 * flapVel) * dt
	flap += flapVel * dt
	local rot = (flapPivot :: CFrame) * CFrame.Angles(0, 0, math.rad(flap))
	for p, rel in pairs(flapParts) do
		if p.Parent then p.CFrame = rot * rel end
	end
end)

local function spinTo(seg: number, done: () -> ())
	local d, axis = disk()
	if not d or not axis then done(); return end
	base = base or axis.CFrame
	local target = 90 - W.Segments[seg].Angle + (math.random() - 0.5) * 18 -- le segment s'arrête sous le pointeur (en haut)
	local from = wheelAngle
	-- on avance toujours dans le même sens, au moins 5 tours
	local to = target
	while to < from + 360 * 5 do to += 360 end
	local t0 = os.clock()
	local dur = W.SpinTime
	-- séparateurs à 22.5° + 45° k (repère roue) ; un séparateur passe sous le pointeur (90°) tous les 45°
	local span = 360 / #W.Segments
	local lastTick = math.floor((from - span / 2) / span)
	local conn
	conn = RunService.RenderStepped:Connect(function()
		local k = math.clamp((os.clock() - t0) / dur, 0, 1)
		local e = 1 - (1 - k) ^ 4 -- ralentit à la fin
		wheelAngle = from + (to - from) * e
		if base then d:PivotTo(base * CFrame.Angles(0, 0, math.rad(wheelAngle))) end
		local tick = math.floor((wheelAngle - span / 2) / span)
		if tick ~= lastTick then lastTick = tick; kick(); UI.Play("Click", 0.3) end
		if k >= 1 then
			conn:Disconnect()
			wheelAngle %= 360
			done()
		end
	end)
end

-- ampoules de la jante : clignotent doucement, chenillard rapide pendant un tour
local WHITE, WARM, OFF = Color3.fromRGB(255, 250, 240), Color3.fromRGB(255, 226, 122), Color3.fromRGB(120, 100, 60)
task.spawn(function()
	local t = 0
	while true do
		local d = disk()
		if d then
			t += 1
			for _, b in ipairs(d:GetChildren()) do
				local k = b:GetAttribute("Bulb")
				if type(k) == "number" and b:IsA("BasePart") then
					local on
					if spinning then on = (k + t) % 4 == 0 else on = (k + math.floor(t / 4)) % 2 == 0 end
					b.Color = on and (k % 2 == 0 and WHITE or WARM) or OFF
					b.Material = on and Enum.Material.Neon or Enum.Material.SmoothPlastic
				end
			end
		end
		task.wait(spinning and 0.06 or 0.15)
	end
end)

local function onWheel()
	if spinning then return end
	spinning = true
	local res = State.Ask("SpinWheel")
	if not res or not res.ok then
		State.Notify:Fire(res and res.msg or "Try again", "error")
		spinning = false
		return
	end
	-- le gain n'est donné (serveur) qu'à la fin du tour : la fenêtre s'ouvre sur l'événement "WheelReward"
	spinTo(res.Seg, function()
		spinning = false
		local r = W.Rewards[res.Reward]
		local _, axis = disk()
		if axis then burst(axis.Position, r and r.Color or Color3.new(1, 1, 1), res.Reward == "Jackpot" and 80 or 40) end
	end)
end

-- [ FENÊTRE DU GAIN ] (StarterGui.WheelWin) -------------------------------------------------
local ICONS = { Coins = 103944045008759, Money = 103944045008759, Boost = 103944045008759, Egg = 140583595805309,
	Luck = 81193001619814, Jackpot = 94666332436790 }
local winGui = player:WaitForChild("PlayerGui"):WaitForChild("WheelWin", 20) :: ScreenGui?
local winOpen = false
local closeWin: () -> ()
local function popIn(o: Instance?, from: number, t: number, style: Enum.EasingStyle?)
	local sc = o and o:FindFirstChild("Pop") :: UIScale?
	if not sc then return end
	sc.Scale = from
	TweenService:Create(sc, TweenInfo.new(t, style or Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end
function closeWin()
	if not winGui or not winOpen then return end
	winOpen = false
	local card = winGui:FindFirstChild("Card") :: GuiObject
	local sc = card:FindFirstChild("Pop") :: UIScale?
	if sc then TweenService:Create(sc, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 }):Play() end
	task.delay(0.2, function() if not winOpen and winGui then winGui.Enabled = false end end)
end
local function showWin(kind: string, text: string)
	if not winGui then State.Notify:Fire(tostring(text), "success"); return end
	local r = W.Rewards[kind]
	local color = r and r.Color or Color3.new(1, 1, 1)
	local jackpot = kind == "Jackpot"
	local card = winGui:FindFirstChild("Card") :: Frame
	local box = card:FindFirstChild("IconBox") :: ImageLabel
	(box:FindFirstChild("Icon") :: ImageLabel).Image = "rbxassetid://" .. tostring(ICONS[kind] or ICONS.Coins)
	box.ImageColor3 = color
	local name = card:FindFirstChild("RewardName") :: TextLabel
	name.Text = string.upper(r and r.Name or kind); name.TextColor3 = color
	local amount = card:FindFirstChild("Amount") :: TextLabel
	-- boosts : le nom dit déjà "x2", le montant affiche la durée
	amount.Text = (kind == "Luck" or kind == "Boost") and "10 MIN" or text
	UI.SetText(card, "Title", jackpot and "JACKPOT!!" or "YOU WON!")
	winGui.Enabled = true
	winOpen = true
	-- fond + carte qui arrive, puis l'icône qui rebondit
	local dim = winGui:FindFirstChild("Dim") :: Frame
	dim.BackgroundTransparency = 1
	TweenService:Create(dim, TweenInfo.new(0.25), { BackgroundTransparency = 0.5 }):Play()
	popIn(card, 0.2, 0.45)
	box.Visible = false
	task.delay(0.25, function() box.Visible = true; popIn(box, 0.1, 0.5, Enum.EasingStyle.Elastic) end)
	amount.TextTransparency = 1
	local st0 = amount:FindFirstChildOfClass("UIStroke"); if st0 then st0.Transparency = 1 end
	task.delay(0.45, function()
		TweenService:Create(amount, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
		local st = amount:FindFirstChildOfClass("UIStroke"); if st then st.Transparency = 0 end
		local sc = amount:FindFirstChild("Pop") :: UIScale?
		if not sc then sc = Instance.new("UIScale"); (sc :: UIScale).Name = "Pop"; (sc :: UIScale).Parent = amount end
		popIn(amount, 1.6, 0.4)
	end)
	UI.Play(jackpot and "LevelUp" or "Win", 0.7)
	if jackpot then task.delay(0.3, function() UI.Play("Fireworks", 0.6) end) end
	-- confettis
	local conf = winGui:FindFirstChild("Confetti") :: Frame
	for i, c in ipairs(conf:GetChildren()) do
		if c:IsA("Frame") then
			if not jackpot and i % 2 == 0 then c.Visible = false; continue end
			c.Visible = true
			local x = math.random()
			c.Position = UDim2.new(x, 0, -0.05 - math.random() * 0.25, 0)
			c.Rotation = math.random(0, 360)
			TweenService:Create(c, TweenInfo.new(1.8 + math.random() * 1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(x + (math.random() - 0.5) * 0.25, 0, 1.05, 0), Rotation = c.Rotation + math.random(-540, 540),
			}):Play()
		end
	end
	-- les rayons tournent tant que la fenêtre est ouverte
	local rays = winGui:FindFirstChild("Rays") :: Frame
	task.spawn(function()
		while winOpen and rays.Parent do
			rays.Rotation = (rays.Rotation + (jackpot and 1.6 or 0.7)) % 360
			RunService.RenderStepped:Wait()
		end
	end)
	-- se ferme tout seul après quelques secondes
	local token = os.clock()
	winGui:SetAttribute("Token", token)
	task.delay(jackpot and 7 or 5, function() if winGui and winGui:GetAttribute("Token") == token then closeWin() end end)
end
if winGui then
	local claim = (winGui:FindFirstChild("Card") :: Frame):FindFirstChild("Claim") :: GuiButton
	UI.Button(claim, function() closeWin() end)
end

-- [ INCUBATEUR ] ----------------------------------------------------------------------------
local function heldEgg(): (string?, any)
	local char = player.Character
	local tool = char and char:FindFirstChildOfClass("Tool")
	local id = tool and tool:GetAttribute("EggId") :: string?
	return id, id and Eggs.ById[id]
end

local incPrompt: ProximityPrompt? = nil
local function drawIncubator()
	if not incPrompt then return end
	local _, def = heldEgg()
	local d = State.Data
	if def and d then
		incPrompt.ActionText = "Super Hatch " .. Format.Money(Lobby.Incubator.Cost(def.Order, d.Rebirths or 0))
		incPrompt.ObjectText = def.Name .. " · x3 mutation luck"
	else
		incPrompt.ActionText = "Hold an egg"
		incPrompt.ObjectText = "Super Hatch · x3 mutation luck"
	end
end

local hatching = false
local function onIncubator()
	if hatching then return end
	local id, def = heldEgg()
	if not id or not def then
		State.Notify:Fire("Hold an egg in your hand, then use the incubator!", "error")
		return
	end
	hatching = true
	local inc = hub:FindFirstChild("Incubator")
	local cf = inc and (inc :: Model):GetBoundingBox()
	-- petite secousse de la machine pendant l'éclosion
	if inc and cf then
		local start = (inc :: Model):GetPivot()
		for i = 1, 8 do
			(inc :: Model):PivotTo(start * CFrame.new(math.random(-10, 10) / 60, 0, math.random(-10, 10) / 60))
			task.wait(0.05)
		end
		(inc :: Model):PivotTo(start)
	end
	local res = State.Ask("SuperHatch", id)
	hatching = false
	if res and res.ok then
		if cf then burst(cf.Position + Vector3.new(0, 2, 0), Color3.fromRGB(120, 255, 170), 60) end
		UI.Play("LevelUp", 0.5)
	else
		State.Notify:Fire(res and res.msg or "Try again", "error")
	end
	drawIncubator()
end

-- [ FUSION : effets sur la machine ] ---------------------------------------------------------------
State.Event.Event:Connect(function(name, payload)
	if name == "WheelReward" and type(payload) == "table" then showWin(tostring(payload.Reward), tostring(payload.Text)) end
end)
State.Event.Event:Connect(function(name, payload)
	if name ~= "FusionDone" then return end
	local m = hub:FindFirstChild("FusionMachine") :: Model?
	if not m then return end
	local cf = m:GetBoundingBox()
	burst(cf.Position + Vector3.new(0, 3, 0), Color3.fromRGB(215, 140, 255), 70)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("ParticleEmitter") then d:Emit(25) end
	end
end)

-- [ PROMPTS ] --------------------------------------------------------------------------------------
local function hook(d: Instance)
	if not d:IsA("ProximityPrompt") then return end
	local a = d:GetAttribute("ClientAction")
	if a == "Wheel" then
		d.Triggered:Connect(onWheel)
	elseif a == "Incubator" then
		incPrompt = d
		d.Triggered:Connect(onIncubator)
		drawIncubator()
	end
end
for _, d in ipairs(hub:GetDescendants()) do hook(d) end
hub.DescendantAdded:Connect(hook)

-- prix de l'incubateur selon l'œuf en main
local function watchChar(char: Model)
	char.ChildAdded:Connect(function(c) if c:IsA("Tool") then drawIncubator() end end)
	char.ChildRemoved:Connect(function(c) if c:IsA("Tool") then task.defer(drawIncubator) end end)
end
if player.Character then watchChar(player.Character) end
player.CharacterAdded:Connect(watchChar)
State.On({ "Rebirths", "Eggs" }, drawIncubator)

return true
