local NODE = pluto.nodes.get "steel_enchant"

NODE.Name = "Enchanted: Steel"
NODE.Description = "Your gun is plated in steel."

function NODE:ModifyWeapon(node, wep)
	wep:SetMaterial "models/player/shared/steel_player"
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
				vm:SetSubMaterial(i - 1, "models/player/shared/steel_player")
			end
		end
	end
end