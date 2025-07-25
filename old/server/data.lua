local data = {}

local temp = {}

function data.LoadData(player: Player)
	return temp[player.UserId]
end

function data.SaveData(player: Player, d)
	temp[player.UserId] = d
end

return data
