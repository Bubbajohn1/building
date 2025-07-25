-- Server
local ReplicatedStorage = game:GetService("ReplicatedStorage").Events
local ShootEvent = ReplicatedStorage:WaitForChild("ShootEvent")
local data = require(game:GetService("ReplicatedStorage").Shared.weapons)
local datastore = require(script.Parent.data)
-- local framework = require(game:GetService("ReplicatedStorage").Shared.instance)

local bodyPartToWeaponKey = {
	Head = "Damage  (Head)",
	UpperTorso = "Damage (Chest & Arms)",
	LowerTorso = "Damage (Stomach)",
	LeftArm = "Damage (Chest & Arms)",
	RightArm = "Damage (Chest & Arms)",
	LeftLeg = "Damage (Legs)",
	RightLeg = "Damage (Legs)",
	-- Add more mappings if needed
}

-- local weapon = framework:get_weapon() -- Get the current weapon from the framework
local weapons = require(game:GetService("ReplicatedStorage").Shared.weapons)
local function ensureInventoryFields(inventory)
	for _, v in pairs(inventory) do
		-- print("INDEX: ", v)
		if v.tier == "knife" then
			continue
		end
		if v.ammo == nil then
			v.ammo = weapons[v.name:lower()]["Magazine Size"]
		end
		if v.reserve == nil then
			v.reserve = weapons[v.name:lower()]["Ammo in Reserve"]
		end
	end
end

local lastFireTimes = {}

function create_beam(origin, direction)
	local MAX_DISTANCE = 1000 -- studs
	local TRACER_COLOR = Color3.fromRGB(255, 255, 0)
	local TRACER_TRANSPARENCY = 0.3
	local TRACER_THICKNESS = 0.2
	local TRACER_TIME = 10 -- how long the tracer lasts

	-- Create tracer part
	local tracer = Instance.new("Part")
	tracer.Anchored = true
	tracer.CanCollide = false
	tracer.Material = Enum.Material.Neon
	tracer.Color = TRACER_COLOR
	tracer.Transparency = TRACER_TRANSPARENCY
	tracer.Size =
		Vector3.new(TRACER_THICKNESS, TRACER_THICKNESS, (origin - origin + direction.Unit * MAX_DISTANCE).Magnitude)
	tracer.CFrame = CFrame.new(origin, origin + direction.Unit * MAX_DISTANCE) * CFrame.new(0, 0, -tracer.Size.Z / 2)
	tracer.Parent = workspace

	-- Optionally delete tracer after a short delay
	game.Debris:AddItem(tracer, TRACER_TIME)
end

ShootEvent.OnServerEvent:Connect(function(player, index)
	local playerData = datastore.LoadData(player)
	if not playerData then
		return
	end
	print("printing playerdata")
	print(playerData)
	print(playerData.Inventory)
	-- local weapon = framework.inventory[framework.weapon_index]
	local weapon = playerData.Inventory[index]
	local weaponName = weapon.name:lower()
	local weaponData = weapons[weaponName]
	if not weaponData then
		return
	end
	local origin = workspace.CurrentCamera.CFrame.Position
	local direction = workspace.CurrentCamera.CFrame.LookVector * weaponData["Bullet Range"]
	local now = tick()
	lastFireTimes[player] = lastFireTimes[player] or {}
	local lastFire = lastFireTimes[player][weaponName] or 0
	local fireDelay = 60 / weaponData["Fire Rate"]

	if now - lastFire < fireDelay then
		return -- Too soon, ignore
	end

	lastFireTimes[player][weaponName] = now
	ensureInventoryFields(playerData.Inventory)

	local ammo = nil
	local reserve = nil
	for i, v in pairs(playerData.Inventory) do
		if v.name:lower() == weapon.name:lower() then
			-- warn("FOUND MATCH: ", v.name, "Ammo:", v.ammo, "Reserve:", v.reserve)
			ammo = v.ammo
			reserve = v.reserve
		end
	end

	if ammo == nil or reserve == nil then
		-- return error("ammo or reserve are nil")
		return
	end

	if ammo <= 0 then
		-- return print("no ammo")
		return
	end

	if reserve <= 0 and ammo <= 0 then
		return
	end

	for i, v in pairs(playerData.Inventory) do
		if v.name:lower() == weapon.name:lower() then
			v.ammo = v.ammo - 1
			print("decreased ammo by 1: ", v.ammo)
		end
	end

	datastore.SaveData(player, playerData)

	if player.Character.Humanoid.Health <= 0 then
		return
	end
	-- Validate input types
	if typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then
		return
	end

	-- Optionally: Check if player is allowed to shoot (cooldown, ammo, etc.)

	-- Optionally: Clamp origin to player's character position to prevent exploits
	local character = player.Character
	if not character or not character:FindFirstChild("Head") then
		return
	end
	local headPos = character.Head.Position
	if (origin - headPos).Magnitude > 10 then
		-- Too far from player, possible exploit
		return
	end

	-- Perform raycast
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(origin, direction, raycastParams)
	create_beam(origin, direction)
	if result then
		local hitPart = result.Instance
		local hitHumanoid = hitPart.Parent:FindFirstChildOfClass("Humanoid")
		if hitHumanoid and hitPart.Parent ~= character then
			local hitKey = bodyPartToWeaponKey[hitPart.Name]
			local damage = weaponData[hitKey] or weaponData["Damage"]
			hitHumanoid:TakeDamage(damage)
		end
	end
end)
