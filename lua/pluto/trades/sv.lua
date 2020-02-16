function pluto.inv.readtradeupdate(ply)
	local trade = pluto.trades.get(ply)

	if (not trade) then
		return
	end

	local amt = net.ReadUInt(3)
	if (amt > table.Count(pluto.currency.byname)) then
		return
	end

	local curr = trade.Currency[ply]
	local items = trade.Items[ply]
	table.Empty(curr)
	table.Empty(items)

	for i = 1, amt do
		local cur = net.ReadString()
		local amt = net.ReadUInt(32)

		if (not pluto.inv.currencies[ply] or pluto.inv.currencies[ply][cur] < amt or amt <= 0) then
			continue
		end

		if (curr[cur]) then
			continue
		end

		curr[cur] = amt
	end

	for i = 1, math.min(net.ReadUInt(4), 12) do
		local ind = net.ReadUInt(4)
		local item = pluto.inv.items[net.ReadUInt(32)]

		if (item.Owner ~= ply:SteamID64()) then
			ply:Kick "You don't own an item in your trade window! (report to meepen)"
			return
		end

		items[ind] = item
	end

	if (not trade) then
		return
	end

	for i = 1, 2 do
		trade.Accepted[trade.Players[i]] = false

		pluto.inv.message(trade.Players[i])
			:write "tradeupdate"
			:send()
	end
end

function pluto.inv.readtraderequest(ply)
	local other = net.ReadEntity()
	if (not IsValid(other) or not other:IsPlayer()) then
		return
	end

	local bypass_checks = true

	if ((bypass_checks or GetRoundState() ~= ROUND_ACTIVE and not ply:Alive()) and (not ply.NextTrade or ply.NextTrade < CurTime())) then
		if (not bypass_checks and GetRoundState() == ROUND_ACTIVE and user:Alive()) then
			ply:ChatPrint "you cannot trade with people right now"
		elseif (not pluto.trades.get(ply) and not pluto.trades.get(other))  then
			ply.NextTrade = CurTime() + 30
			-- TODO(meep): request instead of init

			pluto.trades.cancel(ply)
			pluto.trades.cancel(other)

			pluto.trades.init(ply, other)
		end
	end
end

