hook.Add("TTTBeginRound", "pluto_falling_currency", function()
	if (ttt.GetCurrentRoundEvent() ~= "") then
		return
	end

    if (not pluto.rounds or not pluto.rounds.minis) then
		return
	end

	if (not pluto.rounds.minis.raining and math.random(30) ~= 1) then
		return
	end

	pluto.rounds.minis.raining = nil

	ttt.chat(white_text, "It's ", pluto.currency.byname.droplet.Color, "pouring", white_text, " outside!")

    local count = #player.GetHumans()

	timer.Create("pluto_raining_currency", math.max(2, 1 + count / 8), math.max(20, 25 - count / 6), function()
		for _, ply in pairs(player.GetHumans()) do
			if (not ply:Alive()) then
				continue
			end
			local e = pluto.currency.spawnfor(ply, (pluto.inv.roll {
				droplet = 15,
				pdrop = 1,
				aciddrop = 1
			}), nil, true)
			e:SetPos(e:GetPos() + vector_up * 500)
			e:SetMovementType(CURRENCY_MOVEDOWN)
			e:Update()
		end
	end)
end)