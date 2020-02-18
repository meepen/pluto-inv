pluto.weapons = pluto.weapons or {}

function pluto.weapons.randomgun()
	return table.Random(pluto.weapons.guns)
end

function pluto.weapons.randommelee()
	return table.Random(pluto.weapons.melees)
end

function pluto.weapons.randomgrenade()
	return table.Random(pluto.weapons.grenades)
end

function pluto.weapons.type(gun)
	if (not gun) then
		return
	end

	if (gun.Slot == 1 or gun.Slot == 2) then
		return "Weapon"
	end

	if (gun.Slot == 3) then
		return "Grenade"
	end

	if (gun.Slot == 0) then
		return "Melee"
	end
end

function pluto.weapons.generatetier(tier, wep, tagbiases, rolltier, roll, affixmax, prefix_count, suffix_count)
	if (type(wep) == "string") then
		wep = weapons.GetStored(wep)
	end

	if (not wep) then
		wep = weapons.GetStored(pluto.weapons.randomgun())
	end

	if (type(tier) == "string") then
		tier = pluto.tiers.byname[tier]
	end

	if (not tier) then
		tier = pluto.tiers.random(wep)
	end

	local biases
	if (tier.tags) then
		biases = table.Copy(tier.tags)
	else
		biases = {}
	end

	if (tagbiases) then
		for k, v in pairs(tagbiases) do
			biases[k] = (biases[k] or 1) * v
		end
	end

	return setmetatable({
		ClassName = wep.ClassName,
		Tier = tier,
		Type = "Weapon",
		Mods = tier.affixes < 1 and {} or pluto.mods.generateaffixes(
			wep,
			math.random(1, affixmax or tier.affixes or 0),
			prefix_count,
			suffix_count,
			tier.guaranteed, 
			biases,
			tier.rolltier or rolltier,
			tier.roll or roll
		)
	}, pluto.inv.item_mt)
end

function pluto.weapons.update(item, cb, transact)
	assert(item.RowID, "no rowid")
	assert(item.Owner, "no owner")
	assert(item.TabID, "no tabid")
	assert(item.TabIndex, "no tabindex")

	if (not transact) then
		transact = pluto.db.transact()
	end

	transact:AddQuery("UPDATE pluto_items SET tier = ?, class = ?, special_name = ?, nick = ? WHERE idx = ?", {item.Tier.InternalName, item.ClassName, item.SpecialName, item.Nickname, item.RowID})
	transact:AddQuery("UPDATE pluto_mods SET deleted = TRUE WHERE gun_index = ?", {item.RowID})

	if (item.Mods) then
		for type, list in pairs(item.Mods) do
			for _, mod in ipairs(list) do
				transact:AddQuery(
					"INSERT INTO pluto_mods (gun_index, modname, tier, roll1, roll2, roll3, deleted) VALUES (?, ?, ?, ?, ?, ?, FALSE) ON DUPLICATE KEY UPDATE deleted = FALSE, tier = VALUE(tier), roll1 = VALUE(roll1), roll2 = VALUE(roll2), roll3 = VALUE(roll3)",
					{ item.RowID, mod.Mod, mod.Tier, mod.Roll[1], mod.Roll[2], mod.Roll[3] },
					function(err, q)
						if (err) then
							pwarnf("Couldn't save mod!!")
							PrintTable(mod)
							return
						end
					end
				)
			end
		end
	end

	transact:AddQuery("DELETE FROM pluto_mods WHERE gun_index = ? and deleted = TRUE", {item.RowID})

	transact:AddCallback(function(err, t)
		if (err) then
			cb(nil)
			return
		end

		item.LastUpdate = (item.LastUpdate or 0) + 1
		cb(item.RowID)
	end)

	return transact
end

