--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local Regenerative = "Regenerative"
local COOLDOWN = 0.25

AccessorFunc(FindMetaTable "Player", "m_LastRegen", "LastRegenerate")

hook.Add("OnPlayerRoleChange", Regenerative, function(ply, old, new)
	if (new == Regenerative) then
		ply:SetLastRegenerate(CurTime())
	end
end)

hook.Add("PlayerTick", Regenerative, function(ply)
	if (ply:GetRole() == Regenerative and ply:Alive() and GetRoundState() == ROUND_ACTIVE) then
		if (ply:GetLastRegenerate() + COOLDOWN < CurTime()) then
			ply:SetLastRegenerate(CurTime())
			local hp = ply:Armor() + ply:Health()
			local left = ply:GetMaxHealth() - hp

			ply:SetArmor(math.min(ply:Armor() + math.min(left, 1), 50))
		end
	end
end)

hook.Add("PlayerTakeDamage", Regenerative, function(ply)
	if (ply:GetRole() == Regenerative) then
		ply:SetLastRegenerate(CurTime() + 5)
	end
end)