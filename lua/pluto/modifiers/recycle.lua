MOD.Type = "suffix"
MOD.Name = "Recycling"
MOD.Tags = {
	"mag",
}

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:GetDescription(rolls)
	return string.format("You gain %.01f%% of the bullets you hit back after kill", rolls[1] * 100)
end

function MOD:CanRollOn(class)
	return class.Primary and class.Primary.Ammo:lower() == "smg1"
end

MOD.Tiers = {
	{ 0.4, 0.6 },
	{ 0.3, 0.4 },
	{ 0.15, 0.3 },
}

function MOD:OnDamage(wep, vic, dmginfo, rolls, state)
	wep.AmmoUsed = wep.AmmoUsed or {}
	wep.AmmoUsed[vic] = (wep.AmmoUsed[vic] or 0) + 1
end

function MOD:OnKill(wep, atk, vic, rolls)
	local amt = wep.AmmoUsed[vic]
	if (amt) then
		atk:GiveAmmo(amt * rolls[1], wep:GetPrimaryAmmoType())
	end
end

return MOD