local UserInputService = game:GetService("UserInputService")
local config = require(game.ReplicatedStorage.Shared.config)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.B then
		local buyMenu = game.Players.LocalPlayer.PlayerGui:WaitForChild("buy")
		buyMenu.Enabled = not buyMenu.Enabled
		config.shopOpen = buyMenu.Enabled
	end
end)
