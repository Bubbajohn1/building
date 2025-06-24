local events = require(script.Parent.event)
local framework = {}
framework.__index = framework

export type weapon = {
	name: string,
}

function framework.new()
	local self = setmetatable({}, framework)

	self.weapon_index = 1
	self.inventory = events.RequestInventoryEvent:InvokeServer() or {}
	-- self.inventory = {
	-- 	[1] = { name = "AK47", ammo = 0, reserve = 0 },
	-- 	[2] = { name = "Deagle", ammo = 0, reserve = 0 },
	-- 	[3] = { name = "sus", ammo = 0, reserve = 0 },
	-- }
	return self
end

function framework:get_weapon()
	return self.inventory[self.weapon_index]
end

function framework:refresh_inventory()
	self.inventory = events.RequestInventoryEvent:InvokeServer() or {}
	framework:get_weapon()
end

function framework:set_index(index: number)
	assert(type(index) == "number" and index > 0 and index <= #self.inventory, "Index must be a valid weapon index")
	self.weapon_index = index
	framework:refresh_inventory()
end

return framework
