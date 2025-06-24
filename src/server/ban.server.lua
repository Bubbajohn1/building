local DataStoreService = game:GetService("DataStoreService")
local banStore = DataStoreService:GetDataStore("BanDataStore")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BanEvent = ReplicatedStorage:WaitForChild("BanEvent")

BanEvent.OnServerEvent:Connect(function(player)
	-- Save ban to DataStore
	local userId = player.UserId
	local success, err = pcall(function()
		banStore:SetAsync(tostring(userId), true)
	end)
	if success then
		player:Kick("You have banned yourself.")
	else
		warn("Failed to ban user:", err)
	end
end)
