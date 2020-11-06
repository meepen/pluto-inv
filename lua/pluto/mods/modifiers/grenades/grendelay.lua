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

MOD.Description = "This grenade takes %s less time to explode"

MOD.Tiers = {
	{ 45, 55 },
	{ 35, 45 },
	{ 25, 35 },
	{ 15, 25 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.Primary.Delay = wep.Primary.Delay * (1 - rolls[1] / 100)
end

MOD.ItemType = "Grenade"

return MOD