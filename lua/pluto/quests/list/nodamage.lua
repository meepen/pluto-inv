QUEST.Name = "Invulnerable"
QUEST.Description = "Kill players while at full health."
QUEST.Credits = "Eppen"
QUEST.Color = Color(204, 43, 75)

function QUEST:GetRewardText(seed)
	return "set of three hearts"
end

function QUEST:Init(data)
end

function QUEST:Reward(data)
	pluto.inv.addcurrency(data.Player, "heart", 3):Run()

	data.Player:ChatPrint(white_text, "You have received 3 ", pluto.currency.byname.heart, white_text, "!")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(30, 40)
end