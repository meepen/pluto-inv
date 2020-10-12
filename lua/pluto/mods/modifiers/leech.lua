MOD.Type = "suffix"
MOD.Name = "The Leech"
MOD.Tags = {
	"damage", "heal"
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Damage is lowered by %s. %s of damage is returned as health."

MOD.Tiers = {
	{ 8, 15, 25, 35 },
	{ 8, 15, 15, 25 },
	{ 8, 15, 10, 15 },
}

function MOD:PreDamage(wep, rolls, vic, dmginfo, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		dmginfo:ScaleDamage(1 - rolls[1] / 100)
		local atk = wep:GetOwner()
		if (IsValid(atk)and atk:IsPlayer() and atk:Alive()) then
			local heal = math.min(atk:GetMaxHealth(), atk:Health() + dmginfo:GetDamage() * rolls[2] / 100)

			hook.Run("PlutoHealthGain", atk, heal - atk:Health())

			atk:SetHealth(heal)
		end
	end
end

return MOD