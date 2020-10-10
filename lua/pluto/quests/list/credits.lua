QUEST.Name = "Mr. Rich"
QUEST.Description = "Spend Role Credits"
QUEST.Credits = "Eppen"
QUEST.Color = Color(198, 201, 14)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("daily", seed)
end

function QUEST:Init(data)
	data:Hook("TTTOrderedEquipment", function(data, ply, class, is_item, cost)
		if (ply == data.Player) then
			data:UpdateProgress(cost)
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
	return math.random(80, 100)
end