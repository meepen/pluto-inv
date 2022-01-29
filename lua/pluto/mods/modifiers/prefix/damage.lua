--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "prefix"
MOD.Name = "Damage"
MOD.StatModifier = "Damage"
MOD.Tags = {
	"damage"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDamageMult(rolls)
	return rolls[1] / 100
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:GetDescription(rolls)
	return rolls[1] >= 0 and "Damage is increased by %s" or "Damage is decreased by %s"
end

MOD.Tiers = {
	{ 10, 15 },
	{ 6, 10 },
	{ 3, 6 },
	{ 1, 3 },
}

return MOD