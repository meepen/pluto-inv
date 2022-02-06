--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "Greed"
MOD.Color = Color(3, 211, 55)
MOD.Tags = {
	"greed"
}

function MOD:IsNegative(roll)
	return false
end

function MOD:CanRollOn(class)
	return true
end

function MOD:FormatModifier(index, roll)
	return string.format("%.2f", roll)
end

-- 39.37 units = 1 meter
MOD.Description = "After a rightful kill, will show currencies within %s meters for %s seconds"

MOD.Tiers = {
	{ 40, 50, 5, 10 },
	{ 20, 30, 3, 8 },
	{ 10, 20, 1, 5 },
}

function MOD:OnKill(wep, rolls, atk, vic)
	if (atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
		pluto.statuses.greed(atk, rolls[1] * 39.37, rolls[2])
	end
end

return MOD