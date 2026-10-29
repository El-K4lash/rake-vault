--!strict
-- Client/RewardsController : tout ce qui fait revenir le joueur (affichage seulement, le serveur décide).
--   * HUD.Right : boutons Advent / Quests / Pass / Starter + pastilles "!" quand il y a quelque chose à réclamer
--   * Frames.Advent  : calendrier (portes, cadenas, jour en surbrillance, guirlande qui clignote)
--   * Frames.Quests  : 3 quêtes du jour + bonus + minuteur
--   * Frames.Pass    : Winter Pass (palier, barre d'XP, piste gratuite / premium)
--   * Frames.Starter : offre de départ (rayons qui tournent)
--   * Frames.Offline : gains hors ligne (récupérer / x2 en Robux)
--   * Frames.EggSkip : éclore un œuf tout de suite (argent ou Robux)
--   * HUD.Combo      : compteur de combo de creusage
--   * coffre gelé    : explosion de lumière + bannière
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = require(Shared.Config.Events)
local Store = require(Shared.Config.Store)
local Eggs = require(Shared.Config.Eggs)
local Format = require(Shared.Util.Format)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local Right = UI.HUD:WaitForChild("Right") :: Frame
local ComboHud = UI.HUD:WaitForChild("Combo") :: Frame
local F = {
	Advent = UI.Frames:WaitForChild("Advent") :: Frame,
	Quests = UI.Frames:WaitForChild("Quests") :: Frame,
	Pass = UI.Frames:WaitForChild("Pass") :: Frame,
	Starter = UI.Frames:WaitForChild("Starter") :: Frame,
	Offline = UI.Frames:WaitForChild("Offline") :: Frame,
	EggSkip = UI.Frames:WaitForChild("EggSkip") :: Frame,
	GiftSkip = UI.Frames:WaitForChild("GiftSkip") :: Frame,
}
for _, f in pairs(F) do UI.HookClose(f :: any) end

local GREEN, GOLD, GREY, WHITE = Color3.fromRGB(80, 220, 110), Color3.fromRGB(255, 214, 74), Color3.fromRGB(150, 150, 165), Color3.new(1, 1, 1)
local info: any = nil -- textes des récompenses (RewardsInfo)
local infoAt = 0
local starterOffered = false

-- [ OUTILS ] ---------------------------------------------------------------------------
local function fetchInfo(force: boolean?)
	if not force and info and os.clock() - infoAt < 20 then return info end
	local ok, r = pcall(State.Ask, "RewardsInfo")
	if ok and r then info = r; infoAt = os.clock() end
	return info
end

local function prompt(key: string)
	local p = Store.ByKey[key]
	if not p or p.Id <= 0 then State.Notify:Fire("Coming soon!", "info"); return end
	local isPass = false
	for _, ps in ipairs(Store.Passes) do if ps == p then isPass = true end end
	if isPass then MarketplaceService:PromptGamePassPurchase(player, p.Id)
	else MarketplaceService:PromptProductPurchase(player, p.Id) end
end

local function result(r: any)
	if not r then return end
	if r.msg then State.Notify:Fire(r.msg, r.ok and "success" or "error") end
	if r.ok then UI.Play("LevelUp", 0.45) end
end

local function setBadge(name: string, on: boolean)
	local b = Right:FindFirstChild(name)
	local badge = b and b:FindFirstChild("Badge") :: GuiObject?
	if badge then badge.Visible = on end
end

local function tierOf(xp: number): (number, number, number)
	local t, left = 0, xp
	while t < #Events.Pass.Tiers do
		local need = Events.Pass.TierXP(t + 1)
		if left < need then return t, left, need end
		left -= need
		t += 1
	end
	return t, 0, 0
end

local function setBar(bar: Instance?, have: number, need: number, text: string?)
	if not bar then return end
	local fill = bar:FindFirstChild("Progress") :: GuiObject?
	local t = bar:FindFirstChild("Text") :: TextLabel?
	local k = need > 0 and math.clamp(have / need, 0, 1) or 1
	if fill then fill.Size = UDim2.fromScale(math.max(0.03, 0.976 * k), 0.8) end
	if t then t.Text = text or (Format.Num(have) .. " / " .. Format.Num(need)) end
end

-- icônes (pack SimulatorIcons + interfaces de jeux du vault)
local ICON = {
	Gift = "rbxassetid://13300725267", Coins = "rbxassetid://6931971923", Egg = "rbxassetid://2780804053",
	Star = "rbxassetid://12567645366", Clover = "rbxassetid://8613002294", MoneyX2 = "rbxassetid://116101397751784",
	Diamond = "rbxassetid://6127935575", Santa = "rbxassetid://11743433084", Pickaxe = "rbxassetid://14995858763",
	Clock = "rbxassetid://13873482402", Bolt = "rbxassetid://87193340664010", ChestPink = "rbxassetid://6931963096",
	Candy = "rbxassetid://83551971485687",
}
-- icônes des récompenses (kit K4 du vault, même style que le HUD)
local RICON = {
	Money = "rbxassetid://75469857672333", Egg = "rbxassetid://90244402268300", Clover = "rbxassetid://83475440458968",
	MoneyX2 = "rbxassetid://116101397751784", Speed = "rbxassetid://85473564227225", Star = "rbxassetid://12567645366",
	Gift = "rbxassetid://112101874744840",
}
local function rewardIcon(r: any): string
	if not r then return RICON.Gift end
	if r.Kind == "Money" then return RICON.Money end
	if r.Kind == "Egg" or r.Kind == "BestEgg" then return RICON.Egg end
	if r.Kind == "Boost" then return r.Stat == "Luck" and RICON.Clover or RICON.MoneyX2 end
	if r.Kind == "Charm" then return (r.Stat == "Luck" and RICON.Clover) or (r.Stat == "Speed" and RICON.Speed) or RICON.MoneyX2 end
	if r.Kind == "XP" then return RICON.Star end
	return RICON.Gift
end
-- modèle 3D à montrer à la place de l'image : l'œuf exact (nom lu dans le texte pour "meilleur œuf"),
-- ou un pet en silhouette (pet mystère de la rareté donnée)
local PETS = require(Shared.Config.Pets)
local function rewardModel(r: any, text: string?): (Model?, boolean)
	if not r then return nil, false end
	local folder = ReplicatedStorage.Assets
	if r.Kind == "Egg" or r.Kind == "BestEgg" then
		local def = r.Egg and Eggs.ById[r.Egg]
		if not def and text then
			for _, e in ipairs(Eggs.List) do if string.find(text, e.Name, 1, true) then def = e end end
		end
		return def and folder.Eggs:FindFirstChild(def.Model) :: Model? or nil, false
	end
	if r.Kind == "Pet" then
		local list = PETS.ByRarity and PETS.ByRarity[r.Rarity]
		local p = list and list[#list]
		local id = p and (type(p) == "table" and (p.Id or p.Name) or p)
		return id and folder.Pets.Normal:FindFirstChild(tostring(id)) :: Model? or nil, true
	end
	return nil, false
end
-- remplit une IconBox (Icon + View 3D + "?")
local function setReward(box: Instance?, r: any, text: string?)
	if not box then return end
	local ic = box:FindFirstChild("Icon") :: ImageLabel?
	local vp = box:FindFirstChild("View") :: ViewportFrame?
	local q = box:FindFirstChild("Mystery") :: GuiObject?
	local model, mystery = rewardModel(r, text)
	if vp and model then
		local key = model:GetFullName()
		if vp:GetAttribute("Shown") ~= key then
			vp:SetAttribute("Shown", key)
			UI.ShowModel(vp, model, false, mystery and 1.1 or 1.45)
		end
		vp.ImageColor3 = mystery and Color3.fromRGB(20, 22, 40) or WHITE
		vp.Visible = true
		if ic then ic.Visible = false end
	else
		if vp then vp.Visible = false end
		if ic then ic.Visible = true; ic.Image = rewardIcon(r) end
	end
	if q then q.Visible = mystery and model ~= nil end
end
local function setIcon(parent: Instance?, image: string)
	local ic = parent and parent:FindFirstChild("Icon") :: ImageLabel?
	if ic and ic:IsA("ImageLabel") then ic.Image = image end
end

-- boutons du HUD de droite
for _, b in ipairs(Right:GetChildren()) do
	if b:IsA("GuiButton") then
		UI.Button(b, function()
			if b.Name == "Starter" then UI.Show("Starter") else UI.Toggle(b.Name) end
		end)
	end
end

-- [ CALENDRIER DE L'AVENT ] -------------------------------------------------------------
local Grid = F.Advent:WaitForChild("Grid")
local AdvInfo = F.Advent:WaitForChild("Info") :: TextLabel
-- tuiles du kit K4 : cadeau rouge / vert (tuile blanche teintée), case du jour dorée, case 24 rose, case ouverte bleu nuit
local TILE = "rbxassetid://85340622947101"
local TILE_GOLD = "rbxassetid://138731335957662"
local TILE_SECRET = "rbxassetid://98660535825383"
local BASE_COL = { Red = Color3.fromRGB(226, 62, 70), Green = Color3.fromRGB(52, 178, 96) }
local OPEN_COL = Color3.fromRGB(70, 88, 140)
local function refreshAdvent()
	local data = State.Data
	if not data then return end
	local today = info and info.AdventDay or Events.AdventDay(math.floor(workspace:GetServerTimeNow()))
	local opened = data.Advent or {}
	local ready = false
	for d = 1, 24 do
		local cell = Grid:FindFirstChild("Day" .. d) :: ImageButton?
		if not cell then continue end
		local isOpen = opened[tostring(d)] == true
		local locked = today == 0 or d > today
		local claimable = not isOpen and not locked
		local door = cell:FindFirstChild("Door") :: GuiObject
		local inside = cell:FindFirstChild("Inside") :: GuiObject
		local lock = cell:FindFirstChild("Lock") :: GuiObject
		door.Visible = not isOpen
		inside.Visible = isOpen
		lock.Visible = locked and not isOpen
		local hl = door:FindFirstChild("Today") :: UIStroke?
		if hl then hl.Enabled = claimable end
		local hint = door:FindFirstChild("Hint") :: GuiObject?
		if hint then hint.Visible = claimable end
		for _, n in ipairs({ "RibbonV", "RibbonH" }) do
			local rb = door:FindFirstChild(n) :: GuiObject?
			if rb then rb.Visible = not claimable end
		end
		local base = cell:GetAttribute("Base")
		if isOpen then
			cell.Image = TILE; cell.ImageColor3 = OPEN_COL
		elseif claimable and base ~= "Secret" then
			cell.Image = TILE_GOLD; cell.ImageColor3 = WHITE
		elseif base == "Secret" then
			cell.Image = TILE_SECRET; cell.ImageColor3 = WHITE
		else
			cell.Image = TILE; cell.ImageColor3 = BASE_COL[base :: string] or BASE_COL.Red
		end
		if isOpen then
			local text = info and info.Advent and info.Advent[d] or ""
			UI.SetText(inside, "Reward", text)
			local rs = Events.Advent.Days[d]
			setReward(inside:FindFirstChild("IconBox"), rs and rs[1], text)
		end
		if claimable then ready = true end
	end
	if today == 0 then
		AdvInfo.Text = "The calendar opens on December 1st!"
	elseif today >= 25 then
		AdvInfo.Text = "Merry Christmas! Missed doors can still be opened"
	else
		AdvInfo.Text = ready and ("Day " .. today .. " is ready! Click a glowing door!") or ("Come back tomorrow for day " .. math.min(24, today + 1) .. "!")
	end
	setBadge("Advent", ready)
end
for d = 1, 24 do
	local cell = Grid:FindFirstChild("Day" .. d) :: GuiButton?
	if cell then
		UI.Button(cell, function()
			local r = State.Ask("ClaimAdvent", d)
			result(r)
			if r and r.ok then
				-- la porte s'ouvre en tournant
				local door = cell:FindFirstChild("Door") :: GuiObject
				local s = (cell:FindFirstChild("Pop") :: UIScale)
				TweenService:Create(s, TweenInfo.new(0.15), { Scale = 1.25 }):Play()
				task.delay(0.15, function() TweenService:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Back), { Scale = 1 }):Play() end)
				door.Visible = false
				fetchInfo(true)
			end
			refreshAdvent()
		end)
	end
end
State.On({ "Advent" }, refreshAdvent)

-- guirlande qui clignote + porte du jour qui pulse
local bulbs = {}
for _, b in ipairs((F.Advent:WaitForChild("Garland")):GetChildren()) do if b.Name:match("^Bulb") then table.insert(bulbs, b) end end
RunService.Heartbeat:Connect(function()
	if not F.Advent.Visible then return end
	local t = os.clock()
	for i, b in ipairs(bulbs) do
		(b :: Frame).BackgroundTransparency = (math.sin(t * 4 + i * 1.3) > 0.2) and 0 or 0.55
	end
	for d = 1, 24 do
		local cell = Grid:FindFirstChild("Day" .. d)
		local hl = cell and cell:FindFirstChild("Door") and cell.Door:FindFirstChild("Today") :: UIStroke?
		if hl and hl.Enabled then
			hl.Thickness = 3 + math.sin(t * 6) * 1.5
			local num = cell.Door:FindFirstChild("Number") :: GuiObject?
			if num then
				if not num:GetAttribute("Y0") then num:SetAttribute("Y0", num.Position.Y.Scale) end
				num.Position = UDim2.fromScale(num.Position.X.Scale, (num:GetAttribute("Y0") :: number) - math.abs(math.sin(t * 3)) * 0.05)
			end
		end
	end
end)

-- [ QUÊTES ] ------------------------------------------------------------------------------
local QICON = { Dig = ICON.Pickaxe, Eggs = ICON.Egg, Hatch = ICON.Clock, Sell = ICON.Coins, Rare = ICON.Diamond, Combo = ICON.Bolt, Chest = ICON.ChestPink, Storm = ICON.Candy }
local function questDef(id: string): any
	for _, q in ipairs(Events.Quests) do if q.Id == id then return q end end
	return nil
end
local function refreshQuests()
	local data = State.Data
	local Q = data and data.Quests
	if not Q or not Q.List then return end
	local ready, allDone = false, true
	for i = 1, 3 do
		local row = F.Quests:FindFirstChild("Quest" .. i) :: any
		local q = Q.List[i]
		if not row then continue end
		row.Visible = q ~= nil
		if not q then continue end
		local def = questDef(q.Id)
		UI.SetText(row, "Title", def and string.format(def.Text, q.Goal) or q.Id)
		setIcon(row:FindFirstChild("IconBg"), QICON[q.Id] or ICON.Gift)
		setBar(row:FindFirstChild("Bar"), q.Have, q.Goal)
		UI.SetText(row, "Reward", (info and info.QuestReward or "Reward"))
		local claim = row:FindFirstChild("Claim") :: ImageButton
		local glow = row:FindFirstChild("Glow") :: UIStroke?
		local can = (not q.Done) and q.Have >= q.Goal
		claim.Visible = not q.Done
		UI.SetText(claim, "Text", can and "CLAIM" or (math.floor(100 * q.Have / math.max(1, q.Goal)) .. "%"))
		claim.ImageColor3 = can and WHITE or GREY
		if glow then glow.Color = q.Done and GREEN or (can and GOLD or Color3.fromRGB(80, 100, 160)) end
		row.ImageColor3 = q.Done and Color3.fromRGB(150, 230, 160) or WHITE
		local rw = row:FindFirstChild("Reward") :: GuiObject?
		if rw then rw.Visible = not q.Done end
		local db = row:FindFirstChild("DoneBadge") :: GuiObject?
		if db then db.Visible = q.Done == true end
		if can then ready = true end
		if not q.Done then allDone = false end
	end
	local bonus = F.Quests:FindFirstChild("Bonus") :: Frame
	UI.SetText(bonus, "Reward", info and info.QuestBonus or "Golden Egg")
	local bc = bonus:FindFirstChild("Claim") :: ImageButton
	bc.Visible = not Q.Bonus
	bc.ImageColor3 = allDone and WHITE or GREY
	if Q.Bonus then UI.SetText(bonus, "Title", "Daily bonus claimed!") else UI.SetText(bonus, "Title", "Finish all 3 quests:") end
	local bdb = bonus:FindFirstChild("DoneBadge") :: GuiObject?
	if bdb then bdb.Visible = Q.Bonus == true end
	if allDone and not Q.Bonus then ready = true end
	setBadge("Quests", ready)
end
for i = 1, 3 do
	local row = F.Quests:FindFirstChild("Quest" .. i)
	local c = row and row:FindFirstChild("Claim") :: GuiButton?
	if c then UI.Button(c, function() result(State.Ask("ClaimQuest", i)) end) end
end
UI.Button(F.Quests:WaitForChild("Bonus"):WaitForChild("Claim") :: GuiButton, function() result(State.Ask("ClaimQuest", "bonus")) end)
State.On({ "Quests" }, refreshQuests)

-- [ WINTER PASS ] ---------------------------------------------------------------------------
local Track = F.Pass:WaitForChild("Track") :: ScrollingFrame
local Top = F.Pass:WaitForChild("Top")
-- largeur du défilement = largeur réelle des 30 paliers (AutomaticCanvasSize ne comptait pas les tailles en scale :
-- on ne pouvait pas dépasser le palier 8)
do
	local layout = Track:FindFirstChildWhichIsA("UIListLayout")
	if layout then
		local function fit()
			Track.CanvasSize = UDim2.fromOffset(layout.AbsoluteContentSize.X + 12, 0)
		end
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fit)
		fit()
	end
