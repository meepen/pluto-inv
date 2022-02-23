--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
-- Author: add___123

local name = "stars"

if (SERVER) then
	function pluto.rounds.shootstars()
		timer.Create("pluto_mini_" .. name, 0.33, 30, function()
			for _, ply in pairs(player.GetHumans()) do
				if (not ply:Alive()) then
					continue
				end
				local e = pluto.currency.spawnfor(ply, "_shootingstar", nil, true)
				local eyes = ply:GetEyeTrace().HitPos - ply:GetPos()
				eyes = Vector(eyes.x, eyes.y, 0)
				eyes = eyes:GetNormalized()
				local target = ply:GetPos() + Vector(eyes.x * 150 + math.random(-100, 100), eyes.y * 150 + math.random(-100, 100), math.random(-10, 30))
				local start = target + Vector(eyes.x * 500 + math.random(-300, 300), eyes.y * 500 + math.random(-300, 300), math.random(200, 300))
				e.SkipCrossmap = true
				e:SetPos(start)
				e:SetMovementType(CURRENCY_MOVEVECTOR)
				e:SetMovementVector((target - start):GetNormalized() * 7.5)
				e:Update()
			end
		end)
	end

	hook.Add("TTTBeginRound", "pluto_shooting_" .. name, function()
        if (not pluto.rounds.minis[name]) then
            return
        end

		pluto.rounds.minis[name] = nil

		pluto.rounds.Notify("It's shooting stars!", pluto.currency.byname.stardust.Color)

		pluto.rounds.shootstars()
		
		hook.Add("TTTEndRound", "pluto_mini_" .. name, function()
            hook.Remove("TTTEndRound", "pluto_mini_" .. name)
			timer.Remove("pluto_mini_" .. name)
		end)
	end)
else

end