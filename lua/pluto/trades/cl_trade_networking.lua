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

function pluto.inv.writetradeupdate(what, index, data)
	net.WriteString(what)
	net.WriteUInt(index, 8)
	if (not data) then
		net.WriteBool(false)
	else
		net.WriteBool(true)
		if (what == "item") then
			net.WriteUInt(data.ID, 32)
		elseif (what == "currency") then
			net.WriteString(data.What.InternalName)
			net.WriteUInt(data.Amount, 32)
		end
	end
end

function pluto.inv.writetrademessage(msg)
	net.WriteString(msg)
end

function pluto.inv.readtrademessage()
	local cl
	if (net.ReadBool()) then
		cl = net.ReadEntity()
	end

	local msg = net.ReadString()

	table.insert(pluto.trades.data.messages, {sender = cl, msg})
	hook.Run("PlutoTradeMessage", {sender = cl, msg})
end

function pluto.inv.writetradestatus(b)
	pluto.trades.data.outgoing.accepted = not pluto.trades.data.outgoing.accepted
	net.WriteBool(pluto.trades.data.outgoing.accepted)
end

function pluto.inv.readtradestatus()
	local cl = net.ReadEntity()
	local status = net.ReadBool()

	pluto.trades.data[cl == LocalPlayer() and "outgoing" or "incoming"].accepted = status

	hook.Run("PlutoTradePlayerStatus", cl, status)
end