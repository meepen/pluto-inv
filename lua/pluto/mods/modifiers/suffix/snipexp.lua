--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "Orbital Strikes"
MOD.Tags = {
	"damage", "aoe", "explosive",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:CanRollOn(class)
	return class.Primary and class.Primary.Ammo == "357"
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "%s of your shots will fire a rocket"

MOD.Tiers = {
	{ 0.25, 0.3 },
	{ 0.15, 0.25 },
	{ 0.05, 0.15 },
}

return MOD