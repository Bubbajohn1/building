local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CaseEvent: RemoteEvent = ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("CaseEvent")

CaseEvent.OnClientEvent:Connect(function(skin)
	-- Handle the received skin here
	print("Case Client Event Called!")
	print("Received skin: " .. skin)
	local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("CaseGui")
	local frame = gui:FindFirstChild("Frame")
	local skinLabel: TextLabel = frame:FindFirstChild("TextLabel")
	skinLabel.Text = "You received: " .. skin
end)
