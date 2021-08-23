--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
--[[
	not done columns

	healed INT UNSIGNED DEFAULT 0,

	assists INT UNSIGNED DEFAULT 0,
	hit_to_death INT UNSIGNED DEFAULT 0,

	currency_used INT UNSIGNED DEFAULT 0,
]]

pluto.tracker = pluto.tracker or {
	-- class = {key = add}
}
local function addstat(class, key, amount)
	local track = pluto.tracker[class]
	if (not track) then
		track = {}
		pluto.tracker[class] = track
	end

	track[key] = (track[key] or 0) + amount
end

local function IsPlutoGun(wep)
	return wep.PlutoGun and wep.PlutoGun.RowID
end

hook.Add("PlayerPostLoadout", "pluto_tracker", function(ply)
	for _, wep in ipairs(ply:GetWeapons()) do
		if (not IsPlutoGun(wep)) then
			continue
		end

		local class = wep:GetClass()

		addstat(class, "tracked", 1)
		addstat(class, "rounds_used", 1)

		local item = wep.PlutoGun

		local modcount = 0
		local modtiers = 0
		for type, modlist in pairs(item.Mods) do
			modcount = modcount + #modlist
			for _, mod in pairs(modlist) do
				modtiers = modtiers + mod.Tier
			end
		end
		
		addstat(class, "mods", modcount)
		addstat(class, "mod_tiers", modtiers)
	end
end)

hook.Add("PlayerCurrencyUse", "pluto_tracker", function(ply, wep, currency)
	if (not wep or wep.Type ~= "Weapon") then
		return
	end

	addstat(wep.ClassName, "currency_used", 1)
end)

hook.Add("EntityFireBullets", "pluto_tracker", function(wep, dat)
	if (not IsPlutoGun(wep)) then
		return
	end

	local owner = wep:GetOwner()

	if (not IsValid(owner) or not owner:IsPlayer()) then
		return
	end

	local classname = wep:GetClass()
	local is_ads = wep:GetIronsights()
	local is_jump = owner:KeyDown(IN_JUMP) or not owner:IsOnGround()
	local is_crouch = owner:KeyDown(IN_DUCK) or owner:Crouching()

	local cb = dat.Callback
	dat.Callback = function(ent, tr, dmg)
		addstat(classname, "fired", 1)
		if (is_ads) then
			addstat(classname, "ads_shots", 1)
		end
		if (is_crouch) then
			addstat(classname, "crouch_shots", 1)
		end
		if (is_jump) then
			addstat(classname, "jump_shots", 1)
		end

		if (not IsValid(tr.Entity) or not tr.Entity:IsPlayer()) then
			addstat(classname, "missed", 1)
		elseif (tr.HitGroup == HITGROUP_HEAD) then
			addstat(classname, "headshots", 1)
			if (is_ads) then
				addstat(classname, "ads_hits", 1)
			end
			if (is_crouch) then
				addstat(classname, "crouch_hits", 1)
			end
			if (is_jump) then
				addstat(classname, "jump_hits", 1)
			end
		end

		if (not cb) then
			return
		end
		return cb(ent, tr, dmg)
	end
end)

hook.Add("PlayerTakeDamage", "pluto_tracker", function(vic, wep, atk, damage, dmg)
	if (not IsValid(vic) or not vic:IsPlayer()) then
		return
	end

	if (not IsValid(wep) or not IsPlutoGun(wep)) then
		return
	end

	local classname = wep:GetClass()
	damage = math.Clamp(dmg:GetDamage(), 0, math.max(0, vic:Health()))
	addstat(classname, "damage", damage)

	local vic_wep = vic:GetActiveWeapon()
	if (not IsValid(vic_wep) or not IsPlutoGun(vic_wep)) then
		return
	end
	classname = vic_wep:GetClass()

	addstat(classname, "damage_taken", damage)
end)

hook.Add("DoPlayerDeath", "pluto_tracker", function(ply, atk, dmg)
	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	local wep = dmg:GetInflictor()
	if (not IsValid(wep) or not IsPlutoGun(wep)) then
		return
	end

	local classname = wep:GetClass()
	addstat(classname, "kills", 1)

	for _, vic_wep in ipairs(ply:GetWeapons()) do
		if (not IsPlutoGun(vic_wep)) then
			continue
		end
		local classname = vic_wep:GetClass()
		addstat(classname, "deaths", 1)
	end
end)

hook.Add("TTTEndRound", "pluto_tracker", function()
	local tracker = pluto.tracker
	pluto.tracker = {}
	pluto.db.instance(function(db)
		for classname, data in pairs(tracker) do
			local keys = {}
			local values = {}
			local update = {}
			for key, value in SortedPairs(data) do
				table.insert(keys, key)
				table.insert(values, value)
				table.insert(update, string.format("%s = %s + VALUE(%s)", key, key, key))
			end
			local q = "INSERT INTO pluto_class_stats (classname, " .. table.concat(keys, ", ") .. ") VALUES (" .. string.rep("?, ", #keys) .. "?) ON DUPLICATE KEY UPDATE " .. table.concat(update, ", ")
			mysql_stmt_run(db, q, classname, unpack(values))
		end
	end)
end)

hook.Add("PlutoHitregOverride", "pluto_tracker", function(ent)
	-- add stats?
end)
