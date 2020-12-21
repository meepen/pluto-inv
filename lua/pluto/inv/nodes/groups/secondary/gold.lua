local GROUP = pluto.nodes.groups.get("gold_enchant", 1)

GROUP.Type = "secondary"

GROUP.Guaranteed = {
	"gold_enchant"
}

GROUP.SmallNodes = {
	gold_transform = {
		Shares = 1,
		Max = 1,
	},
	gold_spawns = {
		Shares = 1,
		Max = 1,
	}
}
