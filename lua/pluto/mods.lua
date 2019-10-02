pluto.mods = {
	byname = {},
	suffix = {},
	prefix = {},
}

function pluto.mods.formataffix(affixtype, name)
	if (affixtype == "suffix") then
		return "of " .. name
	end

	return name
end

for _, modname in pairs {
	"accuracy",
	"bleeding",
	"damage",
	"fire",
	"firerate",
	"mag",
	"max_range",
	"min_range",
	"poison",
	"recoil",
	"shock",
	"zoomies",
} do
	local mod = include("modifiers/" .. modname .. ".lua")

	if (not mod) then
		pwarnf("Modifier %s didn't return value.", modname)
		continue
	end

	mod.Name = mod.Name or modname
	mod.InternalName = modname


	-- faster indexing in rolls
	if (mod.Tags) then
		for k, v in pairs(mod.Tags) do
			mod.Tags[k] = v
		end
	end

	pluto.mods[mod.Type] = pluto.mods[mod.Type] or {}

	pluto.mods[mod.Type][modname] = mod
	pluto.mods.byname[modname] = mod
end


local function defaulttierbias(mod)
	return math.random(1, #mod.Tiers)
end
local function defaultroll(mod, tier)
	local needed = #mod.Tiers[tier] / 2

	local retn = {}
	for i = 1, needed do
		retn[i] = math.random()
	end

	return retn
end


function pluto.mods.rollmod(mod, rolltier, roll)
	rolltier = rolltier or defaulttierbias
	roll = roll or defaultroll

	local tier = rolltier(mod)

	return {
		Roll = defaultroll(mod, tier),
		Tier = tier,
		Mod = mod.InternalName
	}
end

--[[
	affixcount = 6
	prefixmax = 3
	suffixmax = 3

	-- optional
	guaranteed = {
		strength = 1, -- guarantee strength tier 1
		recoil = true, -- guarantee recoil any tier
	}

	-- optional
	tagbiases = {
		damage = 100, -- 100x as likely
		accuracy = 0, -- 0x as likely (don't role)
	}

	-- optional
	function rolltier(mod)
		return math.random(1, #mod.Tiers)
	end

	-- optional
	function roll(mod, tier)
		local needed = #mod.Tiers[tier] / 2

		local retn = {}
		for i = 1, needed do
			retn[i] = math.random()
		end

		return retn
	end
]]

local function bias(wpn, list, biases)
	biases = biases or {}

	local retn = {}

	for _, item in pairs(list) do
		if (wpn and item.CanRollOn and not item:CanRollOn(wpn)) then
			continue
		end

		local bias = 1
		for bias, amt in pairs(biases) do
			if (item.Tags[bias]) then
				bias = bias * amt
			end
		end

		retn[#retn + 1] = {
			item = item,
			roll = math.random() * bias
		}
	end

	table.sort(retn, function(a, b)
		return b.roll > a.roll
	end)

	for k, v in pairs(retn) do
		retn[k] = v.item
	end

	return retn
end


function pluto.mods.generateaffixes(wpn, affixcount, prefixmax, suffixmax, guaranteed, tagbiases, rolltier, roll)
	local allowed = {
		prefix = prefixmax or 3,
		suffix = suffixmax or 3
	}

	local retn = {
		suffix = {},
		prefix = {}
	}

	if (guaranteed) then
		for modname, data in pairs(guaranteed) do
			local mod = pluto.mods.byname[modname]
			if (not mod) then
				pwarnf("Mod %s doesn't exist.\n%s", modname, debug.traceback())
				continue
			end

			if (not allowed[mod.Type] or allowed[mod.Type] <= 0 or affixcount <= 0) then
				pwarnf("Mod %s cannot be added due to restrictions.\n%s", modname, debug.traceback())
				continue
			end

			table.insert(retn[mod.Type], pluto.mods.rollmod(mod, rolltier, roll))
			affixcount = affixcount - 1

			allowed[mod.Type] = allowed[mod.Type] - 1
		end
	end


	local potential = {
		suffix = bias(wpn, pluto.mods.suffix, tagbiases),
		prefix = bias(wpn, pluto.mods.prefix, tagbiases),
		current = {
			suffix = 1,
			prefix = 1,
		}
	}
	
	for i = 1, affixcount do
		local chosenaffix = math.random(1, 2) == 1 and "suffix" or "prefix"

		if (allowed[chosenaffix] <= 0 or potential.current[chosenaffix] > #potential[chosenaffix]) then
			chosenaffix = chosenaffix == "suffix" and "prefix" or "suffix"

			if (allowed[chosenaffix] <= 0 or potential.current[chosenaffix] > #potential[chosenaffix]) then
				pwarnf("Couldn't generate another mod.\n%s", debug.traceback())
				break
			end
		end

		local mod = potential[chosenaffix][potential.current[chosenaffix]]
		potential.current[chosenaffix] = potential.current[chosenaffix] + 1
		allowed[chosenaffix] = allowed[chosenaffix] - 1

		table.insert(retn[mod.Type], pluto.mods.rollmod(mod, rolltier, roll))
	end


	return retn
end

concommand.Add("pluto_test_mod_generate_speed", function(ply)
	if (IsValid(ply)) then
		return
	end

	local time = SysTime

	local start = time()

	local count = 100000

	for i = 1, count do
		pluto.mods.generateaffixes(nil, 6)
	end

	print((time() - start) / count)
end)

function pluto.mods.getrolls(mod, tier, rolls)
	local retn = {}
	tier = mod.Tiers[tier]
	for i, roll in ipairs(rolls) do
		local idx = (i - 1) * 2 + 1
		local min, max = tier[idx], tier[idx + 1]
		retn[i] = math.random() * (max - min) + min
	end

	return retn
end


concommand.Add("pluto_generate_random_mods", function(ply, cmd, args)
	if (IsValid(ply)) then
		return
	end


	local affixcount = tonumber(args[1] or 5)
	local count = tonumber(args[2] or 1)


	for i = 1, count do
		pprintf("Generated #%i", i)
		for type, list in pairs(pluto.mods.generateaffixes(nil, affixcount)) do
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
