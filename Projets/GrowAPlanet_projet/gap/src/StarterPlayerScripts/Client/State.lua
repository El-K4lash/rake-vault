--!strict
-- StarterPlayerScripts/Client/State
-- Copie locale des données du joueur, envoyées par le serveur (Remote "Sync").
-- Le client ne modifie JAMAIS ces données : il demande au serveur avec State.Request(...).

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Gamepasses = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Gamepasses"))

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local request = remotes:WaitForChild("Request") :: RemoteEvent
local invoke = remotes:WaitForChild("Invoke") :: RemoteFunction
local player = Players.LocalPlayer

local State = {}
State.Data = {} :: any
State.Loaded = false

local listeners: { [string]: { (any) -> () } } = {}
local eventListeners: { [string]: { (any) -> () } } = {}

-- appelle fn à chaque changement de la clé (et tout de suite si déjà chargée)
function State.On(key: string, fn: (any) -> ())
	listeners[key] = listeners[key] or {}
	table.insert(listeners[key], fn)
	if State.Loaded then task.spawn(fn, State.Data[key]) end
end

local function fire(key: string)
	for _, fn in ipairs(listeners[key] or {}) do
		task.spawn(fn, State.Data[key])
	end
end

-- événements envoyés par le serveur (éclosion, achat...)
function State.OnEvent(name: string, fn: (any) -> ())
	eventListeners[name] = eventListeners[name] or {}
	table.insert(eventListeners[name], fn)
end

function State.Request(action: string, ...: any)
	request:FireServer(action, ...)
end

function State.Invoke(action: string, ...: any): any
	local ok, res = pcall(invoke.InvokeServer, invoke, action, ...)
	return ok and res or nil
end

-- état "calculable" pour Formulas (mêmes calculs que le serveur)
function State.Build()
	local d = State.Data
	local passes = {}
	for name in pairs(Gamepasses) do
		passes[name] = player:GetAttribute("Pass_" .. name) == true
	end
	return {
		Rebirths = d.Rebirths or 0,
		Upgrades = d.Upgrades or {},
		Passes = passes,
		Boosts = d.Boosts or {},
		IndexClaimed = d.IndexClaimed or {},
		Now = workspace:GetServerTimeNow(),
	}
end

-- heure serveur (os.time côté serveur) pour les timers
function State.Now(): number
	return workspace:GetServerTimeNow()
end

remotes:WaitForChild("Sync").OnClientEvent:Connect(function(key: string, value: any)
	if key == "*" then
		State.Data = value
		State.Loaded = true
		for k in pairs(listeners) do fire(k) end
	else
		State.Data[key] = value
		fire(key)
	end
end)

remotes:WaitForChild("Event").OnClientEvent:Connect(function(name: string, payload: any)
	for _, fn in ipairs(eventListeners[name] or {}) do
		task.spawn(fn, payload)
	end
end)

-- les gamepasses changent les calculs : on prévient comme une donnée
player.AttributeChanged:Connect(function(attr)
	if string.sub(attr, 1, 5) == "Pass_" then fire("Passes") end
end)

return State
