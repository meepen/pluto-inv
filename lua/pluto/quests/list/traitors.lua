--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Flawless Victory"
QUEST.Description = "Win as a group of 2 or more traitors without anyone dying"
QUEST.Color = Color(175, 47, 36)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local good = false
	data:Hook("TTTBeginRound", function(data)
		good = data.Player:Alive() and data.Player:GetRoleTeam() == "traitor" and #round.GetActivePlayersByRole "traitor" >= 2
	end)

	data:Hook("DoPlayerDeath", function(data, ply)
		if (ply:GetRoleTeam() == "traitor") then
			good = false
		end
	end)

	data:Hook("TTTEndRound", function(data)
		if (good) then
			data:UpdateProgress(1)
		end
		good = false
	end)
end

function QUEST:GetProgressNeeded()
	return 1
end
