MOD.Type = "suffix"
MOD.Name = "Dense Explosions"
MOD.Tags = {
    "damage"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:CanRollOn(wep)
	return wep.ClassName ~= "weapon_ttt_smoke_grenade" or "weapon_ttt_barrel_grenade" or "weapon_ttt_barrier_grenade" or "weapon_ttt_cage_grenade"
end

MOD.Description = "This grenade has %s more damage."

MOD.Tiers = {
	{ 8, 10 },
	{ 6, 8 },
	{ 4, 6 },
    { 2, 4 },
    { 0, 2 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.DamageMulti = (wep.DamageMulti or 0) * (1 + rolls[1] / 100)
end

MOD.ItemType = "Grenade"

return MOD