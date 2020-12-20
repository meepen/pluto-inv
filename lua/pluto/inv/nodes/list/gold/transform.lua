local NODE = pluto.nodes.get "gold_transform"

NODE.Name = "Gold: Transform"
NODE.Description = "Players killed with this gun transform to gold."
NODE.Experience = 1337

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.GoldEnchant) then
			return
		end

		local id = "gold_transform_" .. wep:GetPlutoID()
		hook.Add("PlayerRagdollCreated", id, function(ply, rag, atk, dmg)
			if (not IsValid(wep)) then
				hook.Remove("PlayerRagdollCreated", id)
				return
			end

			if (dmg and dmg:GetInflictor() == wep) then
				MakeGold(rag)
			end
		end)
	end)
end