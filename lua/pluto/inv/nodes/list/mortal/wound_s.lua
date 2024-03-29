--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "mortal_wound_s"

NODE.Name = "Minor Wound"
NODE.Description = "Damage with this gun removes 5% of the damage's max health from enemy."
NODE.Experience = 3900

function NODE:ModifyWeapon(node, wep)
	wep.MortalWound = (wep.MortalWound or 0) + 0.05
	local id = "pluto_mortal_wound_" .. wep:GetPlutoID()

	hook.Add("PlutoPreDamage", id, function(shooter, vic, dmg)
		if (not IsValid(wep)) then
			hook.Remove("PlayerTakeDamage", id)
			return
		end

		if (wep ~= dmg:GetInflictor()) then
			return
		end

		vic:SetMaxHealth(vic:GetMaxHealth() - math.floor(dmg:GetDamage() * wep.MortalWound))
	end)
end
