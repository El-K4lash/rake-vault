--!strict
-- Client/StormController : les tempêtes côté joueur.
--   * compte à rebours dans le HUD (GUI.HUD.Storm, vraie instance : tools/build_storm_hud.lua)
--   * bannière à l'annonce (20 s avant), au début et à la fin ; toute la météo (neige, vent, lumière) : StormFxController.
--   * tempête dorée : le texte du HUD passe en doré et pulse.
local TweenService = game:GetService("TweenService")

local State = require(script.Parent.State)
local UI = require(script.Parent.UI)

local stormUi = UI.HUD:FindFirstChild("Storm") :: Frame?
local label = stormUi and stormUi:FindFirstChild("Text") :: TextLabel?
local icon = stormUi and stormUi:FindFirstChild("Icon") :: ImageLabel?

local WHITE = Color3.fromRGB(255, 255, 255)
local BLUE = Color3.fromRGB(150, 225, 255)
local GOLD = Color3.fromRGB(255, 220, 90)

local function fmt(s: number): string
	s = math.max(0, math.floor(s))
	return string.format("%d:%02d", s // 60, s % 60)
end

local function refresh()
	if not label then return end
	local kind = workspace:GetAttribute("StormKind")
	local now = workspace:GetServerTimeNow() -- horloge du serveur (l'horloge du PC peut être décalée)
	if kind == "Golden" then
		label.Text = "GOLDEN STORM  " .. fmt((workspace:GetAttribute("StormEnd") :: number? or now) - now)
		label.TextColor3 = GOLD
	elseif kind == "Snow" then
		label.Text = "SNOW STORM  " .. fmt((workspace:GetAttribute("StormEnd") :: number? or now) - now)
		label.TextColor3 = BLUE
	else
		local nextAt = workspace:GetAttribute("NextStorm") :: number?
		if nextAt then
			label.Text = "Next storm  " .. fmt(nextAt - now)
			label.TextColor3 = WHITE
		else
			label.Text = ""
		end
	end
end

task.spawn(function()
	while true do
		refresh()
		task.wait(1)
	end
end)
workspace:GetAttributeChangedSignal("StormKind"):Connect(refresh)

-- pulsation du cadre pendant une tempête
local pulse: Tween? = nil
local function setPulse(on: boolean, color: Color3)
	if pulse then pulse:Cancel(); pulse = nil end
	if not icon then return end
	icon.ImageColor3 = color
	if on then
		pulse = TweenService:Create(icon, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { ImageTransparency = 0.5 })
		pulse:Play()
	else
		icon.ImageTransparency = 0
	end
end

State.Event.Event:Connect(function(name, payload)
	if name == "StormWarning" then
		if UI.Banner then (UI.Banner :: any)("STORM INCOMING", "Snow is coming back in " .. tostring(payload and payload.In or 20) .. "s!", BLUE) end
		UI.Play("Normal", 0.4)
	elseif name == "StormStart" then
		local golden = payload and payload.Kind == "Golden"
		if UI.Banner then
			(UI.Banner :: any)(golden and "GOLDEN STORM!" or "SNOW STORM!", golden and "x3 luck & better eggs for 2 min! Golden Eggs at the North Pole!" or "All zones are covered in fresh snow!", golden and GOLD or BLUE)
		end
		UI.Play(golden and "Win" or "LevelUp", 0.6)
		setPulse(true, golden and GOLD or BLUE)
	elseif name == "StormEnd" then
		setPulse(false, WHITE)
		if UI.Banner then (UI.Banner :: any)("STORM OVER", "", WHITE) end
	end
end)

return true
