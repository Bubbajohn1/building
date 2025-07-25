local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local reloadEvent: RemoteEvent = events:WaitForChild("ReloadEvent")
-- local buyEvent = events:WaitForChild("BuyEvent")
local data = require(script.Parent.Parent:WaitForChild("data"))
local weapons = require(replicatedStorage.Shared.weapons)

reloadEvent.OnServerEvent:Connect(function(player, index)
	local playerData = data.LoadData(player)
	if not playerData then
		return
	end

	local weapon = playerData.Inventory[index]

	if not weapon or not weapon.name then
		return
	end

	-- Find the weapon entry in inventory
	local weaponEntry
	for _, v in pairs(playerData.Inventory) do
		if v.name:lower() == weapon.name:lower() then
			weaponEntry = v
			break
		end
	end
	if not weaponEntry then
		return
	end

	local weaponStats = weapons[weaponEntry.name:lower()]
	if not weaponStats then
		return
	end

	local magSize = weaponStats["Magazine Size"]
	local reserve = weaponEntry.reserve or 0
	local ammo = weaponEntry.ammo or 0

	-- Calculate how much to reload
	local needed = magSize - ammo
	if needed <= 0 or reserve <= 0 then
		return
	end

	local toReload = math.min(needed, reserve)
	weaponEntry.ammo = ammo + toReload
	weaponEntry.reserve = reserve - toReload

	data.SaveData(player, playerData)
end)
