--!strict
-- StarterPlayerScripts/Client/Main : démarre les contrôleurs.
local folder = script.Parent
local order = {
	"State", "UI", "SliceController", "PerfController",
	"HUDController", "NotifyController", "ShopController", "IndexController",
	"BaseController", "RebirthController", "LeaderboardController",
	"ShovelController", "ItemsController", "WorldController", "PenController", "StoreController", "HotbarController", "AdminController", "BoostController", "BoardController", "PenFxController", "LobbyController", "FusionController", "StormFxController", "StormController", "TutorialController", "PlotTagController", "LbBoardController", "MusicController", "SledAnimController", "RewardsController", "UpgradeController", "GroupChestController",
}
for _, name in ipairs(order) do
	local ok, err = pcall(require, folder:WaitForChild(name))
	if not ok then warn("[Client] " .. name .. " : " .. tostring(err)) end
end
