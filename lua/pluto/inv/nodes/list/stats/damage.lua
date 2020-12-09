local NODE = pluto.nodes.get "damage"

NODE.Name = "Stub"

function NODE:GetDescription(node)
	return "Damage is increased by " .. (node.node_val1 * 5) .. "%"
end

function NODE:ModifyWeapon(node, wep)
	wep:DefinePlutoOverrides "Damage"
	wep.Pluto.Damage = wep.Pluto.Damage + wep:ScaleRollType("damage", node.node_val1 / 100 * 5, true)
end