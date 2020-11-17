ROUND.PrintName = "Monke Mania"

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
		:SetCanSeeThroughWalls(false)
end

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	data.chimp = 1.2 + math.min(0.4, (ply:GetNWInt("MonkeScore", 0) * 0.08))
end)
