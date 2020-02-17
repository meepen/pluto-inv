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

function pluto.inv.defaulttabs(steamid, cb)
	pluto.inv.addtabs(steamid, {"equip", "currency", "normal", "buffer"}, function(tabs)
		if (not tabs) then
			return cb(false)
		end

		cb(tabs)
	end):Run()
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

function pluto.inv.addcurrency(steamid, currency, amt, cb, transact)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.transact_or_query(transact, "INSERT INTO pluto_currency_tab (owner, currency, amount) VALUES(?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount + ?", {steamid, currency, math.max(0, amt), amt}, function(err, q)
		if (err) then
			if (not cb) then
				return
			end

			cb(false)

			return
		end

		local ply = player.GetBySteamID64(steamid)
		if (IsValid(ply) and pluto.inv.currencies[ply]) then
			pluto.inv.currencies[ply][currency] = (pluto.inv.currencies[ply][currency] or 0) + amt
			pluto.inv.message(ply)
				:write("currencyupdate", currency)
				:send()
		end

		if (cb) then
			cb(true)
		end
	end)
end

local added_types = {"buffer"}

function pluto.inv.retrievetabs(steamid, cb)
	steamid = pluto.db.steamid64(steamid)

	pluto.db.query("SELECT idx, color, name, tab_type FROM pluto_tabs WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			return cb(false)
		end
		local tabs = {}
	
		local need_add = {}
		for _, v in pairs(added_types) do
			need_add[v] = true
		end

		for _, tab in pairs(q:getData()) do
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
			return pluto.inv.defaulttabs(steamid, cb)
		end

		if (next(need_add, nil) ~= nil) then
			local adding = {}
			for type in pairs(need_add) do
				adding[#adding + 1] = type
			end

			pluto.inv.addtabs(steamid, adding, function()
				pluto.inv.retrievetabs(steamid, cb)
			end):Run()
			return
		end

		cb(tabs)
	end)
end

function pluto.inv.addtabs(steamid, types, cb, transact)
	if (#types == 0) then
		return cb {}
	end

	if (not transact) then
		transact = pluto.db.transact()
	end

	steamid = pluto.db.steamid64(steamid)

	local tabs = {}
	for i = 1, #types do
		local type = types[i]
		transact:AddQuery("INSERT INTO pluto_tabs (name, owner, tab_type) SELECT CAST(COUNT(*) + 1 as CHAR), ?, ? FROM pluto_tabs WHERE owner = ?", {steamid, type or "normal", steamid})
		transact:AddQuery(
			"SELECT idx, color, name, tab_type FROM pluto_tabs WHERE idx = LAST_INSERT_ID()",
			nil,
			function(err, q)
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
			end
		)
	end

	transact:AddCallback(function(err)
		if (err) then
			cb(false)
		else
			cb(tabs)
		end
	end)
	
	return transact
end

function pluto.inv.switchtab(steamid, tabid1, tabindex1, tabid2, tabindex2, cb, transact)
	steamid = pluto.db.steamid64(steamid)

	local affected = 0

	local function addaffected(e, q)
		if (e) then
			return
		end

		affected = affected + q:affectedRows()
	end

	if (not transact) then
		transact = pluto.db.transact()
	end

	transact
		:AddQuery("SELECT 1 FROM pluto_items WHERE tab_id IN (?, ?) FOR UPDATE", {tabid1, tabid2})
		:AddQuery("UPDATE pluto_items SET tab_id = ?, tab_idx = 0 WHERE tab_id = ? AND tab_idx = ?", {tabid1, tabid2, tabindex2}, addaffected)
		:AddQuery("UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE tab_id = ? AND tab_idx = ?", {tabid2, tabindex2, tabid1, tabindex1}, addaffected)
		:AddQuery("UPDATE pluto_items SET tab_idx = ? WHERE tab_id = ? AND tab_idx = 0", {tabindex1, tabid1}, addaffected)
	
	transact:AddCallback(function(err, q)
		if (err) then
			cb(false)
			return
		end

		if (affected ~= 1 and affected ~= 3) then
			cb(false)
			return
		end

		cb(true)
	end)

	return transact
end

function pluto.inv.setitemplacement(ply, item, tabid, tabindex, cb, transact)
	if (not transact) then
		transact = pluto.db.transact()
	end

	local tab = pluto.inv.invs[ply][tabid]

	if (not tab) then
		return
	end

	tab.Items[tabindex] = item
	item.TabID = tabid
	item.TabIndex = tabindex

	transact
		:AddQuery("UPDATE pluto_items SET tab_id = ?, tab_idx = ? WHERE idx = ?", {tabid, tabindex, item.RowID})

	transact:AddCallback(function(err, q)
		if (err) then
			cb(false)
			return
		end

		cb(true)
	end)

	return transact
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

	pluto.db.query("SELECT pluto_items.idx as idx, tier, class, tab_id, tab_idx, exp, special_name, nick, tier1, tier2, tier3, currency1, currency2, locked FROM pluto_items LEFT OUTER JOIN pluto_craft_data c ON c.gun_index = pluto_items.idx JOIN pluto_tabs ON pluto_tabs.idx = pluto_items.tab_id WHERE owner = ?", {steamid}, function(err, q)
		if (err) then
			pwarnf("sql error: %s\n%s", err, debug.traceback())
			return
		end

		pprintf("Weapon list retrieved for %s", steamid)

		local weapons = {}

		for i, item in pairs(q:getData()) do
			local it = setmetatable({
				RowID = item.idx,
				TabIndex = item.tab_idx,
				TabID = item.tab_id,
				Tier = pluto.tiers[item.tier],
				ClassName = item.class,
				Owner = steamid,
				SpecialName = item.special_name,
				Experience = item.exp,
				Nickname = item.nick,
				Locked = tobool(item.locked),
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
				it.Tier = pluto.craft.tier {
					item.tier1 or "unique",
					item.tier2 or "unique",
					item.tier3 or "unique",
				}
			end

			weapons[item.idx] = it
			pluto.itemids[it.RowID] = it
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

			cb(weapons)
		end)
	end)
end

function pluto.inv.deleteitem(steamid, itemid, cb, transact)
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

	pluto.db.transact_or_query(transact, "delete pluto_items from pluto_items inner join pluto_tabs on pluto_tabs.idx = pluto_items.tab_id where pluto_items.idx = ? and pluto_tabs.owner = ? and locked = false", {itemid, steamid}, function(err, q)
		if (err) then
			if (IsValid(cl)) then
				pluto.inv.sendfullupdate(cl)
			end
			return cb(false)
		end

		if (q:affectedRows() ~= 1) then
			if (IsValid(cl)) then
				pluto.inv.sendfullupdate(cl)
			end

			pwarnf("Affected rows: %i", q:affectedRows())
			return cb(false)
		end

		pluto.itemids[itemid] = nil

		cb(true)
	end)
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

	pluto.db.query("UPDATE pluto_items SET exp = exp + ? WHERE idx = ?", {exp, id}, function(e, q)
	end)
end

function pluto.inv.lockitem(steamid, itemid, locked, cb, nostart)
	steamid = pluto.db.steamid64(steamid)

	print(locked)

	return pluto.db.query("UPDATE pluto_items SET locked = ? WHERE idx = ? and locked = ?", {locked, itemid, not locked}, function(err, q)
		if (err) then
			if (IsValid(cl)) then
				pluto.inv.sendfullupdate(cl)
			end
			return cb(false)
		end

		if (q:affectedRows() ~= 1) then
			if (IsValid(cl)) then
				pluto.inv.sendfullupdate(cl)
			end

			pwarnf("Affected rows: %i", q:affectedRows())
			return cb(false)
		end

		pluto.itemids[itemid].Locked = locked

		cb(true)
	end, nil, nostart)
end