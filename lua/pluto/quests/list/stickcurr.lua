QUEST.Name = "Game Player"
QUEST.Description = "Play %s rounds"

function QUEST:GetRewardText(seed)
	return string.format("%i Droplets", 8 + math.floor(seed * 3))
end

function QUEST:Init(data)
	data:Hook("TTTEndRound", function(data)
		data:UpdateProgress(1)
	end)
end

function QUEST:Reward(data)
	-- 8 + math.floor(seed * 3) droplets
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(3, 4)
end