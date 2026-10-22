--!strict
-- ServerScriptService/Services/WorldService
-- Objets à ratisser PERSONNELS : chaque joueur a ses propres objets dans chaque zone débloquée.
--   * le serveur garde la liste (position, objet, pond) par joueur et par zone — c'est elle qui fait foi
--   * le client de ce joueur reçoit "ItemAdd" / "ItemDel" / "ItemSync" et dessine les objets en local
--     (Client/ItemsController) : les autres joueurs ne les voient pas et ne peuvent pas les ramasser
--   * HarvestService ramasse via WorldService.Near / WorldService.Take (tout est revérifié ici)
-- Les barrières de zone (attribut Rebirths) sont toujours posées ici.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Zones = require(Shared.Config.Zones)
local Items = require(Shared.Config.Items)

local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local WorldService = {}
local rng = Random.new()
local map: Folder

export type Rec = { U: number, I: string, Z: string, X: number, Y: number, W: number, R: number, P: boolean, C: Vector3 }
-- items[player][zoneId][uid] = Rec
local items: { [Player]: { [string]: { [number]: Rec } } } = {}
local counts: { [Player]: { [string]: number } } = {}
local nextUid = 0

local function groundY(z: Zones.Zone): number
	local zf = map.Zones:FindFirstChild(z.Id)
	local g = zf and zf:FindFirstChild("Ground") :: BasePart?
	return g and (g.Position.Y + g.Size.Y / 2) or 0
end

-- surface de l'eau du pond (le pond de la maquette est surélevé au-dessus du sol)
local function pondTop(z: Zones.Zone): number
	local zf = map.Zones:FindFirstChild(z.Id)
	local p = zf and zf:FindFirstChild("Pond") :: BasePart?
	if p then
		-- demi-hauteur réelle de la pièce tournée (le pond est un cylindre couché)
		local cf, sz = p.CFrame, p.Size
		local hy = math.abs(cf.RightVector.Y) * sz.X / 2 + math.abs(cf.UpVector.Y) * sz.Y / 2 + math.abs(cf.LookVector.Y) * sz.Z / 2
		return p.Position.Y + hy
	end
	return groundY(z)
end

-- tire une position + un objet (sans rien créer dans le monde)
local function newRec(z: Zones.Zone, itemId: string, inPond: boolean): Rec
	local def = Items.ById[itemId]
	local half = z.Size / 2 - 4
	local ph = z.PondSize / 2
	local x, zz
	if inPond then
		local a = rng:NextNumber(0, math.pi * 2)
		local r = (ph - 1.5) * math.sqrt(rng:NextNumber())
		x, zz = math.cos(a) * r, math.sin(a) * r
	else
		-- hors du pond et de sa bordure de pierres
		repeat
			x = rng:NextNumber(-half, half)
			zz = rng:NextNumber(-half, half)
		until x * x + zz * zz > (ph + 3) ^ 2
	end
	local gy = inPond and (pondTop(z) - 0.45) or (groundY(z) + 0.02)
	nextUid += 1
	local wx, wz = z.Center.X + x, z.Center.Z + zz
	return {
		U = nextUid, I = itemId, Z = z.Id, X = wx, Y = gy, W = wz, R = rng:NextNumber(0, math.pi * 2), P = inPond,
		C = Vector3.new(wx, gy + def.Size * 0.7, wz), -- centre de la hitbox (distance du râteau)
	}
end

-- version envoyée au client (sans le Vector3 calculé)
local function wire(r: Rec): any
	return { U = r.U, I = r.I, Z = r.Z, X = r.X, Y = r.Y, W = r.W, R = r.R, P = r.P }
end

