MOD.Type = "prefix"
MOD.Name = "Capacity"
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
	{ 5, 10 },
	{ 0.1, 5 },
}

function MOD:ModifyWeapon(wep, roll)
	wep.Primary.ClipSize_Original = wep.Primary.ClipSize_Original or wep.Primary.ClipSize

	wep.Pluto.ClipSize = (wep.Pluto.ClipSize or 1) + roll[1] / 100
	local round = wep.Pluto.ClipSize > 1 and math.ceil or math.floor
	wep.Primary.ClipSize = round(wep.Primary.ClipSize_Original * wep.Pluto.ClipSize)
end

return MOD