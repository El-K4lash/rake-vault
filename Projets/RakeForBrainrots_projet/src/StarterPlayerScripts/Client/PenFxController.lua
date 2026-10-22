--!strict
-- Client/PenFxController : animation quand un enclos change de clôture (achat au shop) ou s'agrandit (slot / rebirth).
-- Le serveur garde l'ancien enclos ("OldPen", sans collisions) ~5 s et marque le nouveau (attributs Anim / AnimAt).
-- Ici : une vague part du portail et fait le tour de l'enclos ; sur son passage l'ancienne clôture s'enfonce et s'efface,
-- la nouvelle sort du sol avec un rebond, des étincelles, un éclair de lumière et un anneau d'onde. Pour finir,
-- une aura (Highlight) de la couleur de la nouvelle clôture pulse sur tout l'enclos. Joué chez tous les joueurs.
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")

local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local SPEED = 18        -- studs / s de la vague
local RISE = 3.2        -- profondeur d'où sort la nouvelle clôture
local BUCKET = 5        -- un effet (étincelles + lumière) tous les ~5 studs
local ANIMATED = { Fence = true, Gate = true, UpgradeBoardModel = true, StatsBoardModel = true }

local fxFolder = Instance.new("Folder"); fxFolder.Name = "PenFx"; fxFolder.Parent = workspace

local function parts(pen: Instance): { BasePart }
	local out = {}
	for _, c in ipairs(pen:GetChildren()) do
		if ANIMATED[c.Name] then
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("BasePart") then table.insert(out, d) end
			end
		end
	end
	return out
end

local function flat(v: Vector3): Vector3 return Vector3.new(v.X, 0, v.Z) end

-- étincelles + éclair à un endroit de la vague
local function burst(pos: Vector3, color: Color3, big: boolean?)
	local a = Instance.new("Part")
	a.Anchored = true; a.CanCollide = false; a.CanQuery = false; a.CanTouch = false; a.Transparency = 1
	a.Size = Vector3.new(0.2, 0.2, 0.2); a.Position = pos; a.Parent = fxFolder
	local att = Instance.new("Attachment"); att.Parent = a
	local sp = Instance.new("ParticleEmitter")
	sp.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	sp.Color = ColorSequence.new(color, Color3.new(1, 1, 1))
	sp.LightEmission = 1
	sp.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, big and 1.1 or 0.6), NumberSequenceKeypoint.new(1, 0) })
	sp.Lifetime = NumberRange.new(0.5, 0.9)
	sp.Speed = NumberRange.new(big and 10 or 5, big and 18 or 10)
	sp.SpreadAngle = Vector2.new(180, 180)
	sp.Acceleration = Vector3.new(0, -12, 0)
	sp.Rate = 0
	sp.Parent = att
	sp:Emit(big and 40 or 14)
	local smoke = Instance.new("ParticleEmitter")
	smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
	smoke.Color = ColorSequence.new(Color3.fromRGB(235, 225, 200))
	smoke.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 3) })
	smoke.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1) })
	smoke.Lifetime = NumberRange.new(0.5, 0.8)
	smoke.Speed = NumberRange.new(2, 5)
	smoke.SpreadAngle = Vector2.new(70, 70)
	smoke.Rate = 0
	smoke.Parent = att
	smoke:Emit(big and 12 or 4)
	local light = Instance.new("PointLight"); light.Color = color; light.Range = big and 26 or 14; light.Brightness = big and 6 or 3; light.Parent = a
	TweenService:Create(light, TweenInfo.new(0.6), { Brightness = 0 }):Play()
	-- éclair (boule néon qui gonfle et s'efface)
	local f = Instance.new("Part")
	f.Shape = Enum.PartType.Ball; f.Material = Enum.Material.Neon; f.Color = color
	f.Anchored = true; f.CanCollide = false; f.CanQuery = false; f.CanTouch = false; f.CastShadow = false
	f.Size = Vector3.new(1, 1, 1); f.Position = pos + Vector3.new(0, 2, 0); f.Transparency = 0.2; f.Parent = fxFolder
	TweenService:Create(f, TweenInfo.new(0.45, Enum.EasingStyle.Quad), { Size = Vector3.new(1, 1, 1) * (big and 9 or 4.5), Transparency = 1 }):Play()
	Debris:AddItem(f, 0.6)
	Debris:AddItem(a, 1.2)
end

-- anneau d'onde au sol qui part du portail : 32 petits segments néon qui s'écartent en cercle
local function shockwave(pos: Vector3, color: Color3, radius: number)
	local n = 32
	local dur = radius / SPEED
	for i = 1, n do
		local ang = (i / n) * math.pi * 2
		local dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
		local seg = Instance.new("Part")
		seg.Material = Enum.Material.Neon; seg.Color = color
		seg.Anchored = true; seg.CanCollide = false; seg.CanQuery = false; seg.CanTouch = false; seg.CastShadow = false
		seg.Size = Vector3.new(0.35, 0.25, 1.2)
		local c0 = CFrame.lookAt(pos + Vector3.new(0, 0.35, 0) + dir * 1.5, pos + Vector3.new(0, 0.35, 0) + dir * 1.5 + dir:Cross(Vector3.yAxis))
		seg.CFrame = c0; seg.Transparency = 0.1; seg.Parent = fxFolder
		TweenService:Create(seg, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
			CFrame = c0 + dir * radius, Size = Vector3.new(0.35, 0.25, radius * 2 * math.pi / n * 0.8), Transparency = 1,
		}):Play()
		Debris:AddItem(seg, dur + 0.1)
	end
