pluto.trades = pluto.trades or {}
pluto.trades.status = pluto.trades.status or {}

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