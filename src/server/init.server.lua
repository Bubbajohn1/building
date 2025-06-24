local players = game:GetService("Players")

local DataStoreService = game:GetService("DataStoreService")
local banStore = DataStoreService:GetDataStore("BanDataStore")
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	local userId = player.UserId
	local isBanned = false
	local success, result = pcall(function()
		return banStore:GetAsync(tostring(userId))
	end)
	if success and result then
		isBanned = true
	end
	if isBanned then
		player:Kick("You are banned from this game.")
	end
end)

players.PlayerAdded:Connect(function(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local hum: Humanoid = character:FindFirstChildOfClass("Humanoid")
	-- hum.WalkSpeed, hum.JumpPower, hum.JumpHeight = 0, 0, 0
end)
