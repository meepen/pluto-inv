pluto.weapons = pluto.weapons or {}

-- TODO(meep): uniques

function pluto.weapons.randomgun()
	return table.Random(pluto.weapons.guns)
end

function pluto.weapons.randommelee()
	return table.Random(pluto.weapons.melees)
end

function pluto.weapons.generatetier(tier, wep, ...)
	if (not wep) then
		wep = pluto.weapons.randomgun()
	end

	-- TODO(meep): get tier

	return {
		ClassName = wep,
		Tier = tier or "no tier",
		Mods = pluto.mods.generateaffixes(weapons.GetStored(wep), ...)
	}
end

function pluto.weapons.generateunique(unique, wep, ...)
	if (not wep) then
		wep = pluto.weapons.randomgun()
	end

	-- TODO(meep): get tier

	return {
		ClassName = wep,
		Tier = tier or "no tier",
		Mods = pluto.mods.generateaffixes(weapons.GetStored(wep), ...)
	}
end

concommand.Add("pluto_generate_random_weapons", function(ply, cmd, args)
	if (IsValid(ply)) then
		return
	end


	local class = args[1]
	local affixcount = tonumber(args[2] or 5)
	local count = tonumber(args[3] or 1)


	for i = 1, count do
		local gun = pluto.weapons.generatetier(nil, class, affixcount)
		pprintf("Generated %s %s", gun.Tier, weapons.GetStored(gun.ClassName).PrintName)
		for type, list in pairs(gun.Mods) do
			if (#list == 0) then
				continue
			end

			pprintf("    %s", type)

			for _, item in ipairs(list) do
				local mod = pluto.mods.byname[item.Mod]
				local rolls = pluto.mods.getrolls(mod, item.Tier, item.Roll)
				pprintf("        %s tier %i - %s", pluto.mods.formataffix(mod.Type, mod.Name), item.Tier, mod:GetDescription(rolls))
			end
		end
	end
end)
