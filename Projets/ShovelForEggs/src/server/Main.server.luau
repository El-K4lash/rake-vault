--!strict
-- ServerScriptService/Main : démarre les services dans l'ordre.
local Services = script.Parent:WaitForChild("Services")

local order = {
	"DataService",
	"WorldService",
	"PlotService",
	"EggService",
	"IndexService",
	"HarvestService",
	"EconomyService",
	"RebirthService",
	"UpgradeService",
	"CodesService",
	"LeaderboardService",
	"StoreService",
	"RewardsService",
	"LobbyService",
	"StormService",
	"SledService",
	"TutorialService",
	"SettingsService",
	"DebugService",
	"AdminService",
}

for _, name in ipairs(order) do
	local ok, err = pcall(function()
		local service = require(Services:WaitForChild(name)) :: any
		if service.Start then service.Start() end
	end)
	if not ok then
		warn("[Main] " .. name .. " n'a pas démarré : " .. tostring(err))
	end
end

print("[Shovel for Eggs] serveur prêt")
