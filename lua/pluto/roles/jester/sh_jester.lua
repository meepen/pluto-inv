--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local RoleName = "Jester"

hook.Add("TTTPrepareRoles", RoleName, function(Team, Role)
	Team "jester"
		:SetColor(235, 35, 158)
		:SeenBy {"jester"}
		:SetModifyTicketsFunc(function(tickets)
			return tickets / 2
		end)
		:SetDeathIcon "materials/pluto/roles/jester.png"

	Role(RoleName, "jester")
		:SetCalculateAmountFunc(function(total_players)
			return total_players > 8 and 1 or 0
		end)
end)
