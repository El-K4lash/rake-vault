--!strict
-- ServerScriptService/Services/DataService
-- Sauvegarde des joueurs, fiable :
--   * verrou de session : une même sauvegarde ne peut pas être ouverte par 2 serveurs
--     (sinon duplication / perte). Le verrou est rafraîchi à chaque autosave.
--   * retry avec attente progressive si DataStore échoue
--   * autosave toutes les 60 s + sauvegarde à la sortie + BindToClose (arrêt serveur)
--   * Version du format : les nouvelles clés sont ajoutées automatiquement aux vieilles sauvegardes
-- Le reste du jeu utilise : DataService.Get(player) -> data (table), DataService.Push(player, key)

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Net = require(script.Parent.Parent.Lib.Net)

local DataService = {}

local STORE_NAME = "GrowAPlanet_Players_v1"
local VERSION = 1
local AUTOSAVE = 60
local LOCK_STALE = 180 -- un verrou plus vieux que ça = serveur mort, on peut le reprendre
local MAX_RECEIPTS = 100

-- données de départ d'un nouveau joueur
local function template()
	return {
		Version = VERSION,
		Money = 0,
		TotalEarned = 0,
		Rebirths = 0,
		Upgrades = { Luck = 0, Spawners = 0, HatchSpeed = 0 },
		Incubator = {},      -- liste { Uid, Galaxy, EndsAt }
		Planets = {},        -- [uid] = { Id, Mut, Eq, Lock }
		NextUid = 1,
		Index = {},          -- ["PlanetId"] = true, ["PlanetId:Golden"] = true
		IndexClaimed = {},   -- [rareté] = true
		Boosts = {},         -- [nom] = os.time() de fin
		Daily = { Day = 0, Last = 0 },
		Codes = {},
		Receipts = {},       -- derniers PurchaseId traités (anti double achat)
		StarterPack = false,
		Settings = { Music = true, Sfx = true, LowGfx = false },
		Stats = { Hatched = 0, Playtime = 0, Joins = 0 },
		Tutorial = 0,
		LastOnline = 0,
		GivenGalaxies = {},  -- galaxies offertes (daily, codes, Robux) en attente de place dans l'enclos
	}
end

-- ajoute les clés manquantes (nouvelles versions du jeu) sans toucher aux existantes
local function reconcile(data: any, tpl: any)
	for k, v in pairs(tpl) do
		if data[k] == nil then
			data[k] = if type(v) == "table" then table.clone(v) else v
		elseif type(v) == "table" and type(data[k]) == "table" and next(v) ~= nil then
			reconcile(data[k], v)
		end
	end
end

local store: DataStore? = nil
local ok = pcall(function()
	store = DataStoreService:GetDataStore(STORE_NAME)
end)
if not ok then warn("[DataService] DataStore indisponible : les données ne seront PAS sauvegardées (active l'accès API dans Studio).") end

type Profile = { Data: any, Player: Player, Loaded: boolean, Released: boolean, Saving: boolean }
local profiles: { [Player]: Profile } = {}
local releasing: { [number]: boolean } = {} -- sauvegarde de sortie en cours (par UserId)

-- dans Studio sans accès API, DataStore refuse tout : on joue sans sauvegarde
local function studioNoAccess(err: any): boolean
	local msg = tostring(err)
	return RunService:IsStudio() and (msg:find("403") ~= nil or msg:find("StudioAccessToApisNotAllowed") ~= nil or msg:find("not allowed") ~= nil)
end
local loadedCallbacks: { (Player, any) -> () } = {}
local releaseCallbacks: { (Player, any) -> () } = {}

local function key(userId: number): string
	return "P_" .. userId
end

-- appel DataStore avec retry (attente 1, 2, 4, 8 s)
local function retry<T>(fn: () -> T, tries: number?): (boolean, T?)
	local wait = 1
	for i = 1, tries or 5 do
		local okCall, res = pcall(fn)
		if okCall then return true, res end
		if studioNoAccess(res) then
			warn("[DataService] Studio sans accès API : partie SANS sauvegarde (Game Settings > Security > Enable Studio Access to API Services)")
			store = nil
			return false, nil
		end
		warn("[DataService] essai " .. i .. " raté : " .. tostring(res))
		task.wait(wait)
		wait *= 2
	end
	return false, nil
end

local function load(player: Player): any?
	if not store then
		return template()
	end
	local jobId = game.JobId ~= "" and game.JobId or "studio"
	for attempt = 1, 8 do
		local lockedByOther = false
		local okLoad, result = retry(function()
			return (store :: DataStore):UpdateAsync(key(player.UserId), function(old)
				lockedByOther = false
				old = old or { Data = nil, Lock = nil }
				local lock = old.Lock
				if lock and lock.Job ~= jobId and os.time() - (lock.Time or 0) < LOCK_STALE then
					lockedByOther = true
					return nil -- ne rien écrire
				end
				old.Lock = { Job = jobId, Time = os.time() }
				return old
			end)
		end)
		if not okLoad then
			if not store then return template() end -- Studio sans API
			return nil
		end
		if not lockedByOther and result then
			local data = result.Data or template()
			reconcile(data, template())
			data.Version = VERSION
			return data
		end
		-- l'autre serveur est en train de sauvegarder : on attend un peu
		task.wait(4)
		if not player.Parent then return nil end
	end
	return nil
