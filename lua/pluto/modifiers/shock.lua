MOD.Type = "suffix"
MOD.Name = "Marksmanship"
MOD.Tags = {
	"precise",
	"damage",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Consecutive hits do %s more damage"

MOD.Tiers = {
	{ 7.5, 9 },
	{ 5, 7.5 },
	{ 4, 5 },
	{ 2, 4 },
	{ 1, 2  },
}

function MOD:PreDamage(wep, rolls, vic, dmginfo, state)
	if (wep.MarksmanshipFiring) then
		wep.CurMarksmanship = (wep.CurMarksmanship or 0) + 1
		wep.MarksmanshipFiring = false
	end

	print(wep.CurMarksmanship)

	dmginfo:ScaleDamage(1 + (rolls[1] / 100 * wep.CurMarksmanship))
end

function MOD:OnFire(wep)
	if (wep.MarksmanshipFiring) then
		wep.CurMarksmanship = 0
	end
	wep.MarksmanshipFiring = true
end

return MOD