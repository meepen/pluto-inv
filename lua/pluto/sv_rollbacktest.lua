--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local data = util.JSONToTable(file.Read("data/rollback_20200509.json", "GAME"))

local queries = {}

local function FindTierByName(name)
	if (name:StartWith " ") then
		return pluto.tiers.byname.unique
	end

	for _, tier in pairs(pluto.tiers.byname) do
		if (tier.InternalName == "unique") then
			continue
		end

		if (name:StartWith(tier.Name)) then
			return tier
		end
	end

	return pluto.tiers.byname.unique
end

local function FindWeaponByName(name)
	for _, class in pairs(weapons.GetList()) do
		local wep = baseclass.Get(class.ClassName)

		if (name:sub(-wep.PrintName:len()) == wep.PrintName) then
			return class.ClassName
		end
	end

	error("Couldn't find weapon: " .. name)
end

local function FindModByName(name)
	for _, mod in pairs(pluto.mods.byname) do
		if (mod.Name == name) then
			return mod
		end
	end

	error("Couldn't find mod: " .. name)
end

local function FindModelByName(name)
	local found, found_name
	for _, model in pairs(pluto.models) do
		if (model.Name and (not found or model.Name:len() > found.Name:len()) and name:StartWith(model.Name)) then
			found = model
		end
	end

	if (not found) then
		error("Couldn't find model: " .. name)
	end

	return found
end

local queries = {}

error "old code"
local transact = pluto.db.transact()
local function query(str, t)
	transact:AddQuery(str, t)
	local num = 0
	local out = str:gsub("?", function()
		num = num + 1
		return t[num] or "NULL"
	end)
	print(out)
	table.insert(queries, {str, t})
end


for steamid, items in pairs(data) do
	steamid = steamid:sub(2)

	
	query("INSERT INTO pluto_tabs (name, owner, tab_type) VALUES('Rollback', ?, 'normal')", {steamid})
	query "SET @tab = LAST_INSERT_ID()"

	local tabid = 1

	for _, item in pairs(items) do
		if (item.itemname:find "Model$") then
			
			local model = FindModelByName(item.itemname)

			if (not model) then
				error "no model"
			end

			query("INSERT INTO pluto_items (tier, class, tab_id, tab_idx, nick, special_name, original_owner) VALUES('', ?, @tab, ?, NULL, NULL, ?)", {"model_" .. model.InternalName, tabid, steamid})
		else
			local tier = nil
			if (item.shards) then
				item.shards = {
					FindTierByName(item.shards[1]),
					FindTierByName(item.shards[2]),
					FindTierByName(item.shards[3]),
				}
				tier = pluto.tiers.craft(item.shards)
			else
				tier = FindTierByName(item.itemname)
			end

			query("INSERT INTO pluto_items (tier, class, tab_id, tab_idx, nick, special_name, original_owner) VALUES (?, ?, @tab, ?, NULL, NULL, ?)", {tier.InternalName, FindWeaponByName(item.itemname), tabid, steamid})
			query "SET @gun = LAST_INSERT_ID()"

			if (item.shards) then
				query("INSERT INTO pluto_craft_data (gun_index, tier1, tier2, tier3) VALUES (@gun, ?, ?, ?)", {
					item.shards[1].InternalName,
					item.shards[2].InternalName,
					item.shards[3].InternalName,
				})
			end

			for modname, data in pairs(item.mods or {}) do
				local mod = FindModByName(modname)

				local tierdata = mod.Tiers[data.tier]

				local rolls = {}

				for roll in data.text:gmatch "%[(.-)%]%(https://pluto.gg%)" do
					local num = tonumber((roll:gsub("[^%d%.]", "")))
					local min = tierdata[#rolls * 2 + 1]
					local max = tierdata[#rolls * 2 + 2]
					local pct = (num - min) / (max - min)
					if (pct < 0 or pct > 1 or pct ~= pct) then
						pct = 1
					end

					rolls[#rolls + 1] = pct
				end

				query("INSERT INTO pluto_mods (gun_index, modname, tier, roll1, roll2, roll3) VALUES (@gun, ?, ?, ?, ?, ?)", {mod.InternalName, data.tier, rolls[1], rolls[2], rolls[3]})
			end
		end
		if (tabid > 36) then
			error "aaa"
		end
		tabid = tabid + 1
	end
end

transact:Run()

transact:AddCallback(function() print "DONE" end)