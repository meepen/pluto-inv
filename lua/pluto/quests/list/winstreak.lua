QUEST.Name = "Survivor"
QUEST.Description = "Win rounds in a row without dying"
QUEST.Color = Color(204, 170, 0)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	data:Hook("TTTEndRound", function(data)
		if (data.Player:Alive()) then
			data:UpdateProgress(1)
		end
	end)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (data.Player == vic and ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE) then
			data:UpdateProgress(data.ProgressLeft - data.TotalProgress)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(2, 3)
end