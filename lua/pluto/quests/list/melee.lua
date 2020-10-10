QUEST.Name = "Clubber"
QUEST.Description = "Hit people rightfully with a melee before murdering them"
QUEST.Credits = "Phrot"
QUEST.Color = Color(204, 61, 5)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("hourly", seed)
end

function QUEST:Init(data)
	local meleed = {}
	data:Hook("TTTBeginRound", function(data, gren)
		meleed = {}
	end)

	data:Hook("EntityTakeDamage", function(data, vic, dmg)
		local inf, atk = dmg:GetInflictor(), dmg:GetAttacker()

		if (IsValid(inf) and atk == data.Player and vic:IsPlayer() and inf.Slot == 0 and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			meleed[vic] = true
		end
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and meleed[vic]) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	data.Name = self.Name
	data.Color = self.Color
	pluto.quests.poolreward("hourly", data)
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(4, 5)
end
