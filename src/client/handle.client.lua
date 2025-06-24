local framework = require(game:GetService("ReplicatedStorage").Shared.instance)
local viewmodelPath: Folder = game:GetService("ReplicatedStorage").Viewmodels
local viewmodel
local tick = require(game:GetService("ReplicatedStorage").Shared.tick)

local lastWeapon = nil

function update()
	if viewmodel then
		viewmodel.Parent = workspace.CurrentCamera
		viewmodel.HumanoidRootPart.CFrame = workspace.CurrentCamera.CFrame
	end
end

function weld(gun)
	local Main: Model = gun.GunComponents.GHandle

	for i, v in ipairs(gun:GetDescendants()) do
		if v:IsA("BasePart") and v ~= Main then
			local NewMotor = Instance.new("Motor6D")
			NewMotor.Name = v.Name
			NewMotor.Part0 = Main
			NewMotor.Part1 = v
			NewMotor.C0 = NewMotor.Part0.CFrame:Inverse() * NewMotor.Part1.CFrame
			NewMotor.Parent = Main
		end
	end
end

function equip(viewmodel, gun)
	local GHandle = gun.GunComponents.GHandle
	local HRP = viewmodel:WaitForChild("HumanoidRootPart")
	local HRP_MOTOR6D = HRP:FindFirstChild("Handle")
	if not HRP_MOTOR6D then
		-- Create the Motor6D if it doesn't exist
		local newMotor = Instance.new("Motor6D")
		newMotor.Name = "Handle"
		newMotor.Part0 = HRP
		newMotor.Parent = HRP
		HRP_MOTOR6D = newMotor
	end
	HRP_MOTOR6D.Part1 = GHandle
end

tick.on_tick(function(dt)
	local currentWeapon = string.lower(framework:get_weapon().name)
	if currentWeapon ~= lastWeapon then
		if viewmodel then
			viewmodel:Destroy()
		end
		local found = viewmodelPath:FindFirstChild(currentWeapon)
		if found then
			viewmodel = found:Clone()
			viewmodel.Parent = workspace.CurrentCamera

			-- Find the gun model for this weapon (adjust path as needed)
			local gun = viewmodel:FindFirstChild(currentWeapon)
			if gun then
				gun.Parent = viewmodel
				print("welding: ", gun.Name)
				weld(gun)
				equip(viewmodel, gun)
			end
		end
		lastWeapon = currentWeapon
	end
	update()
end)

tick.update()
