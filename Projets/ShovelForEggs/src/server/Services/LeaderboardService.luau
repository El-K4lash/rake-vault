--!strict
-- ServerScriptService/Services/LeaderboardService
-- Classements globaux (argent total gagné, rebirths) : top 100, affichés sur les panneaux du hub (Client/LbBoardController)
-- et envoyés au client pour le menu Leaderboard. Mise à jour toutes les 60 s.

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local LeaderboardService = {}
local Events = require(Shared.Config.Events)
local BOARDS = {
	{ Key = "Money", Store = "SFE_Lb_Money_v1", Stat = "TotalEarned", Fmt = Format.Money },
	{ Key = "Rebirths", Store = "SFE_Lb_Rebirths_v1", Stat = "Rebirths", Fmt = function(n) return tostring(n) end },
	-- classements de la semaine (remis à zéro le lundi 00:00 UTC : une base par semaine)
	{ Key = "WeekDig", Store = "SFE_Lb_WeekDig_", Weekly = true, Fmt = Format.Num,
		Get = function(d) return (d.Week and d.Week.Id == Events.WeekId(os.time())) and d.Week.Dug or 0 end },
	{ Key = "WeekSecrets", Store = "SFE_Lb_WeekSecrets_", Weekly = true, Fmt = function(n) return tostring(n) end,
		Get = function(d) return (d.Week and d.Week.Id == Events.WeekId(os.time())) and d.Week.Secrets or 0 end },
}
local function value(b: any, data: any): number
	if b.Get then return math.floor(b.Get(data)) end
	return math.floor(data[b.Stat] or 0)
end
local stores: { [string]: OrderedDataStore } = {}
local storeNames: { [string]: string } = {} -- nom de la base hebdomadaire en cours
local cache: { [string]: { { Name: string, UserId: number, Value: number } } } = {}
local names: { [number]: string } = {} -- pseudos déjà demandés (top 100)

local function boardModel(key: string): Model?
	local hub = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Hub")
	if not hub then return nil end
	local lbs = hub:FindFirstChild("Leaderboards")
	return (hub:FindFirstChild(key .. "Leaderboard") or (lbs and lbs:FindFirstChild(key .. "Leaderboard"))) :: Model?
end

-- panneau façon Steal an Egg : écran "Leaderboard" > SurfaceGui > ... > List > Row1..Row10 (Rank / PName / Value)
local function renderBoard(b: any, rows: { any })
	local m = boardModel(b.Key)
	if not m then return end
	local list = m:FindFirstChild("List", true)
	if not list then return end
	for i = 1, 10 do
		local row = list:FindFirstChild("Row" .. i)
		if row then
			local r = rows[i]
			local n = row:FindFirstChild("PName") :: TextLabel?
			local v = row:FindFirstChild("Value") :: TextLabel?
			if n then n.Text = r and r.Name or (i == 1 and #rows == 0 and "No data yet" or "-") end
			if v then v.Text = r and b.Fmt(r.Value) or "" end
			-- tête du joueur (panneaux du lobby)
			local av = row:FindFirstChild("Avatar") :: ImageLabel?
			if av then
				av.Image = (r and r.UserId and r.UserId > 0) and ("rbxthumb://type=AvatarHeadShot&id=" .. r.UserId .. "&w=150&h=150") or ""
			end
			-- les nouveaux panneaux gardent les 10 lignes visibles (vides = "-")
			if not av then row.Visible = r ~= nil or i == 1 end
		end
	end
end

-- classement des joueurs du serveur (si les DataStores ne répondent pas : Studio, panne)
local function serverRows(b: any): { any }
	local rows = {}
	for _, p in ipairs(Players:GetPlayers()) do
		local data = DataService.Get(p)
		if data then table.insert(rows, { Name = p.DisplayName, UserId = p.UserId, Value = value(b, data) }) end
	end
	table.sort(rows, function(a, c) return a.Value > c.Value end)
	return rows
end

local function refresh()
	for _, b in ipairs(BOARDS) do
		if b.Weekly then
			local name = b.Store .. Events.WeekId(os.time())
			if storeNames[b.Key] ~= name then
				pcall(function() stores[b.Key] = DataStoreService:GetOrderedDataStore(name) end)
				storeNames[b.Key] = name
			end
		end
		local store = stores[b.Key]
		if not store then
			cache[b.Key] = serverRows(b)
			renderBoard(b, cache[b.Key])
			continue
		end
		-- écrit les joueurs présents
		for _, p in ipairs(Players:GetPlayers()) do
			local data = DataService.Get(p)
			if data then
				pcall(function() store:SetAsync(tostring(p.UserId), value(b, data)) end)
			end
		end
		local ok, pages = pcall(function() return store:GetSortedAsync(false, 100) end)
		if not ok then
			cache[b.Key] = serverRows(b)
			renderBoard(b, cache[b.Key])
			continue
		end
		local rows = {}
		for _, e in ipairs(pages:GetCurrentPage()) do
			local uid = tonumber(e.key)
			local name = "???"
			if uid then
				if names[uid] then name = names[uid]
				else
					local okN, n = pcall(function() return Players:GetNameFromUserIdAsync(uid) end)
					if okN then name = n; names[uid] = n end
				end
			end
			table.insert(rows, { Name = name, UserId = uid or 0, Value = e.value })
		end
		cache[b.Key] = rows
		renderBoard(b, rows)
	end
	for _, p in ipairs(Players:GetPlayers()) do
		Net.Fire(p, "Leaderboards", cache)
	end
end

function LeaderboardService.Start()
	for _, b in ipairs(BOARDS) do
		if not b.Weekly then pcall(function() stores[b.Key] = DataStoreService:GetOrderedDataStore(b.Store) end) end
	end
	Net.On("GetLeaderboards", function(p)
		-- tant que le classement global n'est pas chargé, on montre le serveur
		for _, b in ipairs(BOARDS) do
			if not cache[b.Key] or #cache[b.Key] == 0 then cache[b.Key] = serverRows(b) end
		end
		Net.Fire(p, "Leaderboards", cache)
	end, 1, 2)
	task.spawn(function()
		task.wait(5)
		while true do
			pcall(refresh)
			task.wait(60)
		end
	end)
end

return LeaderboardService