end
local function refreshPass()
	local data = State.Data
	local P = data and data.Pass
	if not P then return end
	local premium = data.Passes and data.Passes.WinterPass == true
	local tier, have, need = tierOf(P.XP or 0)
	UI.SetText(Top:FindFirstChild("TierBadge") :: Instance, "Tier", tostring(tier))
	if need > 0 then setBar(Top:FindFirstChild("Bar"), have, need, Format.Num(have) .. " / " .. Format.Num(need) .. " XP")
	else setBar(Top:FindFirstChild("Bar"), 1, 1, "MAX TIER!") end
	local left = info and info.PassEnds or (Events.Pass.Ends - math.floor(workspace:GetServerTimeNow()))
	local ends = left >= 86400 and string.format("%dd %dh", left // 86400, (left % 86400) // 3600) or Format.Time(math.max(0, left))
	UI.SetText(Top, "Ends", left > 0 and ("Season ends in " .. ends) or "Season over!")
	local pb = Top:FindFirstChild("Premium") :: ImageButton
	local owned = pb:FindFirstChild("Owned") :: GuiObject?
	if owned then owned.Visible = premium end
	local locked = pb:FindFirstChild("Locked") :: GuiObject?
	if locked then locked.Visible = not premium end
	pb.Image = premium and "rbxassetid://137082657641266" or "rbxassetid://112571562887469"
	pb.AutoButtonColor = not premium
	local ready = false
	for t = 1, #Events.Pass.Tiers do
		local col = Track:FindFirstChild("Tier" .. t)
		if not col then continue end
		local def = Events.Pass.Tiers[t]
		local reached = tier >= t
		for _, side in ipairs({ "Free", "Premium" }) do
			local c = col:FindFirstChild(side) :: GuiObject
			local claimed = (side == "Free" and P.Free or P.Premium)[tostring(t)] == true
			local usable = reached and (side == "Free" or premium)
			local rtext = info and info.Pass and info.Pass[t] and info.Pass[t][side] or ""
			setReward(c:FindFirstChild("IconBox"), def[side], rtext)
			UI.SetText(c, "Reward", rtext)
			UI.SetText(c, "State", claimed and "CLAIMED" or (usable and "CLAIM!" or ""))
			local ck = c:FindFirstChild("Claimed") :: GuiObject?
			if ck then ck.Visible = claimed end
			local st = c:FindFirstChild("State") :: TextLabel?
			if st then st.TextColor3 = claimed and GREEN or GOLD end
			local lock = c:FindFirstChild("Lock") :: GuiObject?
			if lock then lock.Visible = not usable and not claimed end
			local glow = c:FindFirstChild("Glow") :: UIStroke?
			if glow then glow.Thickness = (usable and not claimed) and 4 or 2 end
			if usable and not claimed then ready = true end
		end
		local num = col:FindFirstChild("Num") :: Frame?
		if num and num:IsA("ImageLabel") then num.Image = reached and "rbxassetid://112969477861450" or "rbxassetid://135696051917539" end
	end
	setBadge("Pass", ready)
end
for t = 1, #Events.Pass.Tiers do
	local col = Track:FindFirstChild("Tier" .. t)
	if not col then continue end
	for _, side in ipairs({ "Free", "Premium" }) do
		local c = col:FindFirstChild(side) :: GuiButton?
		if c then
			UI.Button(c, function()
				local data = State.Data
				if side == "Premium" and not (data and data.Passes and data.Passes.WinterPass) then prompt("WinterPass"); return end
				result(State.Ask("ClaimPass", t, side == "Premium"))
			end)
		end
	end
end
UI.Button(Top:WaitForChild("Premium") :: GuiButton, function()
	if State.Data and State.Data.Passes and State.Data.Passes.WinterPass then return end
	prompt("WinterPass")
end)
State.On({ "Pass", "Passes" }, refreshPass)

-- [ OFFRE DE DÉPART ] ---------------------------------------------------------------------
local StarterBtn = Right:WaitForChild("Starter") :: GuiObject
local Rays = F.Starter:FindFirstChild("Rays") :: GuiObject?
local function refreshStarter()
	local data = State.Data
	if not data then return end
	-- le bouton est là dès l'arrivée (tant que le pack n'est pas acheté) ;
	-- la pastille "!" et l'ouverture auto arrivent après Events.Starter.ShowAfter (5 min de jeu)
	local offered = starterOffered or ((data.Stats and data.Stats.Playtime or 0) >= Events.Starter.ShowAfter)
	StarterBtn.Visible = not data.StarterBought
	setBadge("Starter", not data.StarterBought and offered)
	if data.StarterBought and F.Starter.Visible then UI.Close() end
