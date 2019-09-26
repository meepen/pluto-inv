pluto.weapons = pluto.weapons or {}
pluto.tiers = {}

local total_shares = 0
for _, name in pairs {
	"common",
	"junk",
	"mystical",
	"otherworldly",
	"powerful",
	"shadowy",
	"uncommon",
	"vintage",
} do
	local item = include("pluto/tiers/" .. name .. ".lua")
	if (not item) then
		pwarnf("Tier %s didn't return a value", name)
		continue
	end

	if (not item.Shares) then
		pwarnf("Tier %s doesn't have shares", name)
		continue
	end

	pluto.tiers[name] = item
	total_shares = total_shares + item.Shares
end

pluto.tiers_pct = {}

local pct = 0
for name, item in pairs(pluto.tiers) do
	pct = pct + item.Shares / total_shares
	table.insert(pluto.tiers_pct, {
		Percent = pct,
		Tier = item
	})
end


function pluto.tiers.random()
	local rand = math.random()

	for _, item in ipairs(pluto.tiers_pct) do
		if (item.Percent >= rand) then
			return item.Tier
		end
	end

	pwarnf("Reached end of loop in pluto.tiers.random, rand: %f", rand)

	return pluto.tiers.junk
end


function pluto.weapons.randomgun()
	return table.Random(pluto.weapons.guns)
end

function pluto.weapons.randommelee()
	return table.Random(pluto.weapons.melees)
end

function pluto.weapons.generatetier(tier, wep, tagbiases, rolltier, roll)
	if (wep) then
		wep = weapons.GetStored(wep)
	end
	if (not wep) then
		wep = weapons.GetStored(pluto.weapons.randomgun())
	end

	if (tier) then
		tier = pluto.tiers[tier]
	end

	if (not tier) then
		tier = pluto.tiers.random()
	end

	local biases = tier.biases or {}

	if (tagbiases) then
		for k, v in pairs(tagbiases) do
			biases[k] = (biases[k] or 1) * v
		end
	end

	return {
		ClassName = wep.ClassName,
		Tier = tier,
		Mods = pluto.mods.generateaffixes(wep, math.random(1, tier.affixes), nil, nil, tier.guaranteed, biases, tier.rolltier or rolltier, tier.roll or roll)
	}
end

function pluto.weapons.generateunique(unique)
end

concommand.Add("pluto_generate_random_weapons", function(ply, cmd, args)
	if (IsValid(ply)) then
		return
	end

	local class = args[1]
	local tier = args[2]
	local count = tonumber(args[3] or 1)

	for i = 1, count do
		local gun = pluto.weapons.generatetier(tier, class)
		pprintf("Generated %s %s", gun.Tier.Name, weapons.GetStored(gun.ClassName).PrintName)
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
