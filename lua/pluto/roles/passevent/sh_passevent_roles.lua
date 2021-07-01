hook.Add("TTTPrepareRoles", "passevent", function(Team, Role)
	Role("Yaari Spy", "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)

	Role("Descendant", "innocent")
		:SetCalculateAmountFunc(function(total_players)
			return 1
		end)
		:SeenBy {"Yaari Spy"}
end)

hook.Add("TTTRolesSelected", "passevent", function(plys)
	if (#round.Players >= 8) then
		for _, info in ipairs(round.Players) do
			if info.Role.Name == "Traitor" then
				info.Role = ttt.roles["Yaari Spy"]
				break
			end
		end
	end
end)