local function pickItem(z: Zones.Zone, pond: boolean): string
	local list = pond and z.PondItems or z.Items
	local id = list[rng:NextInteger(1, #list)]
	-- les runes sont plus rares que le reste
	if Items.ById[id].Kind == "Rune" and rng:NextNumber() > 0.25 then id = list[1] end
	return id
end

local function unlocked(player: Player, z: Zones.Zone): boolean
	local data = DataService.Get(player)
	return data ~= nil and (data.Rebirths or 0) >= z.Rebirths
end

-- ajoute n objets à un joueur dans une zone (un seul message réseau)
local function add(player: Player, z: Zones.Zone, n: number): number
	local pz = items[player]
	if not pz then return 0 end
	local list = pz[z.Id]
	if not list then list = {}; pz[z.Id] = list; counts[player][z.Id] = 0 end
	local out = {}
	for _ = 1, n do
		if counts[player][z.Id] >= z.MaxItems then break end
		local pond = rng:NextNumber() < 0.25
		local r = newRec(z, pickItem(z, pond), pond)
		list[r.U] = r
		counts[player][z.Id] += 1
		table.insert(out, wire(r))
	end
	if #out > 0 then Net.Fire(player, "ItemAdd", out) end
	return #out
end

local function fillPlayer(player: Player, ratio: number): number
	local n = 0
	for _, z in ipairs(Zones.List) do
		if unlocked(player, z) then
			local want = math.floor(z.MaxItems * ratio) - (counts[player][z.Id] or 0)
			if want > 0 then n += add(player, z, want) end
		end
	end
	return n
end

-- [ API pour HarvestService ] ------------------------------------------------------------
-- objets du joueur dans la zone, à moins de `radius` de `pos`, du plus proche au plus loin
function WorldService.Near(player: Player, zoneId: string, pos: Vector3, radius: number): { { d: number, r: Rec } }
	local out = {}
	local list = items[player] and items[player][zoneId]
	if not list then return out end
	for _, r in pairs(list) do
		local d = (r.C - pos).Magnitude
		if d <= radius then table.insert(out, { d = d, r = r }) end
	end
	table.sort(out, function(a, b) return a.d < b.d end)
	return out
end

-- retire des objets ramassés (et prévient le client)
function WorldService.Take(player: Player, zoneId: string, uids: { number })
	local list = items[player] and items[player][zoneId]
	if not list then return end
	local gone = {}
	for _, u in ipairs(uids) do
		if list[u] then
			list[u] = nil
			counts[player][zoneId] -= 1
			table.insert(gone, u)
		end
	end
	if #gone > 0 then Net.Fire(player, "ItemDel", gone) end
end

-- remplit toutes les zones de tous les joueurs (panel admin)
function WorldService.RefillAll(): number
	local n = 0
	for _, p in ipairs(Players:GetPlayers()) do
		if items[p] then n += fillPlayer(p, 1) end
	end
	return n
end

function WorldService.ZoneFolder(zoneId: string): Folder?
	return map.Zones:FindFirstChild(zoneId) :: Folder?
end

local function syncAll(player: Player)
	local all = {}
	for _, list in pairs(items[player] or {}) do
		for _, r in pairs(list) do table.insert(all, wire(r)) end
	end
	Net.Fire(player, "ItemSync", all)
end

function WorldService.Start()
	map = workspace:WaitForChild("Map") :: Folder
	local zonesFolder = map:WaitForChild("Zones")
	for _, z in ipairs(Zones.List) do
		local zf = zonesFolder:FindFirstChild(z.Id)
		if not zf then
			warn("[World] zone manquante dans la map : " .. z.Id)
			continue
		end
		-- ancien dossier d'objets partagés (plus utilisé)
		local old = zf:FindFirstChild("Items"); if old then old:Destroy() end
		-- la barrière connaît son niveau requis (le client la désactive localement si débloquée)
		local gate = zf:FindFirstChild("Gate")
		if gate then gate:SetAttribute("Rebirths", z.Rebirths) end
		local back = zf:FindFirstChild("GateBack")
		if back then back:SetAttribute("Rebirths", z.Rebirths) end
	end

	DataService.OnLoaded(function(player, _data)
		items[player] = items[player] or {}
		counts[player] = counts[player] or {}
		fillPlayer(player, 0.6)
	end)
	Players.PlayerRemoving:Connect(function(p) items[p] = nil; counts[p] = nil end)
	-- le client redemande la liste complète quand son contrôleur démarre
	Net.On("ItemsSync", function(player) syncAll(player) end, 0.5, 2)

	-- réapparition : chaque zone, pour chaque joueur qui l'a débloquée (plus vite si la zone est presque vide)
	for _, z in ipairs(Zones.List) do
		task.spawn(function()
			while true do
				task.wait(z.SpawnEvery)
				for _, p in ipairs(Players:GetPlayers()) do
					if items[p] and unlocked(p, z) then
						local c = counts[p][z.Id] or 0
						if c < z.MaxItems then add(p, z, c < z.MaxItems * 0.5 and 3 or 1) end
					end
				end
			end
		end)
	end
end

return WorldService
