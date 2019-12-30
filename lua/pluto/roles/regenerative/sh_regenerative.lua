local Regenerative = "Regenerative"

hook.Add("TTTPrepareRoles", Regenerative, function(Team, Role)
	Role(Regenerative, "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return total_players > 8 and math.random(3) == 1 and 1 or 0
		end)
		:SetColor(Color(130, 67, 36))
end)