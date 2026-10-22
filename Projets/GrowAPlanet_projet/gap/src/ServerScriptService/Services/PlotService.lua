--!strict
-- ServerScriptService/Services/PlotService
-- 8 bases autour du hub (Workspace.Map.Plots.Plot1..8). À l'arrivée, chaque joueur reçoit
-- la première base libre, son nom s'affiche sur le panneau, et il y apparaît.
-- Tout ce qui est créé pendant la partie (galaxies, planètes en orbite) va dans Plot.Dynamic
-- et est vidé quand le joueur part.

local Players = game:GetService("Players")

local Net = require(script.Parent.Parent.Lib.Net)
local DataService = require(script.Parent.DataService)

local PlotService = {}

local plotsFolder: Folder
local owners: { [Player]: Model } = {}

local function plotList(): { Model }
	local list = {}
	for _, p in ipairs(plotsFolder:GetChildren()) do
		if p:IsA("Model") then table.insert(list, p) end
	end
	table.sort(list, function(a, b) return (a:GetAttribute("Index") or 0) < (b:GetAttribute("Index") or 0) end)
	return list
end

local function setSign(plot: Model, text: string)
	local sign = plot:FindFirstChild("Sign")
	local label = sign and sign:FindFirstChild("Label", true)
	if label and label:IsA("TextLabel") then
		label.Text = text
	end
end

local function clearDynamic(plot: Model)
	local dyn = plot:FindFirstChild("Dynamic")
	if dyn then dyn:ClearAllChildren() end
end

local function spawnCFrame(plot: Model): CFrame
	local s = plot:FindFirstChild("Spawn")
	if s and s:IsA("BasePart") then
		return s.CFrame + Vector3.new(0, 3, 0)
	end
	return plot:GetPivot() + Vector3.new(0, 5, 0)
end

function PlotService.Get(player: Player): Model?
	return owners[player]
end

function PlotService.TeleportHome(player: Player)
	local plot = owners[player]
	local char = player.Character
	if plot and char then
		char:PivotTo(spawnCFrame(plot))
	end
end

local function assign(player: Player)
	for _, plot in ipairs(plotList()) do
		if not plot:GetAttribute("OwnerId") then
			plot:SetAttribute("OwnerId", player.UserId)
			plot:SetAttribute("OwnerName", player.DisplayName)
			owners[player] = plot
			player:SetAttribute("Plot", plot.Name)
			setSign(plot, player.DisplayName .. "'s Base")
			clearDynamic(plot)
			-- le joueur réapparaît toujours dans sa base
			player.RespawnLocation = nil
			if player.Character then
				task.defer(PlotService.TeleportHome, player)
			end
			return plot
		end
	end
	warn("[PlotService] plus de base libre pour " .. player.Name)
	return nil
end

local function free(player: Player)
	local plot = owners[player]
	if not plot then return end
	owners[player] = nil
	plot:SetAttribute("OwnerId", nil)
	plot:SetAttribute("OwnerName", nil)
	plot:SetAttribute("Equipped", nil)
	setSign(plot, "Empty Base")
	clearDynamic(plot)
end

function PlotService.Start()
	plotsFolder = workspace:WaitForChild("Map"):WaitForChild("Plots") :: Folder
	for _, plot in ipairs(plotList()) do
		setSign(plot, "Empty Base")
		if not plot:FindFirstChild("Dynamic") then
			local d = Instance.new("Folder")
			d.Name = "Dynamic"
			d.Parent = plot
		end
	end

	DataService.OnLoaded(function(player)
		assign(player)
	end)
	-- on libère APRÈS la sauvegarde (OnRelease est appelé juste avant)
	Players.PlayerRemoving:Connect(function(player)
		task.defer(free, player)
	end)

	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			task.wait() -- laisse le personnage se poser
			PlotService.TeleportHome(player)
		end)
	end)
	for _, player in ipairs(Players:GetPlayers()) do
		player.CharacterAdded:Connect(function()
			task.wait()
			PlotService.TeleportHome(player)
		end)
	end

	Net.On("TeleportBase", function(player)
		PlotService.TeleportHome(player)
	end, 0.5, 2)
end

return PlotService
