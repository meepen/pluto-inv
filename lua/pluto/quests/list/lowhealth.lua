QUEST.Name = "Last Stand"
QUEST.Description = "Get kills while under 20 health"
QUEST.Credits = "Froggy"
QUEST.Color = Color(204, 255, 25)
QUEST.RewardPool = "daily"

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		if (not IsValid(vic) or not IsValid(atk) or data.Player ~= atk or atk:GetRoleTeam() == vic:GetRoleTeam()) then
			return
		end

		if (atk:Alive() and atk:Health() < 20) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(20, 30)
end