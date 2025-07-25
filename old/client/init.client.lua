local localplayer = game:GetService("Players").LocalPlayer
local character = localplayer.Character or localplayer.CharacterAdded:Wait()
local events = game:GetService("ReplicatedStorage").Events
local reloadEvent = events:WaitForChild("ReloadEvent")
-- hum.WalkSpeed, hum.JumpPower, hum.JumpHeight = 0, 0, 0
local uis = game:GetService("UserInputService")
local framework = require(game:GetService("ReplicatedStorage").Shared.instance)
local config = require(game:GetService("ReplicatedStorage").Shared.config)

uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if config.shopOpen then
		return
	end

	if input.KeyCode == Enum.KeyCode.One then
		framework:set_index(1)
	elseif input.KeyCode == Enum.KeyCode.Two then
		framework:set_index(2)
	elseif input.KeyCode == Enum.KeyCode.Three then
		framework:set_index(3)
	elseif input.KeyCode == Enum.KeyCode.R then
		-- local weapon = framework:get_weapon()
		reloadEvent:FireServer(framework.weapon_index)
	end
end)
