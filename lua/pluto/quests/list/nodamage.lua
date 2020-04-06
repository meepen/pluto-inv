QUEST.Name = "Invulnerable"
QUEST.Description = "Kill players while at full health."
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetRewardText(seed)
	return "set of two hearts"
end

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam() and atk:Health() == atk:GetMaxHealth()) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	pluto.inv.addcurrency(data.Player, "heart", 3)

	data.Player:ChatPrint(white_text, "You have received 3 ", pluto.currency.byname.heart, white_text, "!")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(50, 60)
end