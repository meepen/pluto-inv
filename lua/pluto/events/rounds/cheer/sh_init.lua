--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
ROUND.PrintName = "Operation Cheer"
ROUND.Name = "Operation Cheer"
ROUND.Author = "add___123"
ROUND.Type = "Special"

function ROUND:TTTPrepareRoles(Team, Role)
	Role("S.A.N.T.A. Agent", "innocent")
		:SetColor(Color(255, 70, 70))
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
end

ROUND:Hook("TTTUpdatePlayerSpeed", function(self, state, ply, data)
	if (not state or not state.speed) then
		return
	end

	data.cheer = state.speed
end)
