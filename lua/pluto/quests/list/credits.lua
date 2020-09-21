QUEST.Name = "Mr. Rich"
QUEST.Description = "Spend Role Credits"
QUEST.Credits = "Eppen"
QUEST.Color = Color(198, 201, 14)

function QUEST:GetRewardText(seed)
	return "set of 10 orange eggs"
end

function QUEST:Init(data)
	data:Hook("TTTOrderedEquipment", function(data, ply, class, is_item, cost)
		if (ply == data.Player) then
			data:UpdateProgress(cost)
		end
	end)
end

function QUEST:Reward(data)
	pluto.inv.addcurrency(data.Player, "crate2", 10)

	local cur = pluto.currency.byname.crate2
	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(cur.Name) and "an " or "a ", cur, white_text, " for completing ", self.Color, self.Name, white_text, "! (x10)")
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(80, 100)
end