local GROUP = pluto.nodes.groups.get("mortal", 2)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"mortal_wound"
}

GROUP.SmallNodes = {
	mortal_wound_s = 1,
}
