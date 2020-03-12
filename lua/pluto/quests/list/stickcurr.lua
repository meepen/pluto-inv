QUEST.Name = "Currency Revealer"
QUEST.Description = "Work with other people to stick %s of their currency with a sticky grenade"
QUEST.Color = Color(255, 0, 0)

function QUEST:GetRewardText(seed)
	return "random grenade"
end

function QUEST:Init(data)
	data:Hook("TTTGrenadeStuck", function(data, gren)
		if (gren:GetOwner() == data.Player and gren:GetParent():GetClass() == "pluto_currency") then
			print "PROGRESSO"
			data:UpdateProgress(1)
		end
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