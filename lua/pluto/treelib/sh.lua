tree = tree or {}

local STATE_MT = {
	__index = {}
}
local STATE = STATE_MT.__index
function STATE:Random(min, max)
	local seed = (1103515245 * self.Seed + 12345) % (2^31)
	self.Seed = (1103515245 * seed + 12345) % (2^31)
	return seed / (2^31) * (max - min) + min
end

function STATE:RandomInt(min, max)
	return math.floor(self:Random(min, max + 1))
end

function STATE:shuffle(stuff)
	local new = {}
	for x, y in ipairs(stuff) do
		new[x] = {
			Value = y,
			Random = self:Random(0, 0x7fffffff)
		}
	end

	table.sort(new, function(a, b)
		return a.Random < b.Random
	end)

	for x, y in ipairs(new) do
		new[x] = y.Value
	end

	return new
end

function STATE:RandomInt(min, max)
	return math.floor(self:Random(0, 1) * (max - min + 1) + min)
end

local function pick(state, shuffled)
	local rand = state:RandomInt(1, shuffled.size)
	for i, group in ipairs(shuffled) do
		rand = rand - #group
		if (rand <= 0) then
			table.remove(shuffled, i)
			shuffled.size = shuffled.size - #group
			return group
		end
	end
end

local node_mt = {
	__index = {},
	__tostring = function(self)
		return "node " .. self.node_id
	end
}

local NODE = node_mt.__index

function NODE:ToScreen(size)
	return size / 2 + size / 2 * self.x, size / 2 + size / 2 * self.y
end

function NODE:GetDistances(depth, done)
	done = done or {
		[self] = 0,
	}
	depth = depth or 1
	for _, conn in pairs(self.connections) do
		local curscore = done[conn]
		if (not curscore) then
			done[conn] = depth
			conn:GetDistances(depth + 1, done)
		elseif (curscore > depth) then
			done[conn] = depth
			conn:GetDistances(depth + 1, done)
		end
	end
	return done
end

function NODE:GetDistanceScore()
	local done = self:GetDistances()
	local amt = 0
	for _, score in pairs(done) do
		amt = amt + score
	end
	return amt
end

function tree.generatelayout(amount, seed, name)
	local state = setmetatable({
		Seed = (util.CRC(name or "treelib") + (seed or math.random(0, 0xffffffff))) % 0x100000000
	}, STATE_MT)

	local connections = state:RandomInt(0, math.max(0, math.floor(amount / 2) - 1))

	local layout = {
		connections = {}
	}

	for i = 1, amount do
		local node = setmetatable({
			connections = {},
			ang = state:Random(-math.pi, math.pi),
			dist = state:Random(0, 1),
			size = 14,
			node_id = i,
		}, node_mt)
		layout[#layout + 1] = node
	end

	local done = {}

	local shuffled = state:shuffle(layout)

	for i, node in pairs(shuffled) do
		shuffled[i] = {node}
	end

	shuffled.size = #shuffled

	while (#shuffled > 1) do
		local group1 = pick(state, shuffled)
		local group2 = pick(state, shuffled)

		local node1 = group1[state:RandomInt(1, #group1)]
		local node2 = group2[state:RandomInt(1, #group2)]


		table.insert(node1.connections, node2)
		table.insert(node2.connections, node1)

		table.insert(layout.connections, {node1, node2})

		for _, node in pairs(group2) do
			table.insert(group1, node)
		end
		
		table.insert(shuffled, group1)
		shuffled.size = shuffled.size + #group1
	end

	while (connections > 0) do
		local n1 = layout[state:RandomInt(1, #layout)]
		local n2 = layout[state:RandomInt(1, #layout)]
		if (n1 == n2) then
			continue
		end
		if (table.HasValue(n1.connections, n2)) then
			continue
		end

		table.insert(n1.connections, n2)

		connections = connections - 1
	end

	local best_node, best_score = nil, math.huge

	for i, node in ipairs(layout) do
		print("distance", node, node:GetDistanceScore())
	end


	for _, node in ipairs(layout) do
		node.x = math.cos(node.ang) * node.dist
		node.y = math.sin(node.ang) * node.dist
	end

	return layout
end

local generated = tree.generatelayout(5, 7)

hook.Add("DrawOverlay", "visualize_node", function()
	local size = 480
	surface.SetDrawColor(20, 20, 20, 200)
	surface.DrawRect(0, 0, size, size)
	
	surface.SetFont "BudgetLabel"

	for i, nodes in ipairs(generated.connections) do
		local nx, ny = nodes[1]:ToScreen(size)
		surface.SetDrawColor(0, 255, 0, 255)
		local cx, cy = nodes[2]:ToScreen(size)
		surface.DrawLine(nx, ny, cx, cy)
	end

	for i, node in ipairs(generated) do
		local nx, ny = node:ToScreen(size)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawRect(nx - node.size / 2, ny - node.size / 2, node.size, node.size)

		surface.SetTextColor(white_text)
		surface.SetTextPos(nx, ny)
		surface.DrawText(tostring(i))
	end
end)
