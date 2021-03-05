pluto.trades = pluto.trades or {}
pluto.trades.status = pluto.trades.status or {}

if (not pluto.trades.data) then
	pluto.trades.data = {
		Clear = function(self)
			self.outgoing = {
				item = {
					lookup = {},
				},
				currency = {
					lookup = {},
				},
				accepted = false,
			}
			self.incoming = {
				item = {
					lookup = {},
				},
				currency = {
					lookup = {},
				},
				accepted = false,
			}
			self.messages = {}
			self.otherply = nil
		end,
	}
	pluto.trades.data:Clear()
end

function pluto.trades.getinboundrequests()
	local inbound = {}
	for ply, status in pairs(pluto.trades.status) do
		if (status == "inbound") then
			table.insert(inbound, ply)
		end
	end

	return inbound
end

function pluto.trades.deny(ply)
end

function pluto.trades.request(ply)
end

function pluto.trades.get()
	return pluto.trades.status
end

function pluto.trades.settradedata(where, type, index, data, amount)
	local recv = pluto.trades.data[where][type]
	if (type == "item") then
		recv[index] = data
	elseif (type == "currency") then
		if (data) then
			recv[index] = {
				What = data,
				Amount = amount
			}
		else
			recv[index] = nil
		end
	end

	if (where == "outgoing") then
		pluto.inv.message()
			:write("tradeupdate", type, index, recv[index])
			:send()
	end
end

function pluto.trades.getdata()
	return pluto.trades.data
end

function pluto.inv.readtraderequestinfo()
	local oply = net.ReadEntity()
	local status = net.ReadString()

	local old_status = pluto.trades.status[oply]

	pluto.trades.status[oply] = status
	if (status == "in progress") then
		pluto.trades.data.active = oply
		pluto.trades.data:Clear()
	elseif (old_status ~= status and old_status == "in progress") then
		pluto.trades.data.active = false
	end

	hook.Run("PlutoTradeRequestInfo", oply, status)
end

function pluto.inv.writerequesttrade(oply)
	net.WriteEntity(oply)

	pluto.trades.status[oply] = "outbound"
end

function pluto.inv.readtradeupdate()
	local side = net.ReadBool() and "incoming" or "outgoing"
	local what = net.ReadString()
	local index = net.ReadUInt(8)
	local data
	if (net.ReadBool()) then
		if (what == "currency") then
			data = {}
			data.What = pluto.currency.byname[net.ReadString()]
			data.Amount = net.ReadUInt(32)
		elseif (what == "item") then
			data = pluto.inv.readitem()
		end
	end

	pluto.trades.data[side][what][index] = data

	hook.Run("PlutoTradeUpdate", side, what, index, data)
end