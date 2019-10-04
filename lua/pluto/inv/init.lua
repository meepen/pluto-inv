pluto.inv = pluto.inv or {
	users = {},
	weapons = {}
}

function pluto.inv.defaulttabs(steamid, cb)
	pluto.inv.addtab(steamid, function(tab)
		if (not tab) then
			return cb(false)
		end

		cb { tab }
	end)
end

function pluto.inv.retrievetabs(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT idx, color, name FROM pluto_tabs WHERE owner = ?", {steamid}, function(err, q)
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
			})
		end

		if (#tabs == 0) then
			return pluto.inv.defaulttabs(steamid, cb)
		end

		cb(tabs)
	end)
end

function pluto.inv.addtab(steamid, cb)
	steamid = pluto.db.steamid64(steamid)
	pluto.db.transact({
		{ "INSERT INTO pluto_tabs (name, owner) SELECT CAST(COUNT(*) + 1 as CHAR), ? FROM pluto_tabs WHERE owner = ?", {steamid, steamid} },
		{ "SELECT idx, color, name FROM pluto_tabs WHERE idx = LAST_INSERT_ID()", nil, function(err, q)
			if (err) then
				return
			end

			local tab = q:getData()[1]

			cb {
				RowID = tab.idx,
				Color = tab.color,
				Name = tab.name,
				Owner = steamid,
			}

		end}
	}, function(err)
		if (err) then
			cb(false)
		end
	end)
end

function pluto.inv.renametab(tab, cb)
	assert(tab.RowID, "no rowid")
	assert(tab.Name, "no name")
	pluto.db.query("UPDATE pluto_tabs SET name = ? WHERE idx = ?", {tab.Name, tab.RowID}, function(err, q)
		return cb(not not err)
	end)
end

function pluto.inv.getfreespace(ply)
	local inv = pluto.inv.invs[ply]
	
	for tabid, tab in SortedPairsByMemberValue(inv, "RowID") do
		for i = 1, 64 do
			if (not tab.Items[i]) then
				return tabid, i
			end
		end
	end
end

function pluto.inv.retrieveitems(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT pluto_items.idx as idx, tier, class, tab_id, tab_idx FROM pluto_items JOIN pluto_tabs ON pluto_tabs.idx = pluto_items.tab_id WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end

		pprintf("Weapon list retrieved for %s", steamid)

		local weapons = {}
		local ids = {}
		local by_mysql_id = {}

		for i, item in pairs(q:getData()) do
			ids[i] = tostring(tonumber(item.idx))
			weapons[item.idx] = {
				RowID = item.idx,
				TabIndex = item.tab_idx,
				TabID = item.tab_id,
				Mods = {
					prefix = {},
					suffix = {},
				},
				Tier = pluto.tiers[item.tier],
				ClassName = item.class,
				Owner = steamid
			}
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