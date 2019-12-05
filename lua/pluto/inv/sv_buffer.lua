local function ornull(n)
	return n and SQLStr(n) or "NULL"
end

function pluto.inv.generatebufferweapon(ply, ...)
	local i = pluto.weapons.generatetier(...)
	sql.Query("INSERT INTO pluto_items (tier, class, owner) VALUES (" .. SQLStr(i.Tier.InternalName) .. ", " .. SQLStr(i.ClassName) .. ", " .. ply:SteamID64() .. ")")
	local id = sql.QueryValue "SELECT last_insert_rowid() as id"
	i.BufferID = id

	if (i.Mods) then
		for type, list in pairs(i.Mods) do
			for _, mod in ipairs(list) do
				sql.Query("INSERT INTO pluto_mods (gun_index, modname, tier, roll1, roll2, roll3) VALUES (" .. 
					id .. ", " ..
					ornull(mod.Mod) .. ", " ..
					ornull(mod.Tier) .. ", " ..
					ornull(mod.Roll[1]) .. ", " ..
					ornull(mod.Roll[2]) .. ", " ..
					ornull(mod.Roll[3]) ..
				")")
			end
		end
	end

	pluto.inv.notifybufferitem(ply, i)

	return i.BufferID
end

function pluto.inv.generatebuffershard(ply, tier)
	local i = {
		ClassName = "shard",
		Tier = pluto.tiers[tier],
		Type = "Shard",
	}

	sql.Query("INSERT INTO pluto_items (tier, class, owner) VALUES (" .. SQLStr(tier) .. ", 'shard', " .. ply:SteamID64() .. ")")
	local id = sql.QueryValue "SELECT last_insert_rowid() as id"
	i.BufferID = id

	pluto.inv.notifybufferitem(ply, i)

	return i.BufferID
end

concommand.Add("pluto_generate_weapon", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.inv.generatebufferweapon(ply, unpack(arg))
end)

function pluto.inv.generatebuffermodel(ply, mdl)
	local i = {
		ClassName = "model_" .. mdl,
		Model = pluto.models[mdl]
	}

	if (not i.Model) then
		return false
	end

	sql.Query("INSERT INTO pluto_items (tier, class, owner) VALUES ('', " .. SQLStr("model_" .. mdl) .. ", " .. ply:SteamID64() .. ")")
	local id = sql.QueryValue "SELECT last_insert_rowid() as id"
	i.BufferID = id

	pluto.inv.notifybufferitem(ply, i)
	return i.BufferID
end

function pluto.inv.notifybufferitem(ply, i)
	local items = sql.Query("SELECT idx FROM pluto_items WHERE owner = " .. ply:SteamID64() .. " ORDER BY idx DESC")

	if (#items > 5) then
		for i = 6, #items do
			items[i] = items[i].idx
		end

		sql.Query("DELETE FROM pluto_items WHERE idx IN (" .. table.concat(items, ", ", 6) .. ")")
	end

	pluto.inv.message(ply)
		:write("bufferitem", i)
		:send()
end