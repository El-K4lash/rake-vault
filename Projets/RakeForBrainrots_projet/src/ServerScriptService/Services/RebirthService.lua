--!strict
-- ServerScriptService/Services/RebirthService
-- Rebirth : remet argent / râteau / sac / sac d'objets à zéro ; garde brainrots, runes, index, slots ;
-- +1 slot offert, +25 % gains, zone suivante débloquée.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Rebirth = require(Shared.Config.Rebirth)
local Upgrades = require(Shared.Config.Upgrades)
local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)
local HarvestService = require(script.Parent.HarvestService)
local PlotService = require(script.Parent.PlotService)

local RebirthService = {}

local function onRebirth(player: Player)
	local data = DataService.Get(player)
	if not data then return end
	local cost = Rebirth.Cost(data.Rebirths)
	if data.Money < cost then
		Net.Notify(player, "You need $" .. cost .. " to rebirth!", "error")
		return
	end
	data.Money = 0
	data.Rake = 1
	data.Bag = 1
	data.BagItems = {}
	data.Boosts = {}
	data.Up = {}
	data.Rebirths += 1
	data.Slots = math.min(Upgrades.MaxSlots, data.Slots + Rebirth.SlotsPerRebirth)
	DataService.Push(player)
	HarvestService.GiveRake(player, data)
	PlotService.Refresh(player)
	local UpgradeService = require(script.Parent.UpgradeService) :: any
	UpgradeService.Apply(player, data)
	Net.Fire(player, "Rebirthed", data.Rebirths)
	-- retour à l'enclos
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local cf = PlotService.SpawnCFrame(player)
	if root and cf then root.CFrame = cf end
end

function RebirthService.Start()
	Net.On("Rebirth", onRebirth, 1, 1)
end

return RebirthService
