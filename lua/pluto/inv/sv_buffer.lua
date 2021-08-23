--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local function ornull(n)
	return n and SQLStr(n) or "NULL"
end

function pluto.inv.lockbuffer(db, ply)
	mysql_cmysql()
	local tab = pluto.inv.invs[ply].tabs.buffer
	mysql_stmt_run(db, "SELECT tab_id, tab_idx FROM pluto_items WHERE tab_id = ? FOR UPDATE", tab.RowID)
end

function pluto.inv.waitbuffer(db, ply)
end


function pluto.inv.pushbuffer(db, ply)
	pluto.inv.lockbuffer(db, ply)
	pluto.inv.waitbuffer(db, ply)
	mysql_cmysql()

	local tab = pluto.inv.invs[ply].tabs.buffer

	if (not tab) then
		return false
	end

	pluto.inv.lockbuffer(db, ply)
	mysql_stmt_run(db, "DELETE FROM pluto_items where tab_id = ? and tab_idx = 36", tab.RowID)
	mysql_stmt_run(db, "UPDATE pluto_items set tab_idx = tab_idx + 50 where tab_id = ?", tab.RowID)
	mysql_stmt_run(db, "UPDATE pluto_items set tab_idx = tab_idx - 49 where tab_id = ?", tab.RowID)
	for i = 35, 1, -1 do
		local item = tab.Items[i]
		tab.Items[i + 1] = item
		if (item) then
			item.TabIndex = i + 1
		end
	end
end

function pluto.inv.popbuffer(db, ply, index)
	mysql_cmysql()
	pluto.inv.lockbuffer(db, ply)

	local tab = pluto.inv.invs[ply].tabs.buffer

	if (not tab) then
		return false
	end

	table.remove(tab.Items, index)
	for i, item in ipairs(tab.Items) do
		item.TabIndex = i
	end

	mysql_stmt_run(db, "DELETE FROM pluto_items where tab_id = ? and tab_idx = ?", tab.RowID, index)
	mysql_stmt_run(db, "UPDATE pluto_items set tab_idx = tab_idx + 50 where tab_id = ? and tab_idx >= ?", tab.RowID, index)
	mysql_stmt_run(db, "UPDATE pluto_items set tab_idx = tab_idx - 51 where tab_id = ? and tab_idx >= ?", tab.RowID, index)
end

function pluto.inv.savebufferitem(db, ply, new_item)
	mysql_cmysql()

	local tab = pluto.inv.invs[ply].tabs.buffer

	pluto.inv.pushbuffer(db, ply)

	new_item.TabID = tab.RowID
	new_item.TabIndex = 1
	new_item.Owner = ply:SteamID64()
	new_item.OriginalOwner = ply:SteamID64()
	new_item.OriginalOwnerName = ply:Nick()

	pluto.weapons.save(db, new_item, ply)

	pluto.inv.notifybufferitem(ply, new_item)

	return new_item
end

function pluto.inv.generatebufferweapon(db, ply, method, ...)
	local new_item = pluto.weapons.generatetier(...)

	new_item.CreationMethod = method or "SPAWNED"

	return pluto.inv.savebufferitem(db, ply, new_item)
end

function pluto.inv.generatebuffergrenade(db, ply, method, tier, grenade, ...)
	return pluto.inv.generatebufferweapon(db, ply, method, tier, grenade or pluto.weapons.randomgrenade(), ...)
end

function pluto.inv.generatebuffershard(db, ply, method, tier)
	mysql_cmysql()

	local new_item = setmetatable({
		ClassName = "shard",
		Tier = pluto.tiers.byname[tier],
		Type = "Shard",
	}, pluto.inv.item_mt)

	new_item.CreationMethod = method

	return pluto.inv.savebufferitem(db, ply, new_item)
end

function pluto.inv.generatebuffermodel(db, ply, method, mdl)
	local new_item = setmetatable({
		ClassName = "model_" .. mdl,
		Model = pluto.models[mdl],
		Type = "Model",
	}, pluto.inv.item_mt)

	new_item.CreationMethod = method

	if (not new_item.Model) then
		return false
	end

	return pluto.inv.savebufferitem(db, ply, new_item)
end

function pluto.inv.notifybufferitem(ply, i)
	pluto.inv.message(ply)
		:write("bufferitem", i)
		:send()
end

function pluto.inv.writebufferitem(ply, i)
	pluto.inv.writeitem(ply, i)
end

function pluto.inv.getbufferitems(owner)
	return pluto.inv.invs[owner].tabs.buffer.Items
end

function pluto.inv.getbufferitem(ply, id)
	local items = pluto.inv.invs[ply].tabs.buffer.Items
	for _, item in pairs(items) do
		if (item.RowID == id) then
			return item
		end
	end
end


concommand.Add("pluto_spawn_weapon", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.db.transact(function(db)
		local item = pluto.inv.generatebufferweapon(db, ply, "SPAWNED", unpack(arg))
		mysql_commit(db)
	end)
end)

concommand.Add("pluto_item_dupe", function(ply, cmd, arg)
	if (not pluto.cancheat(ply)) then
		return
	end

	local wep = pluto.itemids[tonumber(arg[1])]

	if (not wep) then
		ply:ChatPrint("Can't find gun!")
		return
	end
	wep = wep:Duplicate()
	wep.CreationMethod = "SPAWNED"

	pluto.db.transact(function(db)
		pluto.inv.savebufferitem(db, ply, wep)
		mysql_commit(db)
	end)
end)

concommand.Add("pluto_spawn_shard", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.db.transact(function(db)
		pluto.inv.generatebuffershard(db, ply, "SPAWNED", arg[1])
		mysql_commit(db)
	end)
end)

concommand.Add("pluto_spawn_model", function(ply, cmd, arg, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	pluto.db.transact(function(db)
		pluto.inv.generatebuffermodel(db, ply, "SPAWNED", unpack(arg))
		mysql_commit(db)
	end)
end)
