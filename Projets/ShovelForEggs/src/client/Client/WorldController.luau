--!strict
-- Client/WorldController : objets qui flottent/tournent, barrières de zone (ouvertes localement si débloquées),
-- bannière quand on entre dans une zone, animations Idle des pets posés dans les bases.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Zones = require(Shared.Config.Zones)
local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local map = workspace:WaitForChild("Map")

-- [ OBJETS AU SOL ] -----------------------------------------------------------
-- les déchets restent posés au sol (on les ratisse) ; seuls les objets rares / runes flottent et tournent
local tracked: { [BasePart]: { base: CFrame, phase: number } } = {}
local function track(p: Instance)
	if p:IsA("BasePart") and p:GetAttribute("Kind") ~= "Junk" and p:GetAttribute("Kind") ~= "Snow" then tracked[p] = { base = p.CFrame, phase = math.random() * 6.28 } end
end
for _, p in ipairs(CollectionService:GetTagged("Item")) do track(p) end
CollectionService:GetInstanceAddedSignal("Item"):Connect(track)
CollectionService:GetInstanceRemovedSignal("Item"):Connect(function(p) tracked[p :: BasePart] = nil end)
local t = 0
RunService.Heartbeat:Connect(function(dt)
	t += dt
	local cam = workspace.CurrentCamera
	local camPos = cam and cam.CFrame.Position or Vector3.zero
	for p, info in pairs(tracked) do
		if not p.Parent then tracked[p] = nil; continue end
		-- seulement les objets proches (perf)
		if (info.base.Position - camPos).Magnitude > 140 then continue end
		local y = math.sin(t * 2 + info.phase) * 0.2
		p.CFrame = info.base * CFrame.new(0, y + 0.45, 0) * CFrame.Angles(0, t * 0.8 + info.phase, 0)
	end
end)

-- [ BARRIÈRES ] ---------------------------------------------------------------
local zonesFolder = map:WaitForChild("Zones")
local function refreshGates()
	local d = State.Data
	if not d then return end
	for _, zf in ipairs(zonesFolder:GetChildren()) do
		-- barrière de l'entrée + barrière de la sortie arrière (GateBack, invisible : on ne rentre pas par derrière)
		local back = zf:FindFirstChild("GateBack") :: BasePart?
		if back then back.CanCollide = d.Rebirths < ((back:GetAttribute("Rebirths") :: number?) or 0) end
		local gate = zf:FindFirstChild("Gate") :: BasePart?
		if not gate then continue end
		local req = gate:GetAttribute("Rebirths") or 0
		local open = d.Rebirths >= req
		gate.CanCollide = not open
		gate.Transparency = open and 1 or 0.35
		local label = gate:FindFirstChild("GateGui", true)
		local tl = label and label:FindFirstChild("Text") :: TextLabel?
		if tl then
			tl.Text = open and "" or (tostring(req) .. (req == 1 and " REBIRTH" or " REBIRTHS"))
		end
		for _, c in ipairs(gate:GetChildren()) do
			if c:IsA("BasePart") then c.Transparency = open and 1 or 0 end
		end
	end
end
State.On({ "Rebirths" }, refreshGates)

-- [ BANNIÈRE DE ZONE ] --------------------------------------------------------
local lastZone: string? = "hub"
task.spawn(function()
	while true do
		task.wait(0.4)
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart") :: BasePart?
		if root then
			local z = Zones.At(root.Position)
			local id = z and z.Id or "hub"
			if id ~= lastZone then
				lastZone = id
				if z and UI.Banner then
					local d = State.Data
					local locked = d and d.Rebirths < z.Rebirths
					local banner = UI.Banner :: any
					banner(string.upper(z.Name) .. (locked and " (LOCKED)" or ""), locked and ("Need " .. z.Rebirths .. (z.Rebirths == 1 and " rebirth" or " rebirths")) or ("Egg chance 1/" .. math.floor(1 / z.EggChance) .. " · ice x2"), z.Color)
				end
			end
		end
	end
end)

return true
