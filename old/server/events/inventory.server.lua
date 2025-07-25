local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:FindFirstChild("Events")
local requestInventoryEvent: RemoteFunction = events:FindFirstChild("RequestInventory")
local setInventoryEvent: RemoteEvent = events:FindFirstChild("InventoryEvent")

local data = require(script.Parent.Parent:FindFirstChild("data"))
local weapons = require(replicatedStorage.Shared.weapons)

setInventoryEvent.OnServerEvent:Connect(function(player, newInventory)
	local playerData = data.LoadData(player)
	if not playerData then
		return
	end

	-- Example validation
	for _, weapon in pairs(newInventory) do
		if type(weapon) ~= "table" or type(weapon.name) ~= "string" then
			return -- Invalid inventory, ignore
		end
		if not weapons[weapon.name:lower()] then
			return -- Weapon not allowed
		end
	end

	for i, v in pairs(newInventory) do
		if (v.tier or ""):lower() ~= "knife" then
			local weaponStats = weapons[v.name:lower()]
			v.ammo = weaponStats and weaponStats["Magazine Size"] or 0
			v.reserve = weaponStats and weaponStats["Ammo in Reserve"] or 0
		else
			v.ammo = 0
			v.reserve = 0
		end
	end

	playerData.Inventory = newInventory
	data.SaveData(player, playerData)
end)
requestInventoryEvent.OnServerInvoke = function(player)
	local playerData = data.LoadData(player)

	if not playerData then
		return nil
	end

	return playerData.Inventory or {}
end
