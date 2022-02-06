--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
MOD.Type = "suffix"
MOD.Name = "Toxicity"
MOD.Tags = {
	"damage", "poison", "dot"
}

MOD.Color = Color(211, 3, 211)

function MOD:IsNegative(roll)
	return roll < 0
end

function MOD:FormatModifier(index, roll)
	return string.format("%.01f%%", roll)
end

MOD.Description = "Converts %s of your damage to damage over time and amplifies it by %s"

MOD.Tiers = {
	{ 25, 33, 20, 35 },
	{ 10, 25, 20, 35 },
	{ 5,  10, 20, 35 },
}

function MOD:ModifyWeapon(wep, rolls)
	wep:ScaleRollType("damage", rolls[1], true)
end

function MOD:OnDamage(wep, rolls, vic, dmginfo, state)
	if (IsValid(vic) and vic:IsPlayer() and dmginfo:GetDamage() > 0) then
		state.poisondamage = math.ceil(wep:ScaleRollType("damage", rolls[1]) / 100 * dmginfo:GetDamage())
		pluto.statuses.poison(vic, {
			Owner = wep:GetOwner(),
			Weapon = wep,
			Damage = math.ceil(state.poisondamage * (1 + rolls[2] / 100))
		})
	end
end

function MOD:PostDamage(wep, rolls, vic, dmginfo, state)
	if (state.poisondamage) then
		dmginfo:SetDamage(dmginfo:GetDamage() - state.poisondamage)
	end
end

return MOD