end
UI.Button(F.Starter:WaitForChild("Buy") :: GuiButton, function() prompt("Starter") end)
UI.Opened.Event:Connect(function(n)
	if n ~= "Starter" then return end
	for _, d in ipairs(F.Starter:GetDescendants()) do
		if d:IsA("ViewportFrame") and d:GetAttribute("Egg") and #d:GetChildren() == 0 then
			local eggs = ReplicatedStorage.Assets:FindFirstChild("Eggs")
			local def = Eggs.ById[d:GetAttribute("Egg") :: string]
			UI.ShowModel(d, eggs and eggs:FindFirstChild(def and def.Model or "") :: Model?, true, 0.9)
		end
	end
end)
UI.Button(F.Starter:WaitForChild("Later") :: GuiButton, UI.Close)
State.On({ "StarterBought", "Stats" }, refreshStarter)

-- [ HORS LIGNE ] ---------------------------------------------------------------------------
local offlineMoney = 0
UI.Button(F.Offline:WaitForChild("Collect") :: GuiButton, UI.Close)
UI.Button(F.Offline:WaitForChild("Double") :: GuiButton, function() prompt("OfflineX2") end)

-- [ ÉCLORE MAINTENANT ] --------------------------------------------------------------------
local skipUid: string? = nil
-- prix au moment de l'ouverture : il baisse avec le temps restant (même calcul que le serveur)
local skipCost0, skipLeft0, skipFull = 0, 1, 1
local SkipView = F.EggSkip:WaitForChild("View") :: ViewportFrame
local function openSkip(model: Model)
	local uid = model:GetAttribute("EggUid") :: string?
	if not uid then return end
	local r = State.Ask("SkipCost", uid)
	if not r then return end
	if r.Left <= 0 then State.Notify:Fire("This egg is hatching!", "info"); return end
	skipUid = uid
	skipCost0, skipLeft0, skipFull = r.Cost, r.Left, r.Full or r.Left
	local def = Eggs.ById[r.Egg]
	UI.SetText(F.EggSkip, "Egg", def and def.Name or r.Egg)
	UI.SetText(F.EggSkip, "Time", "Hatching in " .. Format.Time(r.Left))
	UI.SetText(F.EggSkip:WaitForChild("Money"), "Text", "SKIP " .. Format.Money(r.Cost))
	local tpl = ReplicatedStorage.Assets:FindFirstChild("Eggs") and ReplicatedStorage.Assets.Eggs:FindFirstChild(def and def.Model or r.Egg)
	UI.ShowModel(SkipView, tpl :: Model?, true, 0.85)
	if UI.Open ~= F.EggSkip then UI.Show("EggSkip") end
