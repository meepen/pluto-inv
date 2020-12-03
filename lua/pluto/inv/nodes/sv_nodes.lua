for _, fname in pairs {
	"test",

	"damage",
	"distance",
	"firerate",
	"mag",
	"recoil",
	"reloading",
	"stub",

	"demon/possess",
	"demon/speed",
	"demon/heal",
	"demon/damage",

	"mortal/wound",
	"mortal/wound_s",
} do
	include("pluto/inv/nodes/list/" .. fname .. ".lua")
end

function pluto.inv.writenode(ply, node)
	local NODE = pluto.nodes.get(node.node_name)

	net.WriteString(NODE:GetName(node))
	net.WriteString(NODE:GetDescription(node))
	net.WriteFunction(NODE.ModifyWeapon)
	net.WriteFloat(node.node_val1 or -1)
	net.WriteFloat(node.node_val2 or -1)
	net.WriteFloat(node.node_val3 or -1)
end


function pluto.inv.writenodes(ply, wep, nodes)
	pluto.inv.writeitem(ply, wep:GetInventoryItem())
	net.WriteInt(wep:GetPlutoID(), 32)

	net.WriteUInt(#nodes, 16)
	for _, node in ipairs(nodes) do
		pluto.inv.writenode(ply, node)
	end
end

function pluto.nodes.apply(wep, nodes)
	for _, node in pairs(nodes) do
		local NODE = pluto.nodes.get(node.node_name)
		NODE:ModifyWeapon(node, wep)
	end

	for _, ply in pairs(player.GetHumans()) do
		pluto.inv.message(ply)
			:write("nodes", wep, nodes)
			:send()
	end
end

concommand.Add("pluto_test_nodes", function(p, c, a)
	if (not pluto.cancheat(p)) then
		return
	end
	if (a[1]) then
		p = Player(a[1])
		if (not IsValid(p)) then
			return
		end
	end

	local wep = p:GetActiveWeapon()

	if (not wep:GetInventoryItem() or not wep:GetInventoryItem().RowID) then
		return
	end

	pluto.nodes.apply(wep, {
		{
			node_name = "mortal_wound",
			node_val1 = math.random(),
			node_id = 2,
			node_bubble = 0,
		},
		{
			node_name = "mortal_wound_s",
			node_val1 = math.random(),
			node_id = 2,
			node_bubble = 0,
		},
	})
end)