MOD.Type = "prefix"
MOD.Name = "Cycle"
MOD.Tags = {
	"rpm", "speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "This gun shoots %s faster"

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