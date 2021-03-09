pluto.inv = pluto.inv or {
	users = {},
	weapons = {}
}

pluto.addmodule("WEAP", Color(255, 128, 128))

pluto.itemids = pluto.inv.items or pluto.itemids or {}

local PLAYER = FindMetaTable "Player"
PLAYER.RealSteamID64 = PLAYER.RealSteamID64 or PLAYER.SteamID64

local fake_cv = CreateConVar("pluto_fake_steamid", "76561198050165746")
cvars.AddChangeCallback(fake_cv:GetName(), function(_, old, new)
	local owner = player.GetBySteamID64(old)
	if (IsValid(old)) then
		old:Kick("fake steamid update")
	end
	local owner = player.GetBySteamID64(new)
	if (IsValid(old)) then
		old:Kick("fake steamid update")
	end
end, fake_cv:GetName())
local fake_owner = CreateConVar("pluto_fake_steamid_owner", "76561198050165746")
cvars.AddChangeCallback(fake_owner:GetName(), function(_, old, new)
	local owner = player.GetBySteamID64(old)
	if (IsValid(old)) then
		old:Kick("fake steamid update")
	end
	local owner = player.GetBySteamID64(new)
	if (IsValid(old)) then
		old:Kick("fake steamid update")
	end
end, fake_owner:GetName())

function PLAYER:SteamID64()
	local sid = self:RealSteamID64()
	if (fake_cv:GetString() ~= "" and sid == fake_owner:GetString()) then
		return fake_cv:GetString()
	end
	return sid or "0"
end

function pluto.inv.defaulttabs(db, steamid)
	mysql_cmysql()

	return pluto.inv.addtabs(db, steamid, {"normal", "normal", "buffer"})
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

concommand.Add("pluto_set_zero_cur", function(p, c, a)
	if (not pluto.cancheat(p)) then
		return
	end

	pluto.db.transact(function(db)
		mysql_stmt_run(db, "DELETE FROM pluto_currency_tab WHERE owner = ? AND currency = ?", pluto.db.steamid64(p), a[1])
		
		local ply = p
		local currency = a[1]
		if (IsValid(ply) and pluto.inv.currencies[ply]) then
			pluto.inv.currencies[ply][currency] = 0
			pluto.inv.message(ply)
				:write("currencyupdate", currency)
				:send()
		end
	end)
end)

local added_types = {"buffer"}

