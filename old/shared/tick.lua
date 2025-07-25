local tick = {}
local rs = game:GetService("RunService")
local connection
tick.rate = 128
tick.interval = 1 / tick.rate
tick.lag = 0 -- artificial lag in seconds
tick._accumulator = 0
tick._callbacks = {}
tick._running = false

function tick.set_rate(rate)
	assert(type(rate) == "number" and rate > 0, "Rate must be a positive number")
	tick.rate = rate
	tick.interval = 1 / rate
end

function tick.on_tick(callback)
	assert(type(callback) == "function", "Callback must be a function")
	table.insert(tick._callbacks, callback)
end

function tick.update()
	if tick._running then
		return
	end
	tick._running = true

	local MAX_TICKS_PER_FRAME = 5

	if rs:IsClient() then
		rs.RenderStepped:Connect(function(dt)
			tick._accumulator = tick._accumulator + dt
			local ticks = 0
			while tick._accumulator >= tick.interval and ticks < MAX_TICKS_PER_FRAME do
				for _, callback in ipairs(tick._callbacks) do
					callback(tick.interval)
				end
				tick._accumulator = tick._accumulator - tick.interval
				ticks = ticks + 1
			end
		end)
	else -- Server
		rs.Heartbeat:Connect(function(dt)
			tick._accumulator = tick._accumulator + dt
			local ticks = 0
			while tick._accumulator >= tick.interval and ticks < MAX_TICKS_PER_FRAME do
				for _, callback in ipairs(tick._callbacks) do
					callback(tick.interval)
				end
				tick._accumulator = tick._accumulator - tick.interval
				ticks = ticks + 1
			end
		end)
	end
end

function tick.end_tick()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	tick._callbacks = {}
	tick._accumulator = 0
	tick._running = false
end

return tick
