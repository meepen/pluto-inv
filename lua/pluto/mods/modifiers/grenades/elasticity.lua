--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "Elasticity"
MOD.Tags = {}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:CanRollOn(wep)
	return wep.ClassName ~= "weapon_ttt_sticky_grenade"
end

MOD.Description = "This grenade is %s less bouncy"

MOD.Tiers = {
	{ 45, 60 },
	{ 30, 45 },
	{ 15, 30 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.Bounciness = (wep.Bounciness or 0) * (1 - rolls[1] / 100)
end

MOD.ItemType = "Grenade"

return MOD