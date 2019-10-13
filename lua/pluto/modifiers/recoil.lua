MOD.Type = "prefix"
MOD.Name = "Control"
MOD.Tags = {
	"recoil"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("Recoil is reduced by %i%%", roll)
	else
		return string.format("Recoil is increased by %i%%", -roll)
	end
end

MOD.Tiers = {
	{ 15, 25 },
	{ 10, 15 },
	{ 5, 10 },
	{ 2.5, 5 },
	{ -2.5, 2.5 },
}

function MOD:ModifyWeapon(wep, roll)
	wep:DefinePlutoOverrides "ViewPunchAngles"
	wep.Pluto.DamageDropoffRange = wep.Pluto.ViewPunchAngles - roll[1] / 100
end

return MOD