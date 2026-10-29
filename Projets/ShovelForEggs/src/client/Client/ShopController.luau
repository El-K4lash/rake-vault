--!strict
-- Client/ShopController : menu Shop (onglets Upgrades / Codes). 3 cartes : pelle, luge, slot du chalet + clôtures.
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
		UI.ShowModel(vp, model, true, 0.9)
	end
end

local function refresh()
	local d = State.Data
	if not d then return end
	-- pelle
	local nextR = Upgrades.Shovels[d.Shovel + 1]
	local curR = Upgrades.Shovels[math.clamp(d.Shovel, 1, #Upgrades.Shovels)]
	local shovelModel = assets:FindFirstChild("ShovelModels") and assets.ShovelModels:FindFirstChild("Shovel" .. (nextR and d.Shovel + 1 or d.Shovel)) :: Model?
	if nextR then
		fillCard(card("ShovelCard"), nextR.Name, string.format("%d snow/dig · %d studs", nextR.Value, nextR.Value2), nextR.Price, shovelModel)
	else
		fillCard(card("ShovelCard"), curR.Name, string.format("%d snow/dig · %d studs", curR.Value, curR.Value2), nil, shovelModel)
	end
	-- luge
	local nextB = Upgrades.Sleds[d.Sled + 1]
	local curB = Upgrades.Sleds[math.clamp(d.Sled, 1, #Upgrades.Sleds)]
	local sledModel = assets:FindFirstChild("Sleds") and assets.Sleds:FindFirstChild("Sled" .. (nextB and d.Sled + 1 or d.Sled)) :: Model?
	if nextB then
		fillCard(card("SledCard"), nextB.Name, "Capacity " .. nextB.Value, nextB.Price, sledModel)
	else
		fillCard(card("SledCard"), curB.Name, "Capacity " .. curB.Value, nil, sledModel)
	end
	-- slot
	local n = d.Slots + 1
	local slotModel = assets:FindFirstChild("Sleds") and assets.Sleds:FindFirstChild("Slot") :: Model?
	if n <= Upgrades.MaxSlots then
		fillCard(card("SlotCard"), "Chalet slot " .. n, "Bigger chalet · room for +1 pet or egg", Upgrades.SlotPrices[n] or 0, slotModel)
	else
		fillCard(card("SlotCard"), "Chalet slots", "All " .. Upgrades.MaxSlots .. " slots unlocked", nil, slotModel)
	end
	-- hatch slots : œufs qui éclosent en même temps (ancien "Egg Slots" du panneau de l'enclos, remis à zéro au rebirth)
	local hu = Upgrades.BaseUpgradeById.EggSlots
	local hl = (d.Up and d.Up.EggSlots) or 0
	local bonus = (d.Passes and d.Passes.TripleEgg) and 3 or 0
	local eggModel = assets:FindFirstChild("Eggs") and assets.Eggs:FindFirstChild("Frozen") :: Model?
	if hl < hu.Max then
		fillCard(card("HatchSlotCard"), "Hatch slot " .. (hu.Value(hl + 1) + bonus),
			(hu.Value(hl) + bonus) .. " > " .. (hu.Value(hl + 1) + bonus) .. " eggs hatching at once", Upgrades.UpgradeCost(hu, hl, d.Rebirths), eggModel)
	else
		fillCard(card("HatchSlotCard"), "Hatch slots", (hu.Value(hl) + bonus) .. " eggs hatching at once", nil, eggModel)
	end
end

UI.Button(card("ShovelCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuyShovel") end)
UI.Button(card("SledCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuySled") end)
UI.Button(card("SlotCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuySlot") end)
UI.Button(card("HatchSlotCard"):WaitForChild("Buy") :: GuiButton, function() State.Send("BuyUpgrade", "EggSlots") end)

State.On({ "Money", "Shovel", "Sled", "Slots", "Up", "Passes", "Rebirths" }, refresh)
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
-- même saisie de code dans la fenêtre Codes et en bas du Store Robux (section Codes)
local function hookCodes(root: Instance)
	local input = root:WaitForChild("InputBar"):WaitForChild("Input") :: TextBox
	local redeem = root:WaitForChild("Redeem") :: GuiButton
	local basePh, baseCol = input.PlaceholderText, input.PlaceholderColor3
	local token = 0
	-- résultat affiché dans la barre de saisie (vert = gagné, rouge = erreur), pas de notif en double
	local function feedback(msg: string, ok: boolean)
		token += 1
		local my = token
		input.Text = ""
		input.PlaceholderText = msg
		input.PlaceholderColor3 = ok and Color3.fromRGB(120, 255, 140) or Color3.fromRGB(255, 100, 100)
		if not ok then UI.Play("Error", 0.5) end
		task.delay(3.5, function()
			if token == my then input.PlaceholderText = basePh; input.PlaceholderColor3 = baseCol end
		end)
	end
	local busy = false
	UI.Button(redeem, function()
		local code = input.Text
		if #code == 0 then feedback("Enter a code first", false) return end
		if busy then return end
		busy = true
		local res = State.Ask("Redeem", code)
		busy = false
		if type(res) == "table" then
			feedback(res.msg or "", res.ok == true)
		else
			feedback("Too fast, try again", false)
		end
	end)
end
hookCodes(Codes)
local storeCodes = UI.Frames:WaitForChild("Store"):WaitForChild("ScrollingFrame"):FindFirstChild("Codes")
if storeCodes then hookCodes(storeCodes:WaitForChild("Card")) end

return true
