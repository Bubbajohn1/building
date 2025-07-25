local data = {}

type SendData = {
	Url: string,
	Method: string,
	Body: { [string]: any }?,
	Headers: { [string]: string }?,
}

-- Add custom types to fit return data
type ReturnData = {
	Astronauts: number?,
}

local HttpService = game:GetService("HttpService")

function mergeTables(t1, t2)
	-- Merge t2 into t1 (t1 overwritten by t2 on same keys)
	local result = {}
	for k, v in pairs(t1 or {}) do
		result[k] = v
	end
	for k, v in pairs(t2 or {}) do
		result[k] = v
	end
	return result
end

local secret = "s3cr3t-t0k3n-1234567890"

function data.request(body: SendData)
	local payload = ""
	local jsonBody = ""
	if body.Method ~= "GET" and body.Method ~= "HEAD" and body.Body then
		jsonBody = payload ~= "" and payload or HttpService:JSONEncode(body.Body)
	end

	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer " .. secret,
	}

	headers = mergeTables(headers, body.Headers)

	local requestOptions = {
		Url = body.Url,
		Method = body.Method,
		Headers = headers,
	}

	if jsonBody ~= "" then
		requestOptions.Body = jsonBody
	end

	local success, result = pcall(function()
		return HttpService:RequestAsync(requestOptions)
	end)

	if success and result.Success then
		local responseData = HttpService:JSONDecode(result.Body)
		local format: ReturnData = {}

		format["Astronauts"] = responseData.number

		return format :: ReturnData
	else
		warn("HTTP Request failed", result.StatusCode, result.StatusMessage)
		return nil
	end
end

return data
