--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "The Collector"
QUEST.Description = "Collect currencies from mini-events"
QUEST.Color = Color(212, 0, 255)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlutoCurrencyPickup", function(data, cur, ply)
		if (not IsValid(cur) or not IsValid(ply) or data.Player ~= ply) then
			return
		end

		local name = cur:GetCurrencyType()
		local movetype = cur:GetMovementType()

		if (name == "_shootingstar" or name == "_chancedice" or movetype == CURRENCY_MOVEDOWN) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(80, 100)
end