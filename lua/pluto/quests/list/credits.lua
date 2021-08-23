--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Mr. Rich"
QUEST.Description = "Spend Role Credits"
QUEST.Credits = "Eppen"
QUEST.Color = Color(198, 201, 14)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("TTTOrderedEquipment", function(data, ply, class, is_item, cost)
		if (ply == data.Player) then
			data:UpdateProgress(cost)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(80, 100)
end