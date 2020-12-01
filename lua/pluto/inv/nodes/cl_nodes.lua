
function pluto.inv.readnode()
	return setmetatable({
		Name = net.ReadString(),
		Description = net.ReadString(),
		ModifyWeapon = net.ReadFunction()
	}, pluto.nodes.mt)
end

function pluto.inv.readnodes()
	local wep = pluto.inv.readitem()
	local plutoid = net.ReadInt(32)
	local node = pluto.inv.readnode()

	pluto.wpn.listeners[plutoid] = function(wep)
		print "listened"
		debug.Trace()
		PrintTable(node)
	end
end