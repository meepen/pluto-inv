-- override PreRender and PostRender
for idx, name in pairs(debug.getregistry()[3]) do
	if (name == "PreRender" or name == "PostRender") then
		debug.getregistry()[3][idx] = "perfmon_" .. name
	end
end

perfmon = perfmon or {
	stack = {},
	time = SysTime,
	lastframe = {},
}

local pluto_perfmon_enabled = CreateConVar("pluto_perfmon_enabled", "0")
local pluto_perfmon_history_length = CreateConVar("pluto_perfmon_history_length", "1")

hook.Add("perfmon_PreRender", "perfmon", function()
	perfmon.enabled = pluto_perfmon_enabled:GetBool()
	perfmon.stack = {
		{
			children = {},
			name = "Render",
			spent = perfmon.time(),
		}
	}
	return hook.Run "PreRender"
end)

hook.Add("perfmon_PostRender", "perfmon", function()
	hook.Run "PostRender"
	perfmon.lastframe = perfmon.stack[1]
	perfmon.lastframe.spent = perfmon.time() - perfmon.lastframe.spent
end)

function perfmon.enable()
	pluto_perfmon_enabled:SetBool(true)
end

function perfmon.disable()
	pluto_perfmon_enabled:SetBool(false)
end

function perfmon.enter(name)
	if (not perfmon.enabled) then
		return
	end

	local n = #perfmon.stack

	local data = perfmon.stack[name]

	if (not data) then
		local parent = perfmon.stack[n]
		data = {
			parent = parent,
			children = {},
			name = name,
			spent = 0,
			entered = 0,
		}
		table.insert(parent.children, data)
	end

	perfmon.stack[n + 1] = data
	data.timing = perfmon.time()
	data.entered = data.entered + 1
end

function perfmon.exit(name)
	if (not perfmon.enabled) then
		return
	end

	local n = #perfmon.stack

	local data = perfmon.stack[n]
	if (not data or data.name ~= name) then
		ErrorNoHalt("Warning: perfmon stack corrupted. Expected " .. name .. " got " .. (data and "nil" or data.name))
	end
	data.spent = data.spent + perfmon.time() - data.timing

	perfmon.stack[n] = nil
end

local function PrintNode(node, depth)
	print(string.format("%s%s (%.02fms)", string.rep("  ", depth), node.name, node.spent * 1000))
	for _, child in ipairs(node.children) do
		PrintNode(child, depth + 1)
	end
end

concommand.Add("pluto_perfmon_dump_last_frame", function()
	PrintNode(perfmon.lastframe, 0)
end)