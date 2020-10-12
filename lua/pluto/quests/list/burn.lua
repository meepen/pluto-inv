QUEST.Name = "Incinerator"
QUEST.Description = "Burn people to death rightfully"
QUEST.Color = Color(255, 136, 77)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("weekly", seed)
end

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		local succ = false

		if (dmg:IsDamageType(DMG_BURN) or dmg:IsDamageType(DMG_BLAST) or dmg:IsDamageType(270532608) or dmg:IsDamageType(268435464)) then
			succ = true
			if (not atk:IsPlayer() and vic.was_burned and data.Player == vic.was_burned.att and vic.was_burned.t > CurTime() - 5) then
				atk = vic.was_burned.att
			end
		end

		if (IsValid(atk) and atk:IsPlayer() and atk:GetRoleTeam() ~= vic:GetRoleTeam() and succ) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	data.Name = self.Name
	data.Color = self.Color
	pluto.quests.poolreward("weekly", data)
end

function QUEST:IsType(type)
	return type == 3
end

function QUEST:GetProgressNeeded(type)
	return math.random(90, 105)
end