--!strict
-- ServerScriptService/Services/SettingsService
-- Réglages du joueur sauvegardés (data.Settings) : Music / Sfx (on/off). Le client envoie "Setting", clé, booléen.
local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local SettingsService = {}
local KEYS = { Music = true, Sfx = true }

function SettingsService.Start()
	Net.On("Setting", function(player: Player, key: any, value: any)
		if type(key) ~= "string" or not KEYS[key] or type(value) ~= "boolean" then return end
		local data = DataService.Get(player)
		if not data then return end
		data.Settings = data.Settings or {}
		data.Settings[key] = value
		DataService.Push(player, "Settings")
	end, 2, 4)
end

return SettingsService
