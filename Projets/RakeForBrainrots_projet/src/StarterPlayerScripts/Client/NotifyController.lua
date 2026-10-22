--!strict
-- Client/NotifyController : messages du serveur (Notify), popups (brainrot trouvé, hors ligne,
-- annonces serveur), bannière de zone.
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Format = require(Shared.Util.Format)
local Brainrots = require(Shared.Config.Brainrots)
local Mutations = require(Shared.Config.Mutations)

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local Notifications = UI.Frames:WaitForChild("Notifications") :: Frame
local Banner = UI.Frames:WaitForChild("Banner") :: Frame
local Popup = UI.Frames:WaitForChild("Popup") :: Frame
local tpl = UI.Templates:WaitForChild("NotificationTemplate") :: TextLabel

local COLORS = {
	info = Color3.fromRGB(255, 255, 255),
	error = Color3.fromRGB(255, 90, 90),
	success = Color3.fromRGB(120, 255, 140),
	rune = Color3.fromRGB(120, 220, 255),
}

local function notify(text: string, kind: string?)
	Notifications.Visible = true
	local l = tpl:Clone()
	l.Text = text
	l.TextColor3 = COLORS[kind or "info"] or COLORS.info
	l.Visible = true
	l.TextTransparency = 0
	l.Parent = Notifications
	if kind == "error" then UI.Play("Error", 0.5) end
	task.delay(2.5, function()
		TweenService:Create(l, TweenInfo.new(0.4), { TextTransparency = 1 }):Play()
		task.wait(0.4)
		l:Destroy()
	end)
	-- max 4 messages
	local kids = {}
	for _, c in ipairs(Notifications:GetChildren()) do if c:IsA("TextLabel") then table.insert(kids, c) end end
	while #kids > 4 do table.remove(kids, 1):Destroy() end
end
State.Notify.Event:Connect(notify)

-- bannière (zone, rebirth)
local bannerTween: Tween?
local function banner(top: string, bottom: string, color: Color3?)
	local a = Banner:FindFirstChild("NewLevel") :: TextLabel
	local b = Banner:FindFirstChild("NewSpeed") :: TextLabel
	a.Text = top
	b.Text = bottom
	a.TextColor3 = color or Color3.new(1, 1, 1)
	Banner.Visible = true
	a.TextTransparency = 0; b.TextTransparency = 0
	task.delay(2.2, function()
		local t = TweenService:Create(a, TweenInfo.new(0.5), { TextTransparency = 1 })
		TweenService:Create(b, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
		t:Play()
		t.Completed:Once(function() if a.TextTransparency >= 1 then Banner.Visible = false end end)
	end)
end
UI.Banner = banner :: any

-- popup : brainrot trouvé (modèle en 3D + nom + rareté)
local popupQueue = {}
local showing = false
local function showPopup(entry: { Id: string, Mut: string, Rarity: string })
	showing = true
	local br = Brainrots.ById[entry.Id]
	local r = br and Brainrots.RarityById[br.Rarity]
	local mut = Mutations.ById[entry.Mut] or Mutations.ById.Normal
	UI.SetText(Popup, "Name", entry.Id)
	local rl = Popup:FindFirstChild("Rarity", true) :: TextLabel?
	if rl and r then rl.Text = (mut.Id ~= "Normal" and (mut.Name .. " ") or "") .. r.Name; rl.TextColor3 = mut.Id ~= "Normal" and mut.Color or r.Color end
	UI.SetText(Popup, "Income", br and ("+" .. Format.Money(br.Income * mut.Mult) .. "/s") or "")
	local vp = Popup:FindFirstChild("View", true) :: ViewportFrame?
	local assets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Brainrots")
	local folder = assets:FindFirstChild(mut.Folder) or assets:FindFirstChild("Normal")
	local model = folder and folder:FindFirstChild(entry.Id) :: Model?
	if vp then UI.ShowModel(vp, model, true) end
	local s = Popup:FindFirstChild("MenuScale") :: UIScale? or Instance.new("UIScale")
	s.Name = "MenuScale"; s.Parent = Popup
	s.Scale = 0.6
	Popup.Visible = true
	TweenService:Create(s, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	UI.Play(r and r.Order >= 4 and "Win" or "Success", 0.6)
	task.wait(2.6)
	local t = TweenService:Create(s, TweenInfo.new(0.2), { Scale = 0.6 })
	t:Play(); t.Completed:Wait()
	Popup.Visible = false
	showing = false
end
local function queuePopup(e)
	table.insert(popupQueue, e)
	if showing then return end
	task.spawn(function()
		while #popupQueue > 0 do
			showPopup(table.remove(popupQueue, 1))
		end
	end)
end

State.Event.Event:Connect(function(name, payload)
	if name == "BrainrotFound" then
		queuePopup(payload)
	elseif name == "ServerAnnounce" then
		local mut = payload.Mut ~= "Normal" and (payload.Mut .. " ") or ""
		notify(payload.Player .. " found a " .. mut .. payload.Rarity .. " " .. payload.Id .. "!", "success")
	elseif name == "AdminAnnounce" then
		banner("📢 ANNOUNCEMENT", tostring(payload), Color3.fromRGB(255, 214, 90))
		notify(tostring(payload), "success")
		UI.Play("LevelUp", 0.5)
	elseif name == "Offline" then
		notify("Welcome back! Your base made " .. Format.Money(payload.Money) .. " while you were away (" .. Format.Time(payload.Seconds) .. ")", "success")
	elseif name == "Rebirthed" then
		banner("REBIRTH " .. tostring(payload) .. "!", "+25% money · new zone unlocked", Color3.fromRGB(178, 107, 255))
		UI.Play("LevelUp", 0.7)
	elseif name == "BagFull" then
		notify("Bag full! Walk on a green SELL pad.", "error")
	elseif name == "IndexNew" then
		notify("New index entry: " .. payload.Id .. (payload.Mut ~= "Normal" and (" (" .. payload.Mut .. ")") or ""), "info")
	end
end)

return true
