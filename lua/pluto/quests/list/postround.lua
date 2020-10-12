QUEST.Name = "Final Fight"
QUEST.Description = "Kill people after the end of the round"
QUEST.Color = Color(153, 25, 0)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("daily", seed)
end

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ENDED and atk == data.Player) then
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
	return math.random(50, 70)
end
