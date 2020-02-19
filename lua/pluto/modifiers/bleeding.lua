MOD.Type = "suffix"
MOD.Name = "Bleeding"
MOD.Tags = {
	"damage", "bleed", "dot"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Converts %s of your damage to Bleed on hit"

MOD.Tiers = {
	{ 25, 30 },
	{ 10, 25 },
	{ 5,  10 },
}

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.bleeddamage = math.ceil(rolls[1] / 100 * dmginfo:GetDamage())
		pluto.statuses.bleed(vic, {
			Owner = wep:GetOwner(),
			Weapon = wep,
			Damage = state.bleeddamage
		})
	end
end

function MOD:PostDamage(wep, rolls, vic, dmginfo, state)
	if (state.bleeddamage) then
		dmginfo:SetDamage(dmginfo:GetDamage() - state.bleeddamage)
	end
end
return MOD