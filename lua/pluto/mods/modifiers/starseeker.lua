--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "implicit"
MOD.Name = "Star Seeker"
MOD.Tags = {
	"greed"
}

MOD.Color = Color(254, 233, 105)

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
MOD.Description = "Stardust falls from the heavens after every kill."

MOD.Tiers = {
	{ 40, 50, 5, 10 },
}

function MOD:OnKill(wep, rolls, atk, vic)
	if (atk:GetRoleTeam() ~= vic:GetRoleTeam()) then
		pluto.currency.spawnfor(atk, "stardust")
		pluto.currency.spawnfor(atk, "stardust")
		if (math.random(2) == 1) then
			pluto.currency.spawnfor(atk, "stardust")
		end
	end
end

return MOD