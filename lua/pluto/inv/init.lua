pluto.inv = pluto.inv or {
	users = {},
	weapons = {}
}

local PLAYER = FindMetaTable "Player"
PLAYER.RealSteamID64 = PLAYER.RealSteamID64 or PLAYER.SteamID64

function PLAYER:SteamID64()
	return self:RealSteamID64() or "0"
end

function pluto.inv.defaulttabs(steamid, cb)
	pluto.inv.addtabs(steamid, {"equip", "currency", "normal"}, function(tabs)
		if (not tabs) then
			return cb(false)
		end

		cb(tabs)
	end)
end

function pluto.inv.retrievecurrency(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT currency, amount FROM pluto_currency_tab WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			return cb(false)
		end

		local cur = {}
		for _, item in pairs(q:getData()) do
			cur[item.currency] = item.amount
		end

		cb(cur)
	end)
end

function pluto.inv.addcurrency(steamid, currency, amt, cb, nostart)
	steamid = pluto.db.steamid64(steamid)

	return pluto.db.query("INSERT INTO pluto_currency_tab (owner, currency, amount) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount + ?", {steamid, currency, math.max(0, amt), amt}, function(err, q)
		if (err) then
			return cb(false)
		end

		local ply = player.GetBySteamID64(steamid)
		if (IsValid(ply) and pluto.inv.currencies[ply]) then
			pluto.inv.currencies[ply][currency] = (pluto.inv.currencies[ply][currency] or 0) + amt
			pluto.inv.message(ply)
				:write("currencyupdate", currency)
				:send()
		end

		cb(true)
	end, nil, nostart)
end

