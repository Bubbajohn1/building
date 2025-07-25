local data = require(script.data1)

local params = {
	Url = "https://efad0cf70489.ngrok-free.app/addPlayer",
	Method = "POST",
	Headers = {},
}

game.Players.PlayerAdded:Connect(function(player: Player)
	params.Body = {
		["userid"] = player.UserId,
	}

	data.request(params)
end)
