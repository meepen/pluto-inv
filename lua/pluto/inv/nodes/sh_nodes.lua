--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto_disable_constellations = CreateConVar("pluto_disable_constellations", "1", { FCVAR_REPLICATED })

pluto.nodes = pluto.nodes or {
	byname = {},
	mt = {
		__index = {}
	}
}

local NODE = pluto.nodes.mt.__index

function NODE:GetName(node)
	return self.Name or node.node_name or "Unknown"
end

function NODE:GetDescription(node)
	local values = {
		node.node_val1,
		node.node_val2,
		node.node_val3,
	}
	return self.Description or "Unknown [" .. table.concat(values, ", ") .. "]"
end

function NODE:ModifyWeapon(node, wep)
	ErrorNoHalt("unimplemented ModifyWeapon: " .. self:GetName(node))
end

function NODE:GetExperienceCost(node)
	return 10000
end

function pluto.nodes.get(name)
	local node = pluto.nodes.byname[name]
	if (not node) then
		node = setmetatable({}, pluto.nodes.mt)
		pluto.nodes.byname[name] = node
	end

	return node
end