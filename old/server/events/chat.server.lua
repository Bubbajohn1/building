local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local chatEvent: RemoteEvent = events:WaitForChild("ChatEvent")

chatEvent.OnServerEvent:Connect(function(player, message)
	if not player or not message or type(message) ~= "string" then
		return
	end

	-- Basic validation: Check if the message is empty or too long
	if message == "" or #message > 200 then
		return
	end

	for i, v in pairs(game.Players:GetPlayers()) do
		chatEvent:FireClient(v, message)
	end
end)
