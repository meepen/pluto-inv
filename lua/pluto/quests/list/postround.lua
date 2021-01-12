QUEST.Name = "Final Fight"
QUEST.Description = "Kill people after the end of the round"
QUEST.Color = Color(153, 25, 0)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ENDED and atk == data.Player and atk ~= vic) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(50, 60)
end
