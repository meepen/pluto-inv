--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
QUEST.Name = "Clubber"
QUEST.Description = "Hit people rightfully with a melee before murdering them"
QUEST.Credits = "Phrot"
QUEST.Color = Color(204, 61, 5)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local meleed = {}
	data:Hook("TTTBeginRound", function(data, gren)
		meleed = {}
	end)

	data:Hook("EntityTakeDamage", function(data, vic, dmg)
		local inf, atk = dmg:GetInflictor(), dmg:GetAttacker()

		if (IsValid(inf) and atk == data.Player and vic:IsPlayer() and (inf.Slot == 0 or inf.ClassName == "weapon_ttt_deagle_u" and dmg:IsDamageType(DMG_CLUB)) and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			meleed[vic] = true
		end
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and meleed[vic]) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(4, 5)
end
