--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local RoleName = "Jester"

local Speedup = 10

local JesterWin = false

hook.Add("PlayerShouldTakeDamage", RoleName, function(ply, atk)
	if (IsValid(atk) and atk:IsPlayer() and atk:GetRole() == RoleName) then
		return false
	end
end)

hook.Add("PlayerDeath", RoleName, function(ply, inf, atk)
	if (not IsValid(atk) or not atk:IsPlayer() or atk == ply or atk:GetRoleData().Evil) then
		return
	end

	if (ply:GetRole() == RoleName and GetRoundState() == ROUND_ACTIVE) then
		round.Speedup(Speedup)
		JesterWin = true
	end
end)

hook.Add("TTTBeginRound", RoleName, function()
	JesterWin = false
end)

hook.Add("TTTOverrideWin", RoleName, function(winning_team, winners, why)
	if (JesterWin and why == "time_limit") then
		return "jester", round.GetAllPlayersWithRole "jester", why
	end
end)