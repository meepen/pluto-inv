ROUND.PrintName = "Bunny Attack"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Bunny", "traitor")
		:SetColor(Color(235, 70, 150, 255))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SeenByAll()
		:SetCanUseBuyMenu(false)

	Role("Child", "innocent")
		:SetColor(Color(128, 120, 129))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
end