function pluto.weapons.save(item, owner, cb, transact)
	if (item.RowID) then
		error "rowid already set"
	end

	if (owner) then
		item.Owner = pluto.db.steamid64(owner)
	end

	assert(item.Owner, "No owner")
	assert(item.TabID, "no tabid")
	assert(item.TabIndex, "no tabindex")

	local tab = pluto.inv.invs[owner][item.TabID]
	assert(tab, "invalid tab")

	local old = tab.Items[item.TabIndex]

	tab.Items[item.TabIndex] = item

	if (not transact) then
		transact = pluto.db.transact()
	end

	transact:AddQuery("INSERT INTO pluto_items (tier, class, tab_id, tab_idx, nick, special_name, original_owner) VALUES(?, ?, ?, ?, ?, ?, ?)", 
		{
			type(item.Tier) == "string" and item.Tier or item.Tier and item.Tier.InternalName or "",
			item.ClassName,
			item.TabID,
			item.TabIndex,
			item.Nickname,
			item.SpecialName,
			item.Owner
		},
		function(err, q)
			item.RowID = q:lastInsert()
		end
	)

	transact:AddQuery "SET @gun = LAST_INSERT_ID()"

	if (item.Tier and item.Tier.InternalName == "crafted") then
		transact:AddQuery(
			"INSERT INTO pluto_craft_data (gun_index, tier1, tier2, tier3) VALUES (@gun, ?, ?, ?) ON DUPLICATE KEY UPDATE tier1 = tier1",
			{
				item.Tier.Tiers[1],
				item.Tier.Tiers[2],
				item.Tier.Tiers[3],
			}
		)
	end

	if (item.Type == "Weapon") then
		for type, list in pairs(item.Mods) do
			for _, mod in ipairs(list) do
				transact:AddQuery(
					"INSERT INTO pluto_mods (gun_index, modname, tier, roll1, roll2, roll3) VALUES (@gun, ?, ?, ?, ?, ?)",
					{ mod.Mod, mod.Tier, mod.Roll[1], mod.Roll[2], mod.Roll[3] },
					function(err, q)
						if (err) then
							pwarnf("Couldn't save mod!!")
							PrintTable(mod)
							return
						end
						mod.RowID = q:lastInsert()
					end
				)
			end
		end
	end

	transact:AddCallback(function(err, t)
		if (err) then
			item.RowID = nil
			item.Owner = nil
			tab.Items[item.TabIndex] = old
			if (cb) then
				cb(nil, err)
			end
			return
		end

		local old = tab.Items[item.TabIndex]

		if (old and old.RowID) then
			pluto.itemids[old.RowID] = nil
		end

		tab.Items[item.TabIndex] = item

		local ply = player.GetBySteamID64(item.Owner)
		if (IsValid(ply) and pluto.tabs[tab.Type] and pluto.tabs[tab.Type].element) then
			pluto.inv.message(ply)
				:write("tabupdate", item.TabID, item.TabIndex)
				:send()
		end

		pluto.inv.items[item.RowID] = item

		item.LastUpdate = (item.LastUpdate or 0) + 1

		pluto.itemids[item.RowID] = item
		if (cb) then
			cb(item.RowID)
		end
	end)

	return transact
end

function pluto.weapons.generateunique(unique)
end

function pluto.weapons.onrollmod(item, newmod)
	for _, ms in pairs(item.Mods) do
		for _, m in pairs(ms) do
			local M = pluto.mods.byname[m.Mod]
			if (M.OnRollMod) then
				M:OnRollMod(item, newmod)
			end
		end
	end
end

function pluto.weapons.addmod(item, modname)
	local toadd = pluto.mods.byname[modname]

	local newmod = pluto.mods.rollmod(toadd, item.Tier.rolltier, item.Tier.roll)

	if (not item.Mods[toadd.Type]) then
		item.Mods[toadd.Type] = {}
	end

	table.insert(item.Mods[toadd.Type], newmod)

	pluto.weapons.onrollmod(item, newmod)
end

function pluto.weapons.generatemod(item, prefix_max, suffix_max, ignoretier)
	local wep = baseclass.Get(item.ClassName)
	local itemtype = pluto.weapons.type(wep)
	local typemods = pluto.mods.byitem[itemtype]

	suffix_max = suffix_max or 3
	prefix_max = prefix_max or math.max(item:GetMaxAffixes() - suffix_max, 3)

	if (not item.Mods) then
		return false
	end

	local prefixes = #item.Mods.prefix
	local suffixes = #item.Mods.suffix

	if (not ignoretier and prefixes + suffixes == item:GetMaxAffixes()) then
		return false
	end

	local have = {}

	for _, Mods in pairs(item.Mods) do
		for _, mod in pairs(Mods) do
			have[mod.Mod] = true
		end
	end

	local allowed = {}

	if (prefixes < prefix_max and typemods.prefix) then
		local t = {}
		for _, item in pairs(typemods.prefix) do
			if (not have[item.InternalName]) then
				t[#t + 1] = item
			end
		end
		if (#t > 0) then
			allowed.prefix = t
		end
	end

	if (suffixes < suffix_max and typemods.suffix) then
		local t = {}
		for _, item in pairs(typemods.suffix) do
			if (not have[item.InternalName]) then
				t[#t + 1] = item
			end
		end
		if (#t > 0) then
			allowed.suffix = t
		end
	end

	local biases
	if (item.Tier.tags) then
		biases = table.Copy(item.Tier.tags)
	else
		biases = {}
	end

	if (tagbiases) then
		for k, v in pairs(tagbiases) do
			biases[k] = (biases[k] or 1) * v
		end
	end

	local mods, type = table.Random(allowed)

	local toadd = pluto.mods.bias(wep, mods, biases)[1]

	pluto.weapons.addmod(item, toadd.InternalName)

	return true
end

concommand.Add("pluto_cheat_currency", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	for cur in pairs(pluto.currency.byname) do
		pluto.inv.addcurrency(ply, cur, 1000, function() end)
	end
end)