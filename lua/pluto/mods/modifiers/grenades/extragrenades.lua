
MOD.Type = "suffix"
MOD.ItemType = "Grenade"
MOD.Name = "Spares"
MOD.Tags = {}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%i", roll)
end

MOD.Description = "Carry %s more of this grenade."

MOD.Tiers = {
	{ 1, 1 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.Primary.ClipSize = (wep.Primary.ClipSize or 1) + (rolls[1])
end

return MOD