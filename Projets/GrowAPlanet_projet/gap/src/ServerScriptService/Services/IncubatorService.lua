--!strict
-- ServerScriptService/Services/IncubatorService
-- L'enclos : les galaxies achetées y attendent leur timer, puis on les fait éclore.
--   * le timer = heure de fin (os.time) sauvegardée → continue même hors ligne
--   * éclosion : tirage de la planète + mutation par le SERVEUR
--   * galaxies offertes (daily, codes, Robux) : si l'enclos est plein, elles attendent dans une file

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Formulas = require(Shared.Util.Formulas)
local Galaxies = require(Shared.Config.Galaxies)
local Planets = require(Shared.Config.Planets)
local Rarities = require(Shared.Config.Rarities)
local Upgrades = require(Shared.Config.Upgrades)
local Models = require(Shared.Visuals.Models)
local Format = require(Shared.Util.Format)

local Net = require(script.Parent.Parent.Lib.Net)
local State = require(script.Parent.Parent.Lib.State)
local DataService = require(script.Parent.DataService)
local PlotService = require(script.Parent.PlotService)
local PlanetService = require(script.Parent.PlanetService)

local IncubatorService = {}
local rng = Random.new()

local function slotPart(plot: Model, index: number): BasePart?
	local slots = plot:FindFirstChild("Slots")
	local s = slots and slots:FindFirstChild("Slot" .. index)
	return if s and s:IsA("BasePart") then s else nil
end

-- redessine toutes les galaxies de l'enclos du joueur
function IncubatorService.Render(player: Player)
	local data = DataService.Get(player)
	local plot = PlotService.Get(player)
	if not data or not plot then return end
	local dyn = plot:FindFirstChild("Dynamic") :: Folder
	local folder = dyn:FindFirstChild("Incubator")
	if folder then folder:Destroy() end
	folder = Instance.new("Folder")
	folder.Name = "Incubator"
	folder.Parent = dyn

	for i, entry in ipairs(data.Incubator) do
		local slot = slotPart(plot, i)
		if slot then
			local g = Galaxies.ById[entry.Galaxy]
			local model = Models.Galaxy(entry.Galaxy, 0.55)
			model:PivotTo(CFrame.new(slot.Position + Vector3.new(0, slot.Size.X / 2 + 3, 0)))
			model:SetAttribute("Uid", entry.Uid)
			model:SetAttribute("EndsAt", entry.EndsAt)
			model:SetAttribute("OwnerId", player.UserId)

			-- étiquette au-dessus (le client met à jour le compte à rebours)
			local bb = Instance.new("BillboardGui")
			bb.Name = "Timer"
			bb.Size = UDim2.fromScale(6, 2)
			bb.StudsOffsetWorldSpace = Vector3.new(0, 3.6, 0)
			bb.AlwaysOnTop = false
			bb.MaxDistance = 80
			bb.LightInfluence = 0
			local name = Instance.new("TextLabel")
			name.Name = "GalaxyName"
			name.BackgroundTransparency = 1
			name.Size = UDim2.fromScale(1, 0.45)
			name.Font = Enum.Font.GothamBlack
			name.TextScaled = true
			name.Text = g and g.Name or entry.Galaxy
			name.TextColor3 = Rarities.Info[g and g.Rarity or "Common"].Color
			name.TextStrokeTransparency = 0
			name.Parent = bb
			local timer = Instance.new("TextLabel")
			timer.Name = "Time"
			timer.BackgroundTransparency = 1
			timer.Position = UDim2.fromScale(0, 0.48)
			timer.Size = UDim2.fromScale(1, 0.52)
			timer.Font = Enum.Font.GothamBlack
			timer.TextScaled = true
			timer.TextColor3 = Color3.new(1, 1, 1)
			timer.TextStrokeTransparency = 0
			timer.Text = Format.Time(entry.EndsAt - os.time())
			timer.Parent = bb
			bb.Parent = model.PrimaryPart

			-- bouton "Hatch" dans le monde (actif quand c'est prêt, le client gère l'affichage)
			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = "HatchPrompt"
			prompt.ActionText = "Hatch"
			prompt.ObjectText = g and g.Name or ""
			prompt.HoldDuration = 0.3
			prompt.MaxActivationDistance = 12
			prompt.RequiresLineOfSight = false
			prompt.Parent = model.PrimaryPart
			local uid = entry.Uid
			prompt.Triggered:Connect(function(who)
				if who == player then IncubatorService.Hatch(player, uid) end
			end)

			model.Parent = folder
		end
	end
end

function IncubatorService.FreeSlots(player: Player): number
	local data = DataService.Get(player)
	if not data then return 0 end
	return Upgrades.Base.IncubatorSlots - #data.Incubator
end

-- ajoute une galaxie dans l'enclos (déjà payée). Renvoie false si plein.
function IncubatorService.Add(player: Player, galaxyId: string): boolean
	local data = DataService.Get(player)
	if not data or not Galaxies.ById[galaxyId] then return false end
	if #data.Incubator >= Upgrades.Base.IncubatorSlots then return false end
	local state = State.Build(player, data)
	local uid = tostring(data.NextUid)
	data.NextUid += 1
	table.insert(data.Incubator, {
		Uid = uid,
		Galaxy = galaxyId,
		EndsAt = os.time() + Formulas.HatchDuration(galaxyId, state),
	})
	DataService.Push(player, "Incubator")
	IncubatorService.Render(player)
	return true
end

