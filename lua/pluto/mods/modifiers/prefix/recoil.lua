--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "prefix"
MOD.Name = "Recoil"
MOD.StatModifier = "ViewPunchAngles"
MOD.Tags = {
	"recoil"
}

function MOD:IsNegative(roll)
	return roll > 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:GetDescription(rolls)
	return rolls[1] < 0 and "Recoil is decreased by %s" or "Recoil is increased by %s"
end

MOD.Tiers = {
	{ -35, -50 },
	{ -25, -35 },
	{ -15, -25 },
	{ 15, -15 },
}

return MOD