local MOD = {}
MOD.Type = "prefix"
MOD.Name = "Bount"
MOD.Tags = {
	"clip"
}
MOD.ModType = "percent"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("Clip size is increased by %.1f%%", roll)
	else
		return string.format("Clip size is decreased by %.1f%%", -roll)
	end
end

MOD.Tiers = {
	{ 20, 30 },
	{ 10, 20 },
	{ -10, 10 },
	{ -20, -10 },
}

function MOD:ModifyWeapon()
end

return MOD