-- donne une galaxie gratuite : dans l'enclos si possible, sinon en file d'attente
function IncubatorService.Give(player: Player, galaxyId: string)
	local data = DataService.Get(player)
	if not data then return end
	if not IncubatorService.Add(player, galaxyId) then
		table.insert(data.GivenGalaxies, galaxyId)
		DataService.Push(player, "GivenGalaxies")
		Net.Notify(player, "Incubator full! Your galaxy is waiting for a free slot.", "warn")
	end
end

-- vide la file d'attente dès qu'il y a de la place
local function flushQueue(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local changed = false
	while #data.GivenGalaxies > 0 and #data.Incubator < Upgrades.Base.IncubatorSlots do
		local id = table.remove(data.GivenGalaxies, 1)
		if id and IncubatorService.Add(player, id) then changed = true end
	end
	if changed then DataService.Push(player, "GivenGalaxies") end
end

local function findIndex(data: any, uid: string): number?
	for i, e in ipairs(data.Incubator) do
		if e.Uid == uid then return i end
	end
	return nil
end

-- fait éclore une galaxie prête. Renvoie la planète obtenue.
function IncubatorService.Hatch(player: Player, uid: string, silent: boolean?): boolean
	local data = DataService.Get(player)
	if not data then return false end
	local i = findIndex(data, uid)
	if not i then return false end
	local entry = data.Incubator[i]
	if os.time() < entry.EndsAt then
		if not silent then Net.Notify(player, "Not ready yet!", "warn") end
		return false
	end
	if PlanetService.Count(data) >= Upgrades.Base.InventoryMax then
		if not silent then Net.Notify(player, "Planet inventory full! Sell some planets first.", "error") end
		return false
	end

	local state = State.Build(player, data)
	local luck = Formulas.Luck(state)
	local planetId = Formulas.RollPlanet(rng, entry.Galaxy, luck)
	local mutation = Formulas.RollMutation(rng, luck)
	table.remove(data.Incubator, i)

	local planetUid, isNew = PlanetService.Add(player, planetId, mutation)
	data.Stats.Hatched += 1

	DataService.Push(player, "Incubator")
	IncubatorService.Render(player)
	flushQueue(player)

	local p = Planets.ById[planetId]
	Net.Fire(player, "Hatched", {
		Galaxy = entry.Galaxy,
		Planet = planetId,
		Mutation = mutation,
		Uid = planetUid,
		New = isNew,
		Rarity = p and p.Rarity,
	})
	return true
end

function IncubatorService.HatchAll(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local now = os.time()
	local ready = {}
	for _, e in ipairs(data.Incubator) do
		if now >= e.EndsAt then table.insert(ready, e.Uid) end
	end
	if #ready == 0 then
		Net.Notify(player, "Nothing is ready to hatch.", "warn")
		return
	end
	for _, uid in ipairs(ready) do
		IncubatorService.Hatch(player, uid, true)
	end
end

-- termine le timer tout de suite (achat Robux "Skip")
function IncubatorService.Skip(player: Player, uid: string?): boolean
	local data = DataService.Get(player)
	if not data or #data.Incubator == 0 then return false end
	local target
	if uid then
		local i = findIndex(data, uid)
		target = i and data.Incubator[i]
	end
	if not target then
		-- par défaut : celle qui a le plus de temps restant
		for _, e in ipairs(data.Incubator) do
			if not target or e.EndsAt > target.EndsAt then target = e end
		end
	end
	if not target then return false end
	target.EndsAt = os.time()
	DataService.Push(player, "Incubator")
	IncubatorService.Render(player)
	return true
end

function IncubatorService.SkipAll(player: Player): boolean
	local data = DataService.Get(player)
	if not data or #data.Incubator == 0 then return false end
	for _, e in ipairs(data.Incubator) do
		e.EndsAt = math.min(e.EndsAt, os.time())
	end
	DataService.Push(player, "Incubator")
	IncubatorService.Render(player)
	return true
end

-- recalcule les timers en cours quand la vitesse d'éclosion change (upgrade / gamepass)
function IncubatorService.Rescale(player: Player, oldFactor: number, newFactor: number)
	local data = DataService.Get(player)
	if not data or oldFactor <= 0 then return end
	local now = os.time()
	for _, e in ipairs(data.Incubator) do
		local left = e.EndsAt - now
		if left > 0 then
			e.EndsAt = now + math.ceil(left * newFactor / oldFactor)
		end
	end
	DataService.Push(player, "Incubator")
	IncubatorService.Render(player)
end

function IncubatorService.Start()
	DataService.OnLoaded(function(player)
		-- la base est attribuée dans le même événement : on attend qu'elle existe
		local t = 0
		while not PlotService.Get(player) and t < 10 and player.Parent do
			task.wait(0.2); t += 0.2
		end
		IncubatorService.Render(player)
		flushQueue(player)
	end)

	Net.On("Hatch", function(player, uid)
		if Net.IsString(uid, 16) then IncubatorService.Hatch(player, uid) end
	end, 6, 10)
	Net.On("HatchAll", function(player)
		IncubatorService.HatchAll(player)
	end, 1, 3)

	-- gamepass Auto-Éclore
	task.spawn(function()
		while true do
			task.wait(Upgrades.Base.AutoHatchInterval)
			for _, player in ipairs(Players:GetPlayers()) do
				local data = DataService.Get(player)
				if data and player:GetAttribute("Pass_AutoHatch") and data.Settings.AutoHatch ~= false then
					local now = os.time()
					for _, e in ipairs(table.clone(data.Incubator)) do
						if now >= e.EndsAt then IncubatorService.Hatch(player, e.Uid, true) end
					end
				end
			end
		end
	end)
end

return IncubatorService
