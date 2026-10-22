--!strict
-- Client/ShopController : menu Shop (onglets Upgrades / Codes). 3 cartes : râteau, sac, slot de base.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Upgrades = require(Shared.Config.Upgrades)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Shop = UI.Frames:WaitForChild("Shop") :: Frame
local Scrolling = Shop:WaitForChild("Scrolling") :: ScrollingFrame
local Row = Scrolling:WaitForChild("UpgradesRow") :: Frame
local FencesRow = Scrolling:FindFirstChild("FencesRow") :: Frame?

UI.HookClose(Shop)

local assets = ReplicatedStorage:WaitForChild("Assets")

local function card(name: string): Frame
	return Row:WaitForChild(name) :: Frame
end

local function fillCard(c: Frame, title: string, desc: string, price: number?, model: Model?)
	UI.SetText(c, "Amount", title)
	UI.SetText(c, "Desc", desc)
	local buy = c:FindFirstChild("Buy") :: GuiButton
	local label = buy:FindFirstChild("Label") :: TextLabel
	if price == nil then
		label.Text = "MAX"
	elseif price == 0 then
		label.Text = "OWNED"
	else
		label.Text = Format.Money(price)
		local money = State.Data and State.Data.Money or 0
		label.TextColor3 = money >= price and Color3.new(1, 1, 1) or Color3.fromRGB(255, 120, 120)
	end
	local vp = c:FindFirstChild("View", true) :: ViewportFrame?
	if vp and model and vp:GetAttribute("Shown") ~= model.Name then
		vp:SetAttribute("Shown", model.Name)
		UI.ShowModel(vp, model, true)
	end
end

local function refresh()
	local d = State.Data
	if not d then return end
	-- râteau
	local nextR = Upgrades.Rakes[d.Rake + 1]
	local curR = Upgrades.Rakes[math.clamp(d.Rake, 1, #Upgrades.Rakes)]
	local rakeModel = assets:FindFirstChild("RakeModels") and assets.RakeModels:FindFirstChild("Rake" .. (nextR and d.Rake + 1 or d.Rake)) :: Model?
	if nextR then
		fillCard(card("RakeCard"), nextR.Name, string.format("%d items/swing · %d studs", nextR.Value, nextR.Value2), nextR.Price, rakeModel)
	else
		fillCard(card("RakeCard"), curR.Name, string.format("%d items/swing · %d studs", curR.Value, curR.Value2), nil, rakeModel)
	end
	-- sac
	local nextB = Upgrades.Bags[d.Bag + 1]
	local curB = Upgrades.Bags[math.clamp(d.Bag, 1, #Upgrades.Bags)]
	local bagModel = assets:FindFirstChild("Bags") and assets.Bags:FindFirstChild("Bag" .. (nextB and d.Bag + 1 or d.Bag)) :: Model?
	if nextB then
		fillCard(card("BagCard"), nextB.Name, "Capacity " .. nextB.Value, nextB.Price, bagModel)
	else
		fillCard(card("BagCard"), curB.Name, "Capacity " .. curB.Value, nil, bagModel)
	end
	-- slot
	local n = d.Slots + 1
	local slotModel = assets:FindFirstChild("Bags") and assets.Bags:FindFirstChild("Slot") :: Model?
	if n <= Upgrades.MaxSlots then
		fillCard(card("SlotCard"), "Pen slot " .. n, "Bigger pen · +1 brainrot or egg", Upgrades.SlotPrices[n] or 0, slotModel)
	else
		fillCard(card("SlotCard"), "Pen slots", "All " .. Upgrades.MaxSlots .. " slots unlocked", nil, slotModel)
	end
end

UI.Button(card("RakeCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuyRake") end)
UI.Button(card("BagCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuyBag") end)
UI.Button(card("SlotCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuySlot") end)

State.On({ "Money", "Rake", "Bag", "Slots" }, refresh)
UI.Opened.Event:Connect(function(n) if n == "Shop" then refresh() end end)

-- clôtures de l'enclos (achat puis équipement)
local fenceCards: { [string]: ImageLabel } = {}
if FencesRow then
	local tpl = UI.Templates:WaitForChild("FenceTemplate") :: ImageLabel
	for _, f in ipairs(Upgrades.FenceStyles) do
		local c = tpl:Clone()
		c.Name = f.Id
		c.LayoutOrder = f.Order
		c.Visible = true
		UI.SetText(c, "Name", f.Name)
		local sw = c:FindFirstChild("Swatch") :: Frame
		sw.BackgroundColor3 = f.Accent
		for _, r in ipairs(sw:GetChildren()) do
			if r:IsA("Frame") and r.Name:sub(1, 4) == "Rail" then r.BackgroundColor3 = f.Rail end
			if r:IsA("Frame") and r.Name:sub(1, 4) == "Post" and f.Post then r.BackgroundColor3 = f.Post end
		end
		if f.Rainbow then
			local g = Instance.new("UIGradient")
			g.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)), ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 220, 60)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 120)), ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 160, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 90, 255)),
			})
			g.Parent = sw
		end
		c.Parent = FencesRow
		fenceCards[f.Id] = c
		UI.Button(c:WaitForChild("Buy") :: GuiButton, function() State.Send("BuyFence", f.Id) end)
	end
end
local function refreshFences()
	local d = State.Data
	if not d then return end
	for id, c in pairs(fenceCards) do
		local f = Upgrades.FenceById[id]
		local label = c:FindFirstChild("Label", true) :: TextLabel
		if d.Fence == id then
			label.Text = "EQUIPPED"; label.TextColor3 = Color3.fromRGB(150, 255, 120)
		elseif d.Fences and d.Fences[id] then
			label.Text = "EQUIP"; label.TextColor3 = Color3.new(1, 1, 1)
		else
			label.Text = Format.Money(f.Price)
			label.TextColor3 = (d.Money >= f.Price) and Color3.new(1, 1, 1) or Color3.fromRGB(255, 120, 120)
		end
		c.ImageColor3 = d.Fence == id and Color3.fromRGB(70, 120, 80) or Color3.fromRGB(70, 74, 92)
	end
end
State.On({ "Money", "Fence", "Fences" }, refreshFences)
UI.Opened.Event:Connect(function(n) if n == "Shop" then refreshFences() end end)

-- codes (fenêtre séparée)
local Codes = UI.Frames:WaitForChild("Codes") :: Frame
UI.HookClose(Codes)
local input = Codes:WaitForChild("InputBar"):WaitForChild("Input") :: TextBox
local redeem = Codes:WaitForChild("Redeem") :: GuiButton
UI.Button(redeem, function()
	local code = input.Text
	if #code == 0 then return end
	local res = State.Ask("Redeem", code)
	if type(res) == "table" then
		State.Notify:Fire(res.msg or "", res.ok and "success" or "error")
		if res.ok then input.Text = "" end
	end
end)

return true
