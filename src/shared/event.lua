local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")

local EventService = {}

-- Cache events/functions
EventService.CashEvent = Events:WaitForChild("CashEvent")
EventService.SetInventoryEvent = Events:WaitForChild("InventoryEvent")
EventService.RequestInventoryEvent = Events:WaitForChild("RequestInventory") -- RemoteFunction

-- Optionally, add a helper to get any event by name
function EventService:Get(name)
	return Events:FindFirstChild(name)
end

return EventService
