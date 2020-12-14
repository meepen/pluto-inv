local AUCTION_HOUSE_ID = "1152921504606846975"

local function get_auction_idx(db)
	mysql_query(db, "SELECT idx FROM pluto_tabs WHERE owner = " .. AUCTION_HOUSE_ID .. " FOR UPDATE")

	local data = mysql_query(db, "SELECT idx FROM pluto_tabs WHERE tab_type = 'auction' AND owner = " .. AUCTION_HOUSE_ID)

	local auction_id = data[1] and data[1].idx

	if (not auction_id) then
		auction_id = mysql_query(db, "INSERT INTO pluto_tabs (name, owner, tab_type) VALUES ('auction_internal', " .. AUCTION_HOUSE_ID .. ", 'auction')").LAST_INSERT_ID
	end

	print(auction_id)
	return auction_id
end

concommand.Add("pluto_send_to_auction", function(p, c, a)
	local itemid = tonumber(a[1])
	if (not itemid) then
		return
	end

	local gun = pluto.itemids[itemid]
	if (not gun or gun.Owner ~= p:SteamID64() or gun.Untradeable) then
		p:ChatPrint "no"
		return
	end

	local price = math.Clamp(tonumber(a[2]) or 0, 100, 25000)
	local tax = math.ceil(price * 0.04)

	if (price < 0 or price ~= price or price > 1000000000) then
		p:ChatPrint "invalid price"
		return
	end

	pluto.db.transact(function(db)
		local tab_id = get_auction_idx(db)

		if (not pluto.inv.addcurrency(db, p, "stardust", -tax)) then
			mysql_rollback(db)
			return
		end

		mysql_stmt_run(db, "SELECT * from pluto_items WHERE tab_id = ? FOR UPDATE", tab_id)
		local max = mysql_stmt_run(db, "SELECT MAX(tab_idx) as max FROM pluto_items WHERE tab_id = ?", tab_id)[1].max or 0

		local auction_id = max + 1

		mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", tab_id, auction_id, itemid)
		mysql_stmt_run(db, "INSERT INTO pluto_auction_info (idx, owner, listed, price) VALUES (?, ?, NOW(), ?)", auction_id, pluto.db.steamid64(p), price)
		
		pluto.inv.invs[p][gun.TabID].Items[gun.TabIndex] = nil
		
		pluto.inv.message(p)
			:write("tabupdate", gun.TabID, gun.TabIndex)
			:send()

		gun.Owner = AUCTION_HOUSE_ID
		gun.TabID = tab_id
		gun.TabIndex = auction_id

		mysql_commit(db)
	end)
end)

pluto.divine = pluto.divine or {}
pluto.divine.auction_list = pluto.divine.auction_list or {}

function pluto.inv.readauctionsearch(p)
	local last_search = p.LastAuctionSearch or -math.huge
	if (last_search > CurTime() - 1) then
		p:ChatPrint "You are searching too fast! Slow your roll!"
		return
	end

	p.LastAuctionSearch = CurTime()
	local page = net.ReadUInt(32)

	pluto.db.transact(function(db)
		local tab_id = get_auction_idx(db)

		local item_rows = mysql_stmt_run(db, [[
			SELECT i.idx as idx, tier, class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, currency1, currency2, locked, untradeable,
				CAST(original_owner as CHAR(32)) as original_owner, owner.displayname as original_name, cast(creation_method as CHAR(16)) as creation_method,
				auction.price as price, CAST(auction.owner as CHAR(32)) as lister
				
				FROM pluto_items i
					LEFT OUTER JOIN pluto_player_info owner ON owner.steamid = i.original_owner
					LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx
					INNER JOIN pluto_auction_info auction ON auction.idx = tab_idx

				WHERE tab_id = ?
				ORDER BY tab_idx ASC
				LIMIT 15 OFFSET ?]], tab_id, page * 15)

		local weapons = {}
		local weapon_ids = {}
		local items = {}
		for _, row in ipairs(item_rows) do
			local item = pluto.inv.itemfromrow(row)
			table.insert(items, item)
			item.Price = row.price
			item.Lister = row.lister
			if (item.Type == "Weapon") then
				weapons[item.RowID] = item
				table.insert(weapon_ids, item.RowID)
			end
			pluto.divine.auction_list[item.RowID] = item
		end

		if (#weapon_ids > 0) then
			local mods = mysql_stmt_run(db, [[
				SELECT idx, gun_index, modname, tier, roll1, roll2, roll3 FROM pluto_mods
				WHERE gun_index IN (]] .. string.rep("?,", #weapon_ids):sub(1, -2) .. [[)]], unpack(weapon_ids))

			for _, mod in ipairs(mods) do
				pluto.inv.readmodrow(weapons, mod)
			end
		end

		pluto.inv.message(p)
			:write("auctiondata", items)
			:send()
	end)
end

concommand.Add("pluto_auction_buy", function(p, c, a)
	local itemid = tonumber(a[1])
	if (not itemid) then
		return
	end

	local new_item = pluto.divine.auction_list[itemid]
	if (not new_item) then
		return
	end

	pluto.db.transact(function(db)
		local tab_id = get_auction_idx(db)
		local tab = pluto.inv.invs[p].tabs.buffer
		mysql_stmt_run(db, "SELECT * from pluto_items WHERE tab_id = ? FOR UPDATE", tab_id)

		pluto.inv.pushbuffer(db, p)
		local data, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = 1 WHERE idx = ? AND tab_id = ?", tab.RowID, new_item.RowID, tab_id)
		if (not data or data.AFFECTED_ROWS ~= 1) then
			mysql_rollback(db)
			return
		end

		if (not pluto.inv.addcurrency(db, p, "stardust", -new_item.Price)) then
			mysql_rollback(db)
			return
		end

		local tab_idx = new_item.TabIndex

		pluto.inv.addcurrency(db, new_item.Lister, "stardust", new_item.Price)

		new_item.TabID = tab.RowID
		new_item.TabIndex = 1
		new_item.Owner = p:SteamID64()
		pluto.itemids[new_item.RowID] = new_item

		mysql_stmt_run(db, "DELETE FROM pluto_auction_info WHERE idx = ?", tab_idx)
		pluto.inv.notifybufferitem(p, new_item)
		tab.Items[1] = new_item
		mysql_commit(db)
	end)
end)

function pluto.inv.writeauctiondata(p, items)
	net.WriteUInt(#items, 8)
	for _, item in ipairs(items) do

		pluto.inv.writeitem(p, item)
		net.WriteUInt(item.Price, 32)
	end
end
