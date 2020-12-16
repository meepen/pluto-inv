
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

function pluto.inv.readconstellations()
	local constellations = {}
	for k = 1, net.ReadUInt(4) do
		local constellation = {}
		for bubble_id = 1, net.ReadUInt(8) do
			constellation[bubble_id] = {
				Name = net.ReadString(),
				Desc = net.ReadString(),
				Unlocked = net.ReadBool(),
			}
		end
		constellations[k] = constellation
	end

	return constellations
end

function pluto.ui.showconstellations(item)
	if (not item.constellations) then
		-- TODO: enable?
		return
	end

	if (IsValid(PLUTO_TREE)) then
		PLUTO_TREE:Remove()
	end
	PLUTO_TREE = vgui.Create "tttrw_base"
	local f = vgui.Create "pluto_tree"
	PLUTO_TREE:AddTab("Constellations", f)
	PLUTO_TREE:SetSize(640, 690)
	f:SetSize(600, 600)
	PLUTO_TREE:Center()
	f:Dock(FILL)
	f.bubbles = tree.make_bubbles(item.constellations, item.ID, item.ClassName)
	f.constellations = item.constellations
	PLUTO_TREE:MakePopup()


end