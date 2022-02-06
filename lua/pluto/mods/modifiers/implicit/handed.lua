--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "implicit"
MOD.Name = "Handed"
MOD.Tags = {}

MOD.Color = Color(255, 208, 86)

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

MOD.Description = "Mods roll one tier lower 50% of the time"

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:OnRollMod(item, mod)
	if (math.random() < 0.5) then
		mod.Tier = math.max(1, mod.Tier - 1)
	end
end

return MOD