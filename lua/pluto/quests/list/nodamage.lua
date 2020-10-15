QUEST.Name = "Invulnerable"
QUEST.Description = "Kill people rightfully while at full health"
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and atk:Health() == atk:GetMaxHealth()) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(50, 60)
end