local config = {
	maxSpeed = 15.,
	jumpForce = 18.,
	airAcceleration = 10.,
	friction = 8.,
}

--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--

local ContextActionService = game:GetService("ContextActionService")
ContextActionService:BindAction("DisableControls", function()
	return Enum.ContextActionResult.Sink
end, false, unpack(Enum.PlayerActions:GetEnumItems()))
local player = game.Players.LocalPlayer
local function disableJumping(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		-- humanoid.JumpPower = 0
		-- humanoid.JumpHeight = 0
		humanoid.AutoJumpEnabled = false
	end
end
if player.Character then
	disableJumping(player.Character)
end
player.CharacterAdded:Connect(disableJumping)

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Config
-- local friction = 5
-- local ground_accelerate = 100
-- local max_velocity_ground = 50
-- local air_accelerate = 20
-- local max_velocity_air = 50
-- local jump_velocity = 50

-- State
local moveDirection = Vector3.zero
local velocity = Vector3.zero
local jumpInput = false
local grounded = false

-- Accelerate logic from your code
local function dot(v1: Vector3, v2: Vector3): number
	return v1.X * v2.X + v1.Y * v2.Y + v1.Z * v2.Z
end

local function Accelerate(accelDir, prevVelocity, accelerate, maxVelocity, dt)
	local projVel = dot(prevVelocity, accelDir)
	local accelVel = accelerate * dt
	if projVel + accelVel > maxVelocity then
		accelVel = maxVelocity - projVel
	end
	return prevVelocity + accelDir * accelVel
end

local function MoveGround(accelDir, prevVelocity, dt)
	local speed = prevVelocity.Magnitude
	if speed > 0 then
		local drop = speed * config.friction * dt
		prevVelocity *= math.max(speed - drop, 0) / speed
	end
	return Accelerate(accelDir, prevVelocity, config.maxSpeed, config.maxSpeed, dt)
end

local function MoveAir(accelDir, prevVelocity, dt)
	return Accelerate(accelDir, prevVelocity, config.airAcceleration, config.airAcceleration, dt)
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.Space then
		jumpInput = true
	end
end)

-- Get direction from camera + input
local function getMoveDir(camera)
	local dir = Vector3.zero
	local forward = camera.CFrame.LookVector
	local right = camera.CFrame.RightVector

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		dir += forward
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		dir -= forward
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		dir += right
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		dir -= right
	end

	dir = Vector3.new(dir.X, 0, dir.Z)
	return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

-- Detect ground with raycast
local function isGrounded(character)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return false
	end

	local ray = workspace:Raycast(root.Position, Vector3.new(0, -2.1, 0), RaycastParams.new())
	return ray ~= nil
end

-- Main setup per character
local function setupCharacter(character)
	local hrp = character:WaitForChild("HumanoidRootPart")
	local camera = workspace.CurrentCamera
	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.MaxForce = Vector3.new(1e5, 0, 1e5)
	bodyVel.Velocity = Vector3.zero
	bodyVel.P = 1000
	bodyVel.Name = "CustomBodyVelocity"
	bodyVel.Parent = hrp

	RunService.RenderStepped:Connect(function(dt)
		if not hrp or not hrp.Parent then
			return
		end

		local inputDir = getMoveDir(camera)
		grounded = isGrounded(character)

		if grounded then
			if inputDir.Magnitude > 0 then
				velocity = MoveGround(inputDir, velocity, dt)
			else
				local speed = velocity.Magnitude
				if speed > 0 then
					local drop = speed * config.friction * dt * 2
					velocity *= math.max(speed - drop, 0) / speed
				end
			end

			if jumpInput then
				hrp.Velocity = Vector3.new(hrp.Velocity.X, config.jumpForce, hrp.Velocity.Z)
				jumpInput = false
			end
		else
			if inputDir.Magnitude > 0 then
				velocity = MoveAir(inputDir, velocity, dt)
			end
		end

		bodyVel.Velocity = Vector3.new(velocity.X, 0, velocity.Z)
	end)
end

if player.Character then
	setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)
