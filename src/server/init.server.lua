local datastore = require(script.data2)

game.Players.PlayerAdded:Connect(function(player: Player)
	local success, result = pcall(function()
		return datastore:GetAsync(player.UserId)
	end)

	if not success then
		local _success, _result = pcall(function()
			return datastore:SetAsync(player.UserId)
		end)
	end
end)
