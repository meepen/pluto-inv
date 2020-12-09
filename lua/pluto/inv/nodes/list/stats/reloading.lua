local NODE = pluto.nodes.get "reloading"

NODE.Name = "Reloading Speed"

function NODE:GetDescription(node)
	return string.format("Reloading is %.2f%% faster", 2 + node.node_val1 * 8)
end

function NODE:ModifyWeapon(node, wep)
	wep:DefinePlutoOverrides "ReloadAnimationSpeed"
	wep.Pluto.ReloadAnimationSpeed = wep.Pluto.ReloadAnimationSpeed + (2 + node.node_val1 * 8) / 100
end
