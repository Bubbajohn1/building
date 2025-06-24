local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local cashEvent = events:WaitForChild("CashEvent")
local requestInventoryEvent: RemoteFunction = events:WaitForChild("RequestInventory")
local setInventoryEvent: RemoteEvent = events:WaitForChild("InventoryEvent")
local reloadEvent: RemoteEvent = events:WaitForChild("ReloadEvent")
local ShowBuyEvent = events:WaitForChild("BuyEvent")
local data = require(script.Parent:WaitForChild("data"))
local weapons = require(replicatedStorage.Shared.weapons)
-- local ui = require(script.Parent.ui)

cashEvent.OnServerEvent:Connect(function(player, reason)
	local playerData = data.LoadData(player)
	if not playerData then
		return
	end

	-- Only allow specific reasons
	local validReasons = {
		round_won = weapons[playerData.Inventory]["KillAward"],
		round_lost = 500,
		enemy_killed = 500,
	}

	local reward = validReasons[reason]
	if reward then
		-- Optionally: Add additional checks here, e.g.:
		-- if reason == "enemy_killed" then
		--     if not player:FindFirstChild("LastKillConfirmed") then return end
		-- end

		playerData.Cash = playerData.Cash + reward
		data.SaveData(player, playerData)
	else
		warn("Invalid cash reason from player:", player.Name, reason)
	end
end)
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
reloadEvent.OnServerEvent:Connect(function(player, weapon)
	local playerData = data.LoadData(player)
	if not playerData or not weapon or not weapon.name then
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

players.PlayerAdded:Connect(function(player)
	player.CameraMode = Enum.CameraMode.LockFirstPerson

	local Inventory = {
		[1] = { name = "AK47", tier = "primary", ammo = 0, reserve = 0 },
		[2] = { name = "Deagle", tier = "secondary", ammo = 0, reserve = 0 },
		[3] = { name = "sus", tier = "knife", ammo = 0, reserve = 0 },
	}

	for i, v in pairs(Inventory) do
		if (v.tier or ""):lower() ~= "knife" then
			local weaponStats = weapons[v.name:lower()]
			v.ammo = weaponStats and weaponStats["Magazine Size"] or 0
			v.reserve = weaponStats and weaponStats["Ammo in Reserve"] or 0
		else
			v.ammo = 0
			v.reserve = 0
		end
	end

	data.SaveData(player, {
		Cash = 0,
		Inventory = Inventory,
	})
end)

local b = false

ShowBuyEvent.OnServerEvent:Connect(function(player, reason)
	-- Optionally: add checks for buy zone, round state, etc.
	b = not b

	if reason then
		-- ui.weapons.init()
	else
		ShowBuyEvent:FireClient(player, b)
	end
end)
-- wipe: local DataStoreService = game:GetService("DataStoreService"); local myDataStore = DataStoreService:GetDataStore("PlayerDataStore");local userId = 100183608; myDataStore:SetAsync(userId, nil) -- This effectively wipes the data

players.PlayerRemoving:Connect(function(player)
	local playerData = data.LoadData(player)
	playerData.Inventory = {}
	playerData.Cash = 0
	if playerData then
		data.SaveData(player, playerData)
	end
end)
