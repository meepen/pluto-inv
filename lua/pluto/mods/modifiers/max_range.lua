--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "prefix"
MOD.Name = "Range"
MOD.StatModifier = "DamageDropoffRangeMax"
MOD.Tags = {
	"range"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Farthest distance you can damage is %s further"

MOD.Tiers = {
	{ 30, 50 },
	{ 20, 30 },
	{ 10, 20 },
	{ 0.1, 10 },
}

return MOD