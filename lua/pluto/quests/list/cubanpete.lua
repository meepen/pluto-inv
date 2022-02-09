QUEST.Name = "Cuban Pete" --https://www.youtube.com/watch?v=O0__b2eLx84
QUEST.Description = "Kill players (Rightfully) with explosive damage." 
QUEST.Credits = "Len Kagamine"
QUEST.Color = Color(250, 88, 24)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("DoPlayerDeath", function(data, vic, atk, dmg)
		local succ = false

		if (atk == data.Player and dmg:IsDamageType(DMG_BLAST)) then
			succ = true
		end

		if (IsValid(atk) and atk:IsPlayer() and atk:GetRoleTeam() ~= vic:GetRoleTeam() and succ) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:GetProgressNeeded()
	return math.random(45, 60)
end