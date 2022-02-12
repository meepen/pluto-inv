MOD.Type = "suffix"
MOD.ItemType = "Grenade"
MOD.Name = "Napalm"
MOD.Tags = {}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:CanRollOn(wep)
	return wep.ClassName ~= "weapon_ttt_smoke_grenade" or "weapon_ttt_barrel_grenade" or "weapon_ttt_barrier_grenade" or "weapon_ttt_cage_grenade"
end

MOD.Description = "Grenade has a %s chance to explode into fire!"

MOD.Tiers = {
	{ 75, 100 },
	{ 50, 75 },
	{ 25, 50 },
	{ 1, 25 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.Spiciness = rolls[1] or 0
end

return MOD