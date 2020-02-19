MOD.Type = "suffix"
MOD.Name = "Rainbows"
MOD.Tags = {
	"cosmetic"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "This grenade contains rainbows."

MOD.Tiers = {
	{ 35, 50 },
}

function MOD:CanRollOn(wep)
	return wep.ClassName == "weapon_ttt_smoke_grenade"
end

function MOD:ModifyWeapon(wep, rolls)
	wep.GrenadeColor = 1
end

MOD.ItemType = "Grenade"

return MOD