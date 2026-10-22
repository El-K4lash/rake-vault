--!strict
-- ServerScriptService/Services/AdminService
-- Panel admin (inspiré du panel de "Save Brainrots From Backrooms" du vault, adapté à Rake for Brainrots).
-- Tout passe par Net.OnInvoke("Admin", cmd, args) : le serveur vérifie TOUJOURS que le joueur est admin
-- (Config/Admins, créateur du jeu, ou Studio). Bans en DataStore, events serveur via Stats.ServerEvent.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Admins = require(Shared.Config.Admins)
local Upgrades = require(Shared.Config.Upgrades)
local Brainrots = require(Shared.Config.Brainrots)
local Mutations = require(Shared.Config.Mutations)
local Eggs = require(Shared.Config.Eggs)
local Items = require(Shared.Config.Items)
local Format = require(Shared.Util.Format)

local Net = require(script.Parent.Parent.Lib.Net)
local Stats = require(script.Parent.Parent.Lib.Stats)
local DataService = require(script.Parent.DataService)

local AdminService = {}

local banStore: DataStore? = nil
pcall(function() banStore = DataStoreService:GetDataStore("RakeForBrainrots_Bans_v1") end)

local logs: { string } = {}
local function log(admin: Player, text: string)
	table.insert(logs, 1, os.date("!%H:%M", os.time()) .. "  " .. admin.Name .. " : " .. text)
	while #logs > 60 do table.remove(logs) end
end

-- admins nommés depuis le panel : [UserId] = { Name, By, At } (DataStore, partagé entre serveurs)
local adminStore: DataStore? = nil
pcall(function() adminStore = DataStoreService:GetDataStore("RakeForBrainrots_Admins_v1") end)
local staff: { [string]: any } = {}

function AdminService.IsOwner(p: Player): boolean
	if RunService:IsStudio() then return true end
	return table.find(Admins.OwnerIds, p.UserId) ~= nil
end

function AdminService.IsAdmin(p: Player): boolean
	return AdminService.IsOwner(p) or staff[tostring(p.UserId)] ~= nil
end

local function applyAttrs(p: Player)
	p:SetAttribute("IsOwner", AdminService.IsOwner(p))
	p:SetAttribute("IsAdmin", AdminService.IsAdmin(p))
end

local function loadStaff()
	if not adminStore then return end
	local ok, v = pcall(function() return (adminStore :: DataStore):GetAsync("Staff") end)
	if ok and type(v) == "table" then staff = v end
	for _, p in ipairs(Players:GetPlayers()) do applyAttrs(p) end
end

-- "1.5M" / "250k" / "1e9" -> nombre
local SUF = { k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18 }
local function parseNum(v: any): number?
	if type(v) == "number" then return v end
	if type(v) ~= "string" then return nil end
	local s = string.lower(string.gsub(v, "[%s,$]", ""))
	local n, suf = string.match(s, "^([%d%.e%+%-]+)(%a*)$")
	local x = n and tonumber(n)
	if not x then return nil end
	if suf ~= "" then
		if not SUF[suf] then return nil end
		x *= SUF[suf]
	end
	if x ~= x or math.abs(x) > 1e30 then return nil end
	return x
end

local function target(args: any): (Player?, any)
	local uid = type(args) == "table" and tonumber(args.Target)
	local p = uid and Players:GetPlayerByUserId(uid)
	return p, p and DataService.Get(p)
end

-- commandes qu'un admin (non propriétaire) n'a pas le droit d'utiliser sur un propriétaire
local PROTECTED = { Kick = true, Ban = true, Reset = true, Freeze = true, Fling = true, SetStat = true, Bring = true,
	Size = true, Speed = true, Jump = true, ResetChar = true }

local function root(p: Player): BasePart?
	local c = p.Character
	return c and c:FindFirstChild("HumanoidRootPart") :: BasePart?
