MOD.Type = "suffix"
MOD.Name = "Timing"
MOD.Tags = {
	"speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "This grenade takes %s longer to explode"

MOD.Tiers = {
	{ 60, 80 },
	{ 45, 60 },
	{ 25, 35 },
	{ 15, 35 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.Primary.Delay = wep.Primary.Delay * (1 + rolls[1] / 100)
end

MOD.ItemType = "Grenade"

return MOD