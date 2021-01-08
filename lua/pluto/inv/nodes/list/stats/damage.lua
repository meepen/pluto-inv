local NODE = pluto.nodes.get "damage"

NODE.Name = "Strength Increase"
NODE.Experience = 2650

function NODE:GetDescription(node)
	return string.format("Damage is increased by %.2f%%", 3 + node.node_val1 * 2)
end

function NODE:ModifyWeapon(node, wep)
	wep.Pluto.Damage = wep.Pluto.Damage + wep:ScaleRollType("damage", (3 + node.node_val1 * 2) / 100, true)
end