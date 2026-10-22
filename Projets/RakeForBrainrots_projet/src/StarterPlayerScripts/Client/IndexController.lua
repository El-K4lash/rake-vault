--!strict
-- Client/IndexController : menu Index (onglets = mutations), cartes 3D, progression, bonus de zone.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Brainrots = require(Shared.Config.Brainrots)
local Mutations = require(Shared.Config.Mutations)
local Zones = require(Shared.Config.Zones)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Index = UI.Frames:WaitForChild("Index") :: Frame
local Scrolling = Index:WaitForChild("Scrolling") :: ScrollingFrame
local Buttons = Index:WaitForChild("Buttons") :: Frame
local Progress = Index:WaitForChild("Progress") :: Frame
local Total = Index:WaitForChild("Total") :: TextLabel
local Reward = Index:WaitForChild("IndexReward") :: TextButton
local tpl = UI.Templates:WaitForChild("IndexTemplate") :: Frame
local assets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Brainrots")

UI.HookClose(Index)
local tab = "Normal"
local cards: { [string]: Frame } = {}

local function key(id: string, mut: string): string
	return mut == "Normal" and id or (id .. ":" .. mut)
end

local function build()
	for _, c in pairs(cards) do c:Destroy() end
	cards = {}
	local mut = Mutations.ById[tab]
	local folder = assets:FindFirstChild(mut.Folder) or assets:FindFirstChild("Normal")
	for i, br in ipairs(Brainrots.List) do
		local c = tpl:Clone()
		c.Name = br.Id
		c.LayoutOrder = i
		c.Visible = true
		local r = Brainrots.RarityById[br.Rarity]
		UI.SetText(c, "Name", br.Id)
		UI.SetText(c, "Income", "$" .. Format.Num(br.Income * mut.Mult) .. "/s")
		local tag = c:FindFirstChild("Tag") :: Frame
		UI.SetText(tag, "Text", string.upper(br.Rarity))
		tag.BackgroundColor3 = r.Color
		local vp = c:FindFirstChild("View") :: ViewportFrame?
		c.Parent = Scrolling
		cards[br.Id] = c
		local model = folder and folder:FindFirstChild(br.Id) :: Model?
		if vp then task.defer(UI.ShowModel, vp, model, false) end
	end
end

local function refresh()
	local d = State.Data
	if not d then return end
	local found, total = 0, 0
	for _, br in ipairs(Brainrots.List) do
		local c = cards[br.Id]
		if not c then continue end
		local has = d.Index[key(br.Id, tab)] == true
		total += 1
		if has then found += 1 end
		local vp = c:FindFirstChild("View") :: ViewportFrame?
		local unknown = c:FindFirstChild("Unknown") :: TextLabel?
		if vp then vp.ImageTransparency = has and 0 or 0.85; vp.ImageColor3 = has and Color3.new(1, 1, 1) or Color3.new(0, 0, 0) end
		if unknown then unknown.Visible = not has end
		local nameL = c:FindFirstChild("Name", true) :: TextLabel?
		if nameL then nameL.Text = has and br.Id or "???" end
	end
	local fill = Progress:FindFirstChild("Fill") :: Frame
	fill.Size = UDim2.fromScale(0.98 * (total > 0 and found / total or 0), 0.76); fill.Visible = found > 0
	UI.SetText(Progress, "Text", string.format("%d / %d DISCOVERED", found, total))
	-- collection totale toutes mutations
	local all, allTotal = 0, 0
	for _, br in ipairs(Brainrots.List) do
		for _, m in ipairs(Mutations.List) do
			allTotal += 1
			if d.Index[key(br.Id, m.Id)] then all += 1 end
		end
	end
	Total.Text = string.format("COLLECTION  %d / %d  (%d%%)", all, allTotal, math.floor(all / allTotal * 100))
	-- bonus de zone : première zone complète non réclamée
	local claimable: string? = nil
	local nextZone: string? = nil
	for _, z in ipairs(Zones.List) do
		if d.IndexClaimed[z.Id] then continue end
		local ok = true
		for _, br in ipairs(Brainrots.List) do
			if br.Zone == z.Id and not d.Index[br.Id] then ok = false; break end
		end
		if ok then claimable = z.Id; break end
		if not nextZone then nextZone = z.Id end
	end
	Reward:SetAttribute("Zone", claimable)
	UI.SetText(Reward, "Top", claimable and "CLAIM REWARD!" or (string.upper(nextZone or "") .. " REWARD"))
	UI.SetText(Reward, "Label", "+5% LUCK")
end

for _, b in ipairs(Buttons:GetChildren()) do
	if b:IsA("GuiButton") then
		UI.Button(b, function()
			tab = b.Name
			build()
			refresh()
		end)
	end
end
UI.Button(Reward, function()
	local z = Reward:GetAttribute("Zone")
	if z then State.Send("ClaimIndex", z) end
end)

build()
State.On({ "Index", "IndexClaimed" }, refresh)
UI.Opened.Event:Connect(function(n) if n == "Index" then refresh() end end)

return true
