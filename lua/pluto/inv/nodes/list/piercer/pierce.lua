local NODE = pluto.nodes.get "pierce_pierce"

NODE.Name = "Wall Piercer"
NODE.Experience = 7300
NODE.Description = "Your bullets pierce walls with 40 power."

function NODE:ModifyWeapon(node, wep)
	wep.Primary.PenetrationValue = (wep.Primary.PenetrationValue or 0) + 40
end