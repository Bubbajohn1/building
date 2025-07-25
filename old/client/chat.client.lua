local player: Player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local chatEvent = events:WaitForChild("ChatEvent")

player.Chatted:Connect(function(message)
	if not message or type(message) ~= "string" then
		return
	end

	-- Basic validation: Check if the message is empty or too long
	if message == "" or #message > 200 then
		return
	end
	chatEvent:FireServer(message)

	local function switch(var, cases)
		for i, v in ipairs(cases) do
			if i == var and i ~= "default" then
				return v()
			end

			return cases["default"]()
		end
	end

	if message:sub(1, 1) == "/" then
		switch(message:sub(2):lower(), {
			["help"] = function()
				return "Available commands: /help, /stats, /inventory"
			end,

			["default"] = function()
				return "Unknown command. Type /help for a list of commands."
			end,
		})
	end
end)

chatEvent.OnClientEvent:Connect(function(message)
	if not message or type(message) ~= "string" then
		return
	end

	-- Display the message in the chat UI
	local chatBox = player.PlayerGui:FindFirstChild("ChatBox")
	if chatBox then
		local newMessage = Instance.new("TextLabel")
		newMessage.Text = message
		newMessage.Size = UDim2.new(1, 0, 0, 20)
		newMessage.BackgroundTransparency = 1
		newMessage.TextColor3 = Color3.new(1, 1, 1)
		newMessage.Parent = chatBox
	end
end)
