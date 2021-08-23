--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Medic"
QUEST.Description = "Heal missing health"
QUEST.Color = Color(255, 0, 255)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("OnPlutoHealthGain", function(data, ply, amt)
		if (amt < 1) then
			return
		end

		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and ply == data.Player and ply:Alive()) then
			data:UpdateProgress(amt)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(800, 1000)
end