--!strict
-- Client/FusionController : menu "Fusion" (machine de fusion du lobby, prompt ClientAction = "Fusion").
-- Gauche : mes pets groupés par (nom + mutation). Un clic sur une carte met UN pet de ce groupe
-- dans le prochain emplacement libre ; un clic sur un emplacement le vide. Avec 3 pets :
--   3 identiques  -> résultat garanti : le même, mutation suivante
--   3 différents  -> "?" : pet au hasard de la plus haute rareté (chance d'une rareté au-dessus)
-- FUSE -> serveur ("Fuse", liste des 3 uid), qui revérifie tout. Cartes = clones de Templates.FusionTemplate.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Pets = require(Shared.Config.Pets)
local Mutations = require(Shared.Config.Mutations)
local Lobby = require(Shared.Config.Lobby)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Frame = UI.Frames:WaitForChild("Fusion") :: Frame
local List = Frame:WaitForChild("List") :: ScrollingFrame
local Empty = Frame:WaitForChild("Empty") :: TextLabel
local Panel = Frame:WaitForChild("Panel") :: Frame
local Slots = Panel:WaitForChild("Slots") :: Frame
local Result = Panel:WaitForChild("Result") :: ImageLabel
local FuseBtn = Panel:WaitForChild("FuseButton") :: ImageButton
local Tpl = UI.Templates:WaitForChild("FusionTemplate") :: ImageLabel
local assets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Pets")
local F = Lobby.Fusion
local NEED = F.Count

UI.HookClose(Frame)

local picks: { string } = {} -- uid des pets mis dans la machine
local busy = false
local cards: { [string]: ImageLabel } = {}

local function model(id: string, mut: string): Model?
	local m = Mutations.ById[mut]
	local folder = (m and assets:FindFirstChild(m.Folder)) or assets:FindFirstChild("Normal")
	return folder and folder:FindFirstChild(id) :: Model?
end
local function nextMut(mut: string): any
	local m = Mutations.ById[mut]
	if not m then return nil end
	for _, o in ipairs(Mutations.List) do if o.Order == m.Order + 1 then return o end end
	return nil
end
local function entry(uid: string): any
	local d = State.Data
	return d and d.Pets[uid]
end
local function isPicked(uid: string): boolean
	for _, u in ipairs(picks) do if u == uid then return true end end
	return false
end
-- groupes (nom + mutation) avec la liste de leurs uid (rangés d'abord, puis ceux de l'enclos)
local function groups(): { any }
	local d = State.Data
	local by: { [string]: any } = {}
	if d then
		for uid, e in pairs(d.Pets) do
			local k = e.Id .. "|" .. e.Mut
			local g = by[k]
			if not g then g = { Key = k, Id = e.Id, Mut = e.Mut, Uids = {} }; by[k] = g end
			table.insert(g.Uids, uid)
		end
	end
	local out = {}
	for _, g in pairs(by) do
		table.sort(g.Uids, function(a, b)
			local sa, sb = (d.Pets[a].Slot or 0) > 0, (d.Pets[b].Slot or 0) > 0
			if sa ~= sb then return not sa end
			return a < b
		end)
		table.insert(out, g)
	end
	table.sort(out, function(a, b)
		local pa, pb = Pets.ById[a.Id], Pets.ById[b.Id]
		local ra, rb = pa and Pets.RarityById[pa.Rarity], pb and Pets.RarityById[pb.Rarity]
		local oa, ob = ra and ra.Order or 0, rb and rb.Order or 0
		if oa ~= ob then return oa > ob end
		local xa, xb = Mutations.ById[a.Mut], Mutations.ById[b.Mut]
		local ma, mb = xa and xa.Order or 0, xb and xb.Order or 0
		if ma ~= mb then return ma > mb end
		return a.Id < b.Id
	end)
	return out
end

-- [ PANNEAU DE DROITE ] --------------------------------------------------------------------
local function drawPanel()
	-- on retire les choix qui n'existent plus (vendus, fusionnés...)
	for i = #picks, 1, -1 do if not entry(picks[i]) then table.remove(picks, i) end end
	for i = 1, 3 do
		local sl = Slots:FindFirstChild("Slot" .. i) :: ImageLabel
		local e = picks[i] and entry(picks[i])
		UI.ShowModel(sl:FindFirstChild("View") :: ViewportFrame, e and model(e.Id, e.Mut) or nil, false, 1.3);
		(sl:FindFirstChild("Q") :: GuiObject).Visible = e == nil;
		(sl:FindFirstChild("Remove") :: GuiObject).Visible = e ~= nil
		sl.ImageColor3 = e and (Mutations.ById[e.Mut] or Mutations.ById.Normal).Color:Lerp(Color3.fromRGB(70, 74, 110), 0.6) or Color3.fromRGB(70, 74, 110)
	end
	local rvp = Result:FindFirstChild("View") :: ViewportFrame
	local tag = Result:FindFirstChild("Tag") :: Frame
	local mystery = Result:FindFirstChild("Mystery") :: TextLabel
	local can = false
	if #picks == NEED then
		local a = entry(picks[1])
		local same = true
		for i = 2, NEED do
			local e = entry(picks[i])
			if e.Id ~= a.Id or e.Mut ~= a.Mut then same = false end
		end
		if same then
			local nm = nextMut(a.Mut)
			mystery.Visible = false
			if nm then
				UI.ShowModel(rvp, model(a.Id, nm.Id), true)
				tag.Visible = true; tag.BackgroundColor3 = nm.Color
				UI.SetText(tag, "Text", string.upper(nm.Name))
				UI.SetText(Result, "Name", a.Id)
				UI.SetText(Result, "Income", "$" .. Format.Num(Pets.ById[a.Id].Income * nm.Mult) .. "/s · 100%")
				can = true
			else
				UI.ShowModel(rvp, nil); tag.Visible = false
				UI.SetText(Result, "Name", "MAX MUTATION"); UI.SetText(Result, "Income", "")
			end
		else
			-- mélange : rareté la plus haute, chance d'une au-dessus
			local best = nil
			for _, u in ipairs(picks) do
				local r = Pets.RarityById[Pets.ById[entry(u).Id].Rarity]
				if not best or r.Order > best.Order then best = r end
			end
			local up = Pets.Rarities[best.Order + 1]
			UI.ShowModel(rvp, nil)
			mystery.Visible = true
			tag.Visible = true; tag.BackgroundColor3 = best.Color
			UI.SetText(tag, "Text", "RANDOM")
			UI.SetText(Result, "Name", "Random " .. best.Name)
			UI.SetText(Result, "Income", up and (math.floor(F.UpChance * 100) .. "% chance " .. up.Name .. "!") or "")
			can = true
		end
	else
		UI.ShowModel(rvp, nil); tag.Visible = false; mystery.Visible = false
		UI.SetText(Result, "Name", "Pick " .. (NEED - #picks) .. " more")
		UI.SetText(Result, "Income", "")
	end
	can = can and not busy
	FuseBtn.Image = (FuseBtn:GetAttribute(can and "On" or "Off") :: string?) or FuseBtn.Image
	UI.SetText(FuseBtn, "Text", busy and "..." or (#picks < NEED and (#picks .. " / " .. NEED) or "FUSE!"))
end

-- [ LISTE ] -----------------------------------------------------------------------------------
local function refresh()
	local gs = groups()
	local seen: { [string]: boolean } = {}
	for i, g in ipairs(gs) do
		seen[g.Key] = true
		local c = cards[g.Key]
		if not c then
			c = Tpl:Clone()
			c.Name = g.Key
			c.Visible = true
			local mut = Mutations.ById[g.Mut]
			local tag = c:FindFirstChild("Tag") :: Frame
			tag.BackgroundColor3 = mut.Color
			UI.SetText(tag, "Text", string.upper(mut.Name))
			UI.SetText(c, "Name", g.Id)
			c.Parent = List
			cards[g.Key] = c
			local cc = c
			task.defer(function() if cc.Parent then UI.ShowModel(cc:FindFirstChild("View") :: ViewportFrame, model(g.Id, g.Mut), false, 1.3) end end)
			local key = g.Key
			UI.Button(c:FindFirstChild("Click") :: GuiButton, function()
				if busy or #picks >= NEED then UI.Play("Error", 0.4); return end
				-- premier pet de ce groupe pas encore choisi
				for _, gg in ipairs(groups()) do
					if gg.Key == key then
						for _, uid in ipairs(gg.Uids) do
							if not isPicked(uid) then table.insert(picks, uid); break end
						end
					end
				end
				refresh()
			end)
		end
		c.LayoutOrder = i
		local free = 0
		for _, uid in ipairs(g.Uids) do if not isPicked(uid) then free += 1 end end
		UI.SetText(c, "Count", "x" .. free)
		local ready = #g.Uids >= NEED and nextMut(g.Mut) ~= nil
		(c:FindFirstChild("Ready") :: GuiObject).Visible = ready;
		(c:FindFirstChild("Selected") :: UIStroke).Enabled = free < #g.Uids
		c.ImageColor3 = free == 0 and Color3.fromRGB(44, 48, 70) or (ready and Color3.fromRGB(70, 96, 84) or Color3.fromRGB(64, 70, 104))
	end
	for k, c in pairs(cards) do
		if not seen[k] then c:Destroy(); cards[k] = nil end
	end
	Empty.Visible = #gs == 0
	drawPanel()
end

-- clic sur un emplacement = on le vide
for i = 1, 3 do
	local sl = Slots:WaitForChild("Slot" .. i)
	UI.Button(sl:WaitForChild("Click") :: GuiButton, function()
		if busy or not picks[i] then return end
		table.remove(picks, i)
		refresh()
	end)
end

UI.Button(FuseBtn, function()
	if busy or #picks < NEED then UI.Play("Error", 0.5); return end
	busy = true
	drawPanel()
	for i = 1, 3 do
		local sl = Slots:FindFirstChild("Slot" .. i) :: ImageLabel
		local sc = sl:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", sl)
		TweenService:Create(sc, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0.6 }):Play()
	end
	local res = State.Ask("Fuse", picks)
	for i = 1, 3 do
		local sl = Slots:FindFirstChild("Slot" .. i) :: ImageLabel
		local sc = sl:FindFirstChildOfClass("UIScale")
		if sc then TweenService:Create(sc, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Scale = 1 }):Play() end
	end
	busy = false
	if res and res.ok then
		picks = {}
		UI.Play("LevelUp", 0.6)
		State.Event:Fire("FusionDone", res)
		local rsc = Result:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", Result)
		rsc.Scale = 1.25
		TweenService:Create(rsc, TweenInfo.new(0.4, Enum.EasingStyle.Back), { Scale = 1 }):Play()
	else
		State.Notify:Fire(res and res.msg or "Fusion failed", "error")
	end
	refresh()
end)

State.On({ "Pets" }, function() if Frame.Visible then refresh() end end)
UI.Opened.Event:Connect(function(n) if n == "Fusion" then picks = {}; refresh() end end)

-- prompt de la machine (instance posée dans la map)
local function hook(d: Instance)
	if d:IsA("ProximityPrompt") and d:GetAttribute("ClientAction") == "Fusion" then
		d.Triggered:Connect(function() if UI.Open ~= Frame then UI.Show("Fusion") end end)
	end
end
local map = workspace:WaitForChild("Map")
for _, d in ipairs(map:GetDescendants()) do hook(d) end
map.DescendantAdded:Connect(hook)

-- [ RAPPEL "FUSE READY" ] : bulle + faisceau vers la machine quand on a 3 brainrots identiques
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local hintNotified = false
local beam: Beam? = nil
local function canFuse(): boolean
	for _, g in ipairs(groups()) do if #g.Uids >= NEED then return true end end
	return false
end
local function refreshHint()
	local target = map:FindFirstChild("FuseTarget", true)
	if not target then return end
	local ok = canFuse() and not Frame.Visible
	local bb = target:FindFirstChild("FuseHint") :: BillboardGui?
	if bb then bb.Enabled = ok end
	local att = target:FindFirstChild("Target")
	local sp = att and att:FindFirstChild("FuseSparks") :: ParticleEmitter?
	if sp then sp.Enabled = ok end
	local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if ok and root then
		if not beam or not beam.Parent then
			local tpl = target:FindFirstChild("FuseBeam") :: Beam?
			if tpl then
				local a0 = root:FindFirstChild("FuseFrom") or Instance.new("Attachment")
				a0.Name = "FuseFrom"; a0.Parent = root
				beam = tpl:Clone(); (beam :: Beam).Attachment0 = a0 :: Attachment; (beam :: Beam).Enabled = true; (beam :: Beam).Parent = target
			end
		end
	elseif beam then
		beam:Destroy(); beam = nil
	end
	if ok and not hintNotified then
		hintNotified = true
		State.Notify:Fire("You have 3 identical pets! Fuse them at the Fusion Machine!", "success")
	end
end
State.On({ "Pets" }, refreshHint)
UI.Opened.Event:Connect(function() task.defer(refreshHint) end)
lp.CharacterAdded:Connect(function() beam = nil; task.wait(1); refreshHint() end)
-- le faisceau ne s'affiche que hors de la machine (à moins de 25 studs il disparaît)
task.spawn(function()
	while true do
		task.wait(0.5)
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") :: BasePart?
		local target = map:FindFirstChild("FuseTarget", true) :: BasePart?
		if beam and root and target then beam.Enabled = (root.Position - target.Position).Magnitude > 25 end
	end
end)

return true
