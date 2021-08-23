--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
ROUND.PrintName = "Bunny Attack"
ROUND.Name = "Bunny Attack"
ROUND.Author = "Meepen"
ROUND.Type = "Special"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Bunny", "traitor")
		:SetColor(Color(235, 70, 150))
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