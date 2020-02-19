pluto.mods = pluto.mods or {
	byname   = {},

	byitem   = {
		--[[
		[type] = {
			suffix = {},
			prefix = {},
			implcit = {}
		}
		]]
	},
}

function pluto.mods.chance(crafted, amount)
	if (not crafted) then
		return 0
	end

	local chance = crafted.Chance
	chance = chance * (1 + (amount - 1) / 5)

	return chance
end