--!strict
-- StarterPlayerScripts/Client/MenusController
-- Petits menus : Upgrades, Rebirth, Index, Daily, Codes, Settings.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Lighting = game:GetService("Lighting")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Formulas = require(Shared.Util.Formulas)
local Upgrades = require(Shared.Config.Upgrades)
local Rebirth = require(Shared.Config.Rebirth)
local Planets = require(Shared.Config.Planets)
local Rarities = require(Shared.Config.Rarities)
local IndexRewards = require(Shared.Config.IndexRewards)
local DailyRewards = require(Shared.Config.DailyRewards)
local Galaxies = require(Shared.Config.Galaxies)
local Models = require(Shared.Visuals.Models)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local function content(name: string): Instance
	return UI.Panel(name):WaitForChild("Body"):WaitForChild("Content")
end

-- [ UPGRADES ] -------------------------------------------------------------------
do
	local c = content("Upgrades")
	local function effect(name: string, level: number): string
		local u = Upgrades[name]
		if name == "Luck" then return "x" .. string.format("%.2f", u.Value(level)) end
		if name == "Spawners" then return tostring(u.Value(level)) .. " spawners" end
		local pct = math.floor((1 - u.Value(level)) * 100 + 0.5)
		return pct == 0 and "Normal speed" or ("-" .. pct .. "% hatch time")
	end
	local function refresh()
		local lv = State.Data.Upgrades or {}
		local money = State.Data.Money or 0
		for _, name in ipairs({ "Luck", "Spawners", "HatchSpeed" }) do
			local row = c:FindFirstChild(name)
			if row then
				local u = Upgrades[name]
				local level = lv[name] or 0
				local cost = Formulas.UpgradeCost(name, level);
				(row:FindFirstChild("Level") :: TextLabel).Text = "LV " .. level .. "/" .. u.MaxLevel;
				(row:FindFirstChild("Effect") :: TextLabel).Text = cost and (effect(name, level) .. "  >  " .. effect(name, level + 1)) or effect(name, level)
				local buy = row:FindFirstChild("Buy") :: Frame
				UI.SetLabel(buy, cost and Format.Money(cost) or "MAX")
				local d = buy:FindFirstChild("Design") :: ImageLabel
				d.ImageColor3 = (cost and money >= cost) and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
			end
		end
	end
	for _, name in ipairs({ "Luck", "Spawners", "HatchSpeed" }) do
		local row = c:WaitForChild(name)
		UI.Button(row:WaitForChild("Buy"), function() State.Request("BuyUpgrade", name) end)
	end
	State.On("Upgrades", refresh)
	State.On("Money", function() if UI.IsOpen("Upgrades") then refresh() end end)
	UI.OnOpen("Upgrades", refresh)
end

-- [ REBIRTH ] --------------------------------------------------------------------
do
	local c = content("Rebirth")
	local function refresh()
		local r = State.Data.Rebirths or 0
		local money = State.Data.Money or 0
		local cost = Formulas.RebirthCost(r);
		(c:FindFirstChild("Before") :: TextLabel).Text = "x" .. Rebirth.Multiplier(r);
		(c:FindFirstChild("After") :: TextLabel).Text = "x" .. Rebirth.Multiplier(r + 1)
		local bar = c:FindFirstChild("Bar") :: Frame;
		(bar:FindFirstChild("Fill") :: Frame).Size = UDim2.fromScale(math.clamp(money / cost, 0, 1), 1);
		(bar:FindFirstChild("Label") :: TextLabel).Text = Format.Money(money) .. " / " .. Format.Money(cost)
		local doBtn = c:FindFirstChild("Do") :: Frame;
		(doBtn:FindFirstChild("Design") :: ImageLabel).ImageColor3 = money >= cost and Color3.new(1, 1, 1) or Color3.fromRGB(150, 150, 150)
		local bonus = Rebirth.BonusSlots(r + 1) > Rebirth.BonusSlots(r);
		(c:FindFirstChild("Info") :: TextLabel).Text = "Money multiplier forever" .. (bonus and " + 1 equip slot" or "") .. ".\nYour money resets. You KEEP your planets!"
	end
	UI.Button(c:WaitForChild("Do"), function() State.Request("Rebirth") end)
	State.On("Rebirths", refresh)
	State.On("Money", function() if UI.IsOpen("Rebirth") then refresh() end end)
	UI.OnOpen("Rebirth", refresh)
end

