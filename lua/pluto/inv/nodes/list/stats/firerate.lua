local NODE = pluto.nodes.get "firerate"

NODE.Name = "Firerate Increase"

function NODE:GetDescription(node)
	return string.format("Firerate is increased by %.2f%%", 2 + node.node_val1 * 4)
end

function NODE:ModifyWeapon(node, wep)
	wep:DefinePlutoOverrides("Delay", 0, function(old, pct)
		local rpm = 60 / old

		rpm = rpm + pct * rpm

		return 60 / rpm
	end)

	wep.Pluto.Delay = wep.Pluto.Delay + (2 + node.node_val1 * 4) / 100
end
