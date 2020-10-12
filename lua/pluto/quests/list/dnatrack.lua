QUEST.Name = "Traitor Tracker"
QUEST.Description = "Kill traitors whose DNA you were following"
QUEST.Color = Color(21, 128, 0)

function QUEST:GetRewardText(seed)
	return pluto.quests.poolrewardtext("weekly", seed)
end

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and atk == data.Player and atk:GetRoleTeam() ~= "traitor" and vic:GetRoleTeam() == "traitor") then
			local scanner = atk:GetWeapon("weapon_ttt_dna")

			if (not IsValid(scanner) or not IsValid(scanner:GetCurrentDNA())) then
				return
			end

			if (scanner:GetCurrentDNA():GetOwner() == vic) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:Reward(data)
	data.Name = self.Name
	data.Color = self.Color
	pluto.quests.poolreward("weekly", data)
end

function QUEST:IsType(type)
	return type == 3
end

function QUEST:GetProgressNeeded(type)
	return math.random(50, 65)
end