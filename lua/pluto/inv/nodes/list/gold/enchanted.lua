--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local NODE = pluto.nodes.get "gold_enchant"

NODE.Name = "Enchanted: Gold"
NODE.Description = "Your gun is plated in gold."
NODE.Experience = 6969

function NODE:ModifyWeapon(node, wep)
	wep:SetMaterial "models/player/shared/gold_player"
	wep.GoldEnchant = true
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
				vm:SetSubMaterial(i - 1, "models/player/shared/gold_player")
			end
		end
	end
end