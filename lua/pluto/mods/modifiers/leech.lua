MOD.Type = "suffix"
MOD.Name = "The Leech"
MOD.Color = Color(3, 211, 97)
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
	{ 8, 15, 15, 25 },
	{ 8, 15, 10, 15 },
	{ 8, 15, 5, 10 },
}

function MOD:PreDamage(wep, rolls, vic, dmginfo, state)
	if (ttt.GetCurrentRoundEvent() ~= "") then
		return
	end

	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		dmginfo:ScaleDamage(1 - rolls[1] / 100)
		local atk = wep:GetOwner()
		if (IsValid(atk)and atk:IsPlayer() and atk:Alive()) then
			local heal = math.min(atk:GetMaxHealth(), atk:Health() + dmginfo:GetDamage() * rolls[2] / 100)

			if (hook.Run("PlutoHealthGain", atk, heal - atk:Health())) then
				return
			end

			atk:SetHealth(heal)
		end
	end
end

return MOD