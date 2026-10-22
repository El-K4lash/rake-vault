--!strict
-- Client/BaseController : menu Base = inventaire de brainrots. Onglets All / Equipped / Unequipped.
-- Clic sur une carte : équipe / retire. Bouton SELL (avec confirmation) sur chaque carte. EQUIP BEST.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Brainrots = require(Shared.Config.Brainrots)
local Mutations = require(Shared.Config.Mutations)
local Rebirth = require(Shared.Config.Rebirth)
local Items = require(Shared.Config.Items)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Base = UI.Frames:WaitForChild("Base") :: Frame
local Scrolling = Base:WaitForChild("Scrolling") :: ScrollingFrame
local Buttons = Base:WaitForChild("Buttons") :: Frame
local Progress = Base:WaitForChild("Progress") :: Frame
local Total = Base:WaitForChild("Total") :: TextLabel
local Best = Base:WaitForChild("IndexReward") :: TextButton
local tpl = UI.Templates:WaitForChild("BaseTemplate") :: Frame
local assets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Brainrots")

UI.HookClose(Base)
local tab = "All"
local cards: { [string]: Frame } = {}
local pendingSell: string? = nil

local function moneyMult(d: any): number
	return Rebirth.Mult(d.Rebirths) * (1 + math.min(d.Runes.Income or 0, Items.RuneCaps.Income))
end

local function refresh()
	local d = State.Data
	if not d then return end
	-- liste triée par revenu
	local list = {}
	local used = 0
	local income = 0
	for uid, e in pairs(d.Brainrots) do
		local br = Brainrots.ById[e.Id]
		if not br then continue end
		local mut = Mutations.ById[e.Mut] or Mutations.ById.Normal
		local inc = br.Income * mut.Mult * moneyMult(d)
		if e.Slot and e.Slot > 0 then used += 1; income += inc end
		table.insert(list, { uid = uid, e = e, br = br, mut = mut, inc = inc })
	end
	table.sort(list, function(a, b) return a.inc > b.inc end)
	local keep: { [string]: boolean } = {}
	for i, it in ipairs(list) do
		local equipped = it.e.Slot and it.e.Slot > 0
		if (tab == "Equipped" and not equipped) or (tab == "Unequipped" and equipped) then continue end
		keep[it.uid] = true
		local c = cards[it.uid]
		if not c then
			c = tpl:Clone()
			c.Name = it.uid
			c.Visible = true
			local vp = c:FindFirstChild("View") :: ViewportFrame?
			local folder = assets:FindFirstChild(it.mut.Folder) or assets:FindFirstChild("Normal")
			local model = folder and folder:FindFirstChild(it.br.Id) :: Model?
			if vp then task.defer(UI.ShowModel, vp, model, false) end
			local click = c:FindFirstChild("Click") :: GuiButton?
			if click then
				UI.Button(click, function()
					local e = State.Data.Brainrots[it.uid]
					if not e then return end
					State.Send(e.Slot and e.Slot > 0 and "Unequip" or "Equip", it.uid)
				end)
			end
			local sell = c:FindFirstChild("Sell") :: GuiButton?
			if sell then
				UI.Button(sell, function()
					if pendingSell == it.uid then
						State.Send("SellBrainrot", it.uid)
						pendingSell = nil
					else
						pendingSell = it.uid
						UI.SetText(sell, "Label", "SURE?")
						task.delay(3, function()
							if pendingSell == it.uid then pendingSell = nil; refresh() end
						end)
					end
				end)
			end
			c.Parent = Scrolling
			cards[it.uid] = c
		end
		c.LayoutOrder = i
		local r = Brainrots.RarityById[it.br.Rarity]
		UI.SetText(c, "Name", it.br.Id)
		UI.SetText(c, "Income", "$" .. Format.Num(it.inc) .. "/s")
		local tag = c:FindFirstChild("Tag") :: Frame
		UI.SetText(tag, "Text", it.mut.Id ~= "Normal" and (string.upper(it.mut.Name) .. " " .. string.upper(it.br.Rarity)) or string.upper(it.br.Rarity))
		tag.BackgroundColor3 = it.mut.Id ~= "Normal" and it.mut.Color or r.Color
		local eqLabel = c:FindFirstChild("Equipped") :: GuiObject?
		if eqLabel then eqLabel.Visible = false end
		local badge = c:FindFirstChild("Badge") :: GuiObject?
		if badge then badge.Visible = equipped == true end
		local stroke = c:FindFirstChild("Stroke") :: UIStroke?
		if stroke then stroke.Color = equipped and Color3.fromRGB(120, 255, 140) or Color3.new(0, 0, 0); stroke.Thickness = equipped and 4 or 2 end
		local sell = c:FindFirstChild("Sell") :: GuiButton?
		if sell then
			local price = math.floor(it.br.Income * it.mut.Mult * r.SellMult)
			UI.SetText(sell, "Label", pendingSell == it.uid and "SURE?" or ("SELL " .. Format.Money(price)))
		end
	end
	for uid, c in pairs(cards) do
		if not keep[uid] then c:Destroy(); cards[uid] = nil end
	end
	local fill = Progress:FindFirstChild("Fill") :: Frame
	fill.Size = UDim2.fromScale(0.98 * (d.Slots > 0 and math.min(1, used / d.Slots) or 0), 0.76); fill.Visible = used > 0
	UI.SetText(Progress, "Text", string.format("%d / %d SLOTS", used, d.Slots))
	Total.Text = "PEN INCOME  " .. Format.Money(income) .. "/s   ·   " .. tostring(#list) .. " BRAINROTS"
end

for _, b in ipairs(Buttons:GetChildren()) do
	if b:IsA("GuiButton") then
		UI.Button(b, function()
			tab = b.Name
			for _, c in pairs(cards) do c:Destroy() end
			cards = {}
			refresh()
		end)
	end
end
UI.Button(Best, function() State.Send("EquipBest") end)

State.On({ "Brainrots", "Slots", "Rebirths", "Runes" }, refresh)
UI.Opened.Event:Connect(function(n) if n == "Base" then refresh() end end)

return true
