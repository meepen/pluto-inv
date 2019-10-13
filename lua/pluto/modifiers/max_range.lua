MOD.Type = "prefix"
MOD.Name = "Vision"
MOD.Tags = {
	"range"
}
MOD.ModType = "percent"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("Max range is increased by %.1f%%", roll)
	else
		return string.format("Max range is decreased by %.1f%%", -roll)
	end
end

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