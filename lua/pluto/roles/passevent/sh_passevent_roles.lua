--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("TTTPrepareRoles", "passevent", function(Team, Role)
	Role("Yaari Spy", "traitor")
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)

	Role("Descendant", "innocent")
		:SetCalculateAmountFunc(function(total_players)
			return 0
		end)
		:SeenBy {"Yaari Spy"}
end)

--[[hook.Add("TTTRolesSelected", "passevent", function(plys)
	if (#round.Players >= 8) then
		for _, info in ipairs(round.Players) do
			if info.Role.Name == "Traitor" then
				info.Role = ttt.roles["Yaari Spy"]
				break
			end
		end
	end
end)--]]