QUEST.Name = "Medic"
QUEST.Description = "Heal missing health"
QUEST.Color = Color(255, 0, 255)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("daily", seed)
end

function QUEST:Init(data)
	data:Hook("PlutoHealthGain", function(data, ply, amt)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and ply:Alive()) then
			data:UpdateProgress(amt)
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
	return math.random(800, 1000)
end