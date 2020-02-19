MOD.Type = "prefix"
MOD.Name = "Proximity"
MOD.Tags = {
	"range"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Damage dropoff starts %s further"

MOD.Tiers = {
	{ 30, 50 },
	{ 20, 30 },
	{ 10, 20 },
	{ 0.1, 10 },
}

function MOD:ModifyWeapon(wep, roll)
	wep:DefinePlutoOverrides "DamageDropoffRange"
	wep.Pluto.DamageDropoffRange = wep.Pluto.DamageDropoffRange + roll[1] / 100
end

return MOD