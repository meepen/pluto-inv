local NODE = pluto.nodes.get "distance"

NODE.Name = "Distance Increase"
NODE.Experience = 1900

function NODE:GetDescription(node)
	return string.format("Falloff distance is increased by %.2f%%", 5 + node.node_val1 * 5)
end

function NODE:ModifyWeapon(node, wep)
	wep.Pluto.DamageDropoffRangeMax = wep.Pluto.DamageDropoffRangeMax + (5 + node.node_val1 * 5) / 100
end
