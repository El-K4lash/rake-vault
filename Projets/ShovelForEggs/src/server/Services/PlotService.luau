--!strict
-- ServerScriptService/Services/PlotService
-- Les enclos des joueurs (un par plot autour du hub) :
--   * attribution d'un plot à l'arrivée, construction de l'enclos (taille selon les slots, clôture achetée)
--   * pets posés dans l'enclos (Slot > 0) : modèles posés au hasard, le client les fait se balader
--   * œufs en incubation affichés dans l'enclos (EggService gère l'éclosion)
--   * argent produit par les pets de l'enclos (en ligne + hors ligne plafonné), pad de collecte

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)
local Upgrades = require(Shared.Config.Upgrades)
local Eggs = require(Shared.Config.Eggs)
local Format = require(Shared.Util.Format)
local PenBuilder = require(Shared.PenBuilder)
local Levels = require(Shared.Config.Levels)
local Rebirth = require(Shared.Config.Rebirth)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)

local PlotService = {}

local OFFLINE_MAX = 2 * 3600 -- 2 h de production hors ligne max
local MODEL_SIZE = 8.5         -- taille max d'un pet dans l'enclos (studs)

type PlotInfo = {
	Model: Model, Root: CFrame, Owner: Player?, Pen: Model?,
	Models: { [string]: Model }, EggModels: { [string]: Model },
	Pad: BasePart?, PadConn: RBXScriptConnection?, Size: Vector2?, Fence: string?, PenW: number?, PenL: number?,
}
local plots: { PlotInfo } = {}
local byPlayer: { [Player]: PlotInfo } = {}
local rng = Random.new()

local function assets(): Folder
	return ReplicatedStorage:WaitForChild("Assets") :: Folder
end

-- [ CAPACITÉ ] ----------------------------------------------------------------
local function incubatingCount(data: any): number
	local n = 0
	for _ in pairs(data.Incubating) do n += 1 end
	return n
end
local function penCount(data: any): number
	local n = 0
	for _, e in pairs(data.Pets) do if e.Slot and e.Slot > 0 then n += 1 end end
	return n
end
function PlotService.Capacity(data: any): number
	return math.min(data.Slots, Upgrades.MaxSlots)
end
-- les 2 premiers œufs en incubation ne prennent pas de place : on peut toujours faire éclore 2 œufs,
-- même avec un chalet rempli de brainrots (sinon les nouveaux joueurs ne comprennent pas pourquoi ça bloque)
PlotService.FreeEggs = 2
function PlotService.Used(data: any): number
	return penCount(data) + math.max(0, incubatingCount(data) - PlotService.FreeEggs)
end
local function freeSlot(data: any): number?
	if PlotService.Used(data) >= PlotService.Capacity(data) then return nil end
	local used = {}
	for _, e in pairs(data.Pets) do if e.Slot and e.Slot > 0 then used[e.Slot] = true end end
	for i = 1, Upgrades.MaxSlots * 2 do
		if not used[i] then return i end
	end
	return nil
end
PlotService.FreeSlot = freeSlot

-- [ ENCLOS ] ------------------------------------------------------------------
local function updatePad(info: PlotInfo, data: any?)
	local pad = info.Pad
	if not pad then return end
	local gui = pad:FindFirstChild("CollectGui") :: BillboardGui?
	if not gui then
		local g = Instance.new("BillboardGui")
		g.Name = "CollectGui"; g.Size = UDim2.fromScale(8, 2); g.StudsOffset = Vector3.new(0, 3, 0)
		g.MaxDistance = 80; g.LightInfluence = 0; g.Parent = pad
		local t = Instance.new("TextLabel"); t.Name = "Text"; t.BackgroundTransparency = 1; t.Size = UDim2.fromScale(1, 1)
		t.TextScaled = true; t.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		t.TextColor3 = Color3.fromRGB(150, 255, 120); t.Parent = g
		local s = Instance.new("UIStroke"); s.Thickness = 2.5; s.Parent = t
		gui = g
	end
	local label = (gui :: BillboardGui):FindFirstChild("Text") :: TextLabel
	label.Text = data and ("COLLECT\n" .. Format.Money(data.Pending)) or "COLLECT"
