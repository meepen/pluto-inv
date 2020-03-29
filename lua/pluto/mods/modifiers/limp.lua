MOD.Type = "suffix"
MOD.Name = "Crippling"
MOD.Tags = {
	"damage", "hinder",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetModifier(roll, wep)
	return roll * 100
end

function MOD:FormatModifier(index, roll, wep)
	DEFINE_BASECLASS(wep)

	return string.format("%.02f%%", self:GetModifier(roll, BaseClass))
end

MOD.Description = "Has a %s chance to cripple on hit"

MOD.Tiers = {
	{ 0.7, 0.9 },
	{ 0.6, 0.7 },
	{ 0.45, 0.6 },
	{ 0.4, 0.45 },
}

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	if (math.random() * 100 < self:GetModifier(rolls[1], wep) / wep.Bullets.Num) then
		pluto.statuses.limp(vic, wep:GetDelay())
	end
end

return MOD