local RoleName = "Jester"

hook.Add("TTTPrepareRoles", RoleName, function(Team, Role)
	Team "jester"
		:SetColor(235, 35, 158)
		:SeenBy {"jester"}
		:SetModifyTicketsFunc(function(tickets)
			return tickets / 2
		end)

	Role(RoleName, "jester")
		:SetCalculateAmountFunc(function(total_players)
			return total_players > 8 and 1 or 0
		end)
end)
