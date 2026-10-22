--!strict
-- Client/MusicController : musique de fond (ReplicatedStorage.Assets.Music, pistes de la lib : thème "brainrot").
-- Playlist mélangée, fondu enchaîné entre les pistes, bouton "Music" du HUD (GUI.HUD.Left.Music) pour couper / remettre.
-- Le choix est sauvegardé (data.Settings.Music, via SettingsService).
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local folder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Music")
local btn = UI.HUD:WaitForChild("Left"):WaitForChild("Music") :: GuiButton
local note = btn:FindFirstChild("Note") :: TextLabel?
local label = btn:FindFirstChild("Text") :: TextLabel?

local VOLUME = 0.35
local FADE = 2.5
local group = Instance.new("SoundGroup"); group.Name = "Music"; group.Volume = 1; group.Parent = SoundService

-- copies locales des pistes (jouées dans SoundService)
local tracks: { Sound } = {}
for _, s in ipairs(folder:GetChildren()) do
	if s:IsA("Sound") then
		local c = s:Clone()
		c.Looped = false; c.Volume = 0; c.SoundGroup = group; c.Parent = SoundService
		table.insert(tracks, c)
	end
end
table.sort(tracks, function(a, b) return ((a:GetAttribute("Order") :: number?) or 0) < ((b:GetAttribute("Order") :: number?) or 0) end)

local enabled = true
local current: Sound? = nil
local order: { number } = {}
local idx = 0

local function shuffle()
	order = {}
	for i = 1, #tracks do order[i] = i end
	for i = #order, 2, -1 do local j = math.random(1, i); order[i], order[j] = order[j], order[i] end
	-- la première partie commence toujours par le thème principal
	if idx == 0 then
		for k, v in ipairs(order) do if v == 1 then order[k], order[1] = order[1], order[k]; break end end
	end
end

local function fadeTo(s: Sound, vol: number, t: number)
	TweenService:Create(s, TweenInfo.new(t, Enum.EasingStyle.Sine), { Volume = vol }):Play()
end

local playNext: () -> ()
function playNext()
	if #tracks == 0 or not enabled then return end
	if idx >= #order then shuffle(); idx = 0 end
	idx += 1
	local s = tracks[order[idx]]
	local prev = current
	if prev and prev ~= s then
		fadeTo(prev, 0, FADE)
		task.delay(FADE, function() if prev ~= current then prev:Stop() end end)
	end
	current = s
	s.TimePosition = 0
	s.Volume = 0
	s:Play()
	fadeTo(s, VOLUME, FADE)
end

for _, s in ipairs(tracks) do
	s.Ended:Connect(function() if s == current and enabled then playNext() end end)
end

local function refreshButton()
	if note then
		note.TextColor3 = enabled and Color3.fromRGB(255, 214, 74) or Color3.fromRGB(130, 130, 140)
		note.Text = "♫"
	end
	if label then label.Text = enabled and "Music" or "Muted" end
end

local function setEnabled(on: boolean, save: boolean)
	if on == enabled and current then refreshButton(); return end
	enabled = on
	refreshButton()
	if on then
		if current and current.IsPaused then
			current:Resume(); fadeTo(current, VOLUME, 1)
		else
			playNext()
		end
	elseif current then
		local c = current
		fadeTo(c, 0, 0.6)
		task.delay(0.6, function() if not enabled then c:Pause() end end)
	end
	if save then State.Send("Setting", "Music", on) end
end

UI.Button(btn, function() setEnabled(not enabled, true) end)

-- réglage sauvegardé
local loaded = false
State.On({ "*", "Settings" }, function()
	local d = State.Data
	if not d or loaded then return end
	loaded = true
	local on = not (d.Settings and d.Settings.Music == false)
	enabled = not on -- force la mise à jour
	setEnabled(on, false)
end)
task.delay(8, function()
	if not loaded then loaded = true; enabled = false; setEnabled(true, false) end
end)

return true
