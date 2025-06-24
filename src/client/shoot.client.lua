local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShootEvent = ReplicatedStorage.Events:WaitForChild("ShootEvent")
local framework = require(game:GetService("ReplicatedStorage").Shared.instance)

local isFiring = false

local old_index = framework.weapon_index

function shoot()
	local weapon = framework:get_weapon()
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
			local origin = workspace.CurrentCamera.CFrame.Position
			local direction = workspace.CurrentCamera.CFrame.LookVector * weaponData["Bullet Range"]
			ShootEvent:FireServer(origin, direction, weapon)
			task.wait(60 / weaponData["Fire Rate"])
		end
	else
		local origin = workspace.CurrentCamera.CFrame.Position
		local direction = workspace.CurrentCamera.CFrame.LookVector * weaponData["Bullet Range"]
		ShootEvent:FireServer(origin, direction, weapon)
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProcessed then
		shoot()
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isFiring = false
	end
end)
