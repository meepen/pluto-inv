MOD.Type = "prefix"
MOD.Name = "Strength"
MOD.Tags = {
	"damage"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDamageMult(rolls)
	return rolls[1] / 100
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Damage is increased by %s"

MOD.Tiers = {
	{ 10, 20 },
	{ 5, 10 },
	{ 2.5, 5 },
	{ 0.1, 2.5 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep:DefinePlutoOverrides "Damage"
	wep.Pluto.Damage = wep.Pluto.Damage + rolls[1] / 100
end

return MOD