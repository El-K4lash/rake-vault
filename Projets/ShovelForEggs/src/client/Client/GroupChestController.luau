--!strict
-- Client/GroupChestController : fenêtre GroupChest (coffre FREE EGG du lobby, réservé aux membres du groupe
-- qui ont mis le jeu en favori). S'ouvre quand le serveur refuse le coffre (événement "ChestLocked").
-- Étape 1 : rejoindre le groupe sans quitter le jeu (GroupService:PromptJoinAsync), le serveur revérifie.
-- Étape 2 : mettre le jeu en favori (AvatarEditorService:PromptSetFavorite).
local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local TweenService = game:GetService("TweenService")

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local player = Players.LocalPlayer
local Frame = UI.Frames:WaitForChild("GroupChest") :: Frame
local Glow = Frame.ChestBox:WaitForChild("Glow") :: ImageLabel
local Step1 = Frame:WaitForChild("Step1") :: ImageLabel
local Step2 = Frame:WaitForChild("Step2") :: ImageLabel
local Claim = Frame:WaitForChild("Claim") :: ImageButton
UI.HookClose(Frame)

local status: any = { Group = false, Fav = false, Left = 0 }
local busy = false
local GREEN = Color3.fromRGB(120, 255, 140)

local function setStep(s: ImageLabel, done: boolean, todo: string)
	local go = s:FindFirstChild("Go") :: ImageButton
	UI.SetText(go, "Text", done and "DONE" or todo)
	go.ImageColor3 = done and Color3.fromRGB(110, 160, 115) or Color3.new(1, 1, 1)
	local label = s:FindFirstChild("Text") :: TextLabel
	label.TextColor3 = done and GREEN or Color3.new(1, 1, 1)
end

local function draw()
	setStep(Step1, status.Group == true, "JOIN")
	setStep(Step2, status.Fav == true, "FAVORITE")
	local ready = status.Group and status.Fav
	local left = tonumber(status.Left) or 0
	UI.SetText(Claim, "Text", not ready and "LOCKED" or (left > 0 and string.format("READY IN %d:%02d", left // 60, left % 60) or "OPEN CHEST"))
	Claim.ImageColor3 = (ready and left <= 0) and Color3.new(1, 1, 1) or Color3.fromRGB(120, 120, 130)
end

local function refresh(st: any?)
	if type(st) == "table" then status = st else
		local ok, r = pcall(State.Ask, "ChestStatus")
		if ok and type(r) == "table" then status = r end
	end
	draw()
end

local function open(st: any?)
	refresh(st)
	if UI.Open ~= Frame then UI.Show("GroupChest") end
end

-- étape 1 : rejoindre le groupe (fenêtre Roblox, on reste dans le jeu)
UI.Button(Step1:WaitForChild("Go") :: GuiButton, function()
	if busy or status.Group then return end
	busy = true
	local gid = status.GroupId
	local ok = gid and pcall(GroupService.PromptJoinAsync, GroupService, gid)
	if not ok then State.Notify:Fire("Search \"Stud'io\" on Roblox and join the group!", "info") end
	local ok2, r = pcall(State.Ask, "GroupJoined")
	busy = false
	if ok2 and type(r) == "table" then
		status = r
		if r.Group then UI.Play("Success", 0.6); State.Notify:Fire("Welcome to Stud'io!", "success") end
	end
	draw()
end)

-- étape 2 : favori
-- Roblox renvoie parfois « Failed » alors que le jeu est bien ajouté (ou déjà en favori) : seul « Non »
-- (PermissionDenied) compte comme un refus. Si l'événement n'arrive jamais, on valide quand même après 12 s.
local favPending = 0
local function markFav()
	if status.Fav then return end
	local ok, r = pcall(State.Ask, "Favorited")
	if ok and type(r) == "table" then status = r; UI.Play("Success", 0.6); State.Notify:Fire("Thanks for the favorite!", "success") end
	draw()
end
UI.Button(Step2:WaitForChild("Go") :: GuiButton, function()
	if status.Fav then return end
	-- déjà en favori ? (marche seulement si Roblox l'autorise, sinon on ignore)
	local okF, already = pcall(AvatarEditorService.GetFavoriteAsync, AvatarEditorService, game.PlaceId, Enum.AvatarItemType.Asset)
	if okF and already == true then markFav(); return end
	favPending += 1
	local id = favPending
	pcall(AvatarEditorService.PromptSetFavorite, AvatarEditorService, game.PlaceId, Enum.AvatarItemType.Asset, true)
	task.delay(12, function()
		if favPending == id and not status.Fav then markFav() end
	end)
end)
AvatarEditorService.PromptSetFavoriteCompleted:Connect(function(result)
	favPending += 1 -- annule le délai de secours
	if result == Enum.AvatarPromptResult.PermissionDenied then return end
	markFav()
end)

-- ouvrir le coffre
UI.Button(Claim, function()
	if busy or not (status.Group and status.Fav) then return end
	busy = true
	local ok, r = pcall(State.Ask, "ClaimChest")
	busy = false
	if ok and type(r) == "table" then
		if r.ok then UI.Close() elseif r.msg then State.Notify:Fire(r.msg, "error") end
	end
	refresh()
end)

-- le serveur a refusé le coffre : on ouvre la fenêtre
State.Event.Event:Connect(function(name, payload)
	if name == "ChestLocked" then open(payload) end
end)

-- halo qui tourne doucement + compte à rebours
task.spawn(function()
	local a = 0
	while true do
		task.wait(0.05)
		if Frame.Visible then
			a = (a + 1.5) % 360
			Glow.Rotation = a
		end
	end
end)
task.spawn(function()
	while true do
		task.wait(1)
		if Frame.Visible and (tonumber(status.Left) or 0) > 0 then
			status.Left -= 1
			draw()
		end
	end
end)

return true
