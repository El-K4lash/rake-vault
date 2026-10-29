--!strict
-- Client/State : copie locale des données du joueur (reçues par "Sync"), signaux de changement,
-- et envoi des demandes au serveur.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Request = Remotes:WaitForChild("Request") :: RemoteEvent
local Invoke = Remotes:WaitForChild("Invoke") :: RemoteFunction
local Sync = Remotes:WaitForChild("Sync") :: RemoteEvent
local EventRemote = Remotes:WaitForChild("Event") :: RemoteEvent
local NotifyRemote = Remotes:WaitForChild("Notify") :: RemoteEvent

local State = {}
State.Data = nil :: any
State.Loaded = Instance.new("BindableEvent")
State.Changed = Instance.new("BindableEvent") -- (key)
State.Event = Instance.new("BindableEvent")   -- (name, payload)
State.Notify = Instance.new("BindableEvent")  -- (text, kind)

function State.Send(action: string, ...: any)
	Request:FireServer(action, ...)
end

function State.Ask(action: string, ...: any): any
	return Invoke:InvokeServer(action, ...)
end

function State.Get(key: string): any
	return State.Data and State.Data[key]
end

Sync.OnClientEvent:Connect(function(key: string, value: any)
	if key == "*" then
		local first = State.Data == nil
		State.Data = value
		if first then State.Loaded:Fire() end
		State.Changed:Fire("*")
	else
		if not State.Data then return end -- on attend la synchro complète
		State.Data[key] = value
		State.Changed:Fire(key)
	end
end)
EventRemote.OnClientEvent:Connect(function(name, payload) State.Event:Fire(name, payload) end)

-- si la première synchro est partie avant que ce script écoute (données chargées très vite), on la redemande
task.spawn(function()
	for _ = 1, 30 do
		task.wait(1)
		if State.Data then return end
		Request:FireServer("Resync")
	end
end)
NotifyRemote.OnClientEvent:Connect(function(text, kind) State.Notify:Fire(text, kind) end)

-- écoute un ou plusieurs champs
function State.On(keys: { string } | string, fn: () -> ())
	local set: { [string]: boolean } = {}
	if type(keys) == "string" then set[keys] = true else for _, k in ipairs(keys) do set[k] = true end end
	local function run()
		local ok, err = pcall(fn)
		if not ok then warn("[State] " .. tostring(err)) end
	end
	State.Changed.Event:Connect(function(k)
		if k == "*" or set[k] then run() end
	end)
	if State.Data then run() end
end

return State
