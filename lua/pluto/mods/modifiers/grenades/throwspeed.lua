--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "prefix"
MOD.ItemType = "Grenade"
MOD.Name = "Power"
MOD.StatModifier = "ThrowVelocity"
MOD.Tags = {
	"speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Throw speed is increased by %s"

MOD.Tiers = {
	{ 35, 50 },
	{ 25, 35 },
	{ 15, 25 },
	{ 10, 15 },
}

return MOD