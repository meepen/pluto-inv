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

		if (item.Untradeable) then
			ply:Kick "You aren't allowed to trade that item! (report to meepen)"
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
			ply.NextTrade = CurTime() + 10
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

	if (not trade) then
		return
	end

	for _, accept in pairs(trade.Accepted) do
		if (not accept) then
			return
		end
	end

	pluto.trades.cancel(ply)

	local function reloadall(txt)
		for _, ply in ipairs(trade.Players) do
			if (not IsValid(ply)) then
				continue
			end
			ply:ChatPrint(string.format("Trade failed: %s", txt))
		end
		for _, ply in pairs(trade.Players) do
			pluto.inv.reloadfor(ply)
		end
	end

	for _, ply in ipairs(trade.Players) do
		ply:ChatPrint "finalizing trade..."
	end
	local snapshot = trade.Snapshot
	local p1, p2 = trade.Players[1], trade.Players[2]
	snapshot.currencies = {
		[p1:SteamID64()] = trade.Currency[p1],
		[p2:SteamID64()] = trade.Currency[p2]
	}
	for _, ply in ipairs(trade.Players) do
		local itemsnapshot = {}
		for i, item in pairs(trade.Items[ply]) do
			itemsnapshot[i] = item:Duplicate()
			itemsnapshot[i].RowID = item.RowID
		end
		snapshot.items[ply:SteamID64()] = itemsnapshot
	end
	for _, ply in ipairs(trade.Players) do
		ply:ChatPrint "created snapshot..."
	end

	pluto.db.transact(function(db)

		-- currency exchange

		for ply, data in pairs(trade.Currency) do
			local otherply = trade.Players[ply == trade.Players[1] and 2 or 1]
			for cur, amt in pairs(data) do
				if (not pluto.inv.addcurrency(db, ply, cur, -amt)) then
					mysql_rollback(db)
					reloadall("currency 1: " .. cur .. " x" .. amt)
					return
				end
				if (not pluto.inv.addcurrency(db, otherply, cur, amt)) then
					mysql_rollback(db)
					reloadall("currency 2: " .. cur .. " x" .. amt)
					return
				end
			end
		end

		for _, ply in ipairs(trade.Players) do
			if (not IsValid(ply)) then
				continue
			end
			
			ply:ChatPrint "currencies finished..."
		end

		-- item exchange

		-- find any items we can swap first
		local complete = {}

		for _, item in pairs(trade.Items[trade.Players[1]]) do
			for _, otheritem in pairs(trade.Items[trade.Players[2]]) do
				if (complete[otheritem]) then -- already did a swap
					continue
				end

				if (not pluto.canswitchtabs(item:GetTab(), otheritem:GetTab(), item.TabIndex, otheritem.TabIndex)) then
					continue
				end

				complete[otheritem], complete[item] = true, true
				local succ = pluto.inv.switchtab(db, item.TabID, item.TabIndex, otheritem.TabID, otheritem.TabIndex)
				if (not succ) then
					reloadall "switch tab 1"
					return
				end
				break
			end
		end

		-- NOW we swap any EMPTY tab place things killme
		local done = setmetatable({}, {__index = function(self, k)
			self[k] = {}
			return self[k]
		end})

		for ply, items in pairs(trade.Items) do
			local otherply = trade.Players[trade.Players[1] == ply and 2 or 1]

			for _, item in pairs(items) do
				if (complete[item]) then
					continue
				end

				local tab1 = item:GetTab()
				local did_good = false

				for _, tab2 in pairs(pluto.inv.invs[otherply]) do
					local tab2_type = pluto.tabs[tab2.Type]
					if (not tab2_type) then
						continue
					end

					for tab2slot = 1, tab2_type.size do
						if (done[tab2.RowID][tab2slot]) then
							continue
						end
						if (tab2.Items[tab2slot]) then
							continue
						end

						-- empty tab slot find, check
						if (not pluto.canswitchtabs(tab1, tab2, item.TabIndex, tab2slot)) then
							continue
						end

						-- GO AHEAD

						local succ, swapped = pluto.inv.switchtab(db, item.TabID, item.TabIndex, tab2.RowID, tab2slot)
						if (not succ) then
							return
						end

						if (not succ or swapped ~= 1) then
							if (succ) then
								mysql_rollback(db)
							end
							print(item.TabID, item.TabIndex, tab2.RowID, tab2slot)
							reloadall("swapped: " .. swapped)
							return
						end
						done[tab2.RowID][tab2slot] = true

						did_good = true
						break
					end
					if (did_good) then
						break
					end
				end

				if (not did_good) then
					mysql_rollback(db)
					reloadall("no good")
					return
				end

				-- complete[item] = true
			end
		end

		for _, ply in ipairs(trade.Players) do
			if (not IsValid(ply)) then
				continue
			end
			
			ply:ChatPrint "items finished..."
		end

		local idx = mysql_stmt_run(db, "INSERT INTO pluto_trades (snapshot, accepted) VALUES(?, true)", util.TableToJSON(snapshot)).LAST_INSERT_ID
		mysql_stmt_run(db, "INSERT INTO pluto_trades_players (trade_id, player) VALUES (?, ?)", idx, pluto.db.steamid64(trade.Players[1]))
		mysql_stmt_run(db, "INSERT INTO pluto_trades_players (trade_id, player) VALUES (?, ?)", idx, pluto.db.steamid64(trade.Players[2]))
		for _, data in pairs(snapshot.items) do
			for _, item in pairs(data) do
				mysql_stmt_run(db, "INSERT INTO pluto_trades_items (trade_id, item_id) VALUES (?, ?)", idx, item.RowID)
			end
		end

		-- TODO(meepen): log lol
		mysql_commit(db)

		for _, ply in ipairs(trade.Players) do
			if (not IsValid(ply)) then
				continue
			end
			
			ply:ChatPrint("trade done! id: " .. idx .."; sending full inventory update...")
		end
		-- TODO(meep): way to remove this? prob not for a while
		pluto.inv.reloadfor(trade.Players[1])
		pluto.inv.reloadfor(trade.Players[2])
	end)
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
		Snapshot = {
			messages = {},
			currency = {},
			items = {},
		},
		Start = RealTime(),
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
	local msg = net.ReadString():sub(1, 128)

	if (msg:Trim() == "") then
		return
	end

	local last_time = (ply.LastTradeMessage or -math.huge)

	if (last_time > CurTime() - 0.5) then
		return
	end

	ply.LastTradeMessage = CurTime()

	local trade = pluto.trades.get(ply)
	if (trade) then
		table.insert(trade.Snapshot.messages, {
			ply:SteamID64(),
			msg
		})
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

	net.WriteBool(true)
end

function pluto.inv.writetrademessage(recv, ply, msg)
	net.WriteEntity(ply)
	net.WriteString(msg)
end

hook.Add("PlayerDisconnected", "pluto_trades", pluto.trades.cancel)

concommand.Add("pluto_print_trade", function(ply, _, args)
	if (not pluto.cancheat(ply)) then
		return	
	end
	
	local id = tonumber(args[1])

	pluto.db.instance(function(db)
		PrintTable(mysql_stmt_run(db, "SELECT CAST(player AS CHAR(32)) as player FROM pluto_trades_players WHERE trade_id = ?", id))
		PrintTable(mysql_stmt_run(db, "SELECT item_id FROM pluto_trades_items WHERE trade_id = ?", id))
		PrintTable(mysql_stmt_run(db, "SELECT CAST(snapshot as CHAR(100000)) as snapshot FROM pluto_trades WHERE idx = ?", id))
	end)
end)