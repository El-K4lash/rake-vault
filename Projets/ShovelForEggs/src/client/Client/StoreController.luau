--!strict
-- Client/StoreController : boutique Robux (bouton "Shop" du HUD -> frame Store, copiée du RobuxShop de Steal an Egg).
-- Chaque bouton d'achat porte l'attribut StoreKey (Config/Store). Id = 0 -> "Coming soon".
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Store = require(Shared.Config.Store)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local Frame = UI.Frames:WaitForChild("Store") :: GuiObject
local Scrolling = Frame:WaitForChild("ScrollingFrame") :: ScrollingFrame
UI.HookClose(Frame :: any)

-- achats
local buttons: { [string]: GuiButton } = {}
for _, d in ipairs(Frame:GetDescendants()) do
	local key = d:GetAttribute("StoreKey")
	if d:IsA("GuiButton") and type(key) == "string" then
		buttons[key] = d
		UI.Button(d, function()
			local p = Store.ByKey[key]
			if not p then return end
			if p.Id <= 0 then
				State.Notify:Fire("Coming soon!", "info")
				return
			end
			local isPass = false
			for _, ps in ipairs(Store.Passes) do if ps == p then isPass = true end end
			if isPass then
				if State.Data and State.Data.Passes and State.Data.Passes[key] then return end
				MarketplaceService:PromptGamePassPurchase(player, p.Id)
			else
				MarketplaceService:PromptProductPurchase(player, p.Id)
			end
		end)
	end
end

-- passes déjà possédés
local function refreshPasses()
	local owned = State.Data and State.Data.Passes or {}
	for _, p in ipairs(Store.Passes) do
		local b = buttons[p.Key]
		local pr = b and b:FindFirstChild("Price", true) :: TextLabel?
		local ic = b and b:FindFirstChild("RobuxIcon", true) :: ImageLabel?
		if pr then
			pr.Text = owned[p.Key] and "OWNED" or tostring(p.Price)
			pr.Size = UDim2.fromScale(0.62 * math.max(#pr.Text, 2), 1)
		end
		if ic then ic.Visible = not owned[p.Key] end
	end
end
State.On({ "Passes" }, refreshPasses)

-- œufs en 3D dans les cartes
local eggAssets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Eggs")
local brAssets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Pets"):WaitForChild("Normal")
local shown = false
local function fillViews()
	if shown then return end
	shown = true
	-- pets du pack : cadrés plus serré (ils paraissaient minuscules), encore plus dans la grande case
	local biggest = 0
	for _, d in ipairs(Scrolling:GetDescendants()) do
		if d:IsA("ViewportFrame") and d:GetAttribute("Pet") then biggest = math.max(biggest, d.AbsoluteSize.X) end
	end
	for _, d in ipairs(Scrolling:GetDescendants()) do
		if d:IsA("ViewportFrame") and d:GetAttribute("Egg") then
			UI.ShowModel(d, eggAssets:FindFirstChild(d:GetAttribute("Egg") :: string) :: Model?, true)
		elseif d:IsA("ViewportFrame") and d:GetAttribute("Pet") then
			local big = biggest > 0 and d.AbsoluteSize.X >= biggest - 1
			UI.ShowModel(d, brAssets:FindFirstChild(d:GetAttribute("Pet") :: string) :: Model?, false, big and 0.92 or 0.9)
		end
	end
end

-- minuteur de l'offre limitée (jusqu'à minuit UTC) + reflet animé du nom
local limited = Scrolling:FindFirstChild("LimitedEgg")
local timer = limited and limited:FindFirstChild("Title", true) :: TextLabel?
local eggName = limited and limited:FindFirstChild("EggName", true) :: TextLabel?
local grad = eggName and eggName:FindFirstChildOfClass("UIGradient")
local acc = 0
RunService.Heartbeat:Connect(function(dt)
	if not (Frame :: GuiObject).Visible then return end
	if grad then grad.Offset = Vector2.new(((os.clock() * 0.6) % 2) - 1, 0) end
	acc += dt
	if acc < 0.5 then return end
	acc = 0
	if timer then
		local left = 86400 - (math.floor(workspace:GetServerTimeNow()) % 86400)
		timer.Text = string.format("%02d:%02d:%02d", left // 3600, (left % 3600) // 60, left % 60)
	end
end)

UI.Opened.Event:Connect(function(n)
	if n == "Store" then fillViews(); refreshPasses() end
end)

return true
