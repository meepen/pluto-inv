--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Unstoppable"
QUEST.Description = "Get rightful kills in quick succession"
QUEST.Credits = "Froggy"
QUEST.Color = Color(0, 128, 100)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (not IsValid(vic) or not IsValid(atk) or data.Player ~= atk or atk:GetRoleTeam() == vic:GetRoleTeam()) then
			return
		end
		
		data:UpdateProgress(1)

		timer.Remove("Unstoppable" .. atk:Nick())

		timer.Create("Unstoppable" .. atk:Nick(), 4, 0, function()
			if (data and IsValid(atk) and data.ProgressLeft > 0) then
				data:UpdateProgress(data.ProgressLeft - data.TotalProgress)
			end
		end)
	end)
end

function QUEST:GetProgressNeeded()
	return 3
end