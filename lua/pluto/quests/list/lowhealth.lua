--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Last Stand"
QUEST.Description = "Get kills while under 30 health"
QUEST.Credits = "Froggy"
QUEST.Color = Color(204, 255, 25)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (not IsValid(vic) or not IsValid(atk) or data.Player ~= atk or atk:GetRoleTeam() == vic:GetRoleTeam()) then
			return
		end

		if (atk:Alive() and atk:Health() < 30) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(20, 30)
end