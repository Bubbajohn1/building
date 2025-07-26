local datastore = require(script.data2)

game.Players.PlayerAdded:Connect(function(player: Player)
	local success, result = pcall(function()
		return datastore:GetAsync(1)
	end)
	print(success, result)

	if not success then
		local _success, _result = pcall(function()
			return datastore:SetAsync(1)
		end)
		print(_success, _result)
	end
end)
