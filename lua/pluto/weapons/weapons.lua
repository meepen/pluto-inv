pluto.weapons = pluto.weapons or {}
pluto.tiers = pluto.tiers or setmetatable({}, {
	__index = {
		random = function()
			local rand = math.random()
		
			for _, item in ipairs(pluto.tiers_pct) do
				if (item.Percent >= rand) then
					return item.Tier
				end
			end
		
			pwarnf("Reached end of loop in pluto.tiers.random, rand: %f", rand)
		
			return pluto.tiers.junk
		end
	}
})

local TIER = {}
pluto.tier_mt = pluto.tier_mt or {}
pluto.tier_mt.__index = TIER

function TIER:GetSubDescription()
	local desc = self.SubDescription

	if (type(desc) == "table") then
		local r = {}

		for k, v in SortedPairs(desc) do
			r[#r + 1] = v
		end

		return table.concat(r, "\n")
	end

	return desc or ""
end

local total_shares = 0
for _, name in pairs {
	"common",
	"confused",
	"junk",
	"mystical",
	"otherworldly",
	"powerful",
	"shadowy",
	"stable",
	"uncommon",
	"unique",
	"vintage",
} do
	local item = include("pluto/tiers/" .. name .. ".lua")
	if (not item) then
		pwarnf("Tier %s didn't return a value", name)
		continue
	end

	setmetatable(item, pluto.tier_mt)

	if (not item.Shares) then
		pwarnf("Tier %s doesn't have shares", name)
		continue
	end

	local prev = pluto.tiers[name]
	if (prev) then
		table.Merge(prev, item)
		item = prev
	end

	item.InternalName = name

	pluto.tiers[name] = item
	total_shares = total_shares + item.Shares
end

pluto.tiers_pct = {}

local pct = 0
for name, item in pairs(pluto.tiers) do
	pct = pct + item.Shares / total_shares

	item.SharePercent = item.Shares / total_shares

	table.insert(pluto.tiers_pct, {
		Percent = pct,
		Tier = item
	})
end

function pluto.weapons.randomgun()
	return table.Random(pluto.weapons.guns)
end

function pluto.weapons.randommelee()
	return table.Random(pluto.weapons.melees)
end

function pluto.weapons.generatetier(tier, wep, tagbiases, rolltier, roll, affixmax, prefix_count, suffix_count)
	if (wep) then
		wep = weapons.GetStored(wep)
	end

	if (not wep) then
		wep = weapons.GetStored(pluto.weapons.randomgun())
	end

	if (type(tier) == "string") then
		tier = pluto.tiers[tier]
	end

	if (not tier) then
		tier = pluto.tiers.random()
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

function pluto.weapons.update(item, cb, nostart)
	assert(item.RowID, "no rowid")
	assert(item.Owner, "no owner")
	assert(item.TabID, "no tabid")
	assert(item.TabIndex, "no tabindex")

	local inserts = {
		{ "UPDATE pluto_items SET tier = ?, class = ?, special_name = ?, nick = ? WHERE idx = ?", {item.Tier.InternalName, item.ClassName, item.SpecialName, item.Nickname, item.RowID} },
		{ "UPDATE pluto_mods SET deleted = TRUE WHERE gun_index = ?", {item.RowID} },
	}

	if (item.Mods) then
		for type, list in pairs(item.Mods) do
			for _, mod in ipairs(list) do
				table.insert(inserts, {
					"INSERT INTO pluto_mods (gun_index, modname, tier, roll1, roll2, roll3, deleted) VALUES (?, ?, ?, ?, ?, ?, FALSE) ON DUPLICATE KEY UPDATE deleted = FALSE, tier = VALUE(tier), roll1 = VALUE(roll1), roll2 = VALUE(roll2), roll3 = VALUE(roll3)",
					{ item.RowID, mod.Mod, mod.Tier, mod.Roll[1], mod.Roll[2], mod.Roll[3] },
					function(err, q)
						if (err) then
							pwarnf("Couldn't save mod!!")
							PrintTable(mod)
							return
						end
					end
				})
			end
		end
	end

	table.insert(inserts, { "DELETE FROM pluto_mods WHERE gun_index = ? and deleted = TRUE", {item.RowID} })

	return pluto.db.transact(inserts, function(err, t)
		if (err) then
			cb(nil)
			return
		end

		item.LastUpdate = (item.LastUpdate or 0) + 1
		cb(item.RowID)
	end, nostart)
end

function pluto.weapons.save(item, owner, cb, nostart, statementsonly)
	if (item.Invalid) then
		error "invalid item"
	end

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

	local tmp = table.Copy(item)
	tmp.Invalid = true
	tab.Items[item.TabIndex] = tmp

	local inserts = {
		{ "REPLACE INTO pluto_items (tier, class, tab_id, tab_idx, nick, special_name, original_owner) VALUES(?, ?, ?, ?, ?, ?, ?)", {type(item.Tier) == "string" and item.Tier or item.Tier and item.Tier.InternalName or "", item.ClassName, item.TabID, item.TabIndex, item.Nickname, item.SpecialName, item.Owner}, function(err, q)
			local insert = q:lastInsert()

			item.RowID = insert
		end },
		{ "SET @gun = LAST_INSERT_ID()" },
	}

	if (item.Tier and item.Tier.InternalName == "crafted") then
		inserts[#inserts + 1] = {
			"INSERT INTO pluto_craft_data (gun_index, tier1, tier2, tier3) VALUES (@gun, ?, ?, ?) ON DUPLICATE KEY UPDATE tier1 = tier1",
			{
				item.Tier.Tiers[1],
				item.Tier.Tiers[2],
				item.Tier.Tiers[3],
			},
			function() end,
		}
	end

	if (item.Type == "Weapon") then
		for type, list in pairs(item.Mods) do
			for _, mod in ipairs(list) do
				table.insert(inserts, {
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
				})
			end
		end
	end

	return pluto.db.transact(inserts, function(err, t)
		if (err) then
			item.RowID = nil
			item.Owner = nil
			tab.Items[item.TabIndex] = old
			cb(nil, err)
			return
		end

		local old = tab.Items[item.TabIndex]

		if (old and not old.Invalid) then
			pluto.itemids[old.RowID] = nil
		end

		tab.Items[item.TabIndex] = item

		local ply = player.GetBySteamID64(item.Owner)
		if (IsValid(ply)) then
			pluto.inv.message(ply)
				:write("tabupdate", item.TabID, item.TabIndex)
				:send()
		end

		pluto.inv.items[item.RowID] = item

		item.LastUpdate = (item.LastUpdate or 0) + 1

		pluto.itemids[item.RowID] = item
		cb(item.RowID)
	end, nostart)
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

	if (prefixes < prefix_max) then
		local t = {}
		for _, item in pairs(pluto.mods.prefix) do
			if (not have[item.InternalName]) then
				t[#t + 1] = item
			end
		end
		if (#t > 0) then
			allowed.prefix = t
		end
	end

	if (suffixes < suffix_max) then
		local t = {}
		for _, item in pairs(pluto.mods.suffix) do
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

	local toadd = pluto.mods.bias(weapons.GetStored(item.ClassName), mods, biases)[1]

	pluto.weapons.addmod(item, toadd.InternalName)

	return true
end

concommand.Add("pluto_cheat_weapon", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	if (not pluto.inv.invs[ply]) then
		return
	end

	local i = pluto.weapons.generatetier(args[1])

	i.TabID, i.TabIndex = pluto.inv.getfreespace(ply, i)

	if (not i.TabID) then
		pwarnf("no tabid")
		return
	end

	print "saving"

	pluto.weapons.save(i, ply, print)
end)

concommand.Add("pluto_cheat_currency", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	for cur in pairs(pluto.currency.byname) do
		pluto.inv.addcurrency(ply, cur, 1000, function() end)
	end
end)