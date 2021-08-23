--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
list = {}
player_manager = {}

pluto = {}

local function GenerateModelData(name)
	local short = name:gsub(" ", "_"):gsub("%a", string.lower):sub(1, 10)

	local dat = pluto[short]
	if (dat) then
		if (name ~= dat.Name) then
			error("shortened conflict between " .. dat.Name .. " & " .. name)
		end
		return dat
	end

	local dat = {
		Name = name
	}
	pluto[short] = dat

	return dat
end

function list.Set(id, key, item)
	if (id == "NPC") then
		return
	end

	if (id ~= "PlayerOptionsModel") then
		error("Unknown id: " .. id)
	end


end

function player_manager.AddValidModel(name, mdl)
	GenerateModelData(name).Model = mdl
end

function player_manager.AddValidHands(name, mdl, skin, bodygroups)
	GenerateModelData(name).Hands = mdl
end

--[[
	c "2b" {
	Name = "2B",
	Model = "models/kuma96/2b/2b_pm.mdl",
	Hands = "models/kuma96/2b/2b_carms.mdl",
	SubDescription = "Everything that lives is designed to end. We are perpetually trapped... in a never-ending spiral of life and death.",
	Color = rare,
	GenerateBodygroups = function(item)
		local id = rand(item.RowID or item.ID)
		local t = {}
		t.Headband = id % 2
		id = math.floor(id / 2)

		t.Skirt = id % (own(item) == "76561198050165746" and 3 or 2)

		t["Virtuous Contract"] = 0
		t["Beastlord"] = 0
		return t
	end
}
]]

dofile "autorun/box2_models.lua"

for short, data in pairs(pluto) do
	print(string.format("c %q {\n\tName = %q,\n\tModel = %q,\n\tHands = %s,\n\tColor = ColorRand(),\n\tSubDescription = %q\n}\n", short, data.Name, data.Model, data.Hands and string.format("%q", data.Hands) or "nil", data.Name))
end