local public = {}
local inventories = {}
local cashBalances = {}

-- Inventory
function public.setInventory(player: Player, data: {})
	inventories[player.UserId] = data
end

function public.getInventory(player: Player): {}
	if not inventories[player.UserId] then
		wait()
	end
	return inventories[player.UserId] or {}
end

-- Cash
function public.setCash(player: Player, amount: number)
	cashBalances[player.UserId] = amount
end

function public.getCash(player: Player): number
	return cashBalances[player.UserId] or 0
end
-- Optional: Clean up data for a user when they leave
function public.clearUserData(player: Player)
	inventories[player.UserId] = nil
	cashBalances[player.UserId] = nil
end

return public
