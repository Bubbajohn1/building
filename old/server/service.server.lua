local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- local buyEvent = events:WaitForChild("BuyEvent")
local data = require(script.Parent:WaitForChild("data"))
local weapons = require(replicatedStorage.Shared.weapons)
-- local ui = require(script.Parent.ui)

players.PlayerAdded:Connect(function(player)
	data.SaveData(player, {
		Cash = 100000,
		Inventory = {},
	})
end)

players.PlayerRemoving:Connect(function(player)
	local playerData = data.LoadData(player)
	playerData.Inventory = {}
	playerData.Cash = 0
	if playerData then
		data.SaveData(player, playerData)
	end
end)
