MOD.Type = "suffix"
MOD.Name = "Crippling"
MOD.Tags = {
	"damage", "hinder",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls, wep)
	DEFINE_BASECLASS(wep)

	if (not BaseClass) then
		return "INVALID WEAPON"
	end

	return string.format("Has a %.02f%% chance to cripple on hit", math.min(0.3, rolls[1] * BaseClass:GetDelay()) * 100)
end

MOD.Tiers = {
	{ 0.3, 0.4 },
	{ 0.2, 0.3 },
	{ 0.1, 0.2 },
	{ 0.01, 0.1 },
}

function MOD:OnDamage(wep, vic, dmginfo, rolls, state)
	if (math.random() < math.min(0.3, rolls[1] * wep:GetDelay())) then
		pluto.statuses.limp(vic, 1)
	end
end

return MOD