function pluto.inv.readtradeaccept(recv)
	local accepted = net.ReadBool()
	local declined = net.ReadBool()

	local trade = pluto.trades.get(recv)

	if (not trade) then
		return
	end

	if (declined) then
		pluto.trades.cancel(recv)
	else
		local otherply = trade.Players[trade.Players[1] == recv and 2 or 1]

		local ignore = {}
		for _, item in pairs(trade.Items[recv]) do
			ignore[item] = true
		end
		local incoming = {}
		for _, item in pairs(trade.Items[otherply]) do
			incoming[#incoming + 1] = item
		end
	
		if (not pluto.inv.getfreespaces(recv, incoming, ignore)) then
			accepted = false
		end

		if (trade.Accepted[recv] ~= accepted) then
			pluto.inv.message(trade.Players[trade.Players[1] == recv and 2 or 1])
				:write("tradeaccept", accepted)
				:send()
		end
		trade.Accepted[recv] = accepted

		if (accepted) then
			pluto.trades.accept(recv)
		end
	end

end

pluto.trades = pluto.trades or {}

function pluto.inv.getfreespaces(ply, items, ignore)
	local retn = {}
	local inv = pluto.inv.invs[ply]
	
	for tabid, tab in SortedPairsByMemberValue(inv, "RowID") do
		local tabtype = pluto.tabs[tab.Type]
		if (not tabtype) then
			pwarnf("Unknown tab type: %s", tab.Type)
			continue
		end
		for i = 1, tabtype.size do
			for k, item in pairs(items) do
				local tabitem = tab.Items[i]
				if ((not tabitem or ignore[tabitem]) and tabtype.canaccept(i, item)) then
					items[k] = nil
					retn[item] = {
						TabID = tabid,
						TabIndex = i,
						Swap = tabitem
					}
					break
				end
			end
		end
	end

	if (table.Count(items) ~= 0) then
		return false
	end

	return retn
end

function pluto.trades.accept(ply)
	local trade = pluto.trades.get(ply)

	if (trade) then
		for _, accept in pairs(trade.Accepted) do
			if (not accept) then
				return
			end
		end

		pluto.trades.cancel(ply)

		-- TODO(meepen): log lol

		local frees = {}

		for i = 1, 2 do
			local otherply = trade.Players[3 - i]
			local recv = trade.Players[i]

			local ignore = {}
			for _, item in pairs(trade.Items[recv]) do
				ignore[item] = true
			end

			local incoming = {}
			for _, item in pairs(trade.Items[otherply]) do
				incoming[#incoming + 1] = item
			end

			frees[i] = pluto.inv.getfreespaces(recv, incoming, ignore)
		end

		local done = {}
		local toswap = {}

		for i = 1, 2 do
			local items, swaplookup = frees[i]

			for item, dst in pairs(items) do
				if (dst.Swap) then
					if (toswap[item]) then
						continue
					end
					toswap[dst.Swap] = item
					done[dst.Swap] = true
					done[item] = true
				end
			end
		end


		local ids = {}
		for i = 1, 2 do
			ids[i] = pluto.db.steamid64(trade.Players[i])
		end

		local transact = pluto.db.transact()

		transact:AddQuery("SELECT * from pluto_items INNER JOIN pluto_tabs ON pluto_items.tab_id = pluto_tabs.idx WHERE OWNER IN (?, ?) FOR UPDATE", ids)

		for i1, i2 in pairs(toswap) do
			local tabid1, tabindex1 = i1.TabID, i1.TabIndex
			local tabid2, tabindex2 = i2.TabID, i2.TabIndex

			transact:AddQuery("UPDATE pluto_items SET tab_id = ?, tab_idx = 0 WHERE idx = ?", {i1.TabID, i2.RowID})
			transact:AddQuery("UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", {i2.TabID, i2.TabIndex, i1.RowID})
			transact:AddQuery("UPDATE pluto_items SET tab_idx = ? WHERE idx = ?", {i1.TabIndex, i2.RowID})
		end

		for i = 1, 2 do
			for item, dst in pairs(frees[i]) do
				if (done[item]) then
					continue
				end

				transact:AddQuery("UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", {dst.TabID, dst.TabIndex, item.RowID})
			end
		end

		for ply, data in pairs(trade.Currency) do
			local otherply = trade.Players[ply == trade.Players[1] and 2 or 1]
			for cur, amt in pairs(data) do
				if (not pluto.inv.currencies[ply] or pluto.inv.currencies[ply][cur] < amt or amt <= 0) then
					return
				end

				transact:AddQuery("INSERT INTO pluto_currency_tab (owner, currency, amount) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount - VALUE(amount)", {pluto.db.steamid64(ply), cur, amt})
				transact:AddQuery("INSERT INTO pluto_currency_tab (owner, currency, amount) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount + VALUE(amount)", {pluto.db.steamid64(otherply), cur, amt})
			end
		end

		transact:Run(function(err, q)
			for i = 1, 2 do
				local ply = trade.Players[i]

				if (IsValid(ply)) then
					pluto.inv.invs[ply] = nil
					pluto.inv.sendfullupdate(ply)
				end
			end
		end)
	end
end

function pluto.trades.cancel(ply)
	local trade = pluto.trades.get(ply)

	if (trade) then
		for i = 1, 2 do
			pluto.trades.list[trade.Players[i]] = nil

			pluto.inv.message(trade.Players[i])
				:write "tradeupdate"
				:send()
		end
	end
end

pluto.trades.list = pluto.trades.list or {}

function pluto.trades.init(ply1, ply2)
	local trade = {
		Players = {ply1, ply2},
		Items = {
			[ply1] = {},
			[ply2] = {}
		},
		Currency = {
			[ply1] = {},
			[ply2] = {}
		},
		Accepted = {
			[ply1] = false,
			[ply2] = false,
		},
	}

	if (pluto.trades[ply1]) then
		pluto.trades.cancel(ply1)
	end

	if (pluto.trades[ply2]) then
		pluto.trades.cancel(ply2)
	end

	pluto.trades.list[ply1] = trade
	pluto.trades.list[ply2] = trade

	pluto.inv.message(ply1)
		:write "tradeupdate"
		:send()

	pluto.inv.message(ply2)
		:write "tradeupdate"
		:send()
end

function pluto.trades.get(ply)
	return pluto.trades.list[ply]
end

function pluto.inv.writetradeaccept(ply, accepted)
	net.WriteBool(accepted)
end

function pluto.inv.readtrademessage(ply)
	local msg = net.ReadString()

	local trade = pluto.trades.get(ply)
	if (trade) then
		for _, tradeply in ipairs(trade.Players) do
			pluto.inv.message(tradeply)
				:write("trademessage", ply, msg)
				:send()
		end
	end
end

function pluto.inv.writetradeupdate(recv)
	local trade = pluto.trades.get(recv)

	if (not trade) then
		net.WriteBool(false)
		return
	end

	local otherply = trade.Players[trade.Players[1] == recv and 2 or 1]

	net.WriteBool(true)
	net.WriteEntity(otherply)

	net.WriteUInt(table.Count(trade.Currency[otherply]), 3)
	for cur, amt in pairs(trade.Currency[otherply]) do
		net.WriteString(cur)
		net.WriteUInt(amt, 32)
	end

	net.WriteUInt(table.Count(trade.Items[otherply]), 4)
	for ind, item in pairs(trade.Items[otherply]) do
		net.WriteUInt(ind, 4)
		pluto.inv.writeitem(recv, item)
	end

	local ignore = {}
	for _, item in pairs(trade.Items[recv]) do
		ignore[item] = true
	end
	local incoming = {}
	for _, item in pairs(trade.Items[otherply]) do
		incoming[#incoming + 1] = item
	end

	local free = pluto.inv.getfreespaces(recv, incoming, ignore)
	net.WriteBool(free)
end

function pluto.inv.writetrademessage(recv, ply, msg)
	net.WriteEntity(ply)
	net.WriteString(msg)
end

hook.Add("PlayerDisconnected", "pluto_trades", pluto.trades.cancel)