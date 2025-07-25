local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player: Player = Players.LocalPlayer

player.CameraMode = Enum.CameraMode.LockFirstPerson
player.CameraMinZoomDistance = 0.5
player.CameraMaxZoomDistance = 0.5
local gui = player.PlayerGui:WaitForChild("CameraGui")
local frame = gui:FindFirstChild("Frame")
local button = frame:FindFirstChild("TextButton")
local config = require(game.ReplicatedStorage.Shared.config)
local toggle = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.B then
		toggle = not toggle
		button.Modal = toggle
	end
end)
