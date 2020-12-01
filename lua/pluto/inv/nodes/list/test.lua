local NODE = pluto.nodes.get "test"

NODE.Name = "Test"
NODE.Description = "Test Node [developer]"

function NODE:ModifyWeapon(wep, values)
	wep:SetMaterial "error"
end