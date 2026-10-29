--!strict
-- ServerScriptService/Services/DataService
-- Sauvegarde fiable : verrou de session, retry, autosave 60 s, BindToClose, versionnage.
-- API : DataService.Get(player) -> data ; DataService.Push(player, key?) ; OnLoaded(cb) ; OnRelease(cb)

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Net = require(script.Parent.Parent.Lib.Net)

local DataService = {}

local STORE_NAME = "ShovelForEggs_Players_v1"
local VERSION = 1
local AUTOSAVE = 60
local LOCK_STALE = 90 -- l'autosave (60 s) rafraîchit le verrou : 90 s = serveur planté
local MAX_RECEIPTS = 100

local function template()
	return {
		Version = VERSION,
		Money = 0,
		TotalEarned = 0,
		Rebirths = 0,
		Shovel = 1,              -- niveau de râteau (1..5)
		Sled = 1,               -- niveau de sac (1..5)
		Slots = 4,             -- slots de base possédés
		SledItems = {},         -- [itemId] = count
		Pets = {},        -- [uid] = { Id, Mut, Slot (0 = rangé, >0 = dans l'enclos) }
		Eggs = {},             -- [eggId] = nombre d'œufs en poche
		Incubating = {},       -- [uid] = { Egg, HatchAt (os.time), U, V (position relative dans l'enclos -0.5..0.5) }
		Fence = "Wood",        -- style de clôture équipé
		Fences = { Wood = true }, -- styles achetés
		ChestAt = 0,
		Favorited = false,     -- a mis le jeu en favori (fenêtre du coffre du groupe)
		SpinAt = 0,            -- prochain tour gratuit de la roue du lobby (os.time)
		Passes = {},           -- [clé] = true : passes Robux possédés (Money, Hatch, Luck, VIP)           -- prochain œuf gratuit du coffre du hub (os.time)
		PassRevoked = {},     -- [clé] = true : pass retiré depuis le panel admin (pas redonné même s'il est acheté)
		NextUid = 1,
		Index = {},            -- ["Id"] = true, ["Id:Mut"] = true
		IndexClaimed = {},     -- [zoneId] = true
		Runes = { Luck = 0, Speed = 0, Sled = 0, Income = 0 },
		Boosts = {},           -- [stat] = os.time() de fin
		Up = {},               -- améliorations de la base (panneau UPGRADES) : [Id] = niveau, remis à zéro au rebirth
		Codes = {},
		Receipts = {},
		Pending = 0,           -- argent produit par la base, pas encore ramassé
		Settings = { Music = true, Sfx = true },
		Stats = { Harvested = 0, Found = 0, Sold = 0, Playtime = 0, Joins = 0 },
		Tutorial = 0,
		LastOnline = 0,
		-- contenu live (RewardsService / Config/Events)
		Advent = {},           -- ["jour"] = true : cases du calendrier ouvertes
		Quests = { Day = "", List = {}, Bonus = false }, -- quêtes du jour
		Pass = { XP = 0, Acc = 0, Free = {}, Premium = {} }, -- Winter Pass : XP + paliers réclamés
		StarterBought = false,
		OfflineLast = { Money = 0, At = 0 }, -- derniers gains hors ligne (pour le x2 Robux)
		Week = { Id = 0, Dug = 0, Secrets = 0 }, -- stats de la semaine (classements hebdomadaires)
		BestCombo = 0,
	}
end

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
if not ok then warn("[DataService] DataStore indisponible : pas de sauvegarde (active l'accès API dans Studio).") end
-- test dans Studio sans toucher à la vraie sauvegarde (utile quand le compte est déjà en jeu : verrou de session)
if RunService:IsStudio() and game:GetService("ServerStorage"):GetAttribute("StudioNoSave") == true then
	store = nil
	warn("[DataService] StudioNoSave : partie de test SANS sauvegarde")
end

type Profile = { Data: any, Player: Player, Loaded: boolean, Released: boolean, Saving: boolean }
local profiles: { [Player]: Profile } = {}
local releasing: { [number]: boolean } = {}

local function studioNoAccess(err: any): boolean
	local msg = tostring(err)
	return RunService:IsStudio() and (msg:find("403") ~= nil or msg:find("StudioAccessToApisNotAllowed") ~= nil or msg:find("not allowed") ~= nil)
end
local loadedCallbacks: { (Player, any) -> () } = {}
local releaseCallbacks: { (Player, any) -> () } = {}

local function key(userId: number): string
	return "P_" .. userId
end

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
	if not store then return template() end
	local jobId = game.JobId ~= "" and game.JobId or "studio"
	for _ = 1, 8 do
		local lockedByOther = false
		local okLoad, result = retry(function()
			return (store :: DataStore):UpdateAsync(key(player.UserId), function(old)
				lockedByOther = false
				old = old or { Data = nil, Lock = nil }
				local lock = old.Lock
				if lock and lock.Job ~= jobId and os.time() - (lock.Time or 0) < LOCK_STALE then
					lockedByOther = true
					return nil
				end
				old.Lock = { Job = jobId, Time = os.time() }
				return old
			end)
		end)
		if not okLoad then
			if not store then return template() end
			return nil
		end
		if not lockedByOther and result then
			local data = result.Data or template()
			reconcile(data, template())
			data.Version = VERSION
			return data
		end
		task.wait(4)
		if not player.Parent then return nil end
	end
	return nil
end

local function save(profile: Profile, release: boolean): boolean
	if not store then return true end
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
				return nil
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
	-- serveur « salle d'attente » d'un redémarrage (AdminService) : on ne charge pas les données,
	-- le joueur repart tout de suite vers un nouveau serveur
	if game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0 then
		local okJ, jd = pcall(player.GetJoinData, player)
		local td = okJ and jd and jd.TeleportData
		if type(td) == "table" and td.SFE_Holding == true then return end
	end
	local t = 0
	while releasing[player.UserId] and t < 30 do
		task.wait(0.2)
		t += 0.2
	end
	local data = load(player)
	if not player.Parent then
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
	Net.Sync:FireClient(player, "*", data)
	pcall((DataService :: any).RefreshStats, player, data)
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
	save(profile, true)
	profiles[player] = nil
	releasing[player.UserId] = nil
end

function DataService.Get(player: Player): any?
	local p = profiles[player]
	return p and not p.Released and p.Data or nil
end

-- leaderstats (liste des joueurs en haut à droite) : Money, Rebirths, Pets possédés
local Format = require(game:GetService("ReplicatedStorage").Shared.Util.Format)
local function refreshStats(player: Player, data: any)
	local ls = player:FindFirstChild("leaderstats")
	if not ls then
		ls = Instance.new("Folder"); ls.Name = "leaderstats"
		for _, n in ipairs({ "Money", "Rebirths", "Pets" }) do
			local v = Instance.new(n == "Money" and "StringValue" or "IntValue"); v.Name = n; v.Parent = ls
		end
		ls.Parent = player
	end
	local count = 0
	for _ in pairs(data.Pets or {}) do count += 1 end
	(ls :: any).Money.Value = Format.Money(data.Money or 0);
	(ls :: any).Rebirths.Value = data.Rebirths or 0;
	(ls :: any).Pets.Value = count
end

DataService.RefreshStats = refreshStats
DataService.Template = template

-- remet les données d'un joueur à zéro (panel admin) : garde seulement les achats Robux (Passes, Receipts)
function DataService.ResetData(player: Player): boolean
	local p = profiles[player]
	if not p or p.Released then return false end
	local data = p.Data
	local keep = { Passes = data.Passes, Receipts = data.Receipts, PassRevoked = data.PassRevoked }
	for k in pairs(data) do data[k] = nil end
	for k, v in pairs(template()) do data[k] = v end
	data.Passes = keep.Passes or {}
	data.Receipts = keep.Receipts or {}
	data.PassRevoked = keep.PassRevoked or {}
	return DataService.SaveNow(player)
end

function DataService.Push(player: Player, k: string?)
	local data = DataService.Get(player)
	if not data then return end
	if k == nil or k == "*" or k == "Money" or k == "Rebirths" or k == "Pets" then
		pcall(refreshStats, player, data)
	end
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

function DataService.SaveNow(player: Player): boolean
	local p = profiles[player]
	if not p or p.Released then return false end
	return save(p, false)
end

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
	-- le client redemande ses données s'il a raté la première synchro
	Net.On("Resync", function(player) DataService.Push(player) end, 1, 3)
	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, p in ipairs(Players:GetPlayers()) do
		task.spawn(onPlayerAdded, p)
	end
	Players.PlayerRemoving:Connect(release)

	task.spawn(function()
		while true do
			task.wait(AUTOSAVE)
			for _, profile in pairs(profiles) do
				if not profile.Released then
					profile.Data.Stats.Playtime += AUTOSAVE
					task.spawn(save, profile, false)
				end
			end
		end
	end)

	game:BindToClose(function()
		if RunService:IsStudio() and not store then return end
		for player in pairs(profiles) do
			task.spawn(release, player)
		end
		local t = os.clock()
		while (next(profiles) ~= nil or next(releasing) ~= nil) and os.clock() - t < 25 do
			task.wait(0.1)
		end
	end)
end

return DataService
