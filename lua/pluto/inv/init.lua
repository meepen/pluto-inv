pluto.inv = pluto.inv or {
	users = {},
	weapons = {}
}

pluto.itemids = pluto.inv.items or pluto.itemids or {}

local PLAYER = FindMetaTable "Player"
PLAYER.RealSteamID64 = PLAYER.RealSteamID64 or PLAYER.SteamID64

local fake_cv = CreateConVar("pluto_fake_steamid", "")

function PLAYER:SteamID64()
	return fake_cv:GetString() ~= "" and fake_cv:GetString() or self:RealSteamID64() or "0"
end

function pluto.inv.defaulttabs(db, steamid)
	mysql_cmysql()

	return pluto.inv.addtabs(db, steamid, {"equip", "currency", "normal", "buffer"})
end

function pluto.inv.reloadfor(ply)
	if (isstring(ply)) then
		ply = player.GetBySteamID64(ply)
	end

	if (not IsValid(ply)) then
		return
	end

	pluto.inv.sendfullupdate(ply)
end

function pluto.inv.retrievecurrency(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.simplequery("SELECT currency, amount FROM pluto_currency_tab WHERE owner = ?", {steamid}, function(d)
		if (not d) then
			return cb(false)
		end

		local cur = {}
		for _, item in ipairs(d) do
			cur[item.currency] = item.amount
		end

		cb(cur)
	end)
end

function pluto.inv.addcurrency(db, steamid, currency, amt)
	mysql_cmysql()

	steamid = pluto.db.steamid64(steamid)

	if (amt >= 0) then
		local succ, err = mysql_stmt_run(db, "INSERT INTO pluto_currency_tab (owner, currency, amount) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount + VALUE(amount)", steamid, currency, amt)

		if (err) then
			return false
		end
	else
		local succ, err = mysql_stmt_run(db, "UPDATE pluto_currency_tab SET amount = amount + ? WHERE owner = ? AND currency = ?", amt, steamid, currency)

		if (not succ or succ.AFFECTED_ROWS ~= 1) then
			return false
		end
	end

	local ply = player.GetBySteamID64(steamid)
	if (IsValid(ply) and pluto.inv.currencies[ply]) then
		pluto.inv.currencies[ply][currency] = (pluto.inv.currencies[ply][currency] or 0) + amt
		pluto.inv.message(ply)
			:write("currencyupdate", currency)
			:send()
	end

	return true
end

local added_types = {"buffer"}

function pluto.inv.retrievetabs(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.instance(function(db)
		local d, err = mysql_stmt_run(db, "SELECT idx, color, name, tab_type FROM pluto_tabs WHERE owner = ?", steamid)
		if (not d) then
			pwarnf("NO TABS FOR %s: %s", steamid, err)
			return cb(false)
		end
		local tabs = {}
	
		local need_add = {}
		for _, v in pairs(added_types) do
			need_add[v] = true
		end

		for _, tab in ipairs(d) do
			need_add[tab.tab_type] = nil
			table.insert(tabs, {
				RowID = tab.idx,
				Color = tab.color,
				Name = tab.name,
				Owner = steamid,
				Type = tab.tab_type,
			})
		end

		if (#tabs == 0) then
			return cb(pluto.inv.defaulttabs(db, steamid))
		end

		if (next(need_add, nil) ~= nil) then
			local adding = {}
			for type in pairs(need_add) do
				adding[#adding + 1] = type
			end

			pluto.inv.addtabs(db, steamid, adding)
			return pluto.inv.retrievetabs(steamid, cb)
		end

		cb(tabs)
	end)
end

function pluto.inv.addtabs(db, steamid, types)
	mysql_cmysql()
	if (#types == 0) then
		return
	end

	steamid = pluto.db.steamid64(steamid)

	local tabs = {}
	for i = 1, #types do
		local type = types[i]
		mysql_stmt_run(db, "INSERT INTO pluto_tabs (name, owner, tab_type) SELECT CAST(COUNT(*) + 1 as CHAR), ?, ? FROM pluto_tabs WHERE owner = ?", steamid, type or "normal", steamid)
		local tab = mysql_query(db, "SELECT idx, color, name, tab_type FROM pluto_tabs WHERE idx = LAST_INSERT_ID()")[1]

		tabs[i] = {
			RowID = tab.idx,
			Color = tab.color,
			Name = tab.name,
			Owner = steamid,
			Type = tab.tab_type,
		}
	end

	return tabs
end


function pluto.inv.switchtab(db, tabid1, tabindex1, tabid2, tabindex2)
	mysql_cmysql()

	local affected = 0

	local function addaffected(e, q)
		if (e) then
			return
		end

		affected = affected + q:affectedRows()
	end

	mysql_stmt_run(db, "SET foreign_key_checks = 0")
	local dat, err, errno = mysql_stmt_run(db, [[
		UPDATE pluto_items i, pluto_items i2 SET
			i.idx = i2.idx, i2.idx = i.idx,
			i.tier = i2.tier, i2.tier = i.tier,
			i.class = i2.class, i2.class = i.class,
			i.nick = i2.nick, i2.nick = i.nick,
			i.special_name = i2.special_name, i2.special_name = i.special_name,
			i.exp = i2.exp, i2.exp = i.exp,
			i.locked = i2.locked, i2.locked = i.locked,
			i.untradeable = i2.untradeable, i2.untradeable = i.untradeable,
			i.original_owner = i2.original_owner, i2.original_owner = i.original_owner
		WHERE i.tab_id = ? AND i.tab_idx = ? AND i2.tab_id = ? AND i2.tab_idx = ?
	]], tabid1, tabindex1, tabid2, tabindex2)
	mysql_stmt_run(db, "SET foreign_key_checks = 1")

	if (dat.AFFECTED_ROWS == 0) then
		local dat, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE tab_id = ? AND tab_idx = ?", tabid2, tabindex2, tabid1, tabindex1)
		if (dat.AFFECTED_ROWS == 0) then
			dat, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE tab_id = ? AND tab_idx = ?", tabid1, tabindex1, tabid2, tabindex2)
		end

		if (dat.AFFECTED_ROWS == 0) then
			mysql_rollback(db)
			return false
		end
	end
	
	return true
end

function pluto.inv.setitemplacement(db, ply, item, tabid, tabindex)
	mysql_cmysql()

	local inv = pluto.inv.invs[ply]

	local tab = inv[tabid]

	if (not tab) then
		return
	end

	inv[item.TabID].Items[item.TabIndex] = nil
	tab.Items[tabindex] = item
	item.TabID = tabid
	item.TabIndex = tabindex


	local succ, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", tabid, tabindex, item.RowID)
	if (not succ) then
		mysql_rollback(db)
		pluto.inv.reloadfor(ply)
		return false
	end

	return true
end

function pluto.inv.renametab(tab, cb)
	assert(tab.RowID, "no rowid")
	assert(tab.Name, "no name")
	pluto.db.simplequery("UPDATE pluto_tabs SET name = ? WHERE idx = ?", {tab.Name, tab.RowID}, function(d)
		return cb(not err)
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

	pluto.db.simplequery("SELECT i.idx as idx, tier, class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, currency1, currency2, locked, untradeable, original_owner, owner.displayname as original_name FROM pluto_items i LEFT OUTER JOIN pluto_player_info owner ON owner.steamid = i.original_owner LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx JOIN pluto_tabs t ON t.idx = i.tab_id WHERE owner = ?", {steamid}, function(d, err)
		if (not d) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end

		pprintf("Weapon list retrieved for %s", steamid)

		local weapons = {}

		for i, item in ipairs(d) do
			local it = setmetatable({
				RowID = item.idx,
				TabIndex = item.tab_idx,
				TabID = item.tab_id,
				Tier = pluto.tiers.byname[item.tier] or pluto.tiers.byname.unique,
				ClassName = item.class,
				Owner = steamid,
				SpecialName = item.special_name,
				Experience = item.exp,
				Nickname = item.nick,
				Locked = tobool(item.locked),
				OriginalOwner = item.original_owner,
				OriginalOwnerName = item.original_name,
				Untradeable = item.untradeable == 1,
			}, pluto.inv.item_mt)

			it.Type = pluto.inv.itemtype(it)

			if (it.Type == "Weapon") then
				it.Mods = {
					implicit = {},
					prefix = {},
					suffix = {},
				}
			elseif (it.Type == "Model") then
				it.Model = pluto.models[it.ClassName:match"model_(.+)"]
			end

			if (item.tier == "crafted") then
				it.Tier = pluto.tiers.craft {
					item.tier1 or "unique",
					item.tier2 or "unique",
					item.tier3 or "unique",
				}
			end

			weapons[item.idx] = it
			pluto.itemids[it.RowID] = it
		end

		pprintf("Querying mods for %s", steamid)
		pluto.db.simplequery([[
			SELECT pluto_mods.idx as idx, gun_index, modname, pluto_mods.tier as tier, roll1, roll2, roll3 FROM pluto_mods
				JOIN pluto_items ON pluto_mods.gun_index = pluto_items.idx
				JOIN pluto_tabs ON pluto_items.tab_id = pluto_tabs.idx
			WHERE owner = ? ORDER BY pluto_mods.idx ASC]], {steamid}, function(d, err)
			pprintf("Got mods for %s", steamid)
			if (not d) then
				pwarnf("sql error: %s\n%s", err, debug.traceback())
				return
			end

			for _, item in ipairs(d) do
				local wpn = weapons[item.gun_index]

				if (not wpn) then
					pwarnf("Mod %i doesn't associate with weapon %i", item.idx, item.gun_index)
					continue
				end

				local mod = pluto.mods.byname[item.modname]

				wpn.Mods[mod.Type] = wpn.Mods[mod.Type] or {}

				if (not item.tier) then
					error "wtf"
				end

				table.insert(wpn.Mods[mod.Type], {
					Roll = { item.roll1, item.roll2, item.roll3 },
					Mod = item.modname,
					Tier = item.tier,
					RowID = item.idx
				})
			end

			pprintf("Returned mods of %s", steamid)
			cb(weapons)
		end)
	end)
end

function pluto.inv.deleteitem(db, steamid, itemid, ignorelock)
	mysql_cmysql()

	steamid = pluto.db.steamid64(steamid)

	local i = pluto.itemids[itemid]

	local cl = player.GetBySteamID64(steamid)
	if (i) then
		if (IsValid(cl)) then
			local tabs = pluto.inv.invs[cl]
			if (tabs and tabs[i.TabID] and tabs[i.TabID].Items[i.TabIndex] == i) then
				tabs[i.TabID].Items[i.TabIndex] = nil
			end
		end
		i.RowID = nil
	end

	local query = "delete pluto_items from pluto_items inner join pluto_tabs on pluto_tabs.idx = pluto_items.tab_id where pluto_items.idx = ? and pluto_tabs.owner = ? and locked = false"
	if (ignorelock) then
		query = "delete pluto_items from pluto_items inner join pluto_tabs on pluto_tabs.idx = pluto_items.tab_id where pluto_items.idx = ? and pluto_tabs.owner = ?"
	end

	local d = mysql_stmt_run(db, query, itemid, steamid)
	if (not d) then
		pluto.inv.reloadfor(cl)
		mysql_rollback(db)
		return false
	end

	if (not d or d.AFFECTED_ROWS ~= 1) then
		pluto.inv.reloadfor(cl)

		pwarnf("Affected rows: %i", d.AFFECTED_ROWS)
		mysql_rollback(db)
		return false
	end

	pluto.itemids[itemid] = nil

	return true
end

function pluto.inv.addexperience(id, exp) -- should not need cb :shrug:
	local item = pluto.itemids[id]
	if (item) then -- notify exp
		item.Experience = (item.Experience or 0) +exp
		local cl = player.GetBySteamID64(item.Owner)
		if (IsValid(cl)) then
			pluto.inv.message(cl)
				:write("expupdate", item)
				:send()
		end
	end

	pluto.db.simplequery("UPDATE pluto_items SET exp = exp + ? WHERE idx = ?", {exp, id})
end

function pluto.inv.addplayerexperience(ply, exp)
	local stmd = pluto.db.steamid64(ply)

	if (type(ply) == "Player") then
		ply:SetPlutoExperience(ply:GetPlutoExperience() + exp)
		for _, oply in pairs(player.GetAll()) do
			pluto.inv.message(oply)
				:write("playerexp", ply, ply:GetPlutoExperience())
				:send()
		end
	end

	pluto.db.simplequery("UPDATE pluto_player_info SET experience = experience + ? WHERE steamid = ?", {exp, stmd})
end

function pluto.inv.lockitem(steamid, itemid, locked, cb)
	steamid = pluto.db.steamid64(steamid)

	return pluto.db.simplequery("UPDATE pluto_items SET locked = ? WHERE idx = ? and locked = ?", {locked, itemid, not locked}, function(d, err)
		if (not d) then
			if (IsValid(cl)) then
				pluto.inv.sendfullupdate(cl)
			end
			return cb(false)
		end

		if (d.AFFECTED_ROWS ~= 1) then
			if (IsValid(cl)) then
				pluto.inv.sendfullupdate(cl)
			end

			pwarnf("Affected rows: %i", q.AFFECTED_ROWS)
			return cb(false)
		end

		pluto.itemids[itemid].Locked = locked

		cb(true)
	end)
end

function pluto.inv.roll(crate)
	local m = math.random()

	local total = 0
	for _, v in pairs(crate) do
		total = total + (istable(v) and v.Shares or v)
	end

	m = m * total

	for itemname, val in pairs(crate) do
		if (istable(val)) then
			m = m - val.Shares
		else
			m = m - val
		end

		if (m <= 0) then
			return itemname, val
		end
	end
end

hook.Add("PlayerSpray", "pluto_sprays", function()
	return true
end)
