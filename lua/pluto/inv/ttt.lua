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
		if (not IsValid(ply) or math.random(3) ~= 1) then
			continue
		end

		if (table.Count(pluto.afk[ply]) <= 3) then
			pprintf("%s was afk this round", ply:Nick())
			continue
		end

		local i = pluto.weapons.generatetier()

		i.TabID, i.TabIndex = pluto.inv.getfreespace(ply)

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