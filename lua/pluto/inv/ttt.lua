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

		i.TabID, i.TabIndex = pluto.inv.getfreespace(ply, i)

		if (not i.TabID) then
			ply:ChatPrint("you are too full to receive a gun!")
			continue
		end

		print "saving"

		pluto.weapons.save(i, ply, function(id)
			if (not id) then
				ply:ChatPrint("error giving you a gun")
				return
			end
			ply:ChatPrint("You got mail!")
		end)
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