MOD.Type = "prefix"
MOD.Name = "Capacity"
MOD.Tags = {
	"mag"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Clip size is increased by %s"

MOD.Tiers = {
	{ 20, 30 },
	{ 10, 20 },
	{ 5, 10 },
	{ 0.1, 5 },
}

function MOD:ModifyWeapon(wep, roll)
	wep.Primary.ClipSize_Original = wep.Primary.ClipSize_Original or wep.Primary.ClipSize
	wep.Primary.DefaultClip_Original = wep.Primary.DefaultClip_Original or wep.Primary.DefaultClip

	wep.Pluto.ClipSize = (wep.Pluto.ClipSize or 1) + roll[1] / 100
	local round = wep.Pluto.ClipSize > 1 and math.ceil or math.floor
	wep.Primary.ClipSize = round(wep.Primary.ClipSize_Original * wep.Pluto.ClipSize)
	wep.Primary.DefaultClip = round(wep.Primary.DefaultClip_Original * wep.Pluto.ClipSize)
end

return MOD