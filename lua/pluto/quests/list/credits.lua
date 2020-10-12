QUEST.Name = "Mr. Rich"
QUEST.Description = "Spend Role Credits"
QUEST.Credits = "Eppen"
QUEST.Color = Color(198, 201, 14)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("TTTOrderedEquipment", function(data, ply, class, is_item, cost)
		if (ply == data.Player) then
			data:UpdateProgress(cost)
		end
	end)
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(80, 100)
end