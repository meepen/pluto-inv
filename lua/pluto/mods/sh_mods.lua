pluto.mods = pluto.mods or {}
pluto.mods.byname = pluto.mods.byname or {}

function pluto.mods.chance(crafted, amount)
	if (not crafted) then
		return 0
	end

	local chance = crafted.Chance
	chance = chance * (1 + (amount - 1) / 5)

	return chance
end

pluto.mods.mt = pluto.mods.mt or {}

function pluto.mods.mt.__colorprint(self)
	return {self.Color or white_text, self.Name or "UNKNOWN"}
end
local MOD = pluto.mods.mt.__index or {}
pluto.mods.mt.__index = MOD

function MOD:GetPrintName()
	if (self.Type == "suffix") then
		return "of " .. self.Name
	end

	return self.Name
end

function MOD:GetTierName(tier)
	return self:GetPrintName() .. " " .. pluto.toroman(tier)
end

function pluto.mods.getrolls(mod, tier, rolls)
	local retn = {}

	tier = mod.Tiers[tier] or mod.Tiers[#mod.Tiers]

	for idx = 2, #tier, 2 do
		local min, max = tier[idx - 1], tier[idx]
		retn[idx / 2] = (rolls[idx / 2] or 0) * (max - min) + min
	end

	return retn
end

function pluto.mods.getminmaxs(mod_data, item)
	local mod = pluto.mods.byname[mod_data.Mod]
	
	if (not mod) then
		return ""
	end

	local tier = mod.Tiers[mod_data.Tier] or mod.Tiers[#mod.Tiers]

	local formatted = {}

	for i = 1, #tier - 1, 2 do
		local index = (i + 1) / 2
		formatted[index] = {
			Mins = mod:FormatModifier(index, tier[i], item.ClassName),
			Maxs = mod:FormatModifier(index, tier[i + 1], item.ClassName),
		}
	end

	return formatted
end

function pluto.mods.format(mod_data, gun)
	local mod = pluto.mods.byname[mod_data.Mod]

	if (not mod) then
		return ""
	end

	local tier = mod.Tiers[mod_data.Tier]
	local rolls = pluto.mods.getrolls(mod, mod_data.Tier, mod_data.Roll)

	local formatted = {}

	for i = 1, #tier - 1, 2 do
		local index = (i + 1) / 2
		formatted[index] = mod:FormatModifier(index, rolls[index], gun.ClassName)
	end

	return formatted
end

function pluto.mods.getdescription(mod_data)
	local mod = pluto.mods.byname[mod_data.Mod]

	if (not mod) then
		return ""
	end

	if (mod.Description) then
		return mod.Description
	elseif (mod.GetDescription) then
		return mod:GetDescription(pluto.mods.getrolls(mod, mod_data.Tier, mod_data.Roll))
	end
end

function pluto.mods.formatdescription(mod_data, item, format)
	local desc = pluto.mods.getdescription(mod_data)
	if (not format) then
		format = pluto.mods.format(mod_data, item)
	end

	return string.formatsafe(desc, unpack(format))
end
