--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "steel_transform"

NODE.Name = "Ice: Transform"
NODE.Description = "Players killed with this gun have a 25% chance transform to steel."
NODE.Experience = 1200

function NODE:ModifyWeapon(node, wep)
	if (math.random() > 0.25) then
		return
	end

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