QUEST.Name = "Traitor Tracker"
QUEST.Description = "Kill traitors whose DNA you were following"
QUEST.Color = Color(21, 128, 0)
QUEST.RewardPool = "weekly"

function QUEST:Init(data)
	data:Hook("PlayerDeath", function(data, vic, inf, atk)
		if (ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE and atk == data.Player) then-- and atk:GetRoleTeam() ~= "traitor" and vic:GetRoleTeam() == "traitor") then
			local scanner = atk:GetWeapon("weapon_ttt_dna")
			local own

			if (IsValid(scanner) and IsValid(scanner:GetCurrentDNA())) then
				own = scanner:GetCurrentDNA():GetDNAOwner()
				if (own:GetClass() == "prop_ragdoll" and own.HiddenState) then
					own = own.HiddenState:GetPlayer()
				end
			end

			if (IsValid(own) and own == vic) then
				data:UpdateProgress(1)
			end
		end
	end)
end

function QUEST:IsType(type)
	return type == 3
end

function QUEST:GetProgressNeeded(type)
	return math.random(25, 30)
end