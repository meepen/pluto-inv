QUEST.Name = "The Inevitable"
QUEST.Description = "Win as a group of 3 or more traitors without anyone dying"
QUEST.Color = Color(175, 47, 36)

function QUEST:GetRewardText(seed)
	return "Inevitable gun"
end

function QUEST:Init(data)
	local good = false
	data:Hook("TTTBeginRound", function(data)
		good = data.Player:Alive() and data.Player:GetRoleTeam() == "traitor" and #round.GetActivePlayersByRole "traitor" >= 3
	end)

	data:Hook("DoPlayerDeath", function(data, ply)
		if (ply:GetRoleTeam() == "traitor") then
			good = false
		end
	end)

	data:Hook("TTTEndRound", function(data)
		if (good) then
			data:UpdateProgress(1)
		end
	end)
end

function QUEST:Reward(data)
	local trans, new_item = pluto.inv.generatebufferweapon(data.Player, "inevitable")
	trans:Run()

	data.Player:ChatPrint(white_text, "You have received ", startswithvowel(new_item.Tier.Name) and "an " or "a ", new_item, white_text, " for completing ", self.Color, self.Name, white_text, "! Check your inventory.")
end

function QUEST:IsType(type)
	return type == 1
end

function QUEST:GetProgressNeeded(type)
	return 1
end
