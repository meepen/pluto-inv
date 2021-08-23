--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: Meepen

local name = "raining"

if (SERVER) then
	hook.Add("TTTBeginRound", "pluto_mini_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

		pluto.rounds.Notify("It's raining droplets!", pluto.currency.byname.droplet.Color)

		local count = #player.GetHumans()

		timer.Create("pluto_mini_" .. name, math.max(0.5, 0.5 + count / 12), math.max(40, 50 - count / 12), function()
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

		hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
			timer.Remove("pluto_mini_" .. name)
		end)
	end)

	hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
		timer.Remove("pluto_mini_" .. name)
	end)
else

end