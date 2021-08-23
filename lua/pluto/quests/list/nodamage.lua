--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Invulnerable"
QUEST.Description = "Kill people rightfully while at full health"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and atk:Health() == atk:GetMaxHealth()) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(50, 60)
end