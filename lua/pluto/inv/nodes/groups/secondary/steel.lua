local GROUP = pluto.nodes.groups.get("steel_enchant", 1)

GROUP.Type = "secondary"

GROUP.Guaranteed = {
	"steel_enchant",
	"steel_share",
}

GROUP.SmallNodes = {
	steel_transform = {
		Shares = 1,
		Max = 1,
	},
	steel_spawns = {
		Shares = 1,
		Max = 1,
	}
}
