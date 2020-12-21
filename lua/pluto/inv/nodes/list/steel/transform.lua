local NODE = pluto.nodes.get "steel_transform"

NODE.Name = "Ice: Transform"
NODE.Description = "Players killed with this gun transform to steel."
NODE.Experience = 1200

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.SteelEnchant) then
			return
		end

		local id = "steel_transform_" .. wep:GetPlutoID()
		hook.Add("PlayerRagdollCreated", id, function(ply, rag, atk, dmg)
			if (not IsValid(wep)) then
				hook.Remove("PlayerRagdollCreated", id)
				return
			end

			if (dmg and dmg:GetInflictor() == wep) then
				MakeGold(rag, "models/player/shared/ice_player")
			end
		end)
	end)
end