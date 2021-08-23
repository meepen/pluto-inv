--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "steel_enchant"

NODE.Name = "Enchanted: Ice"
NODE.Description = "Your gun is plated in steel."
NODE.Experience = 5300

function NODE:ModifyWeapon(node, wep)
	wep:SetMaterial "models/player/shared/ice_player"
	wep.SteelEnchant = true
	if (CLIENT) then
		local last_drawn
		hook.Add("PreDrawViewModel", "pluto_vm_draw", function(vm, ply, wep)
			if (last_drawn and last_drawn ~= wep) then
				vm:SetSubMaterial()
				last_drawn = nil
			end

			if (not last_drawn and wep.PlutoOverrideViewModel) then
				last_drawn = wep
				wep:PlutoOverrideViewModel(vm)
			end
		end)

		function wep:PlutoOverrideViewModel(vm)
			for i in pairs(vm:GetMaterials()) do
				vm:SetSubMaterial(i - 1, "models/player/shared/ice_player")
			end
		end
	end
end