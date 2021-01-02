QUEST.Name = "Bold Killer"
QUEST.Description = "Identify innocents immediately after rightfully killing them"
QUEST.Color = Color(130, 0, 20)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	local kills = {}

	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (not IsValid(vic) or not IsValid(atk) or data.Player ~= atk or atk:GetRoleTeam() ~= "traitor" or vic:GetRoleTeam() ~= "innocent") then
			return
		end

		kills[vic] = CurTime()
	end)

	data:Hook("TTTBodyIdentified", function(data, vic, atk)
		if (not IsValid(vic) or not IsValid(atk) or data.Player ~= atk) then
			return
		end

		if (kills[vic] and CurTime() <= kills[vic] + 5) then
			kills[vic] = nil
			data:UpdateProgress(1)
		end
	end)

	data:Hook("TTTEndRound", function(data)
		kills = {}
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(45, 55)
end