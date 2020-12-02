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

function tree.generatelayout(amount, seed, name)
	local state = setmetatable({
		Seed = (util.CRC(name or "treelib") + (seed or math.random(0, 0xffffffff))) % 0x100000000
	}, STATE_MT)

	local connections = state:RandomInt(0, math.max(0, math.floor(amount / 2) - 1))

	local layout = {}

	for i = 1, amount do
		local node = {
			connections = {},
			x = state:RandomInt(0, 480),
			y = state:RandomInt(0, 480),
			size = state:RandomInt(16, 24),
		}
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
		if (table.HasValue(n1.connections, n2) or table.HasValue(n2.connections, n1)) then
			continue
		end

		table.insert(n1.connections, n2)

		connections = connections - 1
	end

	return layout
end

local generated = tree.generatelayout(7, 3)

hook.Add("DrawOverlay", "visualize_node", function()
	surface.SetDrawColor(20, 20, 20, 200)
	surface.DrawRect(0, 0, 480, 480)
	
	surface.SetFont "BudgetLabel"

	for i, node in pairs(generated) do
		surface.SetDrawColor(0, 255, 0, 255)
		for _, connection in ipairs(node.connections) do
			surface.DrawLine(node.x, node.y, connection.x, connection.y)
		end
	end

	for i, node in pairs(generated) do
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawRect(node.x - node.size / 2, node.y - node.size / 2, node.size, node.size)

		surface.SetTextColor(white_text)
		surface.SetTextPos(node.x, node.y)
		surface.DrawText(tostring(i))
	end
end)