-- [ INDEX ] ----------------------------------------------------------------------
do
	local c = content("Index")
	local grid = c:WaitForChild("Grid") :: ScrollingFrame
	local template = grid:WaitForChild("Template") :: Frame
	local tabs = c:WaitForChild("Tabs")
	local current = "Common"
	local built: { Frame } = {}

	local function refresh()
		for _, f in ipairs(built) do f:Destroy() end
		table.clear(built)
		local index = State.Data.Index or {}
		local pool = Planets.ByRarity[current] or {}
		local found = 0
		for i, p in ipairs(pool) do
			local known = index[p.Id] == true
			if known then found += 1 end
			local card = template:Clone()
			card.Name = p.Id
			card.Visible = true
			card.LayoutOrder = i
			local design = card:FindFirstChild("Design") :: ImageLabel
			if known then UI.Tint(design, current, "ImageColor3") else design.ImageColor3 = Color3.fromRGB(90, 95, 110) end;
			(card:FindFirstChild("PlanetName") :: TextLabel).Text = known and p.Name or "???";
			(card:FindFirstChild("Income") :: TextLabel).Text = known and (Format.Money(p.Income) .. "/s") or "";
			(card:FindFirstChild("Unknown") :: TextLabel).Visible = not known
			local view = card:FindFirstChild("View") :: ViewportFrame
			if known then
				UI.Viewport(view, Models.Planet(p.Id, nil, 3), 0.5, 0.95)
			else
				-- silhouette noire
				local m = Models.Planet(p.Id, nil, 3)
				for _, d in ipairs(m:GetDescendants()) do
					if d:IsA("BasePart") then d.Color = Color3.new(0, 0, 0); d.Material = Enum.Material.SmoothPlastic end
					if d:IsA("ParticleEmitter") or d:IsA("Light") or d:IsA("Fire") then d:Destroy() end
				end
				UI.Viewport(view, m, 0, 0.95)
			end
			-- pastilles des mutations trouvées
			local muts = card:FindFirstChild("Mutations")
			if muts then
				for _, dot in ipairs(muts:GetChildren()) do
					if dot:IsA("Frame") then
						dot.BackgroundTransparency = index[p.Id .. ":" .. dot.Name] and 0 or 0.85
					end
				end
			end
			card.Parent = grid
			table.insert(built, card)
		end;
		(c:FindFirstChild("Progress") :: TextLabel).Text = found .. "/" .. #pool .. " DISCOVERED"
		local claim = c:FindFirstChild("Claim") :: Frame
		local claimed = (State.Data.IndexClaimed or {})[current]
		local bonus = IndexRewards.Bonus[current] or 0
		UI.SetLabel(claim, claimed and "CLAIMED" or ("CLAIM +" .. Format.Percent(bonus)));
		(claim:FindFirstChild("Design") :: ImageLabel).ImageColor3 = (not claimed and found == #pool) and Color3.new(1, 1, 1) or Color3.fromRGB(140, 140, 140)
		for _, t in ipairs(tabs:GetChildren()) do
			if t:IsA("Frame") then
				local d = t:FindFirstChild("Design") :: ImageLabel
				UI.Tint(d, t.Name, "ImageColor3")
				d.ImageTransparency = t.Name == current and 0 or 0.35
			end
		end
	end
	for _, t in ipairs(tabs:GetChildren()) do
		if t:IsA("Frame") then
			UI.Button(t, function()
				current = t.Name
				refresh()
			end)
		end
	end
	UI.Button(c:WaitForChild("Claim"), function() State.Request("ClaimIndex", current) end)
	State.On("Index", function() if UI.IsOpen("Index") then refresh() end end)
	State.On("IndexClaimed", function() if UI.IsOpen("Index") then refresh() end end)
	UI.OnOpen("Index", refresh)
end

-- [ DAILY ] ----------------------------------------------------------------------
do
	local c = content("Daily")
	local days = c:WaitForChild("Days")
	local COOLDOWN = 20 * 3600
	local function rewardText(r: any): string
		if r.Type == "Money" then return r.Minutes .. " min of $" end
		if r.Type == "Galaxy" then
			local g = Galaxies.ById[r.Galaxy]
			return g and g.Name or r.Galaxy
		end
		if r.Type == "Boost" then return "x2 " .. string.upper(r.Boost) end
		return ""
	end
	for i, r in ipairs(DailyRewards.Days) do
		local f = days:FindFirstChild("Day" .. i)
		if f then
			(f:FindFirstChild("Reward") :: TextLabel).Text = rewardText(r)
			if r.Type == "Galaxy" then
				local g = Galaxies.ById[r.Galaxy]
				if g then UI.Tint(f:FindFirstChild("Design") :: ImageLabel, g.Rarity, "ImageColor3") end
			end
		end
	end
	local function claimable(): (boolean, number)
		local d = State.Data.Daily or { Day = 0, Last = 0 }
		if d.Last == 0 then return true, 0 end
		local left = COOLDOWN - (State.Now() - d.Last)
		return left <= 0, left
	end
	local function refresh()
		local d = State.Data.Daily or { Day = 0, Last = 0 }
		local now = State.Now()
		local broken = d.Last > 0 and now - d.Last > DailyRewards.ResetAfterHours * 3600
		local doneDays = broken and 0 or d.Day
		local ok = claimable()
		-- après le jour 7 le cycle recommence
		if ok and doneDays >= #DailyRewards.Days then doneDays = 0 end
		for i = 1, #DailyRewards.Days do
			local f = days:FindFirstChild("Day" .. i)
			if f then
				(f:FindFirstChild("Done") :: TextLabel).Visible = i <= doneDays
				local pop = f:FindFirstChild("Design") :: ImageLabel
				pop.ImageTransparency = (i == doneDays + 1 and ok) and 0 or 0.3
			end
		end
	end
	task.spawn(function()
		while true do
			if UI.IsOpen("Daily") then
				local ok, left = claimable();
				(c:FindFirstChild("Timer") :: TextLabel).Text = ok and "Your reward is ready!" or ("Next reward in " .. Format.Time(left))
				UI.SetLabel(c:FindFirstChild("Claim") :: Frame, ok and "CLAIM" or "WAIT")
			end
			task.wait(1)
		end
	end)
	UI.Button(c:WaitForChild("Claim"), function() State.Request("ClaimDaily") end)
	State.On("Daily", refresh)
	UI.OnOpen("Daily", refresh)
	State.OnEvent("DailyClaimed", function(p)
		UI.Notify("Day " .. p.Day .. " reward: " .. p.Text .. "!", "success")
		UI.Play("Buy")
	end)
end

-- [ CODES ] ----------------------------------------------------------------------
do
	local c = content("Codes")
	local input = c:WaitForChild("Box"):WaitForChild("Input") :: TextBox
	local result = c:WaitForChild("Result") :: TextLabel
	local busy = false
	UI.Button(c:WaitForChild("Redeem"), function()
		if busy or input.Text == "" then return end
		busy = true
		result.Text = "..."
		local res = State.Invoke("Redeem", input.Text)
		busy = false
		if res and res.ok then
			result.TextColor3 = Color3.fromRGB(120, 255, 90)
			result.Text = res.msg
			input.Text = ""
			UI.Play("Buy")
		else
			result.TextColor3 = Color3.fromRGB(255, 90, 90)
			result.Text = res and res.msg or "Error"
		end
	end)
end

-- [ SETTINGS ] -------------------------------------------------------------------
do
	local c = content("Settings")
	local function apply()
		local s = State.Data.Settings or {}
		for _, key in ipairs({ "Music", "Sfx", "LowGfx", "AutoHatch" }) do
			local row = c:FindFirstChild(key)
			if row then
				local on = s[key] ~= false
				if key == "LowGfx" then on = s[key] == true end
				local t = row:FindFirstChild("Toggle") :: Frame
				UI.SetLabel(t, on and "ON" or "OFF");
				(t:FindFirstChild("Design") :: ImageLabel).Image = on and "rbxassetid://118147684330981" or "rbxassetid://139238474736040"
			end
		end
		UI.SfxEnabled = s.Sfx ~= false
		local music = game:GetService("SoundService"):FindFirstChild("Music")
		if music and music:IsA("Sound") then music.Volume = s.Music == false and 0 or 0.35 end
		-- graphismes légers : coupe les effets de lumière
		local low = s.LowGfx == true
		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("BloomEffect") or e:IsA("ColorCorrectionEffect") then e.Enabled = not low end
		end
	end
	for _, key in ipairs({ "Music", "Sfx", "LowGfx", "AutoHatch" }) do
		local row = c:WaitForChild(key)
		UI.Button(row:WaitForChild("Toggle"), function()
			local s = State.Data.Settings or {}
			local cur = if key == "LowGfx" then s[key] == true else s[key] ~= false
			State.Request("Setting", key, not cur)
		end)
	end
	State.On("Settings", apply)
end

-- [ PANNEAUX OUVERTS PAR LES STANDS DU HUB / LE PANNEAU DE LA BASE ] -------------
ProximityPromptService.PromptTriggered:Connect(function(prompt)
	local opens = prompt:GetAttribute("Opens")
	if type(opens) ~= "string" then return end
	if opens == "Sell" then
		UI.Open("Planets")
	else
		UI.Open(opens)
	end
end)

local _ = Rarities
return {}
