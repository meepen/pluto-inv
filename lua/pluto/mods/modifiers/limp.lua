--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "Crippling"
MOD.Color = Color(211, 3, 79)
MOD.Tags = {
	"damage", "hinder",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetModifier(roll, wep)
	return roll * 100
end

function MOD:FormatModifier(index, roll, wep)
	return string.format("%.02f%%", self:GetModifier(roll, baseclass.Get(wep)))
end

MOD.Description = "Has a %s chance to cripple on hit"

MOD.Tiers = {
	{ 0.7, 0.9 },
	{ 0.6, 0.7 },
	{ 0.45, 0.6 },
	{ 0.4, 0.45 },
}

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	if (math.random() * 100 < self:GetModifier(rolls[1], wep) / wep.Bullets.Num) then
		pluto.statuses.limp(vic, wep:GetDelay())
	end
end

return MOD