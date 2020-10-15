QUEST.Name = "Cemented"
QUEST.Description = "Kill people rightfully in one round without jumping"
QUEST.Credits = "add__123"
QUEST.Color = Color(204, 61, 5)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local current = 0
	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
	end)

	data:Hook("KeyPress", function(data, ply, key)
		if (ply == data.Player and key == IN_JUMP and ply:IsOnGround()) then
			current = 0
		end
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			current = current + 1

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return math.random(3, 4)
end