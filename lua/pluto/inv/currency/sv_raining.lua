hook.Add("TTTBeginRound", "pluto_falling_currency", function()
	if (math.random(20) ~= 1) then
		return
	end

	ttt.chat(pluto.currency.byname.droplet.Color, "It's pouring outside!")

	timer.Create("pluto_raining_currency", 1, 20, function()
		for _, ply in pairs(player.GetHumans()) do
			for i = 1, 6 do
				if (not ply:Alive()) then
					return
				end
				local e = pluto.currency.spawnfor(ply, "droplet", nil, "pluto_falling_currency")
				e:SetPos(e:GetPos() + vector_up * 500)
			end
		end
	end)
end)
