local data = require(script.data1)

local params = {
	Url = "https://e101c7eb2a41.ngrok-free.app",
	Method = "POST",
	Headers = {},
	Body = {},
}

local test = data.request(params)
print(test.Astronauts)
