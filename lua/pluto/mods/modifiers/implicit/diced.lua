--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "implicit"
MOD.Name = "Diced"
MOD.Tags = {}

MOD.Color = Color(235, 193, 40)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return false
end

function MOD:FormatModifier(index, roll)
	return ""
end

MOD.Tomeable = true

MOD.Description = "Rolls better numbers on modifiers"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnRollMod(item, mod)
	for i = 1, #mod.Roll do
		mod.Roll[i] = Lerp(mod.Roll[i] + 0.3, 0.5, 1)
	end
end

return MOD