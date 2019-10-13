MOD.Type = "prefix"
MOD.Name = "Cycle"
MOD.Tags = {
	"rpm", "speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("RPM is increased by %.1f%%", roll)
	else
		return string.format("RPM is reduced by %.1f%%", -roll)
	end
end

MOD.Tiers = {
	{ 5,     10  },
	{ 2.5,   5   },
	{ -1,  2.5 },
	{ -4,   -1 },
	{ -6, -4 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.Pluto.Delay = wep.Pluto.Delay + rolls[1] / 100
end

return MOD