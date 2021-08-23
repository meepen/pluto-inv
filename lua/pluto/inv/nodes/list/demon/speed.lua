--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "demon_speed"

NODE.Name = "Demonic Possession: Speed"
NODE.Description = "Once your gun is possessed, gain 10% movement speed."
NODE.Experience = 2800

function NODE:ModifyWeapon(node, wep)
	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.DemonicPossession) then
			return
		end

		wep.DemonicSpeed = (wep.DemonicSpeed or 1) + 0.1
		local id = "demonic_possess_" .. wep:GetPlutoID()
		hook.Add("TTTUpdatePlayerSpeed", id, function(ply, data)
			if (not IsValid(wep)) then
				hook.Remove("TTTUpdatePlayerSpeed", id)
				return
			end

			if (wep:GetOwner() ~= ply) then
				return
			end
			data[id] = wep.DemonicSpeed
		end)

		if (CLIENT and LocalPlayer() == wep:GetOwner()) then
			chat.AddText(Color(255, 20, 50, 200), "i will grant you more speed...")
		end
	end)
end
