MOD.Type = "prefix"
MOD.Name = "Control"
MOD.Tags = {
	"recoil"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:GetDescription(rolls)
	return rolls[1] > 0 and "Recoil is decreased by %s" or "Recoil is increased by %s"
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
	wep.Pluto.ViewPunchAngles = wep.Pluto.ViewPunchAngles - roll[1] / 100
end

return MOD