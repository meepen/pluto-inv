pluto.trades = pluto.trades or {}

local opposites = setmetatable({
	inbound = "outbound",
	outbound = "inbound"
}, {
	__index = function(s, a)
		return a
	end
})

pluto.trades.status = pluto.trades.status or setmetatable({
	-- [ply][oply] = "inbound" | "outbound" | "none" | "in progress"
}, {
	__index = function(self, ply)
		self[ply] = setmetatable({}, {
			__index = function(s, oply)
				if (oply == ply) then
					return "none"
				end

				if (rawget(self[oply], ply)) then
					return opposites[self[oply][ply]]
				end

				return "none"
			end,
			__newindex = function(s, oply, data)
				if (ply == oply) then
					return
				end

				if (rawget(self[oply], ply)) then
					self[oply][ply] = opposites[data]
					pluto.trades.updatefor(ply, oply)
					return
				end

				rawset(s, oply, data)
				pluto.trades.updatefor(ply, oply)
			end
		})
		return self[ply]
	end,
	__call = function(self, ply, oply, status)
		if (status) then
			self[ply][oply] = status
		else
			return self[ply][oply]
		end
	end
})

function pluto.trades.get(ply, oply)
	return pluto.trades.status[ply][oply]
end

function pluto.trades.set(ply, oply, status)
	pluto.trades.status[ply][oply] = status
end

function pluto.trades.updatefor(ply, oply)
	pluto.inv.message(oply)
		:write("traderequestinfo", ply)
		:send()
	pluto.inv.message(ply)
		:write("traderequestinfo", oply)
		:send()
end

function pluto.trades.start(ply, oply)
	print("TRADE STARTED BETWEEN", ply, oply)
	pluto.trades.status(ply, oply, "none")
end

function pluto.inv.readrequesttrade(ply)
	local oply = net.ReadEntity()
	if (not IsValid(oply) or not oply:IsPlayer()) then
		return
	end
	local status = pluto.trades.status(ply, oply)

	if (status == "in progress") then
		return
	end
	
	if (oply:IsBot() and status == "outbound") then
		ply, oply, status = oply, ply, "inbound"
	end

	if (status == "none") then
		pluto.trades.status(ply, oply, "outbound")
	elseif (status == "inbound") then
		pluto.trades.start(ply, oply)
	end

	print("TRADE REQUEST RECEIVED: ", ply, oply, pluto.trades.status(ply, oply))
end