end
UI.Button(F.EggSkip:WaitForChild("Money") :: GuiButton, function()
	if skipUid then State.Send("SkipEgg", skipUid); UI.Close() end
end)
UI.Button(F.EggSkip:WaitForChild("Robux") :: GuiButton, function()
	if skipUid then State.Send("SkipTarget", skipUid); prompt("SkipEgg") end
end)
-- temps restant qui défile pendant que la fenêtre est ouverte
task.spawn(function()
	while true do
		task.wait(1)
		if F.EggSkip.Visible and skipUid then
			for _, d in ipairs(workspace:GetDescendants()) do
				if d:IsA("Model") and d:GetAttribute("EggUid") == skipUid then
					local at = d:GetAttribute("HatchAt") :: number?
					if at then
						local left = math.max(0, at - workspace:GetServerTimeNow())
						UI.SetText(F.EggSkip, "Time", left > 0 and ("Hatching in " .. Format.Time(left)) or "Hatching!")
						local f0 = math.max(skipLeft0, 0.05 * skipFull)
						local cost = math.max(50, math.floor(skipCost0 * math.max(left, 0.05 * skipFull) / math.max(f0, 1)))
						UI.SetText(F.EggSkip:WaitForChild("Money"), "Text", "SKIP " .. Format.Money(math.min(cost, skipCost0)))
						if left <= 0 then UI.Close() end
					end
					break
				end
			end
			if not workspace:FindFirstChild("Egg_" .. skipUid, true) then UI.Close(); skipUid = nil end
		end
	end
end)
-- [ CADEAU : FAIRE ÉCLORE L'ŒUF D'UN AUTRE JOUEUR ] (Robux uniquement, produit "GiftSkip") ------------------
local giftUid: string?, giftOwner: number? = nil, nil
local giftModel: Model? = nil
local GiftView = F.GiftSkip:WaitForChild("View") :: ViewportFrame
do
	local gp = Store.ByKey.GiftSkip
	local price = F.GiftSkip:FindFirstChild("Price", true) :: TextLabel?
	if gp and price then price.Text = tostring(gp.Price) end
