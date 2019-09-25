local MOD = {}
MOD.Type = "prefix"
MOD.Name = "Speed"
MOD.Tags = {
	"rpm", "speed"
}
MOD.ModType = "percent"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("RPM is increased by %.1f%%", roll)
	else
		return string.format("Recoil is reduced by %.1f%%", -roll)
	end
end

MOD.Tiers = {
	{ 5,   10  },
	{ 2.5, 5   },
	{ -5,  2.5 },
	{ -5, -2.5 },
	{ -7.5, -5 }
}

return MOD