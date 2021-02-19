function pluto.inv.writegettrades(sid)
	net.WriteString(sid or LocalPlayer():SteamID64())
end

function pluto.inv.writegettradesnapshot(id)
	net.WriteUInt(id, 32)
end

function pluto.inv.readtradelogsnapshot()
	local id = net.ReadUInt(32)
	local len = net.ReadUInt(32)
	local data = util.Decompress(net.ReadData(len))

	hook.Run("PlutoTradeLogSnapshot", id, data)
end

function pluto.inv.readtradelogresults(recv)
	local trades = {}
	for i = 1, net.ReadUInt(32) do
		local trade = {}
		trades[i] = trade
		trade.ID = net.ReadUInt(32)
		trade.p1name = net.ReadString()
		trade.p1steamid = net.ReadString()
		trade.p2name = net.ReadString()
		trade.p2steamid = net.ReadString()
	end

	hook.Run("PlutoPastTradesReceived", trades)
end
