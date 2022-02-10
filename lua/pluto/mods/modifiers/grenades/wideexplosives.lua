MOD.Type = "prefix"
MOD.Name = "Wide Blast"
MOD.Tags = {}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

function MOD:CanRollOn(wep)
	return wep.ClassName ~= "weapon_ttt_barrel_grenade" or "weapon_ttt_barrier_grenade" or "weapon_ttt_cage_grenade"
end

MOD.Description = "This grenade has %s more explosive range."

MOD.Tiers = {
	{ 16, 20 },
	{ 12, 16 },
	{ 8, 12 },
    { 4, 8 },
    { 0, 4 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep.RangeMulti = (wep.RangeMulti or 0) * (1 + rolls[1] / 100)
end

MOD.ItemType = "Grenade"

return MOD