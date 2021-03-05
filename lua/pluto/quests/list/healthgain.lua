QUEST.Name = "Medic"
QUEST.Description = "Heal missing health"
QUEST.Color = Color(255, 0, 255)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("OnPlutoHealthGain", function(data, ply, amt)
		if (amt < 1) then
			return
		end

		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and ply == data.Player and ply:Alive()) then
			data:UpdateProgress(amt)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(800, 1000)
end