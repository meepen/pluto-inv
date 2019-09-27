pluto.weapons = pluto.weapons or {}
pluto.tiers = {}

local total_shares = 0
for _, name in pairs {
	"common",
	"junk",
	"mystical",
	"otherworldly",
	"powerful",
	"shadowy",
	"uncommon",
	"vintage",
} do
	local item = include("pluto/tiers/" .. name .. ".lua")
	if (not item) then
		pwarnf("Tier %s didn't return a value", name)
		continue
	end

	if (not item.Shares) then
		pwarnf("Tier %s doesn't have shares", name)
		continue
	end

	item.InternalName = name

	pluto.tiers[name] = item
	total_shares = total_shares + item.Shares
end

pluto.tiers_pct = {}

local pct = 0
for name, item in pairs(pluto.tiers) do
	pct = pct + item.Shares / total_shares
	table.insert(pluto.tiers_pct, {
		Percent = pct,
		Tier = item
	})
end


function pluto.tiers.random()
	local rand = math.random()

	for _, item in ipairs(pluto.tiers_pct) do
		if (item.Percent >= rand) then
			return item.Tier
		end
	end

	pwarnf("Reached end of loop in pluto.tiers.random, rand: %f", rand)

	return pluto.tiers.junk
end


function pluto.weapons.randomgun()
	return table.Random(pluto.weapons.guns)
end

function pluto.weapons.randommelee()
	return table.Random(pluto.weapons.melees)
end

function pluto.weapons.generatetier(tier, wep, tagbiases, rolltier, roll)
	if (wep) then
		wep = weapons.GetStored(wep)
	end
	if (not wep) then
		wep = weapons.GetStored(pluto.weapons.randomgun())
	end

	if (tier) then
		tier = pluto.tiers[tier]
	end

	if (not tier) then
		tier = pluto.tiers.random()
	end

	local biases = tier.biases or {}

	if (tagbiases) then
		for k, v in pairs(tagbiases) do
			biases[k] = (biases[k] or 1) * v
		end
	end

	return {
		ClassName = wep.ClassName,
		Tier = tier,
		Mods = pluto.mods.generateaffixes(wep, math.random(1, tier.affixes), nil, nil, tier.guaranteed, biases, tier.rolltier or rolltier, tier.roll or roll)
	}
end

function pluto.weapons.update(item, cb)
	assert(item.Snowflake, "no snowflake")
	assert(item.RowID, "no rowid")
	assert(item.Owner, "no owner")

	local inserts = {
		{ "REPLACE INTO pluto_weapons (id, owner, tier, class) VALUES(?, ?, ?, ?)", {item.Snowflake, item.Owner, item.Tier.InternalName, item.ClassName}, function(err, q)
			local insert = q:lastInsert()

			item.RowID = insert
		end },
		{ "SET @gun = LAST_INSERT_ID()" },
		{ "DELETE FROM pluto_mods WHERE gun_index = @gun" },
	}

	if (item.Mods) then
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

	pluto.db.transact(inserts, function(err, t)
		if (err) then
			cb(nil)
			return
		end

		cb(item.Snowflake)
	end)
end

function pluto.weapons.save(item, owner, cb)
	if (item.Snowflake) then
		error "snowflake already set"
	end

	item.Snowflake = snowflake(pluto_machine_id:GetInt())
	if (owner) then
		item.Owner = pluto.db.steamid64(owner)
	end

	assert(item.Owner, "No owner")
	local inserts = {
		{ "REPLACE INTO pluto_weapons (id, owner, tier, class) VALUES(?, ?, ?, ?)", {item.Snowflake, item.Owner, item.Tier.InternalName, item.ClassName}, function(err, q)
			local insert = q:lastInsert()

			item.RowID = insert
		end },
		{ "SET @gun = LAST_INSERT_ID()" },
	}

	if (item.Mods) then
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

	pluto.db.transact(inserts, function(err, t)
		if (err) then
			item.RowID = nil
			item.Snowflake = nil
			item.Owner = nil
			cb(nil)
			return
		end

		cb(item.Snowflake)
	end)
end

function pluto.weapons.generateunique(unique)
end

concommand.Add("pluto_generate_random_weapons", function(ply, cmd, args)
	if (IsValid(ply)) then
		return
	end

	local class = args[1]
	local tier = args[2]
	local count = tonumber(args[3] or 1)

	for i = 1, count do
		local gun = pluto.weapons.generatetier(tier, class)
		pprintf("Generated %s %s", gun.Tier.Name, weapons.GetStored(gun.ClassName).PrintName)
		for type, list in pairs(gun.Mods) do
			if (#list == 0) then
				continue
			end

			pprintf("    %s", type)

			for _, item in ipairs(list) do
				local mod = pluto.mods.byname[item.Mod]
				local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)
				pprintf("        %s tier %i - %s", pluto.mods.formataffix(mod.Type, mod.Name), item.Tier, mod:GetDescription(rolls))
			end
		end
	end
end)
