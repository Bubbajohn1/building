local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local cashEvent = events:WaitForChild("CashEvent")

local data = require(script.Parent.Parent:WaitForChild("data"))
local weapons = require(replicatedStorage.Shared.weapons)

cashEvent.OnServerEvent:Connect(function(player, reason)
	local playerData = data.LoadData(player)
	if not playerData then
		return
	end

	-- Only allow specific reasons
	local validReasons = {
		round_won = weapons[playerData.Inventory]["KillAward"],
		round_lost = weapons[playerData.Inventory]["KillAward"],
		enemy_killed = weapons[playerData.Inventory]["KillAward"],
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
