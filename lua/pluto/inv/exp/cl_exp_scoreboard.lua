--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
hook.Add("TTTRWScoreboardPlayer", "pluto_level", function(ply, add)
	local pnl = add()

	local col = ply:GetPlutoLevelColor()

	if (isfunction(col)) then
		hook.Add("Tick", pnl, function(self)
			self:SetColor(col())
		end)
	else
		pnl:SetColor(col)
	end

	pnl:SetText(ply:GetPlutoLevel())
end)