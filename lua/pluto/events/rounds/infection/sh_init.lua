--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
ROUND.PrintName = "Infection"
ROUND.Name = "Infection"
ROUND.Author = "add___123"
ROUND.Type = "Special"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("Survivor", "traitor")
		:SetColor(Color(128, 85, 0))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SeenByAll()
		:SetCanUseBuyMenu(false)

	Role("Infected", "traitor")
		:SetColor(Color(0, 128, 0))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SeenByAll()
		:SetCanUseBuyMenu(false)
		:SetCanSeeThroughWalls(false)
end

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	if (state and state.infected and state.infected[ply]) then
		data.infection = 1.3
	else
		data.infection = 0.9
	end
end)