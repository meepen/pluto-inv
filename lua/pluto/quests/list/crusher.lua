--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Noob Crusher"
QUEST.Description = "Crush people rightfully without movement abilities"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	local lastability = 0
	data:Hook("TTTBeginRound", function()
		lastability = 0
	end)
	data:Hook("PlutoMovementAbility", function(data, ply, what)
		if data.Player == ply then
			lastability = CurTime()
		end
	end)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		local succ = false

		if (IsValid(atk)) then
			succ = ((CurTime() > lastability + 5 and dmg:IsDamageType(DMG_FALL)) or dmg:IsDamageType(DMG_CRUSH)) and atk == data.Player
		elseif (dmg:IsDamageType(DMG_FALL) and vic.was_pushed and data.Player == vic.was_pushed.att and vic.was_pushed.t > CurTime() - 5) then
			succ = true
			atk = vic.was_pushed.att
		end

		if (IsValid(atk) and atk:IsPlayer() and atk:GetRoleTeam() ~= vic:GetRoleTeam() and succ) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(5, 10)
end