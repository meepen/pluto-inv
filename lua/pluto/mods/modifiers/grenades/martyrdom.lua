MOD.Type = "suffix"
MOD.ItemType = "Grenade"
MOD.Name = "Revenge"
MOD.Tags = {}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Grenade has a %s chance to drop live on death!"

MOD.Tiers = {
	{ 75, 100 },
	{ 50, 75 },
	{ 25, 50 },
	{ 1, 25 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.MartyrDomChance = (rolls[1]) or 0
end

return MOD