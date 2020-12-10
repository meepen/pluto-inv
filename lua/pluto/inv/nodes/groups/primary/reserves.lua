local GROUP = pluto.nodes.groups.get("reserves", 1)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"mythic_reserves"
}

GROUP.SmallNodes = {
	mag = 2,
	firerate = {
		Shares = 1,
		Max = 1,
	},
	distance = 1,
}
