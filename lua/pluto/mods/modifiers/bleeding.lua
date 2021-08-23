--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "Bleeding"
MOD.Color = Color(211, 45, 3)
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

function MOD:ModifyWeapon(wep, rolls)
	wep:ScaleRollType("damage", rolls[1], true)
end

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.bleeddamage = math.ceil(wep:ScaleRollType("damage", rolls[1]) / 100 * dmginfo:GetDamage())
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