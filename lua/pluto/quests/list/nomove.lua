--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Grounded"
QUEST.Description = "Kill people rightfully in a row from the same spot"
QUEST.Color = Color(245, 245, 195)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local current = 0
	local spot

	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
		spot = nil
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			if (spot and spot:Distance(atk:GetPos()) <= 75) then
				current = current + 1
			else
				spot = atk:GetPos()
				current = 1
			end

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

function QUEST:GetProgressNeeded()
	return 2
end