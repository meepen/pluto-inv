pluto.trades = pluto.trades or {}

local opposites = setmetatable({
	inbound = "outbound",
	outbound = "inbound"
}, {
	__index = function(s, a)
		return a
	end
})

pluto.trades.active = pluto.trades.active or {}

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
					return
				end

				rawset(s, oply, data)
			end
		})
		return self[ply]
	end,
	__call = function(self, ply, oply, status)
		if (status) then
			self[ply][oply] = status
			pluto.trades.updatefor(ply, oply)
		else
			return self[ply][oply]
		end
	end
})

pluto.trades.mt = pluto.trades.mt or {
	__index = {}
}

local TRADE = pluto.trades.mt.__index

function TRADE:Set(who, what, index, data)
	self[who][what][index] = data

	pluto.inv.message(self[who].other)
		:write("tradeupdate", who, what, index, data)
		:send()

	return self
end

function TRADE:End()
	local ply1, ply2
	for ply in pairs(self) do
		if (ply1) then
			ply2 = ply
		else
			ply1 = ply
		end
		pluto.trades.active[ply] = nil
	end

	pluto.trades.status(ply1, ply2, "none")
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
	for _, ply2 in pairs(player.GetAll()) do
		if (ply2 == ply or ply2 == oply) then
			continue
		end

		if (pluto.trades.status(ply, ply2) == "outbound") then
			pluto.trades.status(ply, ply2, "none")
		end
		if (pluto.trades.status(oply, ply2) == "outbound") then
			pluto.trades.status(oply, ply2, "none")
		end
	end

	local tradedata = setmetatable({
		[ply] = {
			item = {},
			currency = {},
			other = oply,
		},
		[oply] = {
			item = {},
			currency = {},
			other = ply,
		},
	}, pluto.trades.mt)

	pluto.trades.active[ply] = {
		other = oply,
		data = tradedata
	}

	pluto.trades.active[oply] = {
		other = ply,
		data = tradedata
	}

	pluto.trades.status(ply, oply, "in progress")
end

function pluto.inv.readrequesttrade(ply)
	local oply = net.ReadEntity()
	if (not IsValid(oply) or not oply:IsPlayer()) then
		return
	end

	local trade = pluto.trades.active[ply]
	if (trade) then
		trade.data:End()
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
end

function pluto.inv.readtradeupdate(ply)
	local what = net.ReadString()
	local index = net.ReadUInt(8)

	local data
	if (what == "currency") then
		if (index == 0 or index > 3) then
			return
		end

		if (net.ReadBool()) then
			data = {}
			data.What = net.ReadString()
			data.Amount = net.ReadUInt(32)
		end

	elseif (what == "item") then
		if (index == 0 or index > 9) then
			return
		end

		if (net.ReadBool()) then
			data = pluto.itemids[net.ReadUInt(32)]
			if (data and data.Owner ~= ply:SteamID64()) then
				ply:ChatPrint "YOU DON'T OWN THAT ITEM!!! REEEE"
				pluto.inv.message(ply)
					:write("tradeupdate", ply, what, index, nil)
					:send()
				return
			end
		end
	else
		return
	end

	local trade = pluto.trades.active[ply]
	if (not trade) then
		ply:ChatPrint "You have no active trade!!1"
		return
	end

	trade.data:Set(ply, what, index, data)
end