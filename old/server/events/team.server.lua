local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local teamEvent = events:WaitForChild("TeamEvent")
local requestTeamEvent = events:WaitForChild("RequestTeam")

teamEvent.OnServerEvent:Connect(function(player: Player, team: Team)
	if player.Team.Name ~= "Neutral" then
		return
	end

	player.Team = team
end)
requestTeamEvent.OnServerInvoke = function(player: Player)
	return player.Team
end