function pluto.inv.retrievetabs(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT idx, color, name, tab_type FROM pluto_tabs WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			return cb(false)
		end
		local tabs = {}
		for _, tab in pairs(q:getData()) do
			table.insert(tabs, {
				RowID = tab.idx,
				Color = tab.color,
				Name = tab.name,
				Owner = steamid,
				Type = tab.tab_type,
			})
		end

		if (#tabs == 0) then
			return pluto.inv.defaulttabs(steamid, cb)
		end

		cb(tabs)
	end)
end

function pluto.inv.addtabs(steamid, types, cb, nostart)
	if (#types == 0) then
		return cb {}
	end

	steamid = pluto.db.steamid64(steamid)
	local queries = {}

	local tabs = {}
	for i = 1, #types do
		local type = types[i]
		queries[i * 2 - 1] = { "INSERT INTO pluto_tabs (name, owner, tab_type) SELECT CAST(COUNT(*) + 1 as CHAR), ?, ? FROM pluto_tabs WHERE owner = ?", {steamid, type or "normal", steamid} }
		queries[i * 2]     = { "SELECT idx, color, name, tab_type FROM pluto_tabs WHERE idx = LAST_INSERT_ID()", nil, function(err, q)
			if (err) then
				return
			end

			local tab = q:getData()[1]

			tabs[i] = {
				RowID = tab.idx,
				Color = tab.color,
				Name = tab.name,
				Owner = steamid,
				Type = tab.tab_type,
			}
		end }
	end

	return pluto.db.transact(queries, function(err)
		if (err) then
			cb(false)
		else
			cb(tabs)
		end
	end, nil, nostart)
end

function pluto.inv.switchtab(steamid, tabid1, tabindex1, tabid2, tabindex2, cb)
	steamid = pluto.db.steamid64(steamid)
	pluto.db.transact({
		{ "SELECT 1 FROM pluto_items WHERE tab_id IN (?, ?) FOR UPDATE", {tabid1, tabid2}},
		{ "UPDATE pluto_items SET tab_id = ?, tab_idx = 0 WHERE tab_id = ? AND tab_idx = ?", {tabid1, tabid2, tabindex2} },
		{ "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE tab_id = ? AND tab_idx = ?", {tabid2, tabindex2, tabid1, tabindex1} },
		{ "UPDATE pluto_items SET tab_idx = ? WHERE tab_id = ? AND tab_idx = 0", {tabindex1, tabid1} },
	}, function(err)
		if (err) then
			cb(false)
			return
		end

		cb(true)
	end)
end

function pluto.inv.renametab(tab, cb)
	assert(tab.RowID, "no rowid")
	assert(tab.Name, "no name")
	pluto.db.query("UPDATE pluto_tabs SET name = ? WHERE idx = ?", {tab.Name, tab.RowID}, function(err, q)
		return cb(not not err)
	end)
end

function pluto.inv.getfreespace(ply, item)
	local inv = pluto.inv.invs[ply]
	
	for tabid, tab in SortedPairsByMemberValue(inv, "RowID") do
		local tabtype = pluto.tabs[tab.Type]
		if (not tabtype) then
			pwarnf("Unknown tab type: %s", tab.Type)
			continue
		end
		for i = 1, tabtype.size do
			if (not tab.Items[i] and tabtype.canaccept(i, item)) then
				return tabid, i
			end
		end
	end
end

function pluto.inv.retrieveitems(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT pluto_items.idx as idx, tier, class, tab_id, tab_idx, exp, special_name, nick FROM pluto_items JOIN pluto_tabs ON pluto_tabs.idx = pluto_items.tab_id WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end

		pprintf("Weapon list retrieved for %s", steamid)

		local weapons = {}
		local ids = {}
		local by_mysql_id = {}

		for i, item in pairs(q:getData()) do
			weapons[item.idx] = setmetatable({
				RowID = item.idx,
				TabIndex = item.tab_idx,
				TabID = item.tab_id,
				Tier = pluto.tiers[item.tier],
				ClassName = item.class,
				Owner = steamid,
				SpecialName = item.special_name,
				Experience = item.exp,
				Nickname = item.nick,
			}, pluto.inv.item_mt)

			local i = weapons[item.idx]
			i.Type = pluto.inv.itemtype(i)

			if (i.Type == "Weapon") then
				weapons[item.idx].Mods = {
					prefix = {},
					suffix = {},
				}

				ids[i] = tostring(tonumber(item.idx))
			elseif (i.Type == "Model") then
				i.Model = pluto.models[i.ClassName:match"model_(.+)"]
			end
		end

		pluto.db.query([[
			SELECT pluto_mods.idx as idx, gun_index, modname, pluto_mods.tier as tier, roll1, roll2, roll3 FROM pluto_mods
				JOIN pluto_items ON pluto_mods.gun_index = pluto_items.idx
				JOIN pluto_tabs ON pluto_items.tab_id = pluto_tabs.idx
			WHERE owner = ? ORDER BY pluto_mods.idx ASC]], {steamid}, function(err, q)
			if (err) then
				pwarnf("sql error: %s\n%s", err, debug.traceback())
				return
			end

			for _, item in pairs(q:getData()) do
				local wpn = weapons[item.gun_index]

				local mod = pluto.mods.byname[item.modname]

				wpn.Mods[mod.Type] = wpn.Mods[mod.Type] or {}

				table.insert(wpn.Mods[mod.Type], {
					Roll = { item.roll1, item.roll2, item.roll3 },
					Mod = item.modname,
					Tier = item.tier,
					RowID = item.idx
				})
			end

			cb(weapons)
		end)
	end)
end

function pluto.inv.deleteitem(steamid, itemid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("DELETE pluto_items FROM pluto_items INNER JOIN pluto_tabs ON pluto_items.tab_id = pluto_tabs.idx WHERE pluto_tabs.owner = ? AND pluto_items.idx = ?", {steamid, itemid}, function(err, q)
		if (err) then
			return cb(false)
		end

		if (q:affectedRows() ~= 1) then
			pwarnf("Affected rows: %i", q:affectedRows())
			return cb(false)
		end

		cb(true)
	end)
end

function pluto.inv.getbufferitems(owner)
	local retn = {}
	for _, item in ipairs(sql.Query("SELECT idx FROM pluto_items WHERE owner = " .. pluto.db.steamid64(owner) .. " ORDER BY idx DESC") or {}) do
		table.insert(retn, pluto.inv.getbufferitem(item.idx))
	end

	return retn
end

function pluto.inv.getbufferitem(id)
	local data = sql.QueryRow("SELECT tier, class, owner FROM pluto_items WHERE idx = " .. SQLStr(id))

	if (not data) then
		return
	end

	local wpn = {
		BufferID = id,
		ClassName = data.class,
		Owner = data.owner
	}

	wpn.Type = pluto.inv.itemtype(wpn)

	if (wpn.Type == "Weapon") then
		wpn.Mods = {
			prefix = {},
			suffix = {},
		}
		wpn.Tier = pluto.tiers[data.tier]

		for _, item in pairs(sql.Query([[SELECT modname, pluto_mods.tier as tier, roll1, roll2, roll3 FROM pluto_mods
			JOIN pluto_items ON pluto_mods.gun_index = pluto_items.idx
			WHERE gun_index = ]] .. SQLStr(id)) or {}) do
			local mod = pluto.mods.byname[item.modname]

			wpn.Mods[mod.Type] = wpn.Mods[mod.Type] or {}

			table.insert(wpn.Mods[mod.Type], {
				Roll = { tonumber(item.roll1), tonumber(item.roll2), tonumber(item.roll3) },
				Mod = item.modname,
				Tier = tonumber(item.tier),
				RowID = tonumber(item.idx),
			})
		end
	elseif (wpn.Type == "Model") then
		wpn.Model = pluto.models[wpn.ClassName:match "^model_(.+)$"]
	end

	return wpn
end