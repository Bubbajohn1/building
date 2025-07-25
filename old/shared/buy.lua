-- BuyMenuModule
local BuyMenu = {}
BuyMenu.__index = BuyMenu

type BuyElements = {
	Gui: ScreenGui,
	MainFrame: Frame,
	Body: Frame,
}

function BuyMenu.new(team, elements: BuyElements)
	local self = setmetatable({}, BuyMenu)
	self.team = team
	self.elements = elements
	return self
end

local categories = {
	["Pistols"] = {
		{ name = "Glock-18", code = "glock", price = 200 },
		{ name = "USP-S", code = "usp", price = 200 },
		{ name = "Desert Eagle", code = "deagle", price = 700 },
	},
	["Rifles"] = {
		{ name = "AK-47", code = "ak47", price = 2700 },
		{ name = "M4A1-S", code = "m4a1s", price = 3100 },
	},
	["Mid-Tier"] = {
		{ name = "MAC-10", code = "mac10", price = 1050 },
		{ name = "MP9", code = "mp9", price = 1250 },
	},
	["Equipment"] = {
		{ name = "Kevlar Vest", code = "kevlar", price = 650 },
		{ name = "Kevlar + Helmet", code = "kevlar_helmet", price = 1000 },
	},
	["Grenades"] = {
		{ name = "HE Grenade", code = "he_grenade", price = 300 },
		{ name = "Flashbang", code = "flashbang", price = 200 },
	},
}

function BuyMenu:GetCategories()
	return categories
end

function BuyMenu:GetWeaponsInCategory(category)
	return categories[category]
end

return BuyMenu
