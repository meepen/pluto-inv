local MOD = {}
MOD.Type = "prefix"
MOD.Name = "Proximity"
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
		return string.format("Minimum range is increased by %.1f%%", roll)
	else
		return string.format("Minimum range is decreased by %.1f%%", -roll)
	end
end

MOD.Tiers = {
	{ 30, 50 },
	{ 20, 30 },
	{ 0, 20 },
	{ -20, 0 },
}

function MOD:ModifyWeapon()
end

return MOD