end

local playing: { [Instance]: boolean } = {}

local function play(pen: Model, oldPen: Model?)
	if playing[pen] then return end
	playing[pen] = true
	local gate = pen:FindFirstChild("Gate") :: Model?
	local origin = gate and flat(gate:GetBoundingBox().Position) or flat(pen:GetPivot().Position)
	local groundY = (gate and gate:GetBoundingBox().Position.Y or pen:GetPivot().Position.Y)
	-- couleur dominante de la nouvelle clôture (le rail le plus fréquent)
	local counts: { [string]: number } = {}
	local color = Color3.fromRGB(255, 220, 120)
	local best = 0
	local fence = pen:FindFirstChild("Fence")
	if fence then
		for _, d in ipairs(fence:GetDescendants()) do
			if d:IsA("BasePart") and d.Size.Magnitude > 3 then
				local k = d.Color:ToHex()
				counts[k] = (counts[k] or 0) + 1
				if counts[k] > best then best = counts[k]; color = d.Color end
			end
		end
	end

	-- nouvelles pièces : cachées et enfoncées, on garde leur place
	local news = parts(pen)
	local homes: { [BasePart]: CFrame } = {}
	for _, p in ipairs(news) do
		homes[p] = p.CFrame
		p.LocalTransparencyModifier = 1
		p.CFrame = p.CFrame - Vector3.new(0, RISE, 0)
	end
	-- textes des panneaux (SurfaceGui / BillboardGui) : LocalTransparencyModifier ne les cache pas, ils resteraient
	-- visibles 3 studs plus bas pendant la vague -> on les coupe et on les rallume quand leur pièce est revenue en place
	local guis: { [BasePart]: { LayerCollector } } = {}
	local guiState: { [LayerCollector]: boolean } = {}
	for _, c in ipairs(pen:GetChildren()) do
		if ANIMATED[c.Name] then
			for _, d in ipairs(c:GetDescendants()) do
				if d:IsA("SurfaceGui") or d:IsA("BillboardGui") then
					local host = (d.Adornee or d.Parent) :: Instance?
					if host and host:IsA("BasePart") and homes[host] then
						guiState[d] = d.Enabled
						d.Enabled = false
						guis[host] = guis[host] or {}
						table.insert(guis[host], d)
					end
				end
			end
		end
	end
	-- panneaux UPGRADES / MY STATS : leurs SurfaceGui sont dans le PlayerGui (Adornee posé par BoardController)
	local pg = player:FindFirstChildOfClass("PlayerGui")
	for _, pair in ipairs({ { "UpgradeBoardGui", "UpgradeBoard" }, { "StatsBoardGui", "StatsBoard" } }) do
		local g = pg and pg:FindFirstChild(pair[1])
		local host = pen:FindFirstChild(pair[2], true)
		if g and g:IsA("LayerCollector") and host and host:IsA("BasePart") and homes[host] and guiState[g] == nil then
			guiState[g] = true
			g.Enabled = false
			guis[host] = guis[host] or {}
			table.insert(guis[host], g)
		end
	end
	local function showGuis(p: BasePart)
		for _, g in ipairs(guis[p] or {}) do if g.Parent then g.Enabled = guiState[g] end end
		guis[p] = nil
	end
	-- ancien enclos : le sol disparaît tout de suite (le nouveau est dessous), la clôture attend la vague
	local olds: { BasePart } = {}
	if oldPen then
		for _, d in ipairs(oldPen:GetDescendants()) do
			if d:IsA("BasePart") then
				if d:FindFirstAncestor("Fence") or d:FindFirstAncestor("Gate") or d:FindFirstAncestor("UpgradeBoardModel") or d:FindFirstAncestor("StatsBoardModel") then
					table.insert(olds, d)
				else
					d.LocalTransparencyModifier = 1
				end
			elseif d:IsA("SurfaceGui") or d:IsA("BillboardGui") then
				d.Enabled = false
			end
		end
	end

	local maxD = 0
	for _, p in ipairs(news) do maxD = math.max(maxD, (flat(p.Position) - origin).Magnitude) end

	-- départ : grosse explosion au portail + onde
	burst(origin + Vector3.new(0, groundY - origin.Y + 3, 0), color, true)
	shockwave(Vector3.new(origin.X, groundY, origin.Z), color, maxD + 6)
	if pen.Parent and pen.Parent:GetAttribute("Owner") == player.UserId then
		UI.Play("LevelUp", 0.6)
	end

	-- vague : chaque pièce part quand l'onde arrive à elle
	local fired: { [number]: boolean } = {}
	local function schedule(p: BasePart, isNew: boolean)
		local d = (flat(isNew and homes[p].Position or p.Position) - origin).Magnitude
		task.delay(d / SPEED, function()
			if not p.Parent then return end
			if isNew then
				p.LocalTransparencyModifier = 0
				local tw = TweenService:Create(p, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { CFrame = homes[p] })
				tw.Completed:Once(function() showGuis(p) end)
				tw:Play()
				local b = math.floor(d / BUCKET)
				if not fired[b] then
					fired[b] = true
					-- un effet par "tranche" de distance, réparti sur le tour : on prend la position de cette pièce
					burst(homes[p].Position, color, false)
				end
			else
				TweenService:Create(p, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					CFrame = p.CFrame - Vector3.new(0, RISE, 0), Transparency = 1,
				}):Play()
			end
		end)
	end
	for _, p in ipairs(olds) do schedule(p, false) end
	for _, p in ipairs(news) do schedule(p, true) end

	-- fin : aura de la nouvelle couleur sur tout l'enclos
	task.delay(maxD / SPEED + 0.45, function()
		if not pen.Parent then playing[pen] = nil; return end
		for _, p in ipairs(news) do if p.Parent and homes[p] then p.CFrame = homes[p]; p.LocalTransparencyModifier = 0; showGuis(p) end end
		local h = Instance.new("Highlight")
		h.Adornee = pen; h.FillColor = color; h.OutlineColor = Color3.new(1, 1, 1)
		h.FillTransparency = 0.35; h.OutlineTransparency = 0; h.DepthMode = Enum.HighlightDepthMode.Occluded
		h.Parent = fxFolder
		TweenService:Create(h, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { FillTransparency = 1, OutlineTransparency = 1 }):Play()
		Debris:AddItem(h, 1.5)
		burst(origin + Vector3.new(0, groundY - origin.Y + 5, 0), Color3.new(1, 1, 1), true)
		task.delay(2, function() playing[pen] = nil end)
	end)
end

local function watchPlot(plot: Instance)
	plot.ChildAdded:Connect(function(c)
		if c.Name ~= "Pen" or not c:IsA("Model") then return end
		-- les attributs arrivent avec l'instance ; on laisse le temps aux enfants de répliquer
		task.wait(0.25)
		local at = c:GetAttribute("AnimAt")
		if c:GetAttribute("Anim") and type(at) == "number" and workspace:GetServerTimeNow() - at < 3 then
			play(c, plot:FindFirstChild("OldPen") :: Model?)
		end
	end)
end

local map = workspace:WaitForChild("Map")
local plots = map:WaitForChild("Plots")
for _, p in ipairs(plots:GetChildren()) do watchPlot(p) end
plots.ChildAdded:Connect(watchPlot)

return true
