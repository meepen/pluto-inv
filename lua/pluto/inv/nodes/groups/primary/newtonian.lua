local GROUP = pluto.nodes.groups.get("newtonian", 2)

GROUP.Type = "primary"

GROUP.Guaranteed = {
	"pusher_push"
}

function GROUP:CanRollOn(class)
	return class and class.Primary and class.Primary.Ammo and class.Primary.Ammo:lower() == "buckshot"
end

GROUP.SmallNodes = {
	damage = {
		Shares = 1.5,
		Max = 2,
	},
	firerate = 1,
	mag = 3,
}
