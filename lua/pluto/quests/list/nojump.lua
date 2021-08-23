--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Cemented"
QUEST.Description = "Kill people rightfully in one round without jumping"
QUEST.Credits = "add__123"
QUEST.Color = Color(204, 61, 5)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local current = 0
	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
	end)

	data:Hook("KeyPress", function(data, ply, key)
		if (ply == data.Player and key == IN_JUMP and ply:IsOnGround()) then
			current = 0
		end
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			current = current + 1

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(3, 4)
end