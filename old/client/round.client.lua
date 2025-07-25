local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local roundevent: RemoteEvent = events:WaitForChild("RoundEvent")
local framework = require(game.ReplicatedStorage.Shared.instance)

roundevent.OnClientEvent:Connect(function(player, round, weapon)
	if round == 1 then
		framework.inventory[2] = weapon
		framework.refresh_inventory()
	else
		-- local round_gain = 0
	end
end)
