MOD.Type = "suffix"
MOD.Name = "Flame"
MOD.Tags = {
	"damage", "fire", "dot"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	local roll = rolls[1]
	return string.format("Converts %.01f%% of your damage to Fire on hit", roll)
end

MOD.Tiers = {
	{ 25, 33 },
	{ 10, 25 },
	{ 5,  10 },
}

function MOD:OnDamage(wep, vic, dmginfo, rolls, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.firedamage = math.ceil(rolls[1] / 100 * dmginfo:GetDamage())
		pluto.statuses.fire(vic, {
			Owner = wep:GetOwner(),
			Weapon = wep,
			Damage = state.firedamage
		})
	end
end

function MOD:PostDamage(wep, vic, dmginfo, rolls, state)
	if (state.firedamage) then
		dmginfo:SetDamage(dmginfo:GetDamage() - state.firedamage)
	end
end

return MOD