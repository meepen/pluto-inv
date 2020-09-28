MOD.Type = "suffix"
MOD.Name = "Flame"
MOD.Tags = {
	"damage", "fire", "dot"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Converts %s of your damage to Fire on hit"

MOD.Tiers = {
	{ 25, 30 },
	{ 10, 25 },
	{ 5,  10 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep:ScaleRollType("damage", rolls[1], true)
end

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.firedamage = math.ceil(wep:ScaleRollType("damage", rolls[1]) / 100 * dmginfo:GetDamage())
		pluto.statuses.fire(vic, {
			Owner = wep:GetOwner(),
			Weapon = wep,
			Damage = state.firedamage
		})
	end
end

function MOD:PostDamage(wep, rolls, vic, dmginfo, state)
	if (state.firedamage) then
		dmginfo:SetDamage(dmginfo:GetDamage() - state.firedamage)
	end
end

return MOD