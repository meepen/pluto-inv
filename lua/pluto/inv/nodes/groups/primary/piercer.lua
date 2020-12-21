local GROUP = pluto.nodes.groups.get("piercer", 2)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"pierce_pierce"
}

GROUP.SmallNodes = {
	pierce_mini = {
		Shares = 1,
		Max = 2,
	},
	damage = {
		Shares = 1,
		Max = 1,
	},
	distance = 2,
}
