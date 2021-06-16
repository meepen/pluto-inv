ROUND.PrintName = "Hotshot"
ROUND.Name = "Hotshot"
ROUND.Author = "add___123"
ROUND.Type = "Special"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Hotshot", "innocent")
		:SetColor(Color(255, 213, 0))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
end