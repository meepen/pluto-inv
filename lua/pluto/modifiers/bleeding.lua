MOD.Type = "suffix"
MOD.Name = "Bleeding"
MOD.Tags = {
	"damage", "bleed", "dot"
}
MOD.ModType = "dot"

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	return string.format("Converts %.01f%% of your damage to Bleed on hit", rolls[1])
end

MOD.Tiers = {
	{ 25, 33 },
	{ 10, 25 },
	{ 5,  10 },
}

function MOD:OnDamage(wep, vic, dmginfo, rolls, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.bleeddamage = math.ceil(rolls[1] / 100 * dmginfo:GetDamage())
		pluto.statuses.bleed(vic, {
			Owner = wep:GetOwner(),
			Weapon = wep,
			Damage = state.bleeddamage
		})
	end
end

function MOD:PostDamage(wep, vic, dmginfo, rolls, state)
	if (state.bleeddamage) then
		dmginfo:SetDamage(dmginfo:GetDamage() - state.bleeddamage)
	end
end
return MOD