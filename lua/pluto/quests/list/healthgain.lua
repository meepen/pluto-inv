QUEST.Name = "Medic"
QUEST.Description = "Heal missing health"
QUEST.Color = Color(255, 0, 255)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("PlutoHealthGain", function(data, ply, amt)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and ply == data.Player and ply:Alive()) then
			data:UpdateProgress(amt)
		end
	end)
end

function QUEST:IsType(type)
	return type == 2
end

function QUEST:GetProgressNeeded(type)
	return math.random(800, 1000)
end