local NODE = pluto.nodes.get "test"

NODE.Name = "Test"
NODE.Description = "Test Node [developer]"

function NODE:ModifyWeapon(node, wep)
	wep:SetMaterial "models/player/shared/gold_player"
	if (CLIENT) then
		hook.Add("PreDrawViewModel", wep, function(self, vm, ply, wp)
			if (wp ~= self) then
				return
			end

			for i in pairs(vm:GetMaterials()) do
				vm:SetSubMaterial(i - 1, "models/player/shared/gold_player")
			end
		end)

		hook.Add("PostDrawViewModel", wep, function(self, vm, ply, wp)
			if (wp ~= self) then
				return
			end

			vm:SetSubMaterial()
		end)
	end
end