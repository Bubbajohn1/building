local data = require(script.data1)
local userid = game:GetService("Players"):GetUserIdFromNameAsync("TcQD")

local params = {
	Url = "https://efad0cf70489.ngrok-free.app/addPlayer",
	Method = "POST",
	Headers = {},
	Body = {
		["userid"] = userid,
	},
}

print()
local test = data.request(params)
print(test.Astronauts)
