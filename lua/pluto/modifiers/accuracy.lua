local MOD = {}
MOD.Type = "prefix"
MOD.Name = "Precise"
MOD.Tags = {
	"accuracy"
}
MOD.ModType = "percent"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("Accuracy is increased by %.1f%%", roll)
	else
		return string.format("Accuracy is decreased by %.1f%%", -roll)
	end
end

MOD.Tiers = {
	{ 15, 25 },
	{ 5, 15 },
	{ -5, 5 },
	{ -20, -5 },
}

function MOD:ModifyWeapon()
end

return MOD