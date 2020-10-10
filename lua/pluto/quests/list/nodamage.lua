QUEST.Name = "Invulnerable"
QUEST.Description = "Kill players while you are at full health"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("daily", seed)
end

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and atk:Health() == atk:GetMaxHealth()) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	data.Name = self.Name
	data.Color = self.Color
	pluto.quests.poolreward("daily", data)
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(50, 60)
end