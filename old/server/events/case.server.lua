local DataStoreService = game:GetService("DataStoreService")
local playerStore = DataStoreService:GetDataStore("PlayerDataStore")
local replicatedStorage = game:GetService("ReplicatedStorage")
local events = replicatedStorage:WaitForChild("Events")
local CaseEvent: RemoteEvent = events:WaitForChild("CaseEvent")
local skins = require(script.Parent.Parent.skins)
local casePrice = 50

CaseEvent.OnServerEvent:Connect(function(player, case)
	local userId = player.UserId
	local data = playerStore:GetAsync(tostring(userId))

	print(data)
	-- print(playerStore:GetAsync(tostring(userId)))

	if data then
		if data.cash >= casePrice then
			data.cash = data.cash - casePrice
			-- local success, err = pcall(function()
			-- 	playerStore:SetAsync(tostring(userId), data)
			-- end)

			local skin = skins.random(case)
			print(skin)
			CaseEvent:FireClient(player, skin)
			print("fired")

			-- if data.skins[skin] then
			-- 	data.cash = data.cash + (casePrice / 5)
			-- 	return
			-- end

			data.skins[#data.skins + 1] = skin

			local success, err = pcall(function()
				playerStore:SetAsync(tostring(userId), data)
			end)
		end
	end
end)
