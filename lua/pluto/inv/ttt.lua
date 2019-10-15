pluto.afk = pluto.afk or {}

hook.Add("PlayerInitialSpawn", "pluto_afk", function(ply)
	pluto.afk[ply] = {}
end)

hook.Add("TTTBeginRound", "pluto_afk", function()
	for _, ply in pairs(round.GetStartingPlayers()) do
		pluto.afk[ply.Player] = {}
	end
end)

hook.Add("PlayerButtonDown", "pluto_afk", function(ply, btn)
	pluto.afk[ply][btn] = true
end)

local function ornull(n)
	return n and SQLStr(n) or "NULL"
end

local function name(x)
	if (not IsValid(x)) then
		return nil
	elseif (x:IsPlayer()) then
		return x:Nick()
	else
		return x.GetPrintName and x:GetPrintName() or x.PrintName or x:GetClass()
	end
end

hook.Add("DoPlayerDeath", "pluto_info", function(vic, atk, dmg)
	local wep = dmg:GetInflictor()
	local atk = dmg:GetAttacker()

	local text = "You died somehow."

	if (IsValid(atk)) then
		if (atk:IsPlayer() and IsValid(wep) and wep:IsWeapon()) then
			text = string.format("%s killed you with their %s. They were a %s.", atk:Nick(), name(wep), atk:GetRole())
		elseif (dmg:IsDamageType(DMG_CRUSH)) then
			local inf = wep or atk
			if (IsValid(inf)) then
				text = string.format("You were crushed by %s", name(inf))
			else
				text = "You were crushed."
			end
		elseif (dmg:IsDamageType(DMG_FALL)) then
			text = "You fell to your death."
		elseif (dmg:IsDamageType(DMG_DROWN)) then
			text = "You drowned."
		end
	end

	vic:ChatPrint(text)
end)

hook.Add("TTTEndRound", "pluto_endround", function()
	for _, obj in pairs(round.GetStartingPlayers()) do
		local ply = obj.Player
		if (not IsValid(ply)) then
			continue
		end

		if (table.Count(pluto.afk[ply]) <= 3) then
			ply.WasAFK = true
			pprintf("%s was afk this round", ply:Nick())
			continue
		end
		ply.WasAFK = false

		if (not IsValid(ply) or math.random(3) ~= 1) then
			continue
		end

		local i = pluto.weapons.generatetier()
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

		local items = sql.Query("SELECT idx FROM pluto_items WHERE owner = " .. SQLStr(ply:SteamID64()) .. " ORDER BY idx DESC")

		if (#items > 5) then
			for i = 6, #items do
				items[i] = items[i].idx
			end

			-- TODO(meep): generate currency

			sql.Query("DELETE FROM pluto_items WHERE idx IN (" .. table.concat(items, ", ", 6) .. ")")
		end

		pluto.inv.message(ply)
			:write("bufferitem", i)
			:send()

		ply:ChatPrint("You got mail!")
	end
end)

hook.Add("TTTPlayerGiveWeapons", "pluto_loadout", function(ply)
	if (not pluto.inv.invs[ply]) then
		return
	end

	local equip_tab

	for _, tab in pairs(pluto.inv.invs[ply]) do
		if (tab.Type == "equip") then
			equip_tab = tab
			break
		end
	end

	if (not equip_tab) then
		pwarnf("Player doesn't have equip tab!")
		return
	end

	local i1 = equip_tab.Items[1]

	if (i1) then
		pluto.NextWeaponSpawn = i1
		ply:Give(i1.ClassName)
	end

	local i2 = equip_tab.Items[2]

	if (i2) then
		pluto.NextWeaponSpawn = i2
		ply:Give(i2.ClassName)
	end
end)