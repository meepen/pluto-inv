--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "implicit"
MOD.Name = "Tomed"
MOD.Tags = {}

MOD.Color = Color(153, 6, 87)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.NoCoined = true

MOD.Description = "This item awaits the tome..."

MOD.Tiers = {
	{ 1, 1 },
}

return MOD