end
local function openGift(model: Model)
	local uid = model:GetAttribute("EggUid") :: string?
	local ownerId = model:GetAttribute("Owner") :: number?
	if not uid or not ownerId or ownerId == 0 or ownerId == player.UserId then return end
	local at = model:GetAttribute("HatchAt") :: number?
	local left = at and math.max(0, at - workspace:GetServerTimeNow()) or 0
	if left <= 1 then State.Notify:Fire("This egg is hatching!", "info"); return end
	giftUid, giftOwner, giftModel = uid, ownerId, model
	local owner = Players:GetPlayerByUserId(ownerId)
	local def = Eggs.ById[(model:GetAttribute("EggId") :: string?) or ""]
	UI.SetText(F.GiftSkip, "Egg", def and def.Name or "Egg")
	UI.SetText(F.GiftSkip, "For", "for " .. (owner and owner.DisplayName or "this player"))
	UI.SetText(F.GiftSkip, "Time", "Hatching in " .. Format.Time(math.floor(left)))
	local tpl = def and ReplicatedStorage.Assets:FindFirstChild("Eggs") and ReplicatedStorage.Assets.Eggs:FindFirstChild(def.Model)
	UI.ShowModel(GiftView, tpl :: Model?, true, 0.85)
	if UI.Open ~= F.GiftSkip then UI.Show("GiftSkip") end
