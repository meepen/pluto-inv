MOD.Type = "suffix"
MOD.Name = "Crippling"
MOD.Tags = {
	"damage", "hinder",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetModifier(roll, wep)
	return math.min(0.3, roll * wep:GetDelay()) * 100
end

function MOD:FormatModifier(index, roll, wep)
	DEFINE_BASECLASS(wep)

	return string.format("%.02f%%", self:GetModifier(roll, BaseClass))
end

MOD.Description = "Has a %s chance to cripple on hit"

MOD.Tiers = {
	{ 0.3, 0.4 },
	{ 0.2, 0.3 },
	{ 0.1, 0.2 },
	{ 0.01, 0.1 },
}

function MOD:OnDamage(wep, vic, dmginfo, rolls, state)
	if (SERVER and math.random() < self:GetModifier(rolls[1], wep) / wep.Bullets.Num) then
		pluto.statuses.limp(vic, 4)
	end
end

return MOD