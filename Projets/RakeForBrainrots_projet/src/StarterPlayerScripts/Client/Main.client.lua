--!strict
-- StarterPlayerScripts/Client/Main : démarre les contrôleurs.
local folder = script.Parent
local order = {
	"State", "UI",
	"HUDController", "NotifyController", "ShopController", "IndexController",
	"BaseController", "RebirthController", "LeaderboardController",
	"RakeController", "ItemsController", "WorldController", "PenController", "StoreController", "HotbarController", "NextWorldController", "AdminController", "BoostController", "BoardController", "PenFxController", "LobbyController", "FusionController", "MapFxController", "TutorialController", "MusicController", "PlotTagController", "LbBoardController",
}
for _, name in ipairs(order) do
	local ok, err = pcall(require, folder:WaitForChild(name))
	if not ok then warn("[Client] " .. name .. " : " .. tostring(err)) end
end
