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

function tree.generatelayout(amount, connections, seed, name)
	local state = setmetatable({
		Seed = (util.CRC(name or "treelib") + (seed or math.random(0, 0xffffffff))) % 0x100000000
	}, STATE_MT)

	connections = math.max(connections or 0, amount - 1)

	local layout = {}

	for i = 1, amount do
		local node = {
			connections = {},
			x = state:Random(0, 480),
			y = state:Random(0, 480),
			size = state:Random(16, 24),
		}
		layout[#layout + 1] = node
	end

	local conn_left = connections
	local amount_left = amount

	local done = {}

	local shuffled = state:shuffle(layout)
	local main = shuffled[1]
	table.remove(shuffled, 1)

	for _, node in ipairs(shuffled) do
		-- connect to main node for now??
		node.connections[1] = main
	end

	return layout
end

local generated = tree.generatelayout(7)

timer.Create("new_tree", 1, 0, function()
	generated = tree.generatelayout(7)
end)

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
