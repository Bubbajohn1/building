local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShowBuyEvent = ReplicatedStorage.Events:WaitForChild("BuyEvent")
local buyMenu = game.Players.LocalPlayer.PlayerGui:WaitForChild("buy")
local lplayer = game:GetService("Players").LocalPlayer

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.B then
		ShowBuyEvent:FireServer()
	end
end)

ShowBuyEvent.OnClientEvent:Connect(function(show)
	local buyMenu = game.Players.LocalPlayer.PlayerGui:WaitForChild("buy")
	buyMenu.Enabled = show
	lplayer.CameraMode = show and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson
end)
