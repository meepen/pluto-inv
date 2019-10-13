MOD.Type = "prefix"
MOD.Name = "Reloading"
MOD.Tags = {
	"reload", "speed"
}
MOD.ModType = "percent"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	if (roll > 0) then
		return string.format("Reloads %.1f%% faster", roll)
	else
		return string.format("Reloads %.1f%% slower", -roll)
	end
end

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