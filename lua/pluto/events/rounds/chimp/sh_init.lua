ROUND.PrintName = "Monke Mania"
ROUND.Name = "Monke Mania"
ROUND.Author = "add___123"
ROUND.Type = "Special"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Banna Boss", "traitor")
		:SetColor(Color(204, 180, 0))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SeenByAll()
		:SetCanUseBuyMenu(false)

	Role("Monke", "traitor")
		:SetColor(Color(77, 38, 0))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SetCanUseBuyMenu(false)
		:SetCanSeeThroughWalls(false)
end

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	data.chimp = 1.1
end)
