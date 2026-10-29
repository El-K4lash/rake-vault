--!strict
-- Client/AdminController : panel admin (StarterGui.AdminPanel, vraies instances construites par tools/build_admin.lua).
-- Visible seulement si le serveur a mis l'attribut IsAdmin sur le joueur. Chaque action = State.Ask("Admin", cmd, args) :
-- c'est le serveur (AdminService) qui vérifie les droits. Ouvrir : bouton "Admin" ou touche F2.
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)
local Eggs = require(Shared.Config.Eggs)
local Admins = require(Shared.Config.Admins)
local Store = require(Shared.Config.Store)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui"):WaitForChild("AdminPanel") :: ScreenGui
local Main = gui:WaitForChild("Main") :: Frame
local Open = gui:WaitForChild("OpenButton") :: GuiButton
local Templates = gui:WaitForChild("Templates") :: Folder
local Tabs = Main:WaitForChild("Tabs") :: Frame
local Pages = Main:WaitForChild("Pages") :: Frame
local Target = Main:WaitForChild("Header"):WaitForChild("Target") :: TextLabel

local selected: number? = nil -- UserId du joueur ciblé
local cache: { [number]: any } = {}
local redrawPasses: () -> () = function() end -- défini plus bas (onglet GIVE > GAMEPASSES)

-- [ outils ] ---------------------------------------------------------------------
local function ask(cmd: string, args: any?): any
	local ok, res = pcall(State.Ask, "Admin", cmd, args or {})
	if not ok or type(res) ~= "table" then
		State.Notify:Fire("Admin: no answer", "error")
		return nil
	end
	if res.msg then State.Notify:Fire(res.msg, res.ok and "success" or "error") end
	return res
end

local function setText(o: Instance, text: string) UI.SetText(o, "Text", text) end

local function toggleImg(b: Instance, on: boolean)
	if b:IsA("ImageButton") or b:IsA("ImageLabel") then
		local id = b:GetAttribute(on and "On" or "Off")
		if type(id) == "string" then (b :: ImageButton).Image = id end
	end
end

-- bouton dangereux : 1er clic = "SURE?", 2e clic dans les 3 s = action
local function confirmButton(b: GuiButton, fn: () -> ())
	local armed = false
	local label = (b:FindFirstChild("Text", true) :: TextLabel?)
	local base = label and label.Text or ""
	UI.Button(b, function()
		if not armed then
			armed = true
			if label then label.Text = "SURE?" end
			task.delay(3, function() armed = false; if label then label.Text = base end end)
			return
		end
		armed = false
		if label then label.Text = base end
		fn()
	end)
end

