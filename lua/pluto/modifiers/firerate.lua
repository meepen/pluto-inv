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

function MOD:GetDescription(rolls)
	return rolls[1] >= 0 and "This gun shoots %s faster" or "This gun shoots %s slower"
end

MOD.Tiers = {
	{ 10, 16 },
	{ 5, 10 },
	{ 2.5, 5 },
	{ -1, 2.5 },
	{ -4, -1 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep:DefinePlutoOverrides "Delay"
	wep.Pluto.Delay = wep.Pluto.Delay - rolls[1] / 100
end

return MOD