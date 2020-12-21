local NODE = pluto.nodes.get "pierce_mini"

NODE.Name = "Mini Wall Piercer"
NODE.Experience = 4300
NODE.Description = "Your bullets pierce walls more effectively."

function NODE:ModifyWeapon(node, wep)
	wep.Primary.PenetrationValue = (wep.Primary.PenetrationValue or 0) + 10
end