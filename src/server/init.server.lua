local datastore = require(script.data2)

game.Players.PlayerAdded:Connect(function(player: Player)
	local success, result = pcall(function()
		return datastore:SetAsync(player.UserId, {
			cash = 100,
		})
	end)

	print(success, result)
end)
