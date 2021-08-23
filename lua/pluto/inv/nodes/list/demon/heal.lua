--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "demon_heal"

NODE.Name = "Demonic Possession: Regen"
NODE.Description = "Once your gun is possessed, full heal on kill."
NODE.Experience = 7500

function NODE:ModifyWeapon(node, wep)
	if (ttt.GetCurrentRoundEvent() ~= "") then
		return
	end

	timer.Simple(0, function()
		if (not IsValid(wep)) then
			return
		end
		if (not wep.DemonicPossession) then
			return
		end

		hook.Add("PlayerDeath", wep, function(self, vic, inf, atk)
			if (atk ~= self:GetOwner()) then
				return
			end

			local amt = atk:GetMaxHealth() - atk:Health()
			hook.Run("OnPlutoHealthGain", atk, amt)
			
			atk:SetHealth(atk:GetMaxHealth())
		end)

		if (CLIENT and LocalPlayer() == wep:GetOwner()) then
			chat.AddText(Color(255, 20, 50, 200), "i will grant you eternal life...")
		end
	end)
end
