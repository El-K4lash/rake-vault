--!strict
-- ServerScriptService/Lib/Net
-- Crée les Remotes et protège TOUTES les demandes du client :
--   * une seule RemoteEvent "Request" (client -> serveur) : Net.On("Equip", handler, {limit})
--   * une RemoteFunction "Invoke" pour les demandes qui attendent une réponse (codes)
--   * "Sync" (serveur -> client) : envoie les données du joueur
--   * "Notify" (serveur -> client) : petits messages à l'écran
--   * "Event" (serveur -> client) : événements (éclosion, achat...)
-- Chaque action a une limite de fréquence par joueur. Les arguments sont vérifiés
-- par le handler lui-même (types attendus), jamais trusted.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = {}

local folder = Instance.new("Folder")
folder.Name = "Remotes"

local function make(class: string, name: string): any
	local r = Instance.new(class)
	r.Name = name
	r.Parent = folder
	return r
end

local request = make("RemoteEvent", "Request") :: RemoteEvent
local invoke = make("RemoteFunction", "Invoke") :: RemoteFunction
Net.Sync = make("RemoteEvent", "Sync") :: RemoteEvent
Net.NotifyRemote = make("RemoteEvent", "Notify") :: RemoteEvent
Net.EventRemote = make("RemoteEvent", "Event") :: RemoteEvent
folder.Parent = ReplicatedStorage

type Handler = (player: Player, ...any) -> ...any
type Entry = { fn: Handler, perSecond: number, burst: number }
local handlers: { [string]: Entry } = {}
local functions: { [string]: Entry } = {}

-- seau de jetons par joueur et par action : "burst" demandes d'un coup, puis "perSecond"/s
local buckets: { [Player]: { [string]: { tokens: number, t: number } } } = {}
local function allow(player: Player, action: string, e: Entry): boolean
	local pb = buckets[player]
	if not pb then pb = {}; buckets[player] = pb end
	local now = os.clock()
	local b = pb[action]
	if not b then b = { tokens = e.burst, t = now }; pb[action] = b end
	b.tokens = math.min(e.burst, b.tokens + (now - b.t) * e.perSecond)
	b.t = now
	if b.tokens < 1 then return false end
	b.tokens -= 1
	return true
end
Players.PlayerRemoving:Connect(function(p) buckets[p] = nil end)

-- enregistre une action "client -> serveur" sans réponse
function Net.On(action: string, fn: Handler, perSecond: number?, burst: number?)
	handlers[action] = { fn = fn, perSecond = perSecond or 4, burst = burst or 6 }
end

-- enregistre une action qui renvoie une réponse au client
function Net.OnInvoke(action: string, fn: Handler, perSecond: number?, burst: number?)
	functions[action] = { fn = fn, perSecond = perSecond or 2, burst = burst or 3 }
end

request.OnServerEvent:Connect(function(player: Player, action: any, ...)
	if type(action) ~= "string" then return end
	local e = handlers[action]
	if not e or not allow(player, action, e) then return end
	local ok, err = pcall(e.fn, player, ...)
	if not ok then warn("[Net] " .. action .. " : " .. tostring(err)) end
end)

invoke.OnServerInvoke = function(player: Player, action: any, ...)
	if type(action) ~= "string" then return nil end
	local e = functions[action]
	if not e then return nil end
	if not allow(player, action, e) then return { ok = false, msg = "Slow down!" } end
	local ok, res = pcall(e.fn, player, ...)
	if not ok then
		warn("[Net] " .. action .. " : " .. tostring(res))
		return { ok = false, msg = "Error" }
	end
	return res
end

-- serveur -> client
function Net.Notify(player: Player, text: string, kind: string?)
	Net.NotifyRemote:FireClient(player, text, kind or "info")
end

function Net.Fire(player: Player, name: string, payload: any)
	Net.EventRemote:FireClient(player, name, payload)
end

-- petites vérifications d'arguments
function Net.IsString(v: any, maxLen: number?): boolean
	return type(v) == "string" and #v > 0 and #v <= (maxLen or 64)
end

function Net.IsInt(v: any, min: number, max: number): boolean
	return type(v) == "number" and v == v and math.floor(v) == v and v >= min and v <= max
end

return Net
