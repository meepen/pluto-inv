for _, fname in pairs {
	"test",

	"damage",
	"distance",
	"firerate",
	"mag",
	"recoil",
	"reloading",
	"stub",
} do
	include("pluto/inv/nodes/list/" .. fname .. ".lua")
end

function pluto.inv.writenode(ply, node)

	local NODE = pluto.nodes.get(node.node_name)

	net.WriteString(NODE:GetName(node))
	net.WriteString(NODE:GetDescription(node))
	net.WriteFunction(NODE.ModifyWeapon)
end


function pluto.inv.writenodes(ply, wep, nodes)
	pluto.inv.writeitem(ply, wep:GetInventoryItem())
	net.WriteInt(wep:GetPlutoID(), 32)

	local node = {
		node_name = "test",
		node_val1 = math.random()
	}

	pluto.inv.writenode(ply, node)
end

concommand.Add("pluto_test_nodes", function(p)
	if (not pluto.cancheat(p)) then
		return
	end

	local wep = p:GetActiveWeapon()

	for _, ply in pairs(player.GetHumans()) do
		pluto.inv.message(ply)
			:write("nodes", wep)
			:send()
	end
end)