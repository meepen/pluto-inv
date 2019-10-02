pluto.inv = pluto.inv or {
	users = {},
	weapons = {}
}


function pluto.inv.retrieveguns(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT idx, tier, class FROM pluto_weapons WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end

		pprintf("Weapon list retrieved for %s", steamid)

		PrintTable(q:getData())
		print"a"

		local weapons = {}
		local ids = {}
		local by_mysql_id = {}

		for i, item in pairs(q:getData()) do
			ids[i] = tostring(tonumber(item.idx))
			weapons[item.idx] = {
				RowID = item.idx,
				Mods = {
					prefix = {},
					suffix = {},
				},
				Tier = pluto.tiers[item.tier],
				ClassName = item.class,
				Owner = steamid
			}
		end

		if (#weapons == 0) then
			return cb(nil)
		end

		pluto.db.query("SELECT idx, gun_index, modname, tier, roll1, roll2, roll3 FROM pluto_mods WHERE gun_index IN (" .. table.concat(ids, ", ") .. ") ORDER BY idx ASC", nil, function(err, q)
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