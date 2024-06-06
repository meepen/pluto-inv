--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local AUCTION_HOUSE_ID = "1152921504606846975"
local AUCTION_TAB

local function fallback() return 255 end

pluto.class_kv = {
	ammo_type = setmetatable({
		["357"] = 0,
		["pistol"] = 1,
		["none"] = 2,
		["smg1"] = 3,
	}, {__index = function() return 2 end}),

	mod_type = setmetatable({
		["suffix"] = 0,
		["prefix"] = 1,
		["implicit"] = 2,
	}, {__index = fallback}),
}

concommand.Add("pluto_update_market_data", function(p)
	if (IsValid(p)) then
		return
	end

	pluto.db.instance(function(db)
		mysql_stmt_run(db, "DELETE FROM pluto_class_kv WHERE 1")

		for _, wep in pairs(weapons.GetList()) do
			wep = baseclass.Get(wep.ClassName)
			mysql_stmt_run(db, "INSERT INTO pluto_class_kv (class, k, v) VALUES (?, 'wep_slot', ?) ON DUPLICATE KEY UPDATE v = v", wep.ClassName, wep.Slot or 255)
			mysql_stmt_run(db, "INSERT INTO pluto_class_kv (class, k, v) VALUES (?, 'ammo_type', ?) ON DUPLICATE KEY UPDATE v = v", wep.ClassName, pluto.class_kv.ammo_type[string.lower(wep.Primary and wep.Primary.Ammo or "none")])
		end

		for name, MOD in pairs(pluto.mods.byname) do
			mysql_stmt_run(db, "INSERT INTO pluto_class_kv (class, k, v) VALUES (?, 'mod_type', ?) ON DUPLICATE KEY UPDATE v = v", name, pluto.class_kv.mod_type[string.lower(MOD.Type or "none")])
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

hook.Add("OnPlutoDatabaseInitialized", "pluto_auction_house", function(db)
	get_auction_idx(db)
end)

concommand.Add("pluto_upgrade_market_data", function(p)
	if (IsValid(p)) then
		return
	end

	pluto.db.instance(function(db)
		local itemrows = mysql_stmt_run(db, "SELECT * FROM pluto_items i LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx WHERE i.tab_id = ?", get_auction_idx(db))
		local modrows = mysql_stmt_run(db, [[
			SELECT m.idx, m.gun_index, m.modname, m.tier, m.roll1, m.roll2, m.roll3
					FROM pluto_mods m
						INNER JOIN pluto_items i ON i.idx = m.gun_index
					WHERE i.tab_id = ?]], get_auction_idx(db))
		local items = {}

		for _, row in ipairs(itemrows) do
			local item = pluto.inv.itemfromrow(row)
			items[row.idx] = item
		end

		for _, mod in ipairs(modrows) do
			if (not items[mod.gun_index]) then
				continue -- should never happen question mark
			end

			pluto.inv.readmodrow(items, mod)
		end

		local amount_left = table.Count(items)
		for idx, item in pairs(items) do
			amount_left = amount_left - 1

			mysql_stmt_run(db, "UPDATE pluto_auction_info SET name = ?, max_mods = ? WHERE idx = ?", item:GetPrintName(), item:GetMaxAffixes(), item.TabIndex)
		end
	end)
end)

concommand.Add("pluto_auction_list", function(p, c, a)
	local itemid = tonumber(a[1])
	if (not itemid) then
		p:ChatPrint "Error: Invalid item"
		return
	end

	local gun = pluto.itemids[itemid]
	if (not gun or gun.Owner ~= p:SteamID64() or gun.Untradeable) then
		p:ChatPrint "Error: You cannot trade this item"
		return
	end

	if (not tonumber(a[2])) then
		p:ChatPrint "Error: Invalid price"
		return
	end

	local price = math.Clamp(tonumber(a[2]), 100, 50000)
	local tax = math.ceil(math.min(250, 10 + 0.075 * price))

	if (tonumber(a[2]) < price) then
		p:ChatPrint "Error: Minimum price is 100 droplet"
		return
	elseif (tonumber(a[2]) > price) then
		p:ChatPrint "Error: Maximum price is 50,000 droplet"
		return
	end

	p:ChatPrint "Listing item..."

	pluto.db.transact(function(db)
		local tab_id = get_auction_idx(db)
		mysql_stmt_run(db, "SELECT * from pluto_items WHERE tab_id = ? FOR UPDATE", tab_id)
		local max = mysql_stmt_run(db, "SELECT MAX(tab_idx) as max FROM pluto_items WHERE tab_id = ?", tab_id)[1].max or 0

		local auction_id = max + 1

		mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", tab_id, auction_id, itemid)
		mysql_stmt_run(db, "INSERT INTO pluto_auction_info (idx, owner, listed, price, name, max_mods) VALUES (?, ?, NOW(), ?, ?, ?)", auction_id, pluto.db.steamid64(p), price, gun:GetPrintName(), gun:GetMaxAffixes())

		pluto.inv.invs[p][gun.TabID].Items[gun.TabIndex] = nil

		if (not pluto.inv.addcurrency(db, p, "droplet", -tax)) then
			p:ChatPrint "You cannot afford the tax!"
			mysql_rollback(db)
			return
		end
		
		pluto.inv.message(p)
			:write("tabupdate", gun.TabID, gun.TabIndex)
			:send()

		-- TODO(Addi) Send an update to reset the item listing, and to update "You Listings""

		gun.Owner = AUCTION_HOUSE_ID
		gun.TabID = tab_id
		gun.TabIndex = auction_id

		mysql_commit(db)

		if (discord and discord.Message) then -- People's test servers will not have this
			discord.Message():AddEmbed(
				gun:GetDiscordEmbed()
					:SetAuthor("Listed for " .. price .. " stardust...")
			):Send "auction-house"
		end

		p:ChatPrint "Item listed!"
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

local joins = {
	slot = "straight_join pluto_class_kv slot force index(`class`) on slot.class = i.class AND slot.k = 'wep_slot'",
	ammo = "straight_join pluto_class_kv ammo force index(`class`)  on ammo.class = i.class AND ammo.k = 'ammo_type'",
	modcount = [[
			INNER JOIN (
				SELECT COUNT(*) as amount, gun_index FROM pluto_mods m
					straight_join pluto_class_kv modtype force index(`class`) on modtype.class = m.modname AND modtype.k = 'mod_type' AND modtype.v != 2
				GROUP BY m.gun_index
			) AS modcount ON modcount.gun_index = i.idx]],
	suffixcount = [[
			INNER JOIN (
				SELECT COUNT(*) as amount, gun_index FROM pluto_mods m
					straight_join pluto_class_kv modtype force index(`class`) on modtype.class = m.modname AND modtype.k = 'mod_type' AND modtype.v = 0
				GROUP BY m.gun_index
			) AS suffixcount ON suffixcount.gun_index = i.idx]],
	prefixcount = [[
			INNER JOIN (
				SELECT COUNT(*) as amount, gun_index FROM pluto_mods m
					straight_join pluto_class_kv modtype force index(`class`) on modtype.class = m.modname AND modtype.k = 'mod_type' AND modtype.v = 1
				GROUP BY m.gun_index
			) AS prefixcount ON prefixcount.gun_index = i.idx]],
}

local searchlist = {
	what = {
		Weapon = {
			filter = "i.class like 'tfa_%' or i.class like 'weapon_%'"
		},
		Model = {
			filter = "i.class like 'model_%'",
		},
		Shard = {
			filter = "i.class = 'shard'"
		}
	},
	["See First:"] = {
		["Oldest Offers"] = {
			sort = "ORDER BY listed ASC"
		},
		["Newest Offers"] = {
			sort = "ORDER BY listed DESC"
		},
		["Lowest ID"] = {
			sort = "ORDER BY idx ASC",
		},
		["Highest ID"] = {
			sort = "ORDER BY idx DESC",
		},
		["Lowest Price"] = {
			sort = "ORDER BY auction.price ASC",
		},
		["Highest Price"] = {
			sort = "ORDER BY auction.price DESC",
		},
	},
	["Item ID:"] = {
		filter = "i.idx >= ? AND i.idx <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 0xffffffff
		end
	},
	["Item Name:"] = {
		filter = "auction.name like CONCAT('%', ?, '%')",
		arguments = function(a)
			return a
		end
	},
	["Weapon Slot:"] = {
		filter = "slot.v = ?",
		arguments = function(a)
			if (a == "Primary") then
				return 2
			elseif (a == "Secondary") then
				return 1
			elseif (a == "Melee") then
				return 0
			elseif (a == "Grenade") then
				return 3
			else
				return 100
			end
		end,
		join = "slot",
	},
	["Current mods:"] = {
		filter = "modcount.amount >= ? and modcount.amount <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 16
		end,
		join = "modcount",
	},
	["Mod Count:"] = { -- TODO(meep)
		filter = "auction.max_mods >= ? and auction.max_mods <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 16
		end,
	},
	["Current suffixes:"] = {
		filter = "suffixcount.amount >= ? and suffixcount.amount <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 16
		end,
		join = "suffixcount",
	},
	["Current prefixes:"] = {
		filter = "prefixcount.amount >= ? and prefixcount.amount <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 16
		end,
		join = "prefixcount",
	},
	["Choose ammo type:"] = {
		filter = "ammo.v = ?",
		arguments = function(a)
			if (a == "Sniper") then
				return pluto.class_kv.ammo_type["357"]
			elseif (a == "Pistol") then
				return pluto.class_kv.ammo_type["pistol"]
			elseif (a == "SMG") then
				return pluto.class_kv.ammo_type["smg1"]
			else
				return pluto.class_kv.ammo_type["none"]
			end
		end,
		join = "ammo"
	},
	["Price Range:"] = {
		filter = "price >= ? and price <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 0xfffffffe
		end,
	}
}

local function pack(...)
	return {n = select("#", ...), ...}
end

function pluto.inv.readauctionsearch(p)
	local page = net.ReadUInt(32)
	local params = {}

	while (net.ReadBool()) do
		local what = net.ReadString()
		local param = {}
		params[what] = param

		for i = 1, net.ReadUInt(2) do
			param[i] = net.ReadString()
		end
	end

	local filterparams = {}
	local filters = setmetatable({"(tab_id = ?)"}, {
		__newindex = function(self, k, v)
			if (not k) then
				return
			end

			rawset(self, k, v)
			if (istable(v)) then
				for i = 1, v.n do
					table.insert(filterparams, v[i])
				end
			end
			rawset(self, #self + 1, k)
		end
	})
	local sort = searchlist["See First:"]["Oldest Offers"].sort
	local joins = setmetatable({}, {
		__newindex = function(self, k, v)
			if (not k or not joins[k]) then
				return
			end

			rawset(self, k, v)
			rawset(self, #self + 1, joins[k])
		end
	})

	for what, param in pairs(params) do
		local lookup = searchlist[what]

		local i = 1
		while (istable(lookup) and param[i]) do
			local nextlookup = lookup[param[i]]
			if (not istable(nextlookup)) then
				break
			end
			lookup = nextlookup
			i = i + 1
		end

		if (not istable(lookup)) then
			pluto.warn("AUCTION", "Failed parameter search.")
			return
		end

		if (param[i] == 'Any') then -- hack lol
			continue
		end

		if (lookup.filter) then
			filters["(" .. lookup.filter .. ")"] = lookup.arguments and pack(lookup.arguments(unpack(param, i))) or true
		end

		if (lookup.join) then
			joins[lookup.join] = true
		end

		if (lookup.sort) then
			sort = lookup.sort
		end
	end

	local last = [[
		LEFT OUTER JOIN pluto_player_info owner ON owner.steamid = i.original_owner
		LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx
		INNER JOIN pluto_auction_info auction ON auction.idx = tab_idx]]
		.. "\n\t\t" .. table.concat(joins, "\n\t\t")
		.. "\n\n\tWHERE " .. table.concat(filters, "\n\t\tAND ")
	
	local ending = "\n\t" .. sort .. "\n\tLIMIT ?, 36"

	local query = [[CREATE TEMPORARY TABLE temp_results SELECT i.idx, auction.price as price, CAST(auction.owner as CHAR(32)) as lister FROM pluto_items i]] .. last .. ending

	pluto.db.transact(function(db)
		local starttime = SysTime()
		local params = {get_auction_idx(db)}
		for _, n in ipairs(filterparams) do
			table.insert(params, n)
		end
		table.insert(params, 36 * (page - 1))

		-- grab guns, then grab mods
		mysql_stmt_run(db, query, unpack(params))
		local auction_datas = mysql_stmt_run(db, "SELECT * from temp_results")
		local count = mysql_stmt_run(db, [[SELECT COUNT(*) as count FROM pluto_items i ]] .. last, unpack(params, 1, #params - 1))[1].count
		pluto.message("MRKT", "Start queried in " .. string.format("%.02fs", SysTime() - starttime))

		local items = pluto.inv.queryitems(db, {
			join = "INNER JOIN temp_results r ON r.idx = i.idx",
		})

		mysql_query(db, "DROP TEMPORARY TABLE temp_results")

		pluto.message("MRKT", "Queried in " .. string.format("%.02fs", SysTime() - starttime))

		local itemlist = {}
		for _, row in ipairs(auction_datas) do
			local item = items[row.idx]
			item.Price = row.price
			item.Lister = row.lister
			items[row.idx] = item
			table.insert(itemlist, item)
		end

		local pagecount = math.ceil(count / 36)

		pluto.inv.message(p)
			:write("auctiondata", itemlist, pagecount)
			:send()
	end)
end

concommand.Add("pluto_auction_buy", function(p, c, a)
	local itemid = tonumber(a[1])
	if (not itemid) then
		p:ChatPrint "Error: Invalid item"
		return
	end

	p:ChatPrint "Buying item..."

	pluto.db.transact(function(db)
		local tab_id = get_auction_idx(db)
		local tab = pluto.inv.invs[p].tabs.buffer
		mysql_stmt_run(db, "SELECT * from pluto_items WHERE tab_id = ? FOR UPDATE", tab_id)

		local item = pluto.inv.queryitems(db, "WHERE i.idx = ?", itemid)[itemid]
		if (not item) then
			p:ChatPrint "Error: Invalid item"
			mysql_rollback(db)
			return
		end
		local auction_data = mysql_stmt_run(db, "SELECT cast(owner as varchar(64)) as lister, price from pluto_auction_info WHERE idx = ?", item.TabIndex)[1]

		if (not auction_data) then
			p:ChatPrint "Error: Auction data not found"
			mysql_rollback(db)
			return
		end

		if (not pluto.inv.addcurrency(db, p, "droplet", -auction_data.price)) then
			p:ChatPrint "Error: You cannot afford this item!"
			mysql_rollback(db)
			return
		end

		pluto.inv.addcurrency(db, auction_data.lister, "droplet", auction_data.price)

		pluto.inv.pushbuffer(db, p)
		local data, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = 1 WHERE idx = ? AND tab_id = ?", tab.RowID, item.RowID, tab_id)
		if (not data or data.AFFECTED_ROWS ~= 1) then
			p:ChatPrint "Error: Could not send item to buffer"
			mysql_rollback(db)
			return
		end
		
		local dat = mysql_stmt_run(db, "DELETE FROM pluto_auction_info WHERE idx = ?", item.TabIndex)
		if (not dat or dat.AFFECTED_ROWS ~= 1) then
			p:ChatPrint "Error: Could not remove item from auction"
			mysql_rollback(db)
			return
		end

		item.TabID = tab.RowID
		item.TabIndex = 1
		item.Owner = p:SteamID64()
		pluto.itemids[item.RowID] = item

		pluto.inv.notifybufferitem(p, item, true)
		tab.Items[1] = item
		mysql_commit(db)

		p:ChatPrint "Item bought!"
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

function pluto.inv.readgetmyitems(cl)
	local page = net.ReadUInt(32)
	local sid64 = pluto.db.steamid64(cl)

	pluto.db.transact(function(db)
		local itemrows = mysql_stmt_run(db, [[
	SELECT i.idx as idx, tier, i.class as class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, locked, untradeable,
		CAST(original_owner as CHAR(32)) as original_owner, owner.displayname as original_name, cast(creation_method as CHAR(16)) as creation_method,
		auction.price as price, CAST(auction.owner as CHAR(32)) as lister

		FROM pluto_items i
			LEFT OUTER JOIN pluto_player_info owner ON owner.steamid = i.original_owner
			LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx
			INNER JOIN pluto_auction_info auction ON auction.idx = tab_idx

		WHERE i.tab_id = ? AND auction.owner = ? ORDER BY auction.price DESC LIMIT ?, 36]], get_auction_idx(db), sid64, (page - 1) * 36)
		local modrows = mysql_stmt_run(db, [[
	SELECT m.idx, m.gun_index, m.modname, m.tier, m.roll1, m.roll2, m.roll3
			FROM pluto_mods m
				INNER JOIN pluto_items i ON i.idx = m.gun_index
				INNER JOIN pluto_auction_info auction ON auction.idx = i.tab_idx
			WHERE i.tab_id = ? AND auction.owner = ?]], get_auction_idx(db), sid64)

		local pages = math.ceil(mysql_stmt_run(db, "SELECT COUNT(*) as amount FROM pluto_auction_info WHERE owner = ?", sid64)[1].amount / 36)

		local items = {}
		local itemlist = {}
		for _, row in ipairs(itemrows) do
			local item = pluto.inv.itemfromrow(row)
			item.Price = row.price
			item.Owner = row.lister
			items[row.idx] = item
			table.insert(itemlist, item)
		end

		for _, mod in ipairs(modrows) do
			if (not items[mod.gun_index]) then
				continue
			end

			pluto.inv.readmodrow(items, mod)
		end

		
		pluto.inv.message(cl)
			:write("gotyouritems", pages, itemlist)
			:send()

	end)
end

function pluto.inv.writegotyouritems(cl, pages, itemlist)
	net.WriteUInt(pages, 32)
	net.WriteUInt(#itemlist, 8)
	for _, item in ipairs(itemlist) do
		pluto.inv.writeitem(cl, item)
		net.WriteUInt(item.Price or 0, 32)
	end
end

concommand.Add("pluto_auction_reclaim", function(p, c, a)
	local itemid = tonumber(a[1])
	if (not itemid) then
		p:ChatPrint "Error: Invalid item"
		return
	end

	p:ChatPrint "Reclaiming item..."

	pluto.db.transact(function(db)
		local tab_id = get_auction_idx(db)
		local tab = pluto.inv.invs[p].tabs.buffer
		mysql_stmt_run(db, "SELECT * from pluto_items WHERE tab_id = ? FOR UPDATE", tab_id)

		local item = pluto.inv.queryitems(db, "WHERE i.idx = ?", itemid)[itemid]

		pluto.inv.pushbuffer(db, p)
		local data, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = 1 WHERE idx = ? AND tab_id = ?", tab.RowID, item.RowID, tab_id)
		if (not data or data.AFFECTED_ROWS ~= 1) then
			p:ChatPrint "Error: Could not send item to buffer"
			mysql_rollback(db)
			return
		end
		mysql_stmt_run(db, "DELETE FROM pluto_auction_info WHERE idx = ?", item.TabIndex)

		item.TabID = tab.RowID
		item.TabIndex = 1
		pluto.itemids[item.RowID] = item

		pluto.inv.notifybufferitem(p, item, true)
		tab.Items[1] = item
		mysql_commit(db)

		p:ChatPrint "Item reclaimed!"
	end)
end)