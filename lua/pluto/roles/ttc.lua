--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

local function IsTTC()
	if (CLIENT) then
		return util.NetworkStringToID "pluto_ttc" ~= 0
	else
		return CreateConVar("pluto_ttc", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}):GetBool()
	end
end

if (not IsTTC()) then
	return
end
	
if (SERVER) then
	util.AddNetworkString "pluto_ttc"
end


pluto.addmodule("TTC", Color(255, 128, 255))
pluto.message("TTC", "TTC Enabled")

pluto.files.load {
	Client = {
	},
	Shared = {
		"roles/regenerative/sh_regenerative.lua",
		"roles/jester/sh_jester.lua",
	},
	Server = {
		"roles/regenerative/sv_regenerative.lua",
		"roles/jester/sv_jester.lua",
	},
	Resources = {
		"materials/pluto/roles/jester.png",
	},
}