MOD.Type = "prefix"
MOD.Name = "Strength"
MOD.Tags = {
	"damage"
}
MOD.ModType = "percent"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDamageMult(rolls)
	return rolls[1] / 100
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("Damage is increased by %i%%", roll)
	else
		return string.format("Damage is reduced by %i%%", -roll)
	end
end

MOD.Tiers = {
	{ 10, 20 },
	{ 5, 10 },
	{ -5, 5 },
	{ -10, -5 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep:DefinePlutoOverrides "Damage"
	wep.Pluto.Damage = wep.Pluto.Damage + rolls[1] / 100
end

return MOD