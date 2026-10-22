--!strict
-- StarterPlayerScripts/Client/Main
-- Démarre tous les contrôleurs de l'interface et du monde.

local folder = script.Parent
local order = {
	"State", "UI",
	"HUDController", "GalaxiesController", "PlanetsController", "ShopController",
	"MenusController", "HatchController", "WorldController",
}
for _, name in ipairs(order) do
	local ok, err = pcall(require, folder:WaitForChild(name))
	if not ok then warn("[Client] " .. name .. " : " .. tostring(err)) end
end
