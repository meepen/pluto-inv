--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
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
