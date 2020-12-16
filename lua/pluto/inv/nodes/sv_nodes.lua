for _, fname in pairs {
	"stats/damage",
	"stats/distance",
	"stats/firerate",
	"stats/mag",
	"stats/recoil",
	"stats/reloading",

	"enigmatic/voice",
	"enigmatic/warn",
	"enigmatic/siren",
	"enigmatic/ground",

	"demon/possess",
	"demon/speed",
	"demon/heal",
	"demon/damage",

	"mortal/wound",
	"mortal/wound_s",

	"gold/enchanted",
	"gold/spawns",
	"gold/transform",

	"steel/enchanted",
	"steel/spawns",
	"steel/transform",

	"reserves/mythic",
} do
	include("pluto/inv/nodes/list/" .. fname .. ".lua")
end

pluto.nodes.groups = pluto.nodes.groups or {
	byname = {},
	get = function(name, shares)
		local r = pluto.nodes.groups.byname[name]
		if (not r) then
			r = {
				Shares = 0,
			}
			pluto.nodes.groups.byname[name] = r
		end

		if (shares) then
			r.Shares = shares
		end

		setmetatable(r, pluto.nodes.groups.mt)

		return r
	end
}

pluto.nodes.groups.mt = pluto.nodes.groups.mt or {
	__index = {}
}

local GROUP = pluto.nodes.groups.mt.__index

function GROUP:CanRollOn()
	return true
end

function GROUP:GetNodeCount()
	return math.random(4, 7)
end

function GROUP:Generate()
	local amount = self:GetNodeCount()

	local bubble = {}

	for _, item in ipairs(self.Guaranteed or {}) do
		table.insert(bubble, {
			node_name = item,
			node_id = #bubble + 1,
			node_val1 = math.random(),
			node_val2 = math.random(),
			node_val3 = math.random(),
		})
		amount = amount - 1
	end

	local rolls = table.Copy(self.SmallNodes)

	for i = 1, amount do
		local itemname, contents = pluto.inv.roll(rolls)
		if (not itemname) then
			break
		end

		if (istable(contents) and contents.Max) then
			contents.Max = contents.Max - 1
			if (contents.Max == 0) then
				rolls[itemname] = nil
			end
		end

		table.insert(bubble, {
			node_name = itemname,
			node_id = #bubble + 1,
			node_val1 = math.random(),
			node_val2 = math.random(),
			node_val3 = math.random(),
		})
	end

	return bubble
end

for _, fname in pairs {
	"primary/demon",
	"primary/enigmatic",
	"primary/normal",
	"primary/mortal",
	"primary/reserves",
	"secondary/gold",
	"secondary/steel",
} do
	include("pluto/inv/nodes/groups/" .. fname .. ".lua")
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

function pluto.inv.writeconstellations(ply, constellations)
	net.WriteUInt(#constellations, 4)
	for _, constellation in ipairs(constellations) do
		net.WriteUInt(#constellation, 8)
		for _, node in ipairs(constellation) do
			local NODE = pluto.nodes.get(node.node_name)
			net.WriteString(NODE:GetName(node))
			net.WriteString(NODE:GetDescription(node))
			net.WriteBool(node.node_unlocked == 1) -- unlocked
		end
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

function pluto.nodes.applyactive(wep, bubbles)
	local active = {}
	for _, bubble in ipairs(bubbles) do
		for _, node in ipairs(bubble) do
			if (node.node_unlocked == 1) then
				table.insert(active, node)
			end
		end
	end

	pluto.nodes.apply(wep, active)
end

function pluto.nodes.generateweapon(class)
	if (not istable(class)) then
		class = baseclass.Get(class)
	end

	if (not istable(class)) then
		return false
	end

	local bubbles = {}

	local available = {
		primary = {},
		secondary = {},
	}

	for itemname, val in pairs(pluto.nodes.groups.byname) do
		if (not val:CanRollOn(class)) then
			continue
		end

		if (not val.Type or not available[val.Type]) then
			continue
		end

		available[val.Type][itemname] = val
	end

	local rolls = pluto.nodes.groups.byname.normal:Generate(class)
	for _, roll in pairs(rolls) do
		roll.node_bubble = 1
	end

	table.insert(bubbles, rolls)

	for i = 1, 4 do
		local type = (i % 2) == 1 and "primary" or "secondary"
		local name, roll = pluto.inv.roll(available[type])
		available[type][name] = nil
		local rolls = roll:Generate()
		for _, mod in pairs(rolls) do
			mod.node_bubble = i + 1
		end
		table.insert(bubbles, rolls)
	end
	
	return bubbles
end

function pluto.inv.writeitemtree(ply, item, tree)
	if (not item) then
		net.WriteBool(false)
		return
	end

	if (not item.tree or not tree) then
		net.WriteBool(false)
		return
	end

	net.WriteBool(true)
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
			node_name = "mythic_reserves",
			node_val1 = math.random(),
		},
	})
end)

function pluto.nodes.fromrows(rows)
	local data = {}

	for _, row in ipairs(rows) do
		local bubbles = data[row.item_id]
		if (not bubbles) then
			bubbles = {}
			data[row.item_id] = bubbles
		end
		local bubble = bubbles[row.node_bubble]
		if (not bubble) then
			bubble = {}
			bubbles[row.node_bubble] = bubble
		end
		bubble[row.node_id] = row
	end

	return data
end

function pluto.nodes.getfor(db, wep)
	if (wep.constellations) then
		return wep.constellations
	end

	mysql_stmt_run(db, "SELECT * from pluto_item_nodes WHERE item_id = ? FOR UPDATE", wep.RowID)
	local nodes = mysql_stmt_run(db, "SELECT * FROM pluto_item_nodes WHERE item_id = ?", wep.RowID)

	local bubbles = {}

	if (not nodes[1]) then
		-- no nodes, generate :)))
		bubbles = pluto.nodes.generateweapon(wep.ClassName)

		local first = true
		for _, bubble in ipairs(bubbles) do
			for _, node in ipairs(bubble) do
				node.node_unlocked = first and 1 or 0
				mysql_stmt_run(db, "INSERT INTO pluto_item_nodes (item_id, node_bubble, node_id, node_name, node_val1, node_val2, node_val3, node_unlocked) VALUES(?, ?, ?, ?, ?, ?, ?, ?)", wep.RowID, node.node_bubble, node.node_id, node.node_name, node.node_val1, node.node_val2, node.node_val3, first and 1 or 0)
				first = false
			end
		end
	else
		bubbles = pluto.nodes.fromrows(nodes)[wep.RowID]
	end

	wep.constellations = bubbles
	wep.LastUpdate = (wep.LastUpdate or 0) + 1
	return bubbles
end

concommand.Add("pluto_create_nodes", function(p, c, a)
	local wep = pluto.itemids[tonumber(a[1])]
	if (not wep or wep.Owner ~= p:SteamID64()) then
		return
	end

	pluto.db.transact(function(db)
		local bubbles = pluto.nodes.getfor(db, wep)
		mysql_commit(db)

		pluto.inv.message(p)
			:write("item", wep)
			:send()
	end)
end)