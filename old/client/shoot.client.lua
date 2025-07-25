local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShootEvent = ReplicatedStorage.Events:WaitForChild("ShootEvent")
local framework = require(game:GetService("ReplicatedStorage").Shared.instance)
local config = require(game:GetService("ReplicatedStorage").Shared.config)
local isFiring = false
local player = game.Players.LocalPlayer
local old_index = framework.weapon_index

function shoot()
	local weapon = framework:get_weapon()
	-- print(weapon)
	-- print(weapon.name)
	-- if not weapon or weapon.name then
	-- 	return
	-- end

	if not player.Character or not player.Character:FindFirstChild("Humanoid") then
		return
	end

	if player.Character.Humanoid.Health <= 0 then
		return
	end

	local weaponData = require(ReplicatedStorage.Shared.weapons)[weapon.name:lower()]
	if not weaponData then
		return
	end

	if weaponData["FullAuto"] == 1 then
		isFiring = true
		old_index = framework.weapon_index -- Set old_index when firing starts
		while isFiring do
			-- Stop firing if weapon index changed
			if framework.weapon_index ~= old_index then
				isFiring = false
				break
			end
			ShootEvent:FireServer(framework.weapon_index)
			-- create_beam(origin, direction)
			task.wait(60 / weaponData["Fire Rate"])
		end
	else
		-- create_beam(origin, direction)
		ShootEvent:FireServer(framework.weapon_index)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if config.shopOpen then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
		shoot()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isFiring = false
	end
end)