end

local function save(profile: Profile, release: boolean): boolean
	if not store then return true end
	-- une seule sauvegarde à la fois : on attend celle en cours
	local waited = 0
	while profile.Saving and waited < 30 do
		task.wait(0.1)
		waited += 0.1
	end
	profile.Saving = true
	local jobId = game.JobId ~= "" and game.JobId or "studio"
	local data = profile.Data
	data.LastOnline = os.time()
	local stolen = false
	local okSave = retry(function()
		return (store :: DataStore):UpdateAsync(key(profile.Player.UserId), function(old)
			stolen = false
			old = old or {}
			if old.Lock and old.Lock.Job ~= jobId then
				stolen = true
				return nil -- un autre serveur a pris la main : on n'écrase pas
			end
			old.Data = data
			old.Lock = if release then nil else { Job = jobId, Time = os.time() }
			return old
		end)
	end)
	profile.Saving = false
	if stolen then warn("[DataService] verrou perdu pour " .. profile.Player.Name) end
	return okSave and not stolen
end

local function onPlayerAdded(player: Player)
	-- s'il vient de quitter CE serveur, on attend la fin de sa sauvegarde de sortie
	local t = 0
	while releasing[player.UserId] and t < 30 do
		task.wait(0.2)
		t += 0.2
	end
	local data = load(player)
	if not player.Parent then
		-- parti pendant le chargement : on libère le verrou tout de suite
		if data and store then
			save({ Data = data, Player = player, Loaded = true, Released = true, Saving = false }, true)
		end
		return
	end
	if not data then
		player:Kick("Your data could not be loaded. Please rejoin in a moment!")
		return
	end
	data.Stats.Joins += 1
	local profile: Profile = { Data = data, Player = player, Loaded = true, Released = false, Saving = false }
	profiles[player] = profile
	for _, cb in ipairs(loadedCallbacks) do
		task.spawn(cb, player, data)
	end
	player:SetAttribute("DataLoaded", true)
end

local function release(player: Player)
	local profile = profiles[player]
	if not profile or profile.Released then return end
	profile.Released = true
	releasing[player.UserId] = true
	for _, cb in ipairs(releaseCallbacks) do
		pcall(cb, player, profile.Data)
	end
	save(profile, true) -- attend une éventuelle autosave en cours avant d'écrire
	profiles[player] = nil
	releasing[player.UserId] = nil
end

-- [ API ] --------------------------------------------------------------------

function DataService.Get(player: Player): any?
	local p = profiles[player]
	return p and not p.Released and p.Data or nil
end

-- envoie une clé (ou tout) au client
function DataService.Push(player: Player, k: string?)
	local data = DataService.Get(player)
	if not data then return end
	if k then
		Net.Sync:FireClient(player, k, data[k])
	else
		Net.Sync:FireClient(player, "*", data)
	end
end

function DataService.OnLoaded(cb: (Player, any) -> ())
	table.insert(loadedCallbacks, cb)
	for player, p in pairs(profiles) do
		task.spawn(cb, player, p.Data)
	end
end

function DataService.OnRelease(cb: (Player, any) -> ())
	table.insert(releaseCallbacks, cb)
end

-- sauvegarde immédiate (après un achat Robux)
function DataService.SaveNow(player: Player): boolean
	local p = profiles[player]
	if not p then return false end
	return save(p, false)
end

-- reçu déjà traité ? (achats Robux idempotents)
function DataService.HasReceipt(data: any, purchaseId: string): boolean
	return table.find(data.Receipts, purchaseId) ~= nil
end

function DataService.AddReceipt(data: any, purchaseId: string)
	table.insert(data.Receipts, purchaseId)
	while #data.Receipts > MAX_RECEIPTS do
		table.remove(data.Receipts, 1)
	end
end

function DataService.Start()
	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, p in ipairs(Players:GetPlayers()) do
		task.spawn(onPlayerAdded, p)
	end
	Players.PlayerRemoving:Connect(release)

	-- autosave
	task.spawn(function()
		while true do
			task.wait(AUTOSAVE)
			for _, profile in pairs(profiles) do
				if not profile.Released then
					task.spawn(save, profile, false)
				end
			end
		end
	end)

	-- arrêt du serveur : on sauvegarde tout le monde en parallèle
	game:BindToClose(function()
		if RunService:IsStudio() and not store then return end
		for player in pairs(profiles) do
			task.spawn(release, player)
		end
		-- attend que TOUTES les sauvegardes soient finies (y compris celles lancées par PlayerRemoving)
		local t = os.clock()
		while (next(profiles) ~= nil or next(releasing) ~= nil) and os.clock() - t < 25 do
			task.wait(0.1)
		end
	end)
end

return DataService
