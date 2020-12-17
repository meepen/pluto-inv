ROUND.PrintName = "Monke Mania"
ROUND.Author = "add___123"

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
	data.chimp = 1.05 + math.min(0.1, (ply:GetNWInt("MonkeScore", 0) * 0.01))
end)
