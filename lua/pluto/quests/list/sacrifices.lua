--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "The Greater Good"
QUEST.Description = "Use Inevitable, Unusual, and Promised in crafting"
QUEST.Color = Color(170, 0, 255)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlutoWeaponCrafted", function(data, ply, wpn, items, cur)
		if (data.Player ~= ply) then
			return
		end

		for _, item in pairs(items) do
			if (item.Tier and item.Tier.InternalName and (item.Tier.InternalName == "inevitable" or item.Tier.InternalName == "unusual" or item.Tier.InternalName == "promised")) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(13, 17)
end
