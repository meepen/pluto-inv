--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

pluto.addmodule("ROLE", Color(255, 128, 255))
pluto.message("ROLE", "Pluto Roles Enabled")

pluto.files.load {
	Client = {
	},
	Shared = {
		"roles/passevent/sh_passevent_roles.lua",
	},
	Server = {
	},
	Resources = {
	},
}