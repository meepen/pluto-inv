hook.Add("TTTBeginRound", "pluto_shooting_stars", function()
    if (not pluto.rounds or not pluto.rounds.minis) then
		return
	end

	if (not pluto.rounds.minis.stars and math.random(20) ~= 1) then
		return
	end

	pluto.rounds.minis.stars = nil

	ttt.chat(white_text, "It's ", pluto.currency.byname.stardust.Color, "shooting stars", white_text, "!")

	timer.Create("pluto_shooting_stars", 4, 20, function()
		for _, ply in pairs(player.GetHumans()) do
			if (not ply:Alive()) then
				continue
			end
            local e = pluto.currency.spawnfor(ply, "_shootingstar")
            local target = ply:GetPos() + Vector(math.random(-80, 80), math.random(-80, 80), 0)
            local start = target + Vector(math.random(-500, 500), math.random(-500, 500), 350)
            e:SetPos(start)
            e:SetMovementType(CURRENCY_MOVEVECTOR)
            e:SetMovementVector((target - start):GetNormalized() * 2.5)
            e:Update()
		end
	end)
end)