end
UI.Button(F.GiftSkip:WaitForChild("Robux") :: GuiButton, function()
	if giftUid and giftOwner then
		State.Send("GiftSkipTarget", giftOwner, giftUid)
		prompt("GiftSkip")
	end
end)
-- temps restant du cadeau pendant que la fenêtre est ouverte
task.spawn(function()
	while true do
		task.wait(1)
		if F.GiftSkip.Visible and giftModel then
			local at = giftModel.Parent and giftModel:GetAttribute("HatchAt") :: number?
			local left = at and math.max(0, at - workspace:GetServerTimeNow()) or 0
			if not giftModel.Parent or left <= 0 then
				UI.Close(); giftUid, giftOwner, giftModel = nil, nil, nil
			else
				UI.SetText(F.GiftSkip, "Time", "Hatching in " .. Format.Time(math.floor(left)))
			end
		end
	end
end)

-- mon œuf : "Hatch now" (argent ou Robux) ; l'œuf d'un autre : "Gift hatch" (Robux, cadeau)
local function hookEgg(inst: Instance)
	if not inst:IsA("ProximityPrompt") or inst.Name ~= "SkipPrompt" then return end
	local m = inst:FindFirstAncestorWhichIsA("Model")
	if not m then return end
	local ownerId = m:GetAttribute("Owner") :: number?
	local mine = ownerId == player.UserId
	-- clic souris sur l'œuf (ClickDetector) : même chose que la touche E
	local cd = inst.Parent and inst.Parent:FindFirstChild("SkipClick") :: ClickDetector?
	if not mine then
		local owner = ownerId and Players:GetPlayerByUserId(ownerId)
		inst.Enabled = owner ~= nil
		inst.ActionText = "Gift hatch"
		inst.ObjectText = "🎁 " .. (owner and owner.DisplayName or "Gift")
		inst.Triggered:Connect(function() openGift(m :: Model) end)
		if cd then cd.MouseClick:Connect(function() if owner and owner.Parent then openGift(m :: Model) end end) end
		return
	end
	inst.Enabled = true
	inst.Triggered:Connect(function() openSkip(m) end)
	if cd then cd.MouseClick:Connect(function() openSkip(m) end) end
