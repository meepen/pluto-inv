pluto.inv = pluto.inv or {
	users = {},
	weapons = {}
}

require "snowflake"

-- developers please ask meepen for this before messing with anything weird
pluto_machine_id = CreateConVar("pluto_machine_id", 1023, {FCVAR_NEVER_AS_STRING, FCVAR_PROTECTED, FCVAR_UNLOGGED}, "Pluto Machine ID for snowflake.")


function pluto.inv.retreive(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT idx, CAST(id as CHAR) as id, tier, class FROM pluto_weapons WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end

		pprintf("Weapon list retrieved for %s", steamid)

		local weapons = {}
		local ids = {}
		local by_mysql_id = {}

		for i, item in pairs(q:getData()) do
			ids[i] = item.idx
			weapons[item.id] = {
				RowID = item.idx,
				Mods = {
					prefix = {},
					suffix = {},
				},
				Tier = pluto.tiers[item.tier],
				ClassName = item.class,
				Owner = steamid,
				Snowflake = item.id,
			}

			by_mysql_id[item.idx] = weapons[item.id]
		end

		if (#weapons == 0) then
			return cb(nil)
		end

		pluto.db.query("SELECT idx, gun_index, modname, tier, roll1, roll2, roll3 FROM pluto_mods WHERE gun_index IN (" .. ("?, "):rep(#weapons):sub(1, -3) .. ") ORDER BY idx ASC", weapons, function(err, q)
			if (err) then
				pwarnf("sql error: %s\n%s", err, debug.traceback())
				return
			end

			for _, item in pairs(q:getData()) do
				local wpn = by_mysql_id[item.gun_index]

				local mod = pluto.mods[item.modname]

				wpn.Mods[mod.Type] = wpn.Mods[mod.Type] or {}

				table.insert(wpn.Mods[mod.Type], {
					Roll = { item.roll1, item.roll2, item.roll3 },
					Mod = item.modname,
					Tier = item.tier,
					RowID = item.id
				})
			end

			cb(weapons)
		end)
	end)
end