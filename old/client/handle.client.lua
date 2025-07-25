local framework = require(game:GetService("ReplicatedStorage").Shared.instance)
local viewmodelPath: Folder = game:GetService("ReplicatedStorage").Viewmodels
local viewmodel
local tick = require(game:GetService("ReplicatedStorage").Shared.tick)

local lastWeapon = nil

-- Head bobble variables
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local bobbleTime = 0
local bobbleSpeed = 8
local bobbleAmount = 0.0055
local walkThreshold = 0.1

function update(dt)
	if viewmodel then
		viewmodel.Parent = workspace.CurrentCamera

		-- Head bobble logic
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local hrp = character and character:FindFirstChild("HumanoidRootPart")
		local camCF = workspace.CurrentCamera.CFrame

		local offset = CFrame.new()
		if humanoid and hrp then
			local velocity = hrp.Velocity
			local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

			if speed > walkThreshold and humanoid.MoveDirection.Magnitude > 0 then
				bobbleTime = bobbleTime + dt * speed * 0.1
				local bobbleY = math.sin(bobbleTime * bobbleSpeed) * bobbleAmount
				local bobbleX = math.cos(bobbleTime * bobbleSpeed * 0.5) * bobbleAmount * 0.5
				offset = CFrame.new(bobbleX, bobbleY, 0)
			else
				bobbleTime = 0
			end
		end

		viewmodel.HumanoidRootPart.CFrame = camCF * offset
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
	local weapon = framework:get_weapon()
	if not weapon or not weapon.name then
		return
	end
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
				-- print("welding: ", gun.Name)
				weld(gun)
				equip(viewmodel, gun)
			end
		end
		lastWeapon = currentWeapon
	end
	update(dt)
end)

tick.update()