local thumbs: { [number]: string } = {}
local function thumb(uid: number, img: ImageLabel)
	if thumbs[uid] then img.Image = thumbs[uid]; return end
	task.spawn(function()
		local ok, url = pcall(Players.GetUserThumbnailAsync, Players, uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		if ok then thumbs[uid] = url; img.Image = url end
	end)
end

local function needTarget(): boolean
	if selected and Players:GetPlayerByUserId(selected) then return true end
	State.Notify:Fire("Select a player first (PLAYERS tab)", "error")
	return false
end

-- [ onglets ] ---------------------------------------------------------------------
local current = "Players"
local onTab: { [string]: () -> () } = {}
local function showTab(name: string)
	current = name
	for _, b in ipairs(Tabs:GetChildren()) do if b:IsA("GuiButton") then toggleImg(b, b.Name == name) end end
	for _, p in ipairs(Pages:GetChildren()) do if p:IsA("GuiObject") then p.Visible = p.Name == name end end
	if onTab[name] then task.spawn(onTab[name]) end
end
for _, b in ipairs(Tabs:GetChildren()) do
	if b:IsA("GuiButton") then UI.Button(b, function() showTab(b.Name) end) end
end

-- [ PLAYERS ] ---------------------------------------------------------------------
local PP = Pages:WaitForChild("Players")
local ListPanel = PP:WaitForChild("ListPanel")
local List = ListPanel:WaitForChild("List") :: ScrollingFrame
local Search = ListPanel:WaitForChild("Search") :: TextBox
local Sel = PP:WaitForChild("Selected")
local Head = Sel:WaitForChild("Head")
local StatsF = Sel:WaitForChild("Stats")
local Reason = Sel:WaitForChild("Reason") :: TextBox
local Acts = Sel:WaitForChild("Actions")

local function showSelected()
	local info = selected and cache[selected]
	if not info then
		UI.SetText(Head, "PName", "—"); UI.SetText(Head, "Sub", "Select a player on the left")
		Target.Text = "No player selected"
		return
	end
	UI.SetText(Head, "PName", info.Display .. (info.Owner and "  👑" or (info.Admin and "  🛡️" or "")))
	UI.SetText(Head, "Sub", "@" .. info.Name .. " · " .. info.UserId .. " · " .. info.Pets .. " pets")
	thumb(info.UserId, Head:FindFirstChild("Avatar") :: ImageLabel)
	Target.Text = "Target: " .. info.Display
	for _, s in ipairs({ "Money", "Rebirths", "Slots", "Shovel", "Sled" }) do
		local r = StatsF:FindFirstChild(s)
		if r then UI.SetText(r, "Value", s == "Money" and Format.Money(info[s]) or tostring(info[s])) end
	end
	redrawPasses()
end

local function drawList()
	for _, c in ipairs(List:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	local q = string.lower(Search.Text)
	local i = 0
	for uid, info in pairs(cache) do
		if q == "" or string.find(string.lower(info.Name .. " " .. info.Display), q, 1, true) then
			i += 1
			local row = (Templates:FindFirstChild("PlayerRow") :: ImageButton):Clone()
			row.Name = tostring(uid); row.Visible = true
			row.LayoutOrder = -math.floor(info.Money / 1e3) -- les plus riches en haut
			UI.SetText(row, "PName", info.Display .. (info.Owner and " 👑" or (info.Admin and " 🛡️" or "")))
			UI.SetText(row, "Info", Format.Money(info.Money) .. " · " .. info.Rebirths .. " rb")
			toggleImg(row, uid == selected)
			thumb(uid, row:FindFirstChild("Avatar") :: ImageLabel)
			row.Parent = List
			UI.Button(row, function() selected = uid; drawList(); showSelected() end)
		end
	end
end

local Events = Pages:WaitForChild("Events")
local function drawEvents(ev: any)
	if type(ev) ~= "table" then return end
	for _, s in ipairs({ "Luck", "Money" }) do
		local e = ev[s]
		local p = Events:FindFirstChild(s)
		if p and e then
			UI.SetText(p, "Status", e.Mult > 1 and ("ACTIVE x" .. e.Mult .. " · " .. Format.Time(math.max(0, e.Left)) .. " left") or "Not active")
		end
	end
	local st, sp = ev.Storm, Events:FindFirstChild("Storm")
	if st and sp then
		UI.SetText(sp, "Status", st.Kind ~= "" and (string.upper(st.Kind) .. " STORM · " .. Format.Time(st.Left) .. " left")
			or ("Next storm in " .. Format.Time(st.Next)))
	end
end

local function refreshPlayers()
	local res = ask("Players")
	if not (res and res.data) then return end
	cache = {}
	for _, info in ipairs(res.data.Players) do cache[info.UserId] = info end
	if selected and not cache[selected] then selected = nil end
	if not selected then selected = player.UserId end
	drawList(); showSelected(); drawEvents(res.data.Events)
end
onTab.Players = refreshPlayers
Search:GetPropertyChangedSignal("Text"):Connect(drawList)

for _, s in ipairs({ "Money", "Rebirths", "Slots", "Shovel", "Sled" }) do
	local r = StatsF:WaitForChild(s)
	UI.Button(r:WaitForChild("Set") :: GuiButton, function()
		if not needTarget() then return end
		local box = r:FindFirstChild("Input") :: TextBox
		if box.Text == "" then return end
		ask("SetStat", { Target = selected, Stat = s, Value = box.Text })
		box.Text = ""
		refreshPlayers()
	end)
end

local function act(name: string, cmd: string, extra: any?)
	return function()
		if not needTarget() then return end
		local a = { Target = selected, Reason = Reason.Text }
		if extra then for k, v in pairs(extra) do a[k] = v end end
		ask(cmd, a)
		task.delay(0.3, refreshPlayers)
	end
end
UI.Button(Acts:WaitForChild("TpTo") :: GuiButton, act("TpTo", "TpTo"))
UI.Button(Acts:WaitForChild("Bring") :: GuiButton, act("Bring", "Bring"))
UI.Button(Acts:WaitForChild("Freeze") :: GuiButton, act("Freeze", "Freeze", { On = true }))
UI.Button(Acts:WaitForChild("Unfreeze") :: GuiButton, act("Unfreeze", "Freeze", { On = false }))
UI.Button(Acts:WaitForChild("Refresh") :: GuiButton, refreshPlayers)
confirmButton(Acts:WaitForChild("Kick") :: GuiButton, act("Kick", "Kick"))
confirmButton(Acts:WaitForChild("Ban") :: GuiButton, act("Ban", "Ban"))
confirmButton(Acts:WaitForChild("Reset") :: GuiButton, act("Reset", "Reset"))

-- [ GIVE ] -----------------------------------------------------------------------
local GP = Pages:WaitForChild("Give")
local BP = GP:WaitForChild("Pets")
local Grid = BP:WaitForChild("Grid") :: ScrollingFrame
local BSearch = BP:WaitForChild("Search") :: TextBox
local MutsF = BP:WaitForChild("Mutations") :: ScrollingFrame
local pickBr: string? = nil
local pickMut = "Normal"
local pickEgg: string? = nil

local function drawPets()
	for _, c in ipairs(Grid:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	local q = string.lower(BSearch.Text)
	for i, br in ipairs(Pets.List) do
		if q == "" or string.find(string.lower(br.Name), q, 1, true) or string.find(string.lower(br.Rarity), q, 1, true) then
			local card = (Templates:FindFirstChild("PetCard") :: ImageButton):Clone()
			card.Name = br.Id; card.Visible = true
			card.LayoutOrder = (Pets.RarityById[br.Rarity].Order or 0) * 1000 + i
			UI.SetText(card, "BName", br.Name)
			UI.SetText(card, "Rarity", br.Rarity)
			local rl = card:FindFirstChild("Rarity") :: TextLabel
			rl.TextColor3 = Pets.RarityById[br.Rarity].Color
			toggleImg(card, pickBr == br.Id)
			card.Parent = Grid
			UI.Button(card, function()
				pickBr = br.Id
				for _, c in ipairs(Grid:GetChildren()) do toggleImg(c, c.Name == pickBr) end
			end)
		end
	end
end
BSearch:GetPropertyChangedSignal("Text"):Connect(drawPets)

for i, m in ipairs(Mutations.List) do
	local chip = (Templates:FindFirstChild("Chip") :: ImageButton):Clone()
	chip.Name = m.Id; chip.LayoutOrder = i; chip.Visible = true
	setText(chip, m.Name)
	toggleImg(chip, m.Id == pickMut)
	chip.Parent = MutsF
	UI.Button(chip, function()
		pickMut = m.Id
		for _, c in ipairs(MutsF:GetChildren()) do toggleImg(c, c.Name == pickMut) end
	end)
end

local EggList = GP:WaitForChild("Eggs"):WaitForChild("List")
for i, e in ipairs(Eggs.List) do
	local chip = (Templates:FindFirstChild("Chip") :: ImageButton):Clone()
	chip.Name = e.Id; chip.LayoutOrder = i; chip.Visible = true
	setText(chip, (string.gsub(e.Name, " Egg$", "")))
	chip.Parent = EggList
	UI.Button(chip, function()
		pickEgg = e.Id
		for _, c in ipairs(EggList:GetChildren()) do toggleImg(c, c.Name == pickEgg) end
	end)
end

UI.Button(BP:WaitForChild("GivePet") :: GuiButton, function()
	if not needTarget() then return end
	if not pickBr then State.Notify:Fire("Pick a pet", "error"); return end
	local lvBox = BP:FindFirstChild("Level") :: TextBox?
	ask("GivePet", { Target = selected, Id = pickBr, Mut = pickMut, Count = (BP:FindFirstChild("Count") :: TextBox).Text, Lv = lvBox and lvBox.Text or "" })
end)
local EP = GP:WaitForChild("Eggs")
UI.Button(EP:WaitForChild("GiveEgg") :: GuiButton, function()
	if not needTarget() then return end
	if not pickEgg then State.Notify:Fire("Pick an egg", "error"); return end
	ask("GiveEgg", { Target = selected, Id = pickEgg, Count = (EP:FindFirstChild("Count") :: TextBox).Text })
end)
local MQ = GP:WaitForChild("Money"):WaitForChild("Buttons")
for name, v in pairs({ M1K = 1e3, M1M = 1e6, M1B = 1e9, M1T = 1e12 }) do
	UI.Button(MQ:WaitForChild(name) :: GuiButton, function()
		if needTarget() then ask("AddMoney", { Target = selected, Value = v }) end
	end)
end
UI.Button(MQ:WaitForChild("R1") :: GuiButton, function() if needTarget() then ask("AddRebirth", { Target = selected }) end end)
UI.Button(MQ:WaitForChild("Runes") :: GuiButton, function() if needTarget() then ask("MaxRunes", { Target = selected }) end end)
-- catégories du GIVE : PETS / PRODUCTS (dev products, chaque clic redonne) / GAMEPASSES (cocher / décocher)
local Cat = GP:WaitForChild("Category")
local PRP = GP:WaitForChild("Products")
local PSP = GP:WaitForChild("Passes")
local PRGrid = PRP:WaitForChild("Grid") :: ScrollingFrame
local PSGrid = PSP:WaitForChild("Grid") :: ScrollingFrame
local PRSearch = PRP:WaitForChild("Search") :: TextBox
local PSSearch = PSP:WaitForChild("Search") :: TextBox
local panels: { [string]: Instance } = { Pets = BP, Products = PRP, Passes = PSP }
local curCat = "Pets"

local GREEN, RED, GREY = Color3.fromRGB(110, 255, 130), Color3.fromRGB(255, 110, 110), Color3.fromRGB(190, 200, 225)

-- liste des produits : [GIFT] Skip Timer exclu (il lui faut l'œuf d'un autre joueur)
local products = {}
for _, p in ipairs(Store.Special) do
	if p.Key ~= "GiftSkip" then table.insert(products, { Key = p.Key, Name = p.Name, Sub = "Special · R$" .. p.Price }) end
end
for _, p in ipairs(Store.Cash) do
	table.insert(products, { Key = p.Key, Name = Format.Money(p.Amount) .. " Cash", Sub = "Money · R$" .. p.Price })
end
for _, list in ipairs({ Store.Eggs, Store.Limited }) do
	for _, p in ipairs(list) do
		local e = Eggs.ById[p.Egg]
		table.insert(products, { Key = p.Key, Name = p.Count .. "x " .. (e and e.Name or p.Egg), Sub = "Eggs · R$" .. p.Price })
	end
end

local function clear(f: Instance) for _, c in ipairs(f:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end end
local function match(q: string, ...: string): boolean
	if q == "" then return true end
	for _, s in ipairs({ ... }) do if string.find(string.lower(s), q, 1, true) then return true end end
	return false
end

local function drawProducts()
	clear(PRGrid)
	local q = string.lower(PRSearch.Text)
	for i, p in ipairs(products) do
		if match(q, p.Name, p.Sub, p.Key) then
			local card = (Templates:FindFirstChild("PetCard") :: ImageButton):Clone()
			card.Name = p.Key; card.LayoutOrder = i; card.Visible = true
			UI.SetText(card, "BName", p.Name)
			UI.SetText(card, "Rarity", p.Sub);
			(card:FindFirstChild("Rarity") :: TextLabel).TextColor3 = GREY
			toggleImg(card, false)
			card.Parent = PRGrid
			UI.Button(card, function()
				if not needTarget() then return end
				local res = ask("GiveProduct", { Target = selected, Key = p.Key })
				if res and res.ok then
					toggleImg(card, true)
					task.delay(0.25, function() toggleImg(card, false) end)
				end
			end)
		end
	end
end

local function drawPasses()
	clear(PSGrid)
	local info = selected and cache[selected]
	local owned = info and info.Passes or {}
	local q = string.lower(PSSearch.Text)
	for i, p in ipairs(Store.Passes) do
		if match(q, p.Name, p.Key) then
			local has = owned[p.Key] == true
			local card = (Templates:FindFirstChild("PetCard") :: ImageButton):Clone()
			card.Name = p.Key; card.LayoutOrder = i; card.Visible = true
			UI.SetText(card, "BName", p.Name)
			UI.SetText(card, "Rarity", has and "[X] OWNED" or "[  ] NOT OWNED");
			(card:FindFirstChild("Rarity") :: TextLabel).TextColor3 = has and GREEN or RED
			toggleImg(card, has)
			card.Parent = PSGrid
			UI.Button(card, function()
				if not needTarget() then return end
				local res = ask("SetPass", { Target = selected, Key = p.Key, On = not has })
				if res and res.ok and res.data and selected and cache[selected] then
					cache[selected].Passes = res.data.Passes
				end
				drawPasses()
			end)
		end
	end
end
redrawPasses = function() if curCat == "Passes" then drawPasses() end end
PRSearch:GetPropertyChangedSignal("Text"):Connect(drawProducts)
PSSearch:GetPropertyChangedSignal("Text"):Connect(drawPasses)

local function showCat(name: string)
	curCat = name
	for n, f in pairs(panels) do (f :: GuiObject).Visible = n == name end
	for _, b in ipairs(Cat:GetChildren()) do if b:IsA("GuiButton") then toggleImg(b, b.Name == name) end end
	if name == "Pets" then
		if #Grid:GetChildren() <= 1 then drawPets() end
	elseif name == "Products" then
		drawProducts()
	else
		drawPasses()
	end
end
for _, b in ipairs(Cat:GetChildren()) do
	if b:IsA("GuiButton") then UI.Button(b, function() showCat(b.Name) end) end
end

onTab.Give = function() showCat(curCat) end

-- [ SERVER ] ---------------------------------------------------------------------
local SP = Pages:WaitForChild("Server")
local Ann = SP:WaitForChild("Announce")
UI.Button(Ann:WaitForChild("Send") :: GuiButton, function()
	local b = Ann:FindFirstChild("Message") :: TextBox
	if b.Text ~= "" then ask("Announce", { Text = b.Text }); b.Text = "" end
end)
local GA = SP:WaitForChild("GiveAll")
UI.Button(GA:WaitForChild("Give") :: GuiButton, function() ask("GiveAll", { Value = (GA:FindFirstChild("Amount") :: TextBox).Text }) end)
local UB = SP:WaitForChild("Unban")
UI.Button(UB:WaitForChild("Do") :: GuiButton, function() ask("Unban", { Name = (UB:FindFirstChild("Name") :: TextBox).Text }) end)
local Q = SP:WaitForChild("Quick"):WaitForChild("Buttons")
UI.Button(Q:WaitForChild("SaveAll") :: GuiButton, function() ask("SaveAll") end)
UI.Button(Q:WaitForChild("RespawnAll") :: GuiButton, function() ask("RespawnAll") end)
UI.Button(Q:WaitForChild("RefillItems") :: GuiButton, function() ask("RefillItems") end)
confirmButton(Q:WaitForChild("Shutdown") :: GuiButton, function() ask("Shutdown") end)
confirmButton(Q:WaitForChild("Restart") :: GuiButton, function() ask("Restart") end)
confirmButton(Q:WaitForChild("RestartAll") :: GuiButton, function() ask("RestartAll") end)

-- [ EVENTS ] ---------------------------------------------------------------------
for _, s in ipairs({ "Luck", "Money" }) do
	local p = Events:WaitForChild(s)
	local mults = p:WaitForChild("Mults")
	local mult = 2
	for _, c in ipairs(mults:GetChildren()) do
		if c:IsA("GuiButton") then
			UI.Button(c, function()
				mult = tonumber(string.sub(c.Name, 2)) or 2
				for _, o in ipairs(mults:GetChildren()) do toggleImg(o, o == c) end
			end)
		end
	end
	UI.Button(p:WaitForChild("Start") :: GuiButton, function()
		local mins = (p:FindFirstChild("Minutes") :: TextBox).Text
		local res = ask("Event", { Stat = s, Mult = mult, Minutes = mins ~= "" and mins or 10 })
		if res and res.data then drawEvents(res.data.Events) end
	end)
end
-- tempêtes (cadre Events.Storm, vraie instance : tools/build_admin_storm_gui.lua)
local stormFrame = Events:FindFirstChild("Storm")
if stormFrame then
	for name, kind in pairs({ SnowStorm = "Snow", GoldenStorm = "Golden" }) do
		local b = stormFrame:FindFirstChild(name) :: GuiButton?
		if b then
			UI.Button(b, function()
				local res = ask("Storm", { Kind = kind })
				if res and res.data then drawEvents(res.data.Events) end
			end)
		end
	end
	local e = stormFrame:FindFirstChild("EndStorm") :: GuiButton?
	if e then
		UI.Button(e, function()
			local res = ask("EndStorm")
			if res and res.data then drawEvents(res.data.Events) end
		end)
	end
end
UI.Button(Events:WaitForChild("Stop"):WaitForChild("StopAll") :: GuiButton, function()
	local res = ask("StopEvents")
	if res and res.data then drawEvents(res.data.Events) end
end)
onTab.Events = refreshPlayers

-- [ FUN ] ------------------------------------------------------------------------
local FP = Pages:WaitForChild("Fun")
for _, s in ipairs({ "Speed", "Jump" }) do
	local p = FP:WaitForChild(s)
	UI.Button(p:WaitForChild("Set") :: GuiButton, function()
		if needTarget() then ask(s, { Target = selected, Value = (p:FindFirstChild("Value") :: TextBox).Text }) end
	end)
end
for _, c in ipairs(FP:WaitForChild("Size"):WaitForChild("Buttons"):GetChildren()) do
	if c:IsA("GuiButton") then UI.Button(c, function() if needTarget() then ask("Size", { Target = selected, Size = c.Name }) end end) end
end
local FA = FP:WaitForChild("Actions"):WaitForChild("Buttons")
UI.Button(FA:WaitForChild("Fling") :: GuiButton, function() if needTarget() then ask("Fling", { Target = selected }) end end)
UI.Button(FA:WaitForChild("Heal") :: GuiButton, function() if needTarget() then ask("Heal", { Target = selected }) end end)
UI.Button(FA:WaitForChild("ResetChar") :: GuiButton, function() if needTarget() then ask("ResetChar", { Target = selected }) end end)
UI.Button(FA:WaitForChild("BringAll") :: GuiButton, function() ask("BringAll") end)

-- [ LOGS ] -----------------------------------------------------------------------
local LogList = Pages:WaitForChild("Logs"):WaitForChild("Panel"):WaitForChild("List") :: ScrollingFrame
onTab.Logs = function()
	local res = ask("Logs")
	if not (res and res.data) then return end
	for _, c in ipairs(LogList:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	for i, line in ipairs(res.data.Logs) do
		local l = (Templates:FindFirstChild("LogLine") :: TextLabel):Clone()
		l.Text = line; l.LayoutOrder = i; l.Visible = true; l.Parent = LogList
	end
	if #res.data.Logs == 0 then
		local l = (Templates:FindFirstChild("LogLine") :: TextLabel):Clone()
		l.Text = "No admin action yet on this server."; l.Visible = true; l.Parent = LogList
	end
end

-- [ ADMINS ] (propriétaires) -------------------------------------------------------
local AP = Pages:WaitForChild("Admins")
local AddF = AP:WaitForChild("Add")
local AList = AP:WaitForChild("ListPanel"):WaitForChild("List") :: ScrollingFrame
local function drawAdmins(list: any)
	if type(list) ~= "table" then return end
	for _, c in ipairs(AList:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
	for i, a in ipairs(list) do
		local row = (Templates:FindFirstChild("AdminRow") :: ImageLabel):Clone()
		row.Name = tostring(a.UserId); row.LayoutOrder = i; row.Visible = true
		local online = Players:GetPlayerByUserId(a.UserId)
		UI.SetText(row, "PName", tostring(a.Name) .. (online and "  🟢" or ""))
		UI.SetText(row, "Info", "UserId " .. tostring(a.UserId) .. (a.At and ("  ·  since " .. os.date("%d/%m/%Y", a.At)) or ""))
		thumb(a.UserId, row:FindFirstChild("Avatar") :: ImageLabel)
		row.Parent = AList
		confirmButton(row:FindFirstChild("Remove") :: GuiButton, function()
			local res = ask("RemoveAdmin", { UserId = a.UserId })
			if res and res.data then drawAdmins(res.data.Admins) end
		end)
	end
	if #list == 0 then
		local l = (Templates:FindFirstChild("LogLine") :: TextLabel):Clone()
		l.Text = "No admin yet. Add one above."; l.Visible = true; l.Parent = AList
	end
end
onTab.Admins = function()
	local res = ask("ListAdmins")
	if res and res.data then drawAdmins(res.data.Admins) end
end
UI.Button(AddF:WaitForChild("AddName") :: GuiButton, function()
	local b = AddF:FindFirstChild("Name") :: TextBox
	if b.Text == "" then return end
	local res = ask("AddAdmin", { Name = b.Text })
	if res and res.ok then b.Text = "" end
	if res and res.data then drawAdmins(res.data.Admins) end
end)
UI.Button(AddF:WaitForChild("AddSelected") :: GuiButton, function()
	if not needTarget() then return end
	local res = ask("AddAdmin", { Target = selected })
	if res and res.data then drawAdmins(res.data.Admins) end
end)
-- l'onglet n'existe que pour les propriétaires
local function applyOwner()
	local owner = player:GetAttribute("IsOwner") == true
	(Tabs:WaitForChild("Admins") :: GuiObject).Visible = owner
	if not owner and current == "Admins" then showTab("Players") end
end
player:GetAttributeChangedSignal("IsOwner"):Connect(applyOwner)
applyOwner()

-- [ OUVERTURE ] ------------------------------------------------------------------
local scale = Main:FindFirstChild("MenuScale") :: UIScale
local function setOpen(on: boolean)
	if on == Main.Visible then return end
	if on then
		Main.Visible = true
		scale.Scale = 0.85
		TweenService:Create(scale, TweenInfo.new(0.18, Enum.EasingStyle.Back), { Scale = 1 }):Play()
		showTab(current)
	else
		Main.Visible = false
	end
	UI.Play("Click", 0.4)
end
UI.Button(Open, function() setOpen(not Main.Visible) end)
UI.Button(Main:WaitForChild("Close") :: GuiButton, function() setOpen(false) end)
UserInputService.InputBegan:Connect(function(input, processed)
	if processed or not gui.Enabled then return end
	if input.KeyCode == Admins.OpenKey then setOpen(not Main.Visible) end
end)

local function applyAdmin()
	gui.Enabled = player:GetAttribute("IsAdmin") == true
	if not gui.Enabled then Main.Visible = false end
end
player:GetAttributeChangedSignal("IsAdmin"):Connect(applyAdmin)
applyAdmin()

-- rafraîchit la liste toutes les 3 s quand le panel est ouvert
task.spawn(function()
	while true do
		task.wait(3)
		if Main.Visible and (current == "Players" or current == "Events") then refreshPlayers() end
	end
end)

return true
