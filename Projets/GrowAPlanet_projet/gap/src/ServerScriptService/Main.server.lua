--!strict
-- ServerScriptService/Main
-- Démarre tous les services du jeu dans le bon ordre.

local Services = script.Parent:WaitForChild("Services")

local order = {
	"DataService",
	"PlotService",
	"IndexService",
	"PlanetService",
	"IncubatorService",
	"SpawnerService",
	"IncomeService",
	"ProgressService",
	"ShopService",
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

print("[Grow a Planet] serveur prêt")
