--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Flawless Victory"
QUEST.Description = "Win as a group of 3 or more traitors without anyone dying"
QUEST.Color = Color(175, 47, 36)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local good = false
	local altgood = false
	data:Hook("TTTBeginRound", function(data)
		if (data.Player:Alive() and data.Player:GetRoleTeam() == "traitor") then
			good = #round.GetActivePlayersByRole "traitor" >= 3
			if (not good) then
				altgood = true
				data.Player:ChatPrint("Because there aren't 3 traitors, you can do Flawless Victory by winning without taking damage!")
			end
		end
	end)

	data:Hook("DoPlayerDeath", function(data, ply)
		if (ply:GetRoleTeam() == "traitor") then
			good = false
		end
	end)

	data:Hook("EntityTakeDamage", function(data, vic, dmg)
		if (not altgood or vic ~= data.Player or dmg:GetDamage() < 1) then
			return
		end

		altgood = false
		data.Player:ChatPrint("You failed Flawless Victory by taking damage!")
	end)

	data:Hook("TTTEndRound", function(data)
		if (good or altgood) then
			data:UpdateProgress(1)
		end
		good = false
		altgood = false
	end)
end

function QUEST:GetProgressNeeded()
	return 1
end
