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
function Fire(request: Request)
	-- for i, v in ipairs(datastore.requests) do
	local type = request.type

	if type == "get" then
		local body = {
			Url = URL .. "/get?userid=" .. HttpService:UrlEncode(tostring(request.data.key)),
			Method = "GET",
		}
		local success, result = pcall(requests.request, body)
		if not success then
			return error("server errored with: ", result)
		end

		request.result = result
	elseif type == "set" then
		local body = {
			Url = URL .. "/set",
			Method = "POST",
			Body = { request.data.key, request.data.payload },
		}
		local success, result = pcall(requests.request, body)
		if not success then
			return error("server errored with: ", result)
		end

		request.result = result
	else
		return error("unknown type: ", type)
	end

	print(request.result)

	return request.result
	-- end
end

function datastore:GetAsync(key)
	local response = Fire(AddRequest({
		type = "get",
		data = {
			key = key,
		},
	}))

	if not response.Success or response.StatusCode ~= 200 then
		error("Request failed: " .. response.StatusCode)
	end

	return response
end

function datastore:SetAsync(key, payload)
	local response = Fire(AddRequest({
		type = "set",
		data = {
			key = key,
			payload = payload or {},
		},
	}))

	if not response.Success or response.StatusCode ~= 200 then
		error("Request failed: " .. response.StatusCode)
	end

	return response
end

return datastore
