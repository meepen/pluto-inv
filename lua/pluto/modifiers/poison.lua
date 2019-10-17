MOD.Type = "suffix"
MOD.Name = "Toxicity"
MOD.Tags = {
	"damage", "poison", "dot"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	return string.format("Converts %.01f%% of your damage and amplifies it by %.01f%% to Poison on hit", rolls[1], rolls[2])
end

MOD.Tiers = {
	{ 25, 33, 30, 45 },
	{ 10, 25, 30, 45 },
	{ 5,  10, 30, 45 },
}

function MOD:OnDamage(wep, vic, dmginfo, rolls, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.poisondamage = math.ceil(rolls[1] / 100 * dmginfo:GetDamage())
		pluto.statuses.poison(vic, {
			Owner = wep:GetOwner(),
			Weapon = wep,
			Damage = math.ceil(state.poisondamage * (1 + rolls[2] / 100))
		})
	end
end

function MOD:PostDamage(wep, vic, dmginfo, rolls, state)
	if (state.poisondamage) then
		dmginfo:SetDamage(dmginfo:GetDamage() - state.poisondamage)
	end
end

return MOD