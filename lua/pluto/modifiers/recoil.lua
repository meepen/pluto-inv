local MOD = {}
MOD.Type = "prefix"
MOD.Name = "Control"
MOD.Tags = {
	"recoil"
}
MOD.ModType = "percent"

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
	{ 10, 20 },
	{ 5, 10 },
	{ -5, 5 },
	{ -30, -15 },
	{ -50, -30 }
}

return MOD