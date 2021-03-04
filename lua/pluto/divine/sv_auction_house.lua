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

		discord.Message():AddEmbed(
			gun:GetDiscordEmbed()
				:SetAuthor("Listed for " .. price .. " stardust...")
		):Send "auction-house"
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
	slot = "INNER JOIN pluto_class_kv slot on slot.class = i.class AND slot.k = 'wep_slot'",
	modcount = "INNER JOIN (SELECT COUNT(*) as amount, gun_index FROM pluto_mods GROUP BY pluto_mods.gun_index) AS modcount ON modcount.gun_index = i.idx",
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
	["Sort by:"] = {
		["Oldest to Newest"] = {
			sort = "ORDER BY listed ASC"
		},
		["Newest to Oldest"] = {
			sort = "ORDER BY listed DESC"
		},
		["ID Low to High"] = {
			sort = "ORDER BY idx ASC",
		},
		["ID High to Low"] = {
			sort = "ORDER BY idx DESC",
		},
		["Price Low to High"] = {
			sort = "ORDER BY price ASC",
		},
		["Price Low to High"] = {
			sort = "ORDER BY price DESC",
		},
	},
	["Item ID:"] = {
		filter = "i.idx >= ? AND i.idx <= ?",
		arguments = function(a, b)
			return tonumber(a) or 0, tonumber(b) or 0xffffffff
		end
	},
	["Item name:"] = {
		filter = "i.class like CONCAT('%', ?, '%')",
		arguments = function(a)
			return a
		end
	},
	["Choose weapon type:"] = {
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
	["Current mods:"] = { -- TODO(meep): no implicits
		filter = "modcount.amount >= ? and modcount.amount <= ?",
		arguments = function(a, b)
			print(tonumber(a) or 0, tonumber(b) or 16)
			return tonumber(a) or 0, tonumber(b) or 16
		end,
		join = "modcount",
	},
	["Maximum mods:"] = { -- TODO(meep)
		filter = "1"
	},
	["Current suffixes:"] = { -- TODO(meep)
		filter = "1"
	},
	["Current prefixes:"] = { -- TODO(meep)
		filter = "1"
	},
	["Choose ammo type:"] = { -- TODO(meep)
		filter = "1"
	},
	["Price:"] = {
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
	local sort = searchlist["Sort by:"]["Newest to Oldest"].sort
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

	local query = [[
SELECT i.idx as idx, tier, i.class as class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, currency1, currency2, locked, untradeable,
	CAST(original_owner as CHAR(32)) as original_owner, owner.displayname as original_name, cast(creation_method as CHAR(16)) as creation_method,
	auction.price as price, CAST(auction.owner as CHAR(32)) as lister
	
	FROM pluto_items i
]] .. last .. ending

	print(query)

	pluto.db.instance(function(db)
		local params = {get_auction_idx(db)}
		for _, n in ipairs(filterparams) do
			table.insert(params, n)
		end
		table.insert(params, 36 * (page - 1))
		PrintTable(params)
		-- grab guns, then grab mods
		local itemresults = mysql_stmt_run(db, query, unpack(params))
		local modquery = [[
SELECT m.idx, m.gun_index, m.modname, m.tier, m.roll1, m.roll2, m.roll3
		FROM pluto_mods m
			INNER JOIN pluto_items i ON i.idx = m.gun_index
			INNER JOIN (SELECT i.idx FROM pluto_items i ]] .. last .. ending .. [[) as i2 ON m.gun_index = i2.idx
		]]
		local modresults, err = mysql_stmt_run(db, modquery, unpack(params, 1, #params))
		local count = mysql_stmt_run(db, [[SELECT COUNT(*) as count FROM pluto_items i ]] .. last, unpack(params, 1, #params - 1))[1].count

		local items = {}
		local itemlist = {}
		for _, row in ipairs(itemresults) do
			local item = pluto.inv.itemfromrow(row)
			item.Price = row.price
			item.Lister = row.lister
			items[row.idx] = item
			table.insert(itemlist, item)
		end

		for _, mod in ipairs(modresults) do
			if (not items[mod.gun_index]) then
				continue -- should never happen question mark
			end

			pluto.inv.readmodrow(items, mod)
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