function pluto.inv.retrievetabs(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.instance(function(db)
		local d, err = mysql_stmt_run(db, "SELECT idx, color, name, tab_type, tab_shape FROM pluto_tabs WHERE owner = ?", steamid)
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
			if (tab.tab_type == "currency") then
				continue
			end
			need_add[tab.tab_type] = nil
			table.insert(tabs, {
				RowID = tab.idx,
				Color = tab.color,
				Name = tab.name,
				Owner = steamid,
				Type = tab.tab_type,
				Shape = tab.tab_shape,
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
		local tab = mysql_query(db, "SELECT idx, color, name, tab_type, tab_shape FROM pluto_tabs WHERE idx = LAST_INSERT_ID()")[1]

		tabs[i] = {
			RowID = tab.idx,
			Color = tab.color,
			Name = tab.name,
			Owner = steamid,
			Type = tab.tab_type,
			Shape = tab.tab_shape,
		}
	end

	return tabs
end


function pluto.inv.switchtab(db, tabid1, tabindex1, tabid2, tabindex2)
	mysql_cmysql()

	local affected = 0

	mysql_stmt_run(db, "SELECT tab_id, tab_idx FROM pluto_items WHERE tab_id IN (?, ?) FOR UPDATE", tabid1, tabid2)
	local affected = 0

	local dat, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = 0 WHERE tab_id = ? AND tab_idx = ?", tabid2, tabid1, tabindex1)
	if (dat.AFFECTED_ROWS == 1) then
		affected = affected + 1
	end
	dat, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE tab_id = ? AND tab_idx = ?", tabid1, tabindex1, tabid2, tabindex2)
	if (err) then
		mysql_rollback(db)
		return false, 0
	end
	if (dat.AFFECTED_ROWS == 1) then
		affected = affected + 1
	end
	dat, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_idx = ? WHERE tab_id = ? AND tab_idx = 0", tabindex2, tabid2)

	if (affected == 0) then
		return false, affected
	else
		return true, affected
	end
end

function pluto.inv.setitemplacement(db, ply, item, tabid, tabindex)
	mysql_cmysql()

	local inv = pluto.inv.invs[ply]

	local tab = inv[tabid]

	if (not tab) then
		return false, "a"
	end

	if (inv[item.TabID]) then
		inv[item.TabID].Items[item.TabIndex] = nil
		print "NO TARGET ???"
	end

	tab.Items[tabindex] = item
	item.TabID = tabid
	item.TabIndex = tabindex


	local succ, err = mysql_stmt_run(db, "UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", tabid, tabindex, item.RowID)
	if (not succ) then
		mysql_rollback(db)
		pluto.inv.reloadfor(ply)
		return false, "b"
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

function pluto.inv.itemfromrow(item)
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
		CreationMethod = item.creation_method,
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

	return it
end

function pluto.inv.readmodrow(weapons, item)
	local wpn = weapons[item.gun_index]

	if (not wpn) then
		pwarnf("Mod %i doesn't associate with weapon %i", item.idx, item.gun_index)
		return
	end

	local mod = pluto.mods.byname[item.modname]

	if (not mod or not wpn.Mods) then
		return
	end

	wpn.Mods[mod.Type] = wpn.Mods[mod.Type] or {}

	if (not item.tier) then
		return
	end

	table.insert(wpn.Mods[mod.Type], {
		Roll = { item.roll1, item.roll2, item.roll3 },
		Mod = item.modname,
		Tier = item.tier,
		RowID = item.idx
	})
end

function pluto.inv.retrieveitems(steamid, cb)
	steamid = pluto.db.steamid64(steamid)
	local ply = player.GetBySteamID64(steamid)

	pluto.message("WEAP", "Retrieving weapon list for ", steamid)

	pluto.db.simplequery("SELECT i.idx as idx, tier, class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, currency1, currency2, locked, untradeable, CAST(original_owner as CHAR(32)) as original_owner, owner.displayname as original_name, cast(creation_method as CHAR(16)) as creation_method FROM pluto_items i LEFT OUTER JOIN pluto_player_info owner ON owner.steamid = i.original_owner LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = i.idx JOIN pluto_tabs t ON t.idx = i.tab_id WHERE owner = ?", {steamid}, function(d, err)
		if (not d) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end


		local weapons = {}

		for i, item in ipairs(d) do
			local it = pluto.inv.itemfromrow(item)

			weapons[item.idx] = it
			pluto.itemids[it.RowID] = it
		end

		pluto.message("WEAP", "Retrieved weapon list for ", steamid)
		pluto.db.simplequery([[
			SELECT pluto_mods.idx as idx, gun_index, modname, pluto_mods.tier as tier, roll1, roll2, roll3 FROM pluto_mods
				JOIN pluto_items ON pluto_mods.gun_index = pluto_items.idx
				JOIN pluto_tabs ON pluto_items.tab_id = pluto_tabs.idx
			WHERE owner = ? ORDER BY pluto_mods.idx ASC]], {steamid}, function(d, err)
				
				
			pluto.message("WEAP", "Retrieved mod list for ", steamid)

			if (not d) then
				pluto.error("WEAP", "Error in mod retrieval callback for ", steamid, ": ", debug.traceback())
				return
			end

			for _, item in ipairs(d) do
				pluto.inv.readmodrow(weapons, item)
			end

			pluto.db.simplequery("SELECT nodes.* FROM pluto_item_nodes nodes INNER JOIN pluto_items i ON i.idx = nodes.item_id INNER JOIN pluto_tabs t ON i.tab_id = t.idx WHERE t.owner = ?", {steamid}, function(d, err)
				pluto.message("WEAP", "Retrieved constellation list for ", steamid)
				local constellations = pluto.nodes.fromrows(d)

				for id, bubbles in pairs(constellations) do
					weapons[id].constellations = bubbles
				end
				cb(weapons)
			end)
		end)
	end)
end

function pluto.inv.deleteitem(db, steamid, itemid, ignorelock)
	mysql_cmysql()

	steamid = pluto.db.steamid64(steamid)

	local i = pluto.itemids[itemid]

	local query = "delete pluto_items from pluto_items inner join pluto_tabs on pluto_tabs.idx = pluto_items.tab_id where pluto_items.idx = ? and pluto_tabs.owner = ? and locked = false"
	if (ignorelock) then
		query = "delete pluto_items from pluto_items inner join pluto_tabs on pluto_tabs.idx = pluto_items.tab_id where pluto_items.idx = ? and pluto_tabs.owner = ?"
	end

	local d = mysql_stmt_run(db, query, itemid, steamid)
	if (not d or d.AFFECTED_ROWS ~= 1) then
		pluto.inv.reloadfor(cl)

		pwarnf("Affected rows: %i", d.AFFECTED_ROWS)
		mysql_rollback(db)
		return false
	end

	local cl = player.GetBySteamID64(steamid)
	if (i) then
		if (IsValid(cl)) then
			local tabs = pluto.inv.invs[cl]
			local tab = tabs and tabs[i.TabID] or nil
			if (tab and tab.Type == "buffer") then
				pluto.inv.popbuffer(db, cl, i.TabIndex)
			end

			if (tab and tab.Items[i.TabIndex] == i) then
				tab.Items[i.TabIndex] = nil
			end

			pluto.inv.message(cl)
				:write("item", i)
				:send()
		end
		i.RowID = nil
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

function pluto.inv.printroll(crate)
	local total = 0
	for _, v in pairs(crate) do
		total = total + (istable(v) and v.Shares or v)
	end

	local inorder = {}

	for itemname, val in pairs(crate) do
		inorder[itemname] = istable(val) and val.Shares or val
	end

	for itemname, shares in SortedPairsByValue(inorder) do
		pluto.message("INV", "Item ", itemname, string.format(": %.03f%%", shares / total * 100))
	end
end

hook.Add("PlayerSpray", "pluto_sprays", function()
	return true
end)

hook.Add("Initialize", "pluto_hooks", function()
	local GM = gmod.GetGamemode()
	function GM:PlutoHealthGain(...)
		hook.Run("OnPlutoHealthGain", ...)
	end
end)