end
for _, d in ipairs(workspace:GetDescendants()) do hookEgg(d) end
workspace.DescendantAdded:Connect(function(d) if d:IsA("ProximityPrompt") then task.defer(hookEgg, d) end end)

-- [ COMBO ] ---------------------------------------------------------------------------------
local Count = ComboHud:WaitForChild("Count") :: TextLabel
local MultL = ComboHud:WaitForChild("Mult") :: TextLabel
local Fill = ComboHud:WaitForChild("Track"):WaitForChild("Fill") :: Frame
local Glow = ComboHud:WaitForChild("Bg"):WaitForChild("Glow") :: UIStroke
local comboScale = ComboHud:FindFirstChild("Pop") :: UIScale? or Instance.new("UIScale")
comboScale.Name = "Pop"; comboScale.Parent = ComboHud
local comboUntil, comboWindow, comboN = 0, 2.5, 0
local TIERS = { { 50, Color3.fromRGB(255, 90, 220) }, { 25, Color3.fromRGB(255, 200, 60) }, { 10, Color3.fromRGB(120, 230, 255) }, { 0, Color3.fromRGB(150, 220, 255) } }
local function comboColor(n: number): Color3
	for _, t in ipairs(TIERS) do if n >= t[1] then return t[2] end end
	return WHITE
end
local function onCombo(p: any)
	comboN = p.N or 0
	if comboN < 3 then ComboHud.Visible = false; return end
	comboWindow = p.Window or comboWindow
	comboUntil = os.clock() + comboWindow
	ComboHud.Visible = true
	Count.Text = "x" .. comboN
	local mult = p.Mult or 1
	MultL.Text = mult > 1 and ("EGG LUCK x" .. mult) or "x10 = EGG LUCK UP"
	local c = comboColor(comboN)
	Count.TextColor3 = c; Glow.Color = c; Fill.BackgroundColor3 = c
	comboScale.Scale = 1.18
	TweenService:Create(comboScale, TweenInfo.new(0.18, Enum.EasingStyle.Back), { Scale = 1 }):Play()
	if comboN == 10 or comboN == 25 or comboN == 50 then
		UI.Play("LevelUp", 0.35)
		State.Notify:Fire("COMBO x" .. comboN .. "! Egg luck x" .. mult, "success")
	end
end
RunService.RenderStepped:Connect(function()
	if not ComboHud.Visible then return end
	local left = comboUntil - os.clock()
	if left <= 0 then ComboHud.Visible = false; return end
	Fill.Size = UDim2.fromScale(math.clamp(left / comboWindow, 0, 1), 1)
	Glow.Transparency = 0.2 + 0.3 * math.sin(os.clock() * 8) ^ 2
end)

-- [ COFFRE GELÉ ] ---------------------------------------------------------------------------
local function chestFx(pos: Vector3)
	local a = Instance.new("Part")
	a.Anchored = true; a.CanCollide = false; a.CanQuery = false; a.CanTouch = false; a.Transparency = 1
	a.Size = Vector3.one; a.CFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0)); a.Parent = workspace
	local att = Instance.new("Attachment"); att.Parent = a
	local function emit(tex: string, col: ColorSequence, n: number, size: number, speed: number, life: number)
		local e = Instance.new("ParticleEmitter")
		e.Texture = tex; e.Color = col; e.LightEmission = 1; e.Enabled = false
		e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, size), NumberSequenceKeypoint.new(1, 0) })
		e.Speed = NumberRange.new(speed * 0.5, speed); e.SpreadAngle = Vector2.new(180, 180); e.Lifetime = NumberRange.new(life * 0.6, life)
		e.Drag = 3; e.RotSpeed = NumberRange.new(-180, 180); e.Acceleration = Vector3.new(0, -8, 0)
		e.Parent = att
		e:Emit(n)
	end
	emit("rbxasset://textures/particles/sparkles_main.dds", ColorSequence.new(Color3.fromRGB(255, 230, 120), Color3.fromRGB(150, 230, 255)), 60, 1.4, 30, 1.6)
	emit("rbxasset://textures/particles/sparkles_main.dds", ColorSequence.new(WHITE), 40, 0.8, 18, 2.2)
	local l = Instance.new("PointLight"); l.Color = Color3.fromRGB(255, 220, 140); l.Range = 22; l.Brightness = 6; l.Parent = a
	TweenService:Create(l, TweenInfo.new(1.4), { Brightness = 0 }):Play()
	-- anneau de glace qui s'élargit
	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder; ring.Anchored = true; ring.CanCollide = false; ring.CanQuery = false; ring.CanTouch = false
	ring.Material = Enum.Material.Neon; ring.Color = Color3.fromRGB(170, 230, 255); ring.Transparency = 0.2
	ring.Size = Vector3.new(0.3, 2, 2); ring.CFrame = CFrame.new(pos + Vector3.new(0, 0.3, 0)) * CFrame.Angles(0, 0, math.rad(90)); ring.Parent = workspace
	TweenService:Create(ring, TweenInfo.new(0.7, Enum.EasingStyle.Quad), { Size = Vector3.new(0.3, 22, 22), Transparency = 1 }):Play()
	task.delay(3, function() a:Destroy(); ring:Destroy() end)
