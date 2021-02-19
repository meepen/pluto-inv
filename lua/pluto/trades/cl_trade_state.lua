pluto.trades = pluto.trades or {}
pluto.trades.status = pluto.trades.status or {}

pluto.trades.data = {
	incoming = {
		item = {},
		currency = {},
	},
	outgoing = {
		item = {},
		currency = {},
	},
	otherply = nil,
}

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
	print(data, amount)
	local recv = pluto.trades.data[where][type]
	recv[index] = amount ~= nil and {
		What = data,
		Amount = amount
	} or data
end

function pluto.trades.getdata()
	return pluto.trades.data
end

function pluto.inv.readtraderequestinfo()
	local oply = net.ReadEntity()
	local status = net.ReadString()

	pluto.trades.status[oply] = status

	hook.Run("PlutoTradeRequestInfo", oply, status)
end

function pluto.inv.writerequesttrade(oply)
	net.WriteEntity(oply)

	pluto.trades.status[oply] = "outbound"
end