local AUCTION_HOUSE_ID = "1152921504606846975"
local AUCTION_TAB

local function init()
end

concommand.Add("pluto_update_class_data", function(p)
	if (IsValid(p)) then
		return
	end
	pluto.db.instance(function(db)
		for _, wep in pairs(weapons.GetList()) do
			wep = baseclass.Get(wep.ClassName)
			mysql_stmt_run(db, "INSERT INTO pluto_class_kv (class, k, v) VALUES (?, 'wep_slot', ?) ON DUPLICATE KEY UPDATE v = v", wep.ClassName, wep.Slot or 255)
		end
	end)
end)

local function get_auction_idx(db)
	if (AUCTION_TAB) then
		return AUCTION_TAB
	end

	mysql_query(db, "SELECT idx FROM pluto_tabs WHERE owner = " .. AUCTION_HOUSE_ID .. " FOR UPDATE")

	local data = mysql_query(db, "SELECT idx FROM pluto_tabs WHERE tab_type = 'auction' AND owner = " .. AUCTION_HOUSE_ID)

	local auction_id = data[1] and data[1].idx

	if (not auction_id) then
		auction_id = mysql_query(db, "INSERT INTO pluto_tabs (name, owner, tab_type) VALUES ('auction_internal', " .. AUCTION_HOUSE_ID .. ", 'auction')").LAST_INSERT_ID
	end

	AUCTION_TAB = auction_id
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

	local price = math.Clamp(tonumber(a[2]) or 0, 100, 90000)
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

local sorts = {
	default = "ORDER BY listed DESC",
	oldest = "ORDER BY listed ASC",
	lowest_price = "ORDER BY price ASC",
	highest_price = "ORDER BY price DESC",
}
local filters = {
	primary = {
		filter = "slot.v = 2",
		join = "INNER JOIN pluto_class_kv slot ON slot.class = i.class AND slot.k = 'wep_slot'"
	},
	secondary = {
		filter = "slot.v = 1",
		join = "INNER JOIN pluto_class_kv slot ON slot.class = i.class AND slot.k = 'wep_slot'"
	},
	melee = {
		filter = "slot.v = 0",
		join = "INNER JOIN pluto_class_kv slot ON slot.class = i.class AND slot.k = 'wep_slot'"
	},
	shard = {
		filter = "class = 'shard'"
	},
	model = {
		filter = "class like 'model_%'"
	}
}

function pluto.inv.readauctionsearch(p)
	local page = net.ReadUInt(32)
	local sort = sorts[net.ReadString()] or sorts.default
	local filter = {}
	local joins = {}
	while (net.ReadBool()) do
		local current = filters[net.ReadString()]
		if (not current) then
			continue
		end
		if (current.filter and not filter[current.filter]) then
			table.insert(filter, current.filter)
			filter[current.filter] = true
		end
		if (current.join and not joins[current.join]) then
			table.insert(joins, current.join)
			joins[current.join] = true
		end
	end

	filter = table.concat(filter, " AND ")
	joins = table.concat(joins, " ")
	if (filter == "") then
		filter = "1"
	end

	local last_search = p.LastAuctionSearch or -math.huge
	if (last_search > CurTime() - 1) then
		p:ChatPrint "You are searching too fast! Slow your roll!"
		return
	end

	p.LastAuctionSearch = CurTime()

	local function runnext(item_rows)
		local items = {}
		local pages
		local function finalize()
			pluto.inv.message(p)
				:write("auctiondata", items, pages)
				:send()
		end

		local waiting_for = 2
		local function check_waiting()
			waiting_for = waiting_for - 1 
			if (waiting_for == 0) then
				finalize()
			end
		end
		pluto.db.instance(function(db)
			pages = math.ceil(mysql_query(db, [[
				SELECT COUNT(*) as amount
					FROM pluto_items i ]] .. joins .. [[ 
					WHERE tab_id = ]] .. get_auction_idx(db) .. [[ AND ]] .. filter)[1].amount / 15)
			check_waiting()
		end)
		for _, row in ipairs(item_rows) do
			local item = pluto.divine.auction_list[row.idx]
			if (not item) then
				item = pluto.inv.itemfromrow(row)
				item.Price = row.price
				item.Lister = row.lister
				if (item.Type == "Weapon") then
					waiting_for = waiting_for + 1
					pluto.db.instance(function(db)
						for _, mod in ipairs(mysql_query(db, "SELECT idx, gun_index, modname, tier, roll1, roll2, roll3 FROM pluto_mods WHERE gun_index = " .. item.RowID)) do
							pluto.inv.readmodrow({[item.RowID] = item}, mod)
						end
						check_waiting()
					end)
				end
				pluto.divine.auction_list[item.RowID] = item
			end
			table.insert(items, item)
		end
		check_waiting()
	end

	pluto.db.instance(function(db)
		local tab_id = get_auction_idx(db)

		local item_rows, err = mysql_stmt_run(db, [[
			SELECT i.idx as idx, tier, i.class as class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, currency1, currency2, locked, untradeable,
				CAST(original_owner as CHAR(32)) as original_owner, owner.displayname as original_name, cast(creation_method as CHAR(16)) as creation_method,
				auction.price as price, CAST(auction.owner as CHAR(32)) as lister

				FROM pluto_items i
					LEFT OUTER JOIN pluto_player_info owner ON owner.steamid = i.original_owner
					LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx
					INNER JOIN pluto_auction_info auction ON auction.idx = tab_idx ]] .. joins .. [[

				WHERE tab_id = ? AND ]] .. filter .. [[
				]] .. sort .. [[
				LIMIT 15 OFFSET ?]], tab_id, page * 15)
				print(err)
		runnext(item_rows)
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
	pluto.divine.auction_list[itemid] = nil

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

function pluto.inv.writeauctiondata(p, items, pages)
	net.WriteUInt(pages, 32)

	net.WriteUInt(#items, 8)
	for _, item in ipairs(items) do

		pluto.inv.writeitem(p, item)
		net.WriteUInt(item.Price, 32)
	end
end
