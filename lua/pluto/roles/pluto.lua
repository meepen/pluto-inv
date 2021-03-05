
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