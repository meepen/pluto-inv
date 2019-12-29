MOD.Type = "suffix"
MOD.Name = "Recycling"
MOD.Tags = {
	"mag",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "You gain %s of the bullets you hit back after kill"

function MOD:CanRollOn(class)
	return class.Primary and class.Primary.Ammo:lower() == "smg1"
end

MOD.Tiers = {
	{ 40, 60 },
	{ 30, 40 },
	{ 15, 30 },
}

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	wep.AmmoUsed = wep.AmmoUsed or {}
	wep.AmmoUsed[vic] = (wep.AmmoUsed[vic] or 0) + 1
end

function MOD:OnKill(wep, rolls, atk, vic)
	local amt = wep.AmmoUsed[vic]
	if (amt) then
		atk:GiveAmmo(amt * rolls[1] / 100, wep:GetPrimaryAmmoType())
	end
end

return MOD