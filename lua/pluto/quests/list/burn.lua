--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Incinerator"
QUEST.Description = "Burn people to death rightfully"
QUEST.Color = Color(255, 136, 77)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		local succ = false

		if (not atk:IsPlayer() and vic.was_burned and vic.was_burned.t > CurTime() - 10) then
			atk = vic.was_burned.att
		end

		if (atk == data.Player and (dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(DMG_SLOWBURN))) then
			succ = true
		end

		if (IsValid(atk) and atk:IsPlayer() and atk:GetRoleTeam() ~= vic:GetRoleTeam() and succ) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(60, 75)
end