--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "prefix"
MOD.Name = "Reload Speed"
MOD.StatModifier = "ReloadAnimationSpeed"
MOD.Tags = {
	"reload", "speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Reloads %s faster"

MOD.Tiers = {
	{ 40, 60 },
	{ 25, 40 },
	{ 10, 25 },
	{ -10, 10 },
}

return MOD