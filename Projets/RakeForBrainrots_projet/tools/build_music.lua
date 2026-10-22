-- tools/build_music.lua : musique de fond (Edit, une fois).
--   * ReplicatedStorage.Assets.Music : pistes trouvées dans la lib (jeux "brainrot" / simulateurs du dossier games)
--   * bouton "Music" dans StarterGui.GUI.HUD.Left (copie du bouton Codes, icône = note ♫ jaune contour noir)
-- Logique : Client/MusicController (+ SettingsService pour sauvegarder on/off).
local L = game.StarterGui.GUI.HUD.Left
local old = L:FindFirstChild("Music"); if old then old:Destroy() end
local codes = L.Codes
local m = codes:Clone(); m.Name = "Music"; m.LayoutOrder = (codes.LayoutOrder or 0) + 1
local ic = m:FindFirstChild("Icon")
local note = Instance.new("TextLabel"); note.Name = "Note"; note.BackgroundTransparency = 1
note.Position = ic.Position; note.Size = ic.Size; note.AnchorPoint = ic.AnchorPoint; note.ZIndex = ic.ZIndex
note.Text = "♫"; note.TextScaled = true; note.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
note.TextColor3 = Color3.fromRGB(255, 214, 74)
local s = Instance.new("UIStroke"); s.Name = "Stroke"; s.Thickness = 3; s.Color = Color3.new(0, 0, 0); s.LineJoinMode = Enum.LineJoinMode.Round; s.Parent = note
note.Parent = m
ic:Destroy()
m.Text.Text = "Music"
m.Parent = L

local A = game.ReplicatedStorage.Assets
local mf = A:FindFirstChild("Music"); if mf then mf:Destroy() end
mf = Instance.new("Folder"); mf.Name = "Music"; mf.Parent = A
-- 1 = thème principal (joué en premier) : "Day" du jeu brainrot de la lib (CandyRot)
local tracks = { { "BrainrotDay", 138693920798127 }, { "BrainrotTheme", 140733404109810 }, { "Chill", 115585877205328 }, { "Adventure", 1838583566 } }
for i, t in ipairs(tracks) do
	local snd = Instance.new("Sound"); snd.Name = t[1]; snd.SoundId = "rbxassetid://" .. t[2]; snd.Volume = 0.35; snd.Looped = false
	snd:SetAttribute("Order", i); snd.Parent = mf
end
return "music ok"