end

local onCollect: (Player) -> ()

-- (re)construit la clôture si la taille ou le style changent
local function buildPen(info: PlotInfo, data: any?)
	local slots = data and data.Slots or Upgrades.FreeSlots
	local w, l = Upgrades.Pen.Size(slots)
	-- couleur de la clôture : selon les rebirths (ou celle du shop si elle est mieux)
	local fenceId = Upgrades.FenceFor(data)
	-- (comparaison avec une tolérance : un Vector2 stocke des float32, l'égalité stricte échouait
	-- et l'enclos était reconstruit à chaque rafraîchissement -> clignotement)
	if info.Pen and info.Pen.Parent and info.PenW and math.abs(info.PenW - w) < 0.01 and math.abs(info.PenL - l) < 0.01 and info.Fence == fenceId then return false end
	local style = Upgrades.FenceById[fenceId] or Upgrades.FenceById.Wood
	local name = info.Owner and info.Owner.DisplayName or nil
	-- changement de clôture (shop) ou agrandissement (slot / rebirth) : l'ancien enclos reste quelques secondes
	-- (sans collisions) pour que les clients jouent l'animation de transition (Client/PenFxController)
	local animReason: string? = nil
	if info.Pen and info.Pen.Parent and info.Owner then
		animReason = (info.Fence ~= fenceId) and "Fence" or "Grow"
		local prev = info.Model:FindFirstChild("OldPen"); if prev then prev:Destroy() end
		local old = info.Pen :: Model
		old.Name = "OldPen"
		for _, d in ipairs(old:GetDescendants()) do
			if d:IsA("BasePart") then d.CanCollide = false; d.CanTouch = false; d.CanQuery = false end
		end
		task.delay(5, function() if old.Parent then old:Destroy() end end)
	end
	info.Pen = PenBuilder.Build(info.Model, info.Root, w, l, style, name)
	if animReason then
		(info.Pen :: Model):SetAttribute("Anim", animReason);
		(info.Pen :: Model):SetAttribute("AnimAt", workspace:GetServerTimeNow())
	end
	info.Size = Vector2.new(w, l)
	info.PenW, info.PenL = w, l
	info.Fence = fenceId
	local placed = info.Model:FindFirstChild("Placed") or Instance.new("Folder")
	placed.Name = "Placed"; placed.Parent = info.Model
	if info.PadConn then info.PadConn:Disconnect() end
	local pen = info.Pen :: Model
	local pad = pen:FindFirstChild("CollectPad", true) :: BasePart?
	info.Pad = pad
	if pad then
		info.PadConn = pad.Touched:Connect(function(hit)
			local p = Players:GetPlayerFromCharacter(hit.Parent)
			if p and info.Owner == p then onCollect(p) end
		end)
	end
	updatePad(info, data)
	return true
end

-- point dans la zone de balade (coordonnées relatives u,v ∈ [-0.5, 0.5]), au sol
local function areaPoint(info: PlotInfo, u: number, v: number): Vector3
	local area = info.Pen and info.Pen:FindFirstChild("Area") :: BasePart?
	if not area then return info.Root.Position end
	return (area.CFrame * CFrame.new(u * area.Size.X, -area.Size.Y / 2, v * area.Size.Z)).Position
end
function PlotService.AreaPoint(player: Player, u: number, v: number): Vector3?
	local info = byPlayer[player]
	return info and areaPoint(info, u, v) or nil
end

-- position monde -> (u, v) dans l'enclos du joueur (nil si dehors)
function PlotService.ToPen(player: Player, pos: Vector3): (number?, number?)
	local info = byPlayer[player]
	local area = info and info.Pen and info.Pen:FindFirstChild("Area") :: BasePart?
	if not area then return nil, nil end
	local rel = area.CFrame:PointToObjectSpace(pos)
	local u, v = rel.X / area.Size.X, rel.Z / area.Size.Z
	if u ~= u or v ~= v or rel.Y ~= rel.Y then return nil, nil end -- NaN
	if math.abs(u) > 0.5 or math.abs(v) > 0.5 or math.abs(rel.Y) > 8 then return nil, nil end
	return u, v
end

-- [ BRAINROTS DANS L'ENCLOS ] --------------------------------------------------
-- boîte englobante alignée sur les axes du monde (GetBoundingBox suit l'orientation du pivot)
local function worldBounds(m: Model): (Vector3, Vector3)
	local lo, hi = Vector3.new(math.huge, math.huge, math.huge), Vector3.new(-math.huge, -math.huge, -math.huge)
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") and d.Transparency < 1 then
			local cf, h = d.CFrame, d.Size / 2
			for _, sx in ipairs({ -1, 1 }) do for _, sy in ipairs({ -1, 1 }) do for _, sz in ipairs({ -1, 1 }) do
				local w = cf * Vector3.new(h.X * sx, h.Y * sy, h.Z * sz)
				lo = lo:Min(w); hi = hi:Max(w)
			end end end
		end
	end
	if lo.X == math.huge then local cf, s = m:GetBoundingBox(); return cf.Position - s / 2, cf.Position + s / 2 end
	return lo, hi
end
local function worldSize(m: Model): Vector3 local lo, hi = worldBounds(m); return hi - lo end
local function worldMinY(m: Model): number local lo = worldBounds(m); return lo.Y end
local function petTemplate(id: string, mutId: string): Model?
	local mut = Mutations.ById[mutId] or Mutations.ById.Normal
	local folder = assets():FindFirstChild("Pets")
	local variant = folder and folder:FindFirstChild(mut.Folder)
	local t = variant and variant:FindFirstChild(id) :: Model?
	if not t then
		variant = folder and folder:FindFirstChild("Normal")
		t = variant and variant:FindFirstChild(id) :: Model?
	end
	return t
end
PlotService.PetTemplate = petTemplate

-- texte du billboard : nom (+ niveau) et revenu
local function fillInfo(g: Instance, entry: any, data: any?)
	local labels = g:FindFirstChild("TextLabels")
	if not labels then return end
	local n = labels:FindFirstChild("Name") :: TextLabel?
	local e = labels:FindFirstChild("Earnings") :: TextLabel?
	local lv = Levels.Of(entry)
	if n then n.Text = entry.Id .. (lv > 1 and (lv >= Levels.Max and "  [MAX]" or ("  [Lv " .. lv .. "]")) or "") end
	if e then e.Text = data and (Format.Money(Stats.PetIncome(data, entry)) .. "/s") or "" end
end

local function infoGui(entry: any, data: any?, height: number): BillboardGui?
	local tpl = assets():FindFirstChild("GuiTemplates")
	local src = tpl and tpl:FindFirstChild("InfoGUI") :: BillboardGui?
	if not src then return nil end
	local g = src:Clone()
	local br = Pets.ById[entry.Id]
	local r = br and Pets.RarityById[br.Rarity]
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	local labels = g:FindFirstChild("TextLabels")
	if labels then
		local n = labels:FindFirstChild("Name") :: TextLabel?
		local e = labels:FindFirstChild("Earnings") :: TextLabel?
		local ra = labels:FindFirstChild("Rarity") :: TextLabel?
		local mu = labels:FindFirstChild("Mutation") :: TextLabel?
		local ti = labels:FindFirstChild("Timer") :: TextLabel?
		if n then n.Text = entry.Id end
		if e then e.Text = "" end
		if ra and r then ra.Text = r.Name; ra.TextColor3 = r.Color end
		if mu then mu.Text = mut.Id == "Normal" and "" or mut.Name; mu.TextColor3 = mut.Color; mu.Visible = mut.Id ~= "Normal" end
		if ti then ti.Visible = false end
	end
	fillInfo(g, entry, data)
	g.StudsOffset = Vector3.new(0, height / 2 + 1.6, 0)
	g.MaxDistance = 70
	return g
end

local function render(info: PlotInfo, uid: string, entry: any?, data: any?)
	local old = info.Models[uid]
	if old then old:Destroy(); info.Models[uid] = nil end
	if not entry or not entry.Slot or entry.Slot <= 0 or not info.Pen then return end
	local template = petTemplate(entry.Id, entry.Mut)
	if not template then return end
	local m = template:Clone()
	m.Name = uid
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false end
		if d:IsA("LuaSourceContainer") then d:Destroy() end
	end
	-- la rotation du modèle (souvent 90° sur X dans le pack) est gardée : sinon il se retrouve couché
	local rot = m:GetPivot().Rotation
	local size = worldSize(m)
	local maxDim = math.max(size.X, size.Y, size.Z)
	if maxDim > MODEL_SIZE then m:ScaleTo(m:GetScale() * MODEL_SIZE / maxDim) end
	-- plus le niveau est haut, plus le brainrot est gros (Levels.Scale)
	local lvScale = Levels.Scale(Levels.Of(entry))
	if lvScale ~= 1 then m:ScaleTo(m:GetScale() * lvScale) end
	local p = areaPoint(info, rng:NextNumber(-0.45, 0.45), rng:NextNumber(-0.45, 0.45))
	local ang = rng:NextNumber(0, math.pi * 2)
	m:PivotTo(CFrame.new(p) * CFrame.Angles(0, ang, 0) * rot)
	-- posé au sol (boîte englobante alignée sur le monde)
	local minY, size2 = worldMinY(m), worldSize(m)
	m:PivotTo(m:GetPivot() + Vector3.new(0, p.Y - minY, 0))
	m:SetAttribute("Yaw", ang)
	m:SetAttribute("Uid", uid)
	m:SetAttribute("PetId", entry.Id)
	m:SetAttribute("Mut", entry.Mut)
	m:SetAttribute("Wander", true)
	m:SetAttribute("Owner", info.Owner and info.Owner.UserId or 0)
	m:SetAttribute("Height", size2.Y)
	m:SetAttribute("LvScale", lvScale)
	m:SetAttribute("Lift", m:GetPivot().Y - p.Y) -- hauteur du pivot au-dessus du sol (le client s'en sert quand la taille change)
	local g = infoGui(entry, data, size2.Y)
	local anchor = m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart")
	if g then
		g.Adornee = anchor
		g.Parent = m
	end
	-- "Upgrade" : invite sur le pet (le client ne l'affiche qu'au propriétaire et ouvre la fenêtre Upgrade)
	if anchor then
		local pp = Instance.new("ProximityPrompt")
		pp.Name = "UpgradePrompt"; pp.ActionText = "Upgrade"; pp.ObjectText = entry.Id
		pp.HoldDuration = 0; pp.MaxActivationDistance = 9; pp.RequiresLineOfSight = false
		pp.KeyboardKeyCode = Enum.KeyCode.F
		pp:SetAttribute("ClientAction", "Upgrade"); pp:SetAttribute("Uid", uid)
		pp.Parent = anchor
		-- clic souris sur le brainrot : boîte invisible (les parts du pet ont CanQuery = false)
		local bcf, bsz = m:GetBoundingBox()
		local hit = Instance.new("Part")
		hit.Name = "UpgradeHit"; hit.Transparency = 1; hit.Anchored = true
		hit.CanCollide = false; hit.CanTouch = false; hit.CanQuery = true
		hit.Size = Vector3.new(math.max(2, bsz.X), math.max(2, bsz.Y), math.max(2, bsz.Z)); hit.CFrame = bcf
		hit.Parent = m
		local cd = Instance.new("ClickDetector")
		cd.Name = "UpgradeClick"; cd.MaxActivationDistance = 60; cd:SetAttribute("Uid", uid)
		cd.Parent = hit
	end
	m.Parent = info.Model:FindFirstChild("Placed") or info.Model
	info.Models[uid] = m
end

-- [ ŒUFS EN INCUBATION ] -------------------------------------------------------
local function renderEgg(info: PlotInfo, uid: string, inc: any?)
	local old = info.EggModels[uid]
	if old then old:Destroy(); info.EggModels[uid] = nil end
	if not inc or not info.Pen then return end
	local def = Eggs.ById[inc.Egg]
	local folder = assets():FindFirstChild("Eggs")
	local tpl = folder and def and folder:FindFirstChild(def.Model) :: Model?
	local m: Model
	if tpl then
		m = tpl:Clone()
	else
		m = Instance.new("Model")
		local p = Instance.new("Part"); p.Shape = Enum.PartType.Ball; p.Size = Vector3.new(3, 3.6, 3); p.Parent = m
		p.Color = def and def.Color or Color3.new(1, 1, 1)
	end
	m.Name = "Egg_" .. uid
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanQuery = false; d.CanTouch = false end
		if d:IsA("LuaSourceContainer") then d:Destroy() end
	end
	-- œufs à décor (bonnet, sapin, couronne…) : on règle la hauteur totale, la largeur reste raisonnable
	local _, size = m:GetBoundingBox()
	local k = math.min(4.8 / size.Y, 3.9 / math.max(size.X, size.Z))
	m:ScaleTo(m:GetScale() * k)
	local _, s2 = m:GetBoundingBox()
	local p = areaPoint(info, inc.U or 0, inc.V or 0)
	m:PivotTo(CFrame.new(p + Vector3.new(0, s2.Y / 2, 0)) * CFrame.Angles(0, rng:NextNumber(0, 6.28), 0))
	m:SetAttribute("EggUid", uid)
	m:SetAttribute("EggId", inc.Egg)
	m:SetAttribute("HatchAt", inc.HatchAt)
	m:SetAttribute("Owner", info.Owner and info.Owner.UserId or 0)
	local bb = Instance.new("BillboardGui")
	bb.Name = "EggTimer"; bb.Size = UDim2.fromScale(7, 2.2); bb.StudsOffset = Vector3.new(0, s2.Y / 2 + 1.8, 0)
	bb.MaxDistance = 70; bb.LightInfluence = 0
	bb.Adornee = m:FindFirstChildWhichIsA("BasePart")
	bb.Parent = m
	local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
	local n = Instance.new("TextLabel"); n.Name = "Name"; n.BackgroundTransparency = 1; n.Size = UDim2.fromScale(1, 0.5)
	n.TextScaled = true; n.FontFace = font; n.Text = def and def.Name or "Egg"; n.TextColor3 = def and def.Color or Color3.new(1, 1, 1); n.Parent = bb
	local s1 = Instance.new("UIStroke"); s1.Thickness = 2; s1.Parent = n
	local t = Instance.new("TextLabel"); t.Name = "Timer"; t.BackgroundTransparency = 1; t.Position = UDim2.fromScale(0, 0.5); t.Size = UDim2.fromScale(1, 0.5)
	t.TextScaled = true; t.FontFace = font; t.Text = "..."; t.TextColor3 = Color3.new(1, 1, 1); t.Parent = bb
	local st = Instance.new("UIStroke"); st.Thickness = 2; st.Parent = t
	-- "éclore maintenant" : invite + clic sur l'œuf (le client n'affiche l'invite qu'au propriétaire)
	local hit = Instance.new("Part")
	hit.Name = "SkipHit"; hit.Transparency = 1; hit.Anchored = true; hit.CanCollide = false; hit.CanTouch = false; hit.CanQuery = true
	hit.Size = Vector3.new(4.2, s2.Y + 0.4, 4.2); hit.CFrame = CFrame.new(p + Vector3.new(0, s2.Y / 2, 0)); hit.Parent = m
	local pp = Instance.new("ProximityPrompt")
	pp.Name = "SkipPrompt"; pp.ActionText = "Hatch now"; pp.ObjectText = def and def.Name or "Egg"
	pp.HoldDuration = 0; pp.MaxActivationDistance = 12; pp.RequiresLineOfSight = false; pp.Style = Enum.ProximityPromptStyle.Default
	pp.Parent = hit
	local cd = Instance.new("ClickDetector"); cd.Name = "SkipClick"; cd.MaxActivationDistance = 45; cd.Parent = hit
	m.Parent = info.Model:FindFirstChild("Placed") or info.Model
	info.EggModels[uid] = m
end
function PlotService.RenderEgg(player: Player, uid: string, inc: any?)
	local info = byPlayer[player]
	if info then renderEgg(info, uid, inc) end
end
function PlotService.EggPosition(player: Player, uid: string): Vector3?
	local info = byPlayer[player]
	local m = info and info.EggModels[uid]
	return m and m:GetPivot().Position or nil
end

local function renderAll(info: PlotInfo, data: any)
	local rebuilt = buildPen(info, data) ~= false
	if rebuilt then
		-- nouvel enclos : tout est replacé
		for _, m in pairs(info.Models) do m:Destroy() end
		for _, m in pairs(info.EggModels) do m:Destroy() end
		info.Models = {}
		info.EggModels = {}
	end
	-- sinon mise à jour incrémentale : on ne touche pas aux pets déjà là (pas de clignotement)
	for uid, m in pairs(info.Models) do
		local e = data.Pets[uid]
		if not e or not e.Slot or e.Slot <= 0 or m:GetAttribute("Mut") ~= e.Mut or not m.Parent then
			m:Destroy(); info.Models[uid] = nil
		end
	end
	for uid, entry in pairs(data.Pets) do
		if entry.Slot and entry.Slot > 0 and not info.Models[uid] then render(info, uid, entry, data) end
	end
	for uid, m in pairs(info.EggModels) do
		if not data.Incubating[uid] or not m.Parent then m:Destroy(); info.EggModels[uid] = nil end
	end
	for uid, inc in pairs(data.Incubating) do
		if not info.EggModels[uid] then renderEgg(info, uid, inc) end
	end
	updatePad(info, data)
end
PlotService.RenderAll = renderAll

function PlotService.Refresh(player: Player)
	local info = byPlayer[player]
	local data = DataService.Get(player)
	if info and data then renderAll(info, data) end
end

-- [ ÉQUIPER / RANGER ] -----------------------------------------------------------
local function onEquip(player: Player, uid: any)
	local data = DataService.Get(player)
	local info = byPlayer[player]
	if not data or not info or type(uid) ~= "string" then return end
	local entry = data.Pets[uid]
	if not entry or (entry.Slot and entry.Slot > 0) then return end
	local slot = freeSlot(data)
	if not slot then
		Net.Notify(player, "Your chalet is full! Buy more slots in the shop.", "error")
		return
	end
	entry.Slot = slot
	render(info, uid, entry, data)
	DataService.Push(player, "Pets")
end

-- appelé à l'éclosion : dans l'enclos s'il reste de la place, sinon il remplace le plus faible s'il rapporte plus
function PlotService.AutoEquip(player: Player, uid: string)
	local data = DataService.Get(player)
	local info = byPlayer[player]
	if not data or not info then return end
	local entry = data.Pets[uid]
	if not entry or (entry.Slot and entry.Slot > 0) then return end
	local slot = freeSlot(data)
	if not slot then
		local worstUid, worstInc = nil, math.huge
		for u, e in pairs(data.Pets) do
			if e.Slot and e.Slot > 0 then
				local inc = Stats.PetIncome(data, e)
				if inc < worstInc then worstUid, worstInc = u, inc end
			end
		end
		if not worstUid or Stats.PetIncome(data, entry) <= worstInc then return end
		local worst = data.Pets[worstUid]
		slot = worst.Slot
		worst.Slot = 0
		render(info, worstUid, nil, data)
		Net.Notify(player, entry.Id .. " replaced " .. worst.Id .. " in your chalet!", "success")
	end
	entry.Slot = slot
	render(info, uid, entry, data)
	DataService.Push(player, "Pets")
end

local function onUnequip(player: Player, uid: any)
	local data = DataService.Get(player)
	local info = byPlayer[player]
	if not data or not info or type(uid) ~= "string" then return end
	local entry = data.Pets[uid]
	if not entry or not entry.Slot or entry.Slot <= 0 then return end
	entry.Slot = 0
	render(info, uid, nil, data)
	DataService.Push(player, "Pets")
end

local function onEquipBest(player: Player)
	local data = DataService.Get(player)
	local info = byPlayer[player]
	if not data or not info then return end
	local list = {}
	for uid, e in pairs(data.Pets) do table.insert(list, { uid = uid, e = e, inc = Stats.PetIncome(data, e) }) end
	table.sort(list, function(a, b) return a.inc > b.inc end)
	local max = PlotService.Capacity(data) - incubatingCount(data)
	for i, it in ipairs(list) do
		it.e.Slot = i <= max and i or 0
	end
	renderAll(info, data)
	DataService.Push(player, "Pets")
	Net.Notify(player, "Best pets placed in your chalet!", "success")
end

-- [ AMÉLIORATION ] ------------------------------------------------------------------
-- grossit le brainrot sur place après une amélioration (il reste au sol, le billboard suit)
local function rescale(m: Model, entry: any)
	local want = Levels.Scale(Levels.Of(entry))
	local cur = (m:GetAttribute("LvScale") :: number?) or 1
	if math.abs(want - cur) < 1e-3 then return end
	local groundY = m:GetPivot().Y - ((m:GetAttribute("Lift") :: number?) or 0)
	m:ScaleTo(m:GetScale() * want / cur)
	m:PivotTo(m:GetPivot() + Vector3.new(0, groundY - worldMinY(m), 0))
	local h = worldSize(m).Y
	m:SetAttribute("LvScale", want)
	m:SetAttribute("Height", h)
	m:SetAttribute("Lift", m:GetPivot().Y - groundY)
	local g = m:FindFirstChild("InfoGUI") :: BillboardGui?
	if g then g.StudsOffset = Vector3.new(0, h / 2 + 1.6, 0) end
end
-- UpgradePet(uid, n) : n niveaux (1 ou "max" = autant que l'argent le permet). Le serveur recalcule tout.
local function onUpgrade(player: Player, uid: any, n: any): any
	local data = DataService.Get(player)
	if not data or type(uid) ~= "string" then return { ok = false } end
	local entry = data.Pets[uid]
	if not entry then return { ok = false, msg = "Pet not found" } end
	local lv = Levels.Of(entry)
	if lv >= Levels.Max then return { ok = false, msg = "Already max level!" } end
	local want = (n == "max") and Levels.Max or math.clamp(math.floor(tonumber(n) or 1), 1, Levels.Max)
	local count, total = Levels.Affordable(entry, data.Rebirths, data.Money, want)
	if count <= 0 then return { ok = false, msg = "Not enough money!" } end
	data.Money -= total
	entry.Lv = lv + count
	entry.Spent = (tonumber(entry.Spent) or 0) + total -- argent investi (remboursé à moitié à la vente / fusion)
	DataService.Push(player, "Money")
	DataService.Push(player, "Pets")
	-- billboard de l'enclos mis à jour sur place (pas de re-rendu : le pet ne saute pas)
	local info = byPlayer[player]
	local m = info and info.Models[uid]
	local g = m and m:FindFirstChild("InfoGUI")
	if g then fillInfo(g, entry, data) end
	if m then rescale(m, entry) end
	local RewardsService = require(script.Parent.RewardsService) :: any
	pcall(RewardsService.Progress, player, "Upgrade", count)
	return { ok = true, Lv = entry.Lv, Count = count, Spent = total }
end

-- retire un pet de l'enclos (vente) : appelé par EconomyService
function PlotService.Remove(player: Player, uid: string)
	local info = byPlayer[player]
	if info then render(info, uid, nil, nil) end
end

onCollect = function(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local amount = math.floor(data.Pending)
	if amount <= 0 then return end
	data.Pending = 0
	data.Money += amount
	data.TotalEarned += amount
	DataService.Push(player, "Pending")
	DataService.Push(player, "Money")
	Net.Fire(player, "Collected", amount)
	local info = byPlayer[player]
	if info then updatePad(info, data) end
end

-- [ PLOTS ] -------------------------------------------------------------------
function PlotService.GetPlot(player: Player): Model?
	local info = byPlayer[player]
	return info and info.Model or nil
end
function PlotService.SpawnCFrame(player: Player): CFrame?
	local info = byPlayer[player]
	local sp = info and info.Pen and info.Pen:FindFirstChild("Spawn") :: BasePart?
	return sp and sp.CFrame + Vector3.new(0, 3, 0) or nil
end

local function assign(player: Player, data: any)
	for _, info in ipairs(plots) do
		if not info.Owner then
			info.Owner = player
			byPlayer[player] = info
			info.Model:SetAttribute("Owner", player.UserId)
			info.Pen = nil -- reconstruit avec le nom du joueur
			if data.LastOnline and data.LastOnline > 0 then
				local away = math.clamp(os.time() - data.LastOnline, 0, OFFLINE_MAX)
				local gained = math.floor(Stats.BaseIncome(data) * away)
				if gained > 0 then
					data.Pending += gained
					local RewardsService = require(script.Parent.RewardsService) :: any
					RewardsService.SetOffline(player, data, gained)
					Net.Fire(player, "Offline", { Seconds = away, Money = gained })
				end
			end
			renderAll(info, data)
			DataService.Push(player, "Pending")
			player:SetAttribute("Plot", info.Model.Name)
			task.spawn(function()
				local char = player.Character or player.CharacterAdded:Wait()
				local root = char:WaitForChild("HumanoidRootPart", 5) :: BasePart?
				local cf = PlotService.SpawnCFrame(player)
				if root and cf then root.CFrame = cf end
			end)
			return
		end
	end
	warn("[Plot] plus d'enclos libre pour " .. player.Name)
end

local function unassign(player: Player)
	local info = byPlayer[player]
	if not info then return end
	for _, m in pairs(info.Models) do m:Destroy() end
	for _, m in pairs(info.EggModels) do m:Destroy() end
	info.Models = {}
	info.EggModels = {}
	info.Owner = nil
	info.Model:SetAttribute("Owner", nil)
	info.Pen = nil
	buildPen(info, nil)
	byPlayer[player] = nil
end

function PlotService.Start()
	local map = workspace:WaitForChild("Map")
	local folder = map:WaitForChild("Plots")
	for i = 1, 8 do
		local m = folder:FindFirstChild("Plot" .. i) :: Model?
		local root = m and m:FindFirstChild("Root") :: BasePart?
		if not m or not root then continue end
		local info: PlotInfo = { Model = m, Root = root.CFrame - Vector3.new(0, root.Size.Y / 2, 0), Owner = nil, Pen = nil, Models = {}, EggModels = {} }
		buildPen(info, nil)
		table.insert(plots, info)
	end

	DataService.OnLoaded(assign)
	Players.PlayerRemoving:Connect(unassign)
	-- respawn : retour à son enclos
	local function hookRespawn(p: Player)
		p.CharacterAdded:Connect(function(char)
			task.wait(0.2)
			local root = char:FindFirstChild("HumanoidRootPart") :: BasePart?
			local cf = PlotService.SpawnCFrame(p)
			if root and cf then root.CFrame = cf end
		end)
	end
	Players.PlayerAdded:Connect(hookRespawn)
	for _, p in ipairs(Players:GetPlayers()) do hookRespawn(p) end

	Net.On("Equip", onEquip, 6, 6)
	Net.On("Unequip", onUnequip, 6, 6)
	Net.On("EquipBest", onEquipBest, 2, 2)
	Net.On("Collect", onCollect, 2, 2)
	Net.OnInvoke("UpgradePet", onUpgrade, 6, 8)

	-- production : toutes les secondes (et la clôture suit le nombre de slots)
	task.spawn(function()
		while true do
			task.wait(1)
			for player, info in pairs(byPlayer) do
				local data = DataService.Get(player)
				if data then
					local ok, err = pcall(function()
						buildPen(info, data)
						local inc = Stats.BaseIncome(data)
						if inc > 0 then
							data.Pending += inc
							updatePad(info, data)
						end
					end)
					if not ok then warn("[PlotService] income : " .. tostring(err)) end
				end
			end
		end
	end)
	task.spawn(function()
		while true do
			task.wait(3)
			for player in pairs(byPlayer) do DataService.Push(player, "Pending") end
		end
	end)
end

return PlotService
