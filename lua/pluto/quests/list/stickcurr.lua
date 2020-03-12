QUEST.Name = "Game Player"
QUEST.Description = "Play %s rounds"

function QUEST:Init(data)
	data:Hook("TTTEndRound", function(data)
		print "updato"
		data:UpdateProgress(1)
	end)
end

function QUEST:Reward(data)
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(3, 4)
end