
function pluto.inv.readnode()
	local node = setmetatable({
		Name = net.ReadString(),
		Description = net.ReadString(),
		ModifyWeapon = net.ReadFunction(),
		node_val1 = net.ReadFloat(),
		node_val2 = net.ReadFloat(),
		node_val3 = net.ReadFloat(),
	}, pluto.nodes.mt)

	if (node.node_val1 == -1) then
		node.node_val1 = nil
	end
	if (node.node_val2 == -1) then
		node.node_val2 = nil
	end
	if (node.node_val3 == -1) then
		node.node_val3 = nil
	end

	PrintTable(node)
	return node
end

function pluto.inv.readnodes()
	local wep = pluto.inv.readitem()
	local plutoid = net.ReadInt(32)
	local nodes = {}

	for i = 1, net.ReadUInt(16) do
		nodes[i] = pluto.inv.readnode()
	end

	pluto.wpn.listeners[plutoid] = function(wep)
		for _, node in pairs(nodes) do
			node:ModifyWeapon(node, wep)
		end
	end
end

function pluto.inv.readitemtree()
	if (not net.ReadBool()) then
		return
	end

	local wep = pluto.inv.readitem()
	
	if (IsValid(pluto.stars)) then
		pluto.stars:Remove()
	end
	pluto.stars = vgui.Create "DFrame"
	pluto.stars.bubbles = pluto.stars:Add "pluto_tree"
	pluto.stars.bubbles:Dock(FILL)

	pluto.stars:SetPos(200, 0)
	pluto.stars:SetSize(600, 650)
	pluto.stars:Center()

	pluto.stars:MakePopup()
	pluto.stars:SetKeyboardInputEnabled(false)
end