end
local function hum(p: Player): Humanoid?
	local c = p.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function announce(text: string)
	for _, p in ipairs(Players:GetPlayers()) do Net.Fire(p, "AdminAnnounce", text) end
end

local function plotRefresh(p: Player)
	local PlotService = require(script.Parent.PlotService) :: any
	PlotService.Refresh(p)
end

local function playerInfo(p: Player): any
	local d = DataService.Get(p)
	local n = 0
	if d then for _ in pairs(d.Brainrots) do n += 1 end end
	return {
		UserId = p.UserId, Name = p.Name, Display = p.DisplayName, Owner = AdminService.IsOwner(p),
		Money = d and d.Money or 0, Rebirths = d and d.Rebirths or 0, Slots = d and d.Slots or 0,
		Rake = d and d.Rake or 0, Bag = d and d.Bag or 0, Brainrots = n, Admin = AdminService.IsAdmin(p),
	}
end

local function events(): any
	local out = {}
	for _, s in ipairs({ "Luck", "Money" }) do
		local m = Stats.ServerEvent(s)
		local e = workspace:GetAttribute("Event" .. s .. "End")
		out[s] = { Mult = m, Left = (m > 1 and type(e) == "number") and (e - os.time()) or 0 }
	end
	return out
end

-- [ COMMANDES ] ------------------------------------------------------------------
type Cmd = (admin: Player, args: any) -> (boolean, string?, any?)
local C: { [string]: Cmd } = {}

C.Players = function()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do table.insert(list, playerInfo(p)) end
	return true, nil, { Players = list, Events = events() }
end

