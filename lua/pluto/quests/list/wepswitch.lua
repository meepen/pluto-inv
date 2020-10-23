QUEST.Name = "Swiss Army Traitor"
QUEST.Description = "Get a rightful kill with a melee, primary, and secondary in one round"
QUEST.Color = Color(45, 20, 130)
QUEST.RewardPool = "hourly"

function QUEST:Init(data)
	local current = 0
	local kills = {
		[1] = false,
		[2] = false,
		[3] = false,
	}
	data:Hook("TTTBeginRound", function(data, gren)
		current = 0
		kills = {
		[1] = false,
		[2] = false,
		[3] = false,
	}
	end)

	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and atk == data.Player and atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
			if (not inf:IsWeapon() or kills[inf:GetSlot()]) then
				return
			end

			current = current + 1
			kills[inf:GetSlot()] = true

			if (current == data.ProgressLeft) then
				data:UpdateProgress(data.ProgressLeft)
			end
		end
	end)
end

function QUEST:GetProgressNeeded()
	return 3
end