-- Author: Meepen

if (SERVER) then
	hook.Add("TTTBeginRound", "pluto_mini_raining", function()
		if (ttt.GetCurrentRoundEvent() ~= "") then
			return
		end

		if (not pluto.rounds or not pluto.rounds.minis) then
			return
		end

		if (not pluto.rounds.minis.raining and math.random(40) ~= 1) then
			return
		end

		pluto.rounds.minis.raining = nil

		pluto.rounds.Notify("It's raining droplets!", pluto.currency.byname.droplet.Color)

		local count = #player.GetHumans()

		timer.Create("pluto_mini_raining", math.max(0.5, 0.5 + count / 12), math.max(40, 50 - count / 12), function()
			for _, ply in pairs(player.GetHumans()) do
				if (not ply:Alive()) then
					continue
				end
				local e = pluto.currency.spawnfor(ply, (pluto.inv.roll {
					droplet = 15,
					pdrop = 1,
					aciddrop = 1
				}))
				e.SkipCrossmap = true
				e:SetPos(e:GetPos() + vector_up * 500)
				e:SetMovementType(CURRENCY_MOVEDOWN)
				e:Update()
			end
		end)
	end)
else

end