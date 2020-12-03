local NODE = pluto.nodes.get "mortal_wound"

NODE.Name = "Mortal Wound"
NODE.Description = "Damage with this gun removes 20% of the damage's max health from enemy."

function NODE:ModifyWeapon(node, wep)
	wep.MortalWound = (wep.MortalWound or 0) + 0.2
	local id = "pluto_mortal_wound_" .. wep:GetPlutoID()

	hook.Add("PlutoPreDamage", id, function(shooter, vic, dmg)
		if (not IsValid(wep)) then
			hook.Remove("PlayerTakeDamage", id)
			return
		end

		if (wep ~= dmg:GetInflictor()) then
			return
		end

		targ:SetMaxHealth(targ:GetMaxHealth() - math.floor(dmg:GetDamage() * wep.MortalWound))
	end)
end
