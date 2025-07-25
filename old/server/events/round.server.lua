local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local roundevent: RemoteEvent = events:WaitForChild("RoundEvent")
local data = require(script.Parent.Parent.data)
local weaponStats = require(replicatedStorage.Shared.weapons)

local round = 1

roundevent.OnServerEvent:Connect(function(player, action)
	local playerdata = data.LoadData(player)

	-- player.Team = "Terrorists"

	print("round started")

	if not playerdata or not action or type(action) ~= "string" then
		return
	end

	print("passed playerdata check")

	if action == "start" then
		local team = player.Team
		print("checking team")
		if not team or team == "Neutral" then
			return
		end

		print("team checked success")

		if round == 0 then
			data.SaveData(player, {
				Cash = 10000,
				Inventory = {},
			})
		elseif round == 1 then
			data.SaveData(player, {
				Cash = 800,
				Inventory = {},
			})
		else
		end

		roundevent:FireClient(player, round, {
			name = "deagle",
			tier = "secondary",
			ammo = weaponStats["Magazine Size"],
			reserve = weaponStats["Ammo in Reserve"],
		})
	end
end)
