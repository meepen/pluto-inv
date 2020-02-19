MOD.Type = "prefix"
MOD.Name = "Vision"
MOD.Tags = {
	"range"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Farthest distance you can damage is %s further"

MOD.Tiers = {
	{ 30, 50 },
	{ 20, 30 },
	{ 10, 20 },
	{ 0.1, 10 },
}

function MOD:ModifyWeapon(wep, roll)
	wep:DefinePlutoOverrides "DamageDropoffRangeMax"
	wep.Pluto.DamageDropoffRangeMax = wep.Pluto.DamageDropoffRangeMax + roll[1] / 100
end

return MOD