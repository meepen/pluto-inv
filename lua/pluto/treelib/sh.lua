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

function NODE:ToScreen(size, outline)
	outline = (outline or 0) + 20
	size = size - outline
	return outline / 2 + size / 2 + size / 2 * self.x, outline / 2 + size / 2 + size / 2 * self.y
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


local function intersect(a, b, c, d)
	local a1 = b.y - a.y
	local b1 = a.x - b.x
	local c1 = a1 * a.x + b1 * a.y

	local a2 = d.y - c.y
	local b2 = c.x - d.x
	local c2 = a2 * c.x + b2 * c.y

	local determinant = a1 * b2 - a2 * b1
	if (determinant == 0) then
		return false
	end

	local hitx = (b2 * c1 - b1 * c2) / determinant
	local hity = (a1 * c2 - a2 * c1) / determinant

	return hitx, hity
end

local function getintersections(layout)
	local doing = {}

	local count = 0
	for _, a in ipairs(layout) do
		doing[a] = true
		for _, b in ipairs(a.connections) do
			doing[b] = true
			local high_x = math.max(a.x, b.x)
			local low_x = math.min(a.x, b.x)
			for _, node in ipairs(layout) do
				doing[node] = true
				for _, onode in ipairs(node.connections) do
					if (doing[onode]) then
						continue
					end
					doing[onode] = true

					local ohigh_x = math.max(node.x, onode.x)
					local olow_x = math.min(node.x, onode.x)

					local hitx, hity = intersect(a, b, node, onode)
					if (hitx and hitx < high_x and hitx > low_x and hitx < ohigh_x and hitx > olow_x) then
						count = count + 1
					end

					doing[onode] = false
				end
				doing[node] = false
			end
			doing[b] = false
		end
		doing[a] = false
	end

	return count
end

function linelengths(layout)
	local length = 0
	for _, nodes in pairs(layout.connections) do
		local a, b = nodes[1], nodes[2]
		length = length + math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
	end
	return lengths
end

function tree.generatelayout(amount, seed, name)
	local state = setmetatable({
		Seed = (util.CRC(name or "treelib") + (seed or math.random(0, 0xffffffff))) % 0x100000000
	}, STATE_MT)

	local connections = state:RandomInt(0, math.max(0, math.floor(amount * 0.4)))

	local layout = {
		connections = {}
	}

	for i = 1, amount do
		local node = setmetatable({
			connections = {},
			size = 20,
			node_id = i,
			bubble = layout
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
		table.insert(n2.connections, n1)
		table.insert(layout.connections, {n1, n2})

		connections = connections - 1
	end

	local best_node, best_score = nil, math.huge

	for i, node in ipairs(layout) do
		local score = node:GetDistanceScore()
		if (score < best_score) then
			best_node, best_score = node, score
		end
	end

	local scores = best_node:GetDistances()

	local highest_distance = -math.huge
	for _, dist in pairs(scores) do
		highest_distance = math.max(highest_distance, dist)
	end

	local by_distance = {}

	for i = 0, highest_distance do
		by_distance[i] = {}
	end

	for node, dist in pairs(best_node:GetDistances()) do
		node.dist = dist / highest_distance / 100 -- divide to decompress later
	end

	for _, node in ipairs(layout) do
		table.insert(by_distance[scores[node]], node)
	end

	for dist, nodes in pairs(by_distance) do
		for i, node in ipairs(nodes) do
			node.ang = math.rad((i - 1) / #nodes * 360 - 32 * dist)
		end
	end

	for _, node in ipairs(layout) do
		node.x = math.cos(node.ang) * node.dist
		node.y = math.sin(node.ang) * node.dist
	end

	-- find intersections

	local doing = {}
	
	for _, node in ipairs(layout) do
		doing[node] = true
		for _, conn in ipairs(node.connections) do
			if (doing[conn]) then
				continue
			end
			doing[conn] = true

			local high_x = math.max(conn.x, node.x)
			local low_x = math.min(conn.x, node.x)

			for _, onode in ipairs(layout) do
				if (doing[onode]) then
					continue
				end
				doing[onode] = true
				for _, oconn in ipairs(onode.connections) do
					if (doing[oconn]) then
						continue
					end
					local ohigh_x = math.max(oconn.x, onode.x)
					local olow_x = math.min(oconn.x, onode.x)
					doing[oconn] = true
					local hitx, hity = intersect(node, conn, onode, oconn)
					if (hitx and hitx < high_x and hitx > low_x and hitx < ohigh_x and hitx > olow_x) then
						-- INTERSECTED
						-- find lowest connections
						-- brute force tests, attempt to first midsection from intersection and origin, then try swapping positions and go with lowest 

						-- midsection tests
						local list = {node, conn, onode, oconn}
						local best_change = {Intersections = getintersections(layout), LineLength = linelengths(layout)}
						table.sort(list, function(a, b)
							return a.node_id < b.node_id
						end)

						for _, current in ipairs(list) do
							for _, other in ipairs(list) do
								if (other == current) then
									continue
								end
								local cx, cy = current.x, current.y
								local ox, oy = other.x, other.y

								local intersections = getintersections(layout)
								local length = linelengths(layout)
								if (not best_change or best_change.Intersections > intersections or (best_change.Intersections == intersections and length == best_change.LineLength)) then
									best_change = {
										Intersections = intersections,
										LineLength = length,
										Run = function(node)
											current.x, current.y, other.x, other.y = other.x, other.y, current.x, current.y
										end
									}
								end

								other.x, other.y = ox, oy
								current.x, current.y = cx, cy
							end
						end

						for _, current in ipairs(list) do
							local other = ({
								[node] = conn,
								[conn] = node,
								[onode] = oconn,
								[oconn] = onode,
							})[current]

							local cx, cy = current.x, current.y

							current.x, current.y = (other.x + hitx) / 2, (other.y + hity) / 2
							local intersections = getintersections(layout)
							local length = linelengths(layout)
							if (not best_change or best_change.Intersections > intersections or (best_change.Intersections == intersections and length == best_change.LineLength)) then
								best_change = {
									Intersections = intersections,
									LineLength = length,
									Run = function()
										current.x, current.y = (other.x + hitx) / 2, (other.y + hity) / 2
									end
								}
							end

							current.x, current.y = cx, cy
						end

						if (best_change.Run) then
							best_change.Run()
						end
					end
					doing[oconn] = nil
				end
				doing[onode] = nil
			end
			doing[conn] = nil
		end
		-- this is done forever: micro optimization
		-- doing[node] = nil
	end


	-- decompression of nodes
	local most_length, most_node = -math.huge
	for _, node in ipairs(layout) do
		local length = node.x ^ 2 + node.y ^ 2
		if (length > most_length) then
			most_length, most_node = length, node
		end
	end

	most_length = math.sqrt(most_length)

	for _, node in ipairs(layout) do
		node.x = node.x / most_length
		node.y = node.y / most_length
	end

	layout.x = state:Random(0, 1)
	layout.y = state:Random(0, 1)
	layout.background = state:RandomInt(1, 3)

	return layout
end

function tree.make_bubbles(treedata, seed, name)
	seed = seed or 0
	local bubbles = {
		trees = {}
	}

	for i, data in ipairs(treedata) do
		bubbles.trees[i] = tree.generatelayout(#data, seed + 0x1337 * i, name)
		bubbles.trees[i].size = 200
		bubbles.trees[i].id = i
		if (i >= 2) then
			bubbles.trees[i].ang = 45 + (360 / (#treedata - 1)) * (i - 2)
			bubbles.trees[i].size = 256
		end
	end
	return bubbles
end
