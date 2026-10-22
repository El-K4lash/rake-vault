local Players = game:GetService("Players")

local ADMIN_IDS = {
	-- [SECURITE] IDs d'inconnus retires : mets ton UserId ici
}

local function isAdmin(userId)
	for _, id in ipairs(ADMIN_IDS) do
		if userId == id then
			return true
		end
	end
	return false
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")

		if isAdmin(player.UserId) then
			humanoid.DisplayName = player.DisplayName .. " ?"
		end
	end)
end)