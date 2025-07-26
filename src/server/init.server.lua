local datastore = require(script.data2)

game.Players.PlayerAdded:Connect(function(player: Player)
	print(datastore:SetAsync(player.UserId, {
		cash = 100,
	}))
end)
