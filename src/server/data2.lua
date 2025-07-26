local datastore = {}
datastore.__index = datastore

local requests = require(script.Parent.data1)

local URL = "https://bad348cd333b.ngrok-free.app"

type Request = {
	type: string,
	data: { key: string, payload: { [any]: any }? },
	result: any?,
}

datastore.is_ready = false
datastore.requests = {} :: { Request }

local HttpService = game:GetService("HttpService")

function AddRequest(request: Request)
	-- datastore.requests[#datastore.requests + 1] = request
	return request
end

-- Fires a given request
-- Returns the response from the server
function Fire(v: Request)
	-- for i, v in ipairs(datastore.requests) do
	local type = v.type

	if type == "get" then
		local body = {
			Url = URL .. "/get?userid=" .. HttpService:UrlEncode(tostring(v.data.key)),
			Method = "GET",
		}
		local success, result = pcall(requests.request, body)
		if not success then
			return error("server errored with: ", result)
		end

		v.result = result
	elseif type == "set" then
		local body = {
			Url = URL .. "/set",
			Method = "POST",
			Body = { v.data.key, v.data.payload },
		}
		local success, result = pcall(requests.request, body)
		if not success then
			return error("server errored with: ", result)
		end

		v.result = result
	else
		return error("unknown type: ", type)
	end

	print(v.result)

	return v.result
	-- end
end

function datastore:GetAsync(key)
	return Fire(AddRequest({
		type = "get",
		data = {
			key = key,
		},
	}))
end

function datastore:SetAsync(key, payload)
	return Fire(AddRequest({
		type = "set",
		data = {
			key = key,
			payload = payload,
		},
	}))
end

return datastore