C.SetStat = function(admin, args)
	local p, d = target(args)
	if not (p and d) then return false, "Player not found" end
	local v = parseNum(args.Value)
	if not v then return false, "Invalid value" end
	local stat = args.Stat
	if stat == "Money" then
		d.Money = math.max(0, math.floor(v)); DataService.Push(p, "Money")
	elseif stat == "Rebirths" then
		d.Rebirths = math.clamp(math.floor(v), 0, 1000); DataService.Push(p); plotRefresh(p)
	elseif stat == "Slots" then
		d.Slots = math.clamp(math.floor(v), 1, Upgrades.MaxSlots); DataService.Push(p, "Slots"); plotRefresh(p)
	elseif stat == "Rake" then
		d.Rake = math.clamp(math.floor(v), 1, #Upgrades.Rakes); DataService.Push(p, "Rake")
		local HarvestService = require(script.Parent.HarvestService) :: any
		HarvestService.GiveRake(p, d)
	elseif stat == "Bag" then
		d.Bag = math.clamp(math.floor(v), 1, #Upgrades.Bags); DataService.Push(p, "Bag")
	else
		return false, "Unknown stat"
	end
	log(admin, "set " .. stat .. " of " .. p.Name .. " = " .. tostring(math.floor(v)))
	Net.Notify(p, "An admin set your " .. stat .. " to " .. Format.Num(v), "info")
	return true, stat .. " set to " .. Format.Num(v)
end

C.AddMoney = function(admin, args)
	local p, d = target(args)
	local v = parseNum(args.Value)
	if not (p and d and v) then return false, "Invalid" end
	d.Money = math.max(0, d.Money + v); d.TotalEarned = (d.TotalEarned or 0) + math.max(v, 0)
	DataService.Push(p, "Money")
	log(admin, "gave " .. Format.Money(v) .. " to " .. p.Name)
	Net.Notify(p, "An admin gave you " .. Format.Money(v) .. "!", "success")
	return true, "+" .. Format.Money(v) .. " to " .. p.Name
end

C.AddRebirth = function(admin, args)
	local p, d = target(args)
	if not (p and d) then return false, "Player not found" end
	d.Rebirths += 1; DataService.Push(p); plotRefresh(p)
	log(admin, "+1 rebirth to " .. p.Name)
	return true, p.Name .. " : " .. d.Rebirths .. " rebirths"
end

C.MaxRunes = function(admin, args)
	local p, d = target(args)
	if not (p and d) then return false, "Player not found" end
	for k, cap in pairs(Items.RuneCaps) do d.Runes[k] = cap end
	DataService.Push(p, "Runes")
	log(admin, "max runes for " .. p.Name)
	return true, "Runes maxed for " .. p.Name
end

C.GiveBrainrot = function(admin, args)
	local p, d = target(args)
	if not (p and d) then return false, "Player not found" end
	if not Brainrots.ById[args.Id] then return false, "Unknown brainrot" end
	local mut = Mutations.ById[args.Mut] and args.Mut or "Normal"
	local n = math.clamp(math.floor(parseNum(args.Count) or 1), 1, 50)
	local HarvestService = require(script.Parent.HarvestService) :: any
	for _ = 1, n do HarvestService.AddBrainrot(p, d, args.Id, mut) end
	DataService.Push(p, "Brainrots"); DataService.Push(p, "Index")
	local name = Brainrots.ById[args.Id].Name or args.Id
	log(admin, "gave " .. n .. "x " .. mut .. " " .. name .. " to " .. p.Name)
	Net.Notify(p, "An admin gave you " .. n .. "x " .. (mut ~= "Normal" and (mut .. " ") or "") .. name .. "!", "success")
	return true, n .. "x " .. name .. " (" .. mut .. ") -> " .. p.Name
end

C.GiveEgg = function(admin, args)
	local p, d = target(args)
	if not (p and d) then return false, "Player not found" end
	if not Eggs.ById[args.Id] then return false, "Unknown egg" end
	local n = math.clamp(math.floor(parseNum(args.Count) or 1), 1, 100)
	d.Eggs[args.Id] = (d.Eggs[args.Id] or 0) + n
	DataService.Push(p, "Eggs")
	local EggService = require(script.Parent.EggService) :: any
	EggService.SyncTools(p, d)
	log(admin, "gave " .. n .. "x " .. args.Id .. " to " .. p.Name)
	return true, n .. "x " .. args.Id .. " -> " .. p.Name
end

C.Kick = function(admin, args)
	local p = target(args)
	if not p then return false, "Player not found" end
	local reason = type(args.Reason) == "string" and args.Reason ~= "" and string.sub(args.Reason, 1, 120) or "Kicked by an admin"
	log(admin, "kicked " .. p.Name .. " (" .. reason .. ")")
	p:Kick(reason)
	return true, p.Name .. " kicked"
end

C.Ban = function(admin, args)
	local p = target(args)
	if not p then return false, "Player not found" end
	if p == admin then return false, "You can't ban yourself" end
	local reason = type(args.Reason) == "string" and args.Reason ~= "" and string.sub(args.Reason, 1, 120) or "Banned by an admin"
	if banStore then
		local ok = pcall(function() (banStore :: DataStore):SetAsync("B_" .. p.UserId, { Reason = reason, By = admin.UserId, At = os.time(), Name = p.Name }) end)
		if not ok then return false, "Ban not saved (DataStore error)" end
	end
	log(admin, "banned " .. p.Name .. " (" .. reason .. ")")
	p:Kick("You are banned: " .. reason)
	return true, p.Name .. " banned"
end

C.Unban = function(admin, args)
	local key = type(args) == "table" and args.Name
	if type(key) ~= "string" or key == "" then return false, "Enter a username or UserId" end
	local uid = tonumber(key)
	if not uid then
		local ok, id = pcall(Players.GetUserIdFromNameAsync, Players, key)
		if not ok then return false, "Unknown user" end
		uid = id
	end
	if not banStore then return false, "DataStore unavailable" end
	local ok = pcall(function() (banStore :: DataStore):RemoveAsync("B_" .. uid) end)
	if not ok then return false, "DataStore error" end
	log(admin, "unbanned " .. key)
	return true, key .. " unbanned"
end

C.Reset = function(admin, args)
	local p = target(args)
	if not p then return false, "Player not found" end
	if not DataService.ResetData(p) then return false, "Reset failed" end
	log(admin, "RESET data of " .. p.Name)
	p:Kick("Your data was reset by an admin. Rejoin to start fresh!")
	return true, p.Name .. " reset"
end

C.TpTo = function(admin, args)
	local p = target(args)
	local a, b = root(admin), p and root(p)
	if not (a and b) then return false, "No character" end
	a.CFrame = b.CFrame * CFrame.new(0, 0, 4)
	return true, "Teleported to " .. (p :: Player).Name
end

C.Bring = function(admin, args)
	local p = target(args)
	local a, b = root(admin), p and root(p)
	if not (a and b) then return false, "No character" end
	b.CFrame = a.CFrame * CFrame.new(0, 0, -4)
	log(admin, "brought " .. (p :: Player).Name)
	return true, (p :: Player).Name .. " brought"
end

C.BringAll = function(admin)
	local a = root(admin)
	if not a then return false, "No character" end
	local i = 0
	for _, p in ipairs(Players:GetPlayers()) do
		local r = root(p)
		if p ~= admin and r then i += 1; r.CFrame = a.CFrame * CFrame.new((i % 5 - 2) * 4, 0, -5 - math.floor(i / 5) * 4) end
	end
	log(admin, "brought everyone")
	return true, i .. " players brought"
end

C.Freeze = function(admin, args)
	local p = target(args)
	local r = p and root(p)
	if not r then return false, "No character" end
	r.Anchored = args.On == true
	log(admin, (args.On and "froze " or "unfroze ") .. (p :: Player).Name)
	return true, (p :: Player).Name .. (args.On and " frozen" or " unfrozen")
end

C.Speed = function(admin, args)
	local p = target(args)
	local h = p and hum(p)
	local v = parseNum(args.Value)
	if not (h and v) then return false, "Invalid" end
	h.WalkSpeed = math.clamp(v, 0, 300)
	return true, "Speed " .. h.WalkSpeed
end

C.Jump = function(admin, args)
	local p = target(args)
	local h = p and hum(p)
	local v = parseNum(args.Value)
	if not (h and v) then return false, "Invalid" end
	h.UseJumpPower = true; h.JumpPower = math.clamp(v, 0, 500)
	return true, "Jump " .. h.JumpPower
end

C.Size = function(admin, args)
	local p = target(args)
	local c = p and p.Character
	local s = ({ Tiny = 0.4, Normal = 1, Big = 1.8, Giant = 3 })[args.Size]
	if not (c and s) then return false, "Invalid" end
	c:ScaleTo(s)
	return true, (p :: Player).Name .. " -> " .. args.Size
end

C.Fling = function(admin, args)
	local p = target(args)
	local r = p and root(p)
	if not r then return false, "No character" end
	r.AssemblyLinearVelocity = Vector3.new(math.random(-120, 120), 160, math.random(-120, 120))
	log(admin, "flung " .. (p :: Player).Name)
	return true, "Yeet!"
end

C.Heal = function(admin, args)
	local p = target(args)
	local h = p and hum(p)
	if not h then return false, "No character" end
	h.Health = h.MaxHealth
	return true, "Healed"
end

C.ResetChar = function(admin, args)
	local p = target(args)
	if not p then return false, "Player not found" end
	p:LoadCharacter()
	return true, (p :: Player).Name .. " respawned"
end

C.Announce = function(admin, args)
	local t = type(args) == "table" and args.Text
	if type(t) ~= "string" or #t < 1 then return false, "Empty message" end
	t = string.sub(t, 1, 200)
	local ok, filtered = pcall(function()
		local TextService = game:GetService("TextService")
		return TextService:FilterStringAsync(t, admin.UserId):GetNonChatStringForBroadcastAsync()
	end)
	announce(ok and filtered or t)
	log(admin, "announce: " .. t)
	return true, "Sent"
end

C.GiveAll = function(admin, args)
	local v = parseNum(type(args) == "table" and args.Value)
	if not v or v <= 0 then return false, "Invalid amount" end
	for _, p in ipairs(Players:GetPlayers()) do
		local d = DataService.Get(p)
		if d then d.Money += v; d.TotalEarned = (d.TotalEarned or 0) + v; DataService.Push(p, "Money") end
	end
	announce("🎁 An admin gave everyone " .. Format.Money(v) .. "!")
	log(admin, "gave everyone " .. Format.Money(v))
	return true, "Everyone got " .. Format.Money(v)
end

C.Event = function(admin, args)
	local stat = type(args) == "table" and args.Stat
	if stat ~= "Luck" and stat ~= "Money" then return false, "Unknown event" end
	local m = math.clamp(math.floor(parseNum(args.Mult) or 2), 2, 10)
	local mins = math.clamp(parseNum(args.Minutes) or 10, 1, 240)
	workspace:SetAttribute("Event" .. stat, m)
	workspace:SetAttribute("Event" .. stat .. "End", os.time() + math.floor(mins * 60))
	announce((stat == "Luck" and "🍀 x" or "💰 x") .. m .. " " .. string.upper(stat) .. " EVENT for " .. math.floor(mins) .. " min!")
	log(admin, "started x" .. m .. " " .. stat .. " event (" .. mins .. " min)")
	return true, "x" .. m .. " " .. stat .. " started", { Events = events() }
end

C.StopEvents = function(admin)
	for _, s in ipairs({ "Luck", "Money" }) do
		workspace:SetAttribute("Event" .. s, nil); workspace:SetAttribute("Event" .. s .. "End", nil)
	end
	announce("Events ended.")
	log(admin, "stopped all events")
	return true, "Events stopped", { Events = events() }
end

C.SaveAll = function(admin)
	local n = 0
	for _, p in ipairs(Players:GetPlayers()) do if DataService.SaveNow(p) then n += 1 end end
	log(admin, "saved all (" .. n .. ")")
	return true, n .. " saved"
end

C.RespawnAll = function(admin)
	for _, p in ipairs(Players:GetPlayers()) do task.spawn(p.LoadCharacter, p) end
	log(admin, "respawned all")
	return true, "Everyone respawned"
end

C.RefillItems = function(admin)
	local WorldService = require(script.Parent.WorldService) :: any
	local n = WorldService.RefillAll()
	log(admin, "refilled zones (+" .. n .. ")")
	return true, "+" .. n .. " items"
end

C.Shutdown = function(admin)
	log(admin, "SHUTDOWN")
	announce("⚠ Server restarting for an update...")
	task.delay(3, function()
		for _, p in ipairs(Players:GetPlayers()) do DataService.SaveNow(p) end
		for _, p in ipairs(Players:GetPlayers()) do p:Kick("Server closed for an update. Rejoin!") end
	end)
	return true, "Shutting down in 3s"
end

-- [ GESTION DES ADMINS ] (propriétaires seulement) --------------------------------
local function saveStaff(mut: (any) -> ()): boolean
	if not adminStore then mut(staff); return true end
	local ok, v = pcall(function()
		return (adminStore :: DataStore):UpdateAsync("Staff", function(old)
			local t = type(old) == "table" and old or {}
			mut(t)
			return t
		end)
	end)
	if ok and type(v) == "table" then staff = v end
	if not ok and RunService:IsStudio() then
		mut(staff) -- Studio sans accès API : gardé en mémoire le temps du test
		return true
	end
	return ok
end

local function staffList(): any
	local list = {}
	for uid, e in pairs(staff) do table.insert(list, { UserId = tonumber(uid), Name = e.Name, At = e.At }) end
	table.sort(list, function(a, b) return (a.At or 0) < (b.At or 0) end)
	return list
end

C.ListAdmins = function()
	return true, nil, { Admins = staffList() }
end

C.AddAdmin = function(admin, args)
	local key = type(args) == "table" and (args.Target or args.Name)
	local uid = tonumber(key)
	local name: string? = nil
	if not uid then
		if type(key) ~= "string" or key == "" then return false, "Enter a username or UserId" end
		local ok, id = pcall(Players.GetUserIdFromNameAsync, Players, key)
		if not ok then return false, "Unknown user" end
		uid = id
	end
	local online = Players:GetPlayerByUserId(uid :: number)
	name = online and online.Name or nil
	if not name then
		local ok, n = pcall(Players.GetNameFromUserIdAsync, Players, uid)
		name = ok and n or tostring(uid)
	end
	if online and AdminService.IsOwner(online) then return false, (name :: string) .. " is already an owner" end
	if not saveStaff(function(t) t[tostring(uid)] = { Name = name, By = admin.UserId, At = os.time() } end) then
		return false, "DataStore error"
	end
	if online then applyAttrs(online); Net.Notify(online, "You are now an admin! Press F2 to open the panel.", "success") end
	log(admin, "made " .. tostring(name) .. " admin")
	return true, tostring(name) .. " is now admin", { Admins = staffList() }
end

C.RemoveAdmin = function(admin, args)
	local uid = type(args) == "table" and tonumber(args.UserId)
	if not uid then return false, "Invalid" end
	local name = staff[tostring(uid)] and staff[tostring(uid)].Name or tostring(uid)
	if not saveStaff(function(t) t[tostring(uid)] = nil end) then return false, "DataStore error" end
	local online = Players:GetPlayerByUserId(uid)
	if online then applyAttrs(online); Net.Notify(online, "You are no longer an admin.", "info") end
	log(admin, "removed admin " .. tostring(name))
	return true, tostring(name) .. " is no longer admin", { Admins = staffList() }
end

local OWNER_ONLY = { ListAdmins = true, AddAdmin = true, RemoveAdmin = true, Shutdown = true }

C.Logs = function()
	return true, nil, { Logs = logs }
end

-- [ DÉMARRAGE ] --------------------------------------------------------------------
local function checkBan(p: Player)
	if not banStore or AdminService.IsAdmin(p) then return end
	local ok, ban = pcall(function() return (banStore :: DataStore):GetAsync("B_" .. p.UserId) end)
	if ok and type(ban) == "table" then p:Kick("You are banned: " .. tostring(ban.Reason)) end
end

function AdminService.Start()
	Net.OnInvoke("Admin", function(player: Player, cmd: any, args: any)
		if not AdminService.IsAdmin(player) then return { ok = false, msg = "Not admin" } end
		local fn = type(cmd) == "string" and C[cmd]
		if not fn then return { ok = false, msg = "Unknown command" } end
		local owner = AdminService.IsOwner(player)
		if OWNER_ONLY[cmd] and not owner then return { ok = false, msg = "Owner only" } end
		if PROTECTED[cmd] and not owner then
			local t = target(args)
			if t and t ~= player and AdminService.IsOwner(t) then return { ok = false, msg = "You can't do that to an owner" } end
		end
		local ok, msg, data = fn(player, args)
		return { ok = ok, msg = msg, data = data }
	end, 10, 20)
	local function joined(p: Player)
		applyAttrs(p)
		task.spawn(checkBan, p)
	end
	task.spawn(loadStaff)
	for _, p in ipairs(Players:GetPlayers()) do joined(p) end
	Players.PlayerAdded:Connect(joined)
	-- les admins ajoutés / retirés sur un autre serveur arrivent ici au bout d'une minute max
	task.spawn(function() while true do task.wait(60); loadStaff() end end)
end

return AdminService
