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

MOD.Description = "Converts %s of your damage and amplifies it by %s to Poison on hit"

MOD.Tiers = {
	{ 25, 33, 30, 50 },
	{ 10, 25, 30, 50 },
	{ 5,  10, 30, 50 },
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