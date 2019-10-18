MOD.Type = "prefix"
MOD.Name = "Reloading"
MOD.Tags = {
	"reload", "speed"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Reloads %s faster"

MOD.Tiers = {
	{ 15, 25 },
	{ 10, 15 },
	{ 5, 10 },
	{ 0.1, 5 },
}

function MOD:ModifyWeapon(wep, roll)
	wep:DefinePlutoOverrides "ReloadAnimationSpeed"
	wep.Pluto.ReloadAnimationSpeed = wep.Pluto.ReloadAnimationSpeed - roll[1] / 100
end

return MOD