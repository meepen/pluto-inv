hook.Add("TTTPrepareRoles", "passevent", function(Team, Role)
	Role("Yaari Spy", "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return total_players > 8 and 1 or 0
		end)

	Role("Descendant", "innocent")
		:SetCalculateAmountFunc(function(total_players)
			return 1
		end)
end)