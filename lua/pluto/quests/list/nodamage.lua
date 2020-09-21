QUEST.Name = "Invulnerable"
QUEST.Description = "Kill players while you are at full health"
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
	pluto.inv.addcurrency(data.Player, "heart", 2)

	local cur = pluto.currency.byname.heart
	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(cur.Name) and "an " or "a ", cur, white_text, " for completing ", self.Color, self.Name, white_text, "! (x2)")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(50, 60)
end