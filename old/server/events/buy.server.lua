local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local buyEvent: RemoteEvent = events:WaitForChild("BuyEvent")
-- local buyEvent = events:WaitForChild("BuyEvent")
local data = require(script.Parent.Parent:WaitForChild("data"))
local weapons = require(replicatedStorage.Shared.weapons)
-- local ui = require(script.Parent.ui)

buyEvent.OnServerEvent:Connect(function(player, weaponName)
	print("Player " .. player.Name .. " is trying to buy weapon: " .. weaponName)
	-- add checks to ensure player is allowed to buy this weapon, they are in the buy zone, correct team, etc.
	local playerData = data.LoadData(player)
	if not playerData then
		return
	end

	print("Player " .. player.Name .. " has " .. playerData.Cash .. " cash.")

	local weaponStats = weapons[weaponName:lower()]
	if not weaponStats then
		return
	end

	print("Weapon stats for " .. weaponName .. ":")

	local cost = weaponStats["Price"]
	if playerData.Cash < cost then
		return -- Not enough cash
	end

	print("Cost: " .. cost)

	-- Check if the weapon is already in inventory
	-- for _, v in pairs(playerData.Inventory) do
	-- 	if v.name:lower() == weaponName:lower() then
	-- 		return -- Already have this weapon
	-- 	end
	-- end

	print("Weapon is not in inventory, proceeding to add.")

	local type = weaponStats["Type"]
	if type ~= "primary" and type ~= "secondary" and type ~= "knife" then
		return -- Invalid weapon type
	end

	print("Weapon type: " .. type)

	local priv = {
		["primary"] = 1,
		["secondary"] = 2,
		["knife"] = 3,
	}

	-- -- Add the weapon to inventory
	-- table.insert(playerData.Inventory, {
	-- 	name = weaponName,
	-- 	tier = weaponStats["Tier"],
	-- 	ammo = weaponStats["Magazine Size"],
	-- 	reserve = weaponStats["Ammo in Reserve"],
	-- })

	playerData.Inventory[priv[type]] = {
		name = weaponName,
		tier = type,
		ammo = weaponStats["Magazine Size"],
		reserve = weaponStats["Ammo in Reserve"],
	}

	playerData.Cash = playerData.Cash - cost
	print("Player " .. player.Name .. " bought " .. weaponName .. " for " .. cost .. " cash.")
	print("Remaining cash: " .. playerData.Cash)
	data.SaveData(player, playerData)
	events:FindFirstChild("InventoryEvent"):FireClient(player)
end)
