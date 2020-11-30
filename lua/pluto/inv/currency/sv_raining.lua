local rain
hook.Add("TTTBeginRound", "pluto_falling_currency", function()
	if (not rain and math.random(20) ~= 1) then
		return
	end

	rain = false

	ttt.chat(white_text, "It's ", pluto.currency.byname.droplet.Color, "pouring", white_text, " outside!")

	timer.Create("pluto_raining_currency", 1.5, 15, function()
		for _, ply in pairs(player.GetHumans()) do
			if (not ply:Alive()) then
				return
			end
			for i = 1, 5 do
				local e = pluto.currency.spawnfor(ply, pluto.inv.roll {
					droplet = 15,
					pdrop = 1,
					aciddrop = 1
				}, nil, "pluto_falling_currency")
				e:SetPos(e:GetPos() + vector_up * 500)
			end
		end
	end)
end)

concommand.Add("pluto_make_it_rain", function(p)
	if (not pluto.cancheat(p)) then
		return
	end

	rain = true
end)