end

-- [ ÉVÉNEMENTS SERVEUR ] ----------------------------------------------------------------------
State.Event.Event:Connect(function(name, payload)
	if name == "Combo" then
		onCombo(payload)
	elseif name == "ChestOpened" then
		if typeof(payload.Pos) == "Vector3" then chestFx(payload.Pos) end
		UI.Play("LevelUp", 0.7)
		local egg = payload.Egg and Eggs.ById[payload.Egg]
		local sub = "+" .. Format.Money(payload.Money or 0) .. (egg and (" · " .. egg.Name) or "") .. (payload.Charm and " · +2% charm" or "")
		if UI.Banner then (UI.Banner :: any)("FROZEN CHEST!", sub, Color3.fromRGB(150, 225, 255)) end
	elseif name == "QuestReady" then
		local def = questDef(tostring(payload))
		State.Notify:Fire("Quest complete! Open Quests to claim it", "success")
		UI.Play("LevelUp", 0.35)
		if def then refreshQuests() end
	elseif name == "PassTier" then
		if UI.Banner then (UI.Banner :: any)("PASS TIER " .. tostring(payload) .. "!", "New Winter Pass reward unlocked", Color3.fromRGB(120, 200, 255)) end
		UI.Play("LevelUp", 0.5)
	elseif name == "StarterOffer" then
		starterOffered = true
		refreshStarter()
		if UI.Open == nil and State.Data and not State.Data.StarterBought then UI.Show("Starter") end
	elseif name == "StarterBought" then
		if UI.Banner then (UI.Banner :: any)("STARTER PACK!", table.concat(payload or {}, " · "), GOLD) end
		refreshStarter()
	elseif name == "Offline" then
		offlineMoney = payload.Money or 0
		if offlineMoney <= 0 then return end
		UI.SetText(F.Offline, "Money", "+" .. Format.Money(offlineMoney))
		UI.SetText(F.Offline, "Time", "(" .. Format.Time(payload.Seconds or 0) .. " away)")
		task.delay(2.5, function()
			if UI.Open ~= F.Offline then UI.Show("Offline") end
		end)
	end
end)

-- rayons de l'offre qui tournent, minuteurs
RunService.Heartbeat:Connect(function(dt)
	if Rays and F.Starter.Visible then Rays.Rotation = (Rays.Rotation + dt * 18) % 360 end
end)
task.spawn(function()
	while true do
		if F.Quests.Visible then
			local left = Events.ToMidnight(math.floor(workspace:GetServerTimeNow()))
			UI.SetText(F.Quests, "Timer", string.format("New quests in %02dh %02dm %02ds", left // 3600, (left % 3600) // 60, left % 60))
		end
		task.wait(1)
	end
end)

-- textes réels (montants du joueur) à l'ouverture
UI.Opened.Event:Connect(function(n)
	if n == "Advent" or n == "Quests" or n == "Pass" then
		task.spawn(function()
			fetchInfo(true)
			refreshAdvent(); refreshQuests(); refreshPass()
		end)
	end
end)
State.On({ "Rebirths" }, function() infoAt = 0 end)
task.spawn(function()
	if not State.Data then State.Loaded.Event:Wait() end
	fetchInfo(true)
	refreshAdvent(); refreshQuests(); refreshPass(); refreshStarter()
	-- nouveau jour / montants qui grandissent : on relit les textes de temps en temps
	while true do
		task.wait(60)
		fetchInfo(true)
		refreshAdvent(); refreshQuests(); refreshPass()
	end
end)
-- tests en Studio : ouvrir un menu depuis la console
if RunService:IsStudio() then
	local be = Instance.new("BindableEvent"); be.Name = "SFE_Show"; be.Parent = player:WaitForChild("PlayerGui")
	be.Event:Connect(function(n) UI.Show(n) end)
end

return true
