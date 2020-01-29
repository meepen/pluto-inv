pluto.inv = pluto.inv or {}

pluto.inv.messages = {
	cl2sv = {
		[0]  = "end",
		[1]  = "tabswitch",
		[2]  = "itemdelete",
		[3]  = "currencyuse",
		[4]  = "tabrename",
		[5]  = "claimbuffer",
		[6]  = "tradeupdate",
		[7]  = "trademessage",
		[8]  = "traderequest",
		[9]  = "tradeaccept",
		[10] = "votemap",
		[11] = "likemap",
		[12] = "requestcraftresults",
		[13] = "craft",
	},
	sv2cl = {
		[0] = "end",
		[1] = "item",
		[2] = "mod",
		[3] = "tab",
		[4] = "status",
		[5] = "tabupdate",
		[6] = "currencyupdate",
		[7] = "bufferitem",
		[8] = "tradeupdate",
		[9] = "trademessage",
		[10] = "tradeaccept",
		[11] = "fullupdate",
		[12] = "crate_id",
		[13] = "mapvote",
		[14] = "mapvotes",
		[15] = "craftresults",
		[16] = "expupdate",
		[17] = "nitro",
	}
}

function pluto.inv.itemtype(i)
	local class = type(i) == "table" and i.ClassName or i
	if (class == "shard") then
		return "Shard"
	elseif (class:StartWith "weapon_") then
		return "Weapon"
	elseif (class:StartWith "model_") then
		return "Model"
	else
		return "Unknown"
	end
end

for k, v in pairs(pluto.inv.messages.cl2sv) do
	pluto.inv.messages.cl2sv[v] = k
end
for k, v in pairs(pluto.inv.messages.sv2cl) do
	pluto.inv.messages.sv2cl[v] = k
end

co_net.Receive("pluto_inv_data", function(len, cl)
	pprintf("Collecting %i bits of inventory data...", len)

	while (not pluto.inv.readmessage(cl)) do
	end
end)

function pluto.inv.readmessage(cl)
	local uid = net.ReadUInt(8)
	local id = (SERVER and pluto.inv.messages.cl2sv or pluto.inv.messages.sv2cl)[uid]

	if (id == "end") then
		pluto.inv.readend()
		return true
	end

	local fn = pluto.inv["read" .. id]

	if (not fn) then
		pwarnf("no function for %i", uid)
		return false
	end

	fn(cl)
end

local a = {
	__index = {
		write = function(self, what, ...)
			if (SERVER) then
				pluto.inv.send(self.Player, what, ...)
			else
				pluto.inv.send(what, ...)
			end
			return self
		end,
		send = function(self)
			self:write("end")
			net.Finish()
		end
	}
}

function pluto.inv.message(ply)
	co_net.Start("pluto_inv_data", function()
		if (SERVER) then
			net.Send(ply)
		else
			net.SendToServer()
		end
	end)

	return setmetatable({
		Player = ply
	}, a)
end

local ITEM = {}

pluto.inv.item_mt = pluto.inv.item_mt or {}
pluto.inv.item_mt.__index = ITEM

function ITEM:GetPrintName()
	if (self.Nickname) then
		return "\"" .. self.Nickname .. "\""
	end

	if (self.SpecialName) then
		return string.format(self.SpecialName, self:GetRawName())
	end

	return self:GetDefaultName()
end

function ITEM:ShouldPreventChange()
	if (self.Type ~= "Weapon") then
		return true
	end
	
	if (self.Tier and self.Tier.NoChange) then
		return true
	end

	if (self and self.Mods) then
		for _, mods in pairs(self.Mods) do
			for _, mod in pairs(mods) do
				local m = pluto.mods.byname[mod.Mod]
				if (m and m.PreventChange == true) then
					return true
				end
			end
		end
	end

	return false
end

function ITEM:GetMod(name)
	local real = pluto.mods.byname[name]

	if (not real) then
		return
	end

	if (not self.Mods or not self.Mods[real.Type]) then
		return
	end

	for _, mod in pairs(self.Mods[real.Type]) do
		if (mod.Mod == name) then
			return mod
		end
	end
end

function ITEM:GetMaxAffixes()
	local affix = 0

	if (self.Tier) then
		affix = self.Tier.affixes
	end

	if (self.Mods and self.Mods.implicit) then
		for _, modd in pairs(self.Mods.implicit) do
			local mod = pluto.mods.byname[modd.Mod]
			if (mod.ExtraAffixes) then
				affix = affix + mod.ExtraAffixes
			end
		end
	end

	return affix
end

function ITEM:GetDefaultName()
	if (self.Type == "Shard") then
		local tier = self.Tier
		if (istable(tier)) then
			tier = tier.Name
		end
		return tier .. " Tier Shard"
	elseif (self.Type == "Weapon") then -- item
		local w = weapons.GetStored(self.ClassName)
		local tier = self.Tier
		if (istable(tier)) then
			tier = tier.Name
		end
		return tier .. " " .. (w and w.PrintName or "N/A")
	elseif (self.Type == "Model") then
		return self.Name
	end

	return "Unknown type: " .. self.Type
end

function ITEM:GetRawName()
	if (self.Type == "Shard") then
		return "Tier Shard"
	elseif (self.Type == "Weapon") then -- item
		local w = weapons.GetStored(self.ClassName)
		return w and w.PrintName or "N/A"
	elseif (self.Type == "Model") then
		return self.Name
	end

	return "Unknown type: " .. self.Type
end

-- https://gist.github.com/efrederickson/4080372
local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
local chars = { "I", "V", "X", "L", "C", "D", "M" }

local function ToRomanNumerals(s)
    --s = tostring(s)
    s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
	local ret = ""
        for i = #numbers, 1, -1 do
        local num = numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. chars[j] .. chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end

function ITEM:GetDiscordEmbed()
	local embed = discord.Embed()
		:SetColor(self.Tier.Color)
		:SetTitle(self:GetPrintName())

	if (self.Tier) then
		local desc = self.Tier:GetSubDescription()

		if (self:GetMaxAffixes() > 0) then
			desc = desc .. (desc:len() > 0 and "\n" or "") .. "You can get up to " .. self:GetMaxAffixes() .. " modifiers on this item."
		end

		if (desc:len() > 0) then
			embed:SetDescription(desc)
		end
	end
	
	if (self.Mods) then
		for type, mods in pairs(self.Mods) do
			for ind, moditem in ipairs(mods) do
				local mod = pluto.mods.byname[moditem.Mod]
				local rolls = pluto.mods.getrolls(mod, moditem.Tier, moditem.Roll)
				local name = pluto.mods.formataffix(mod.Type, mod.Name)
				local tier = moditem.Tier
				local tierroll = mod.Tiers[moditem.Tier] or mod.Tiers[#mod.Tiers]

				local desc_fmt = {}

				for i, roll in ipairs(rolls) do
					desc_fmt[i] = "[" .. mod:FormatModifier(i, math.abs(roll), self.ClassName) .. "](https://pluto.gg)"
				end

				embed:AddField(name .. " " .. ToRomanNumerals(tier), string.format(mod.Description or mod:GetDescription(rolls), unpack(desc_fmt)))
			end
		end
	end

	return embed
end