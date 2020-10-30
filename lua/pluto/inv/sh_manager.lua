pluto.inv = pluto.inv or {}

pluto.inv.messages = {
	cl2sv = {
		[0]  = "end",
		"tabswitch",
		"itemdelete",
		"currencyuse",
		"tabrename",
		"claimbuffer",
		"tradeupdate",
		"trademessage",
		"traderequest",
		"tradeaccept",
		"votemap",
		"likemap",
		"requestcraftresults",
		"craft",
		"itemlock",
		"rename",
		"ui",
		"unname",
	},
	sv2cl = {
		[0] = "end",
		"item",
		"mod",
		"tab",
		"status",
		"tabupdate",
		"currencyupdate",
		"bufferitem",
		"tradeupdate",
		"trademessage",
		"tradeaccept",
		"fullupdate",
		"crate_id",
		"mapvote",
		"mapvotes",
		"craftresults",
		"expupdate",
		"itemlock",
		"nitro",
		"quests",
		"quest",
		"questdone",
		"playermodel",
		"playerexp",
	}
}

function pluto.inv.itemtype(i)
	local class = type(i) == "table" and i.ClassName or i
	if (class == "shard") then
		return "Shard"
	elseif (class:StartWith "weapon_" or class:StartWith "tfa_") then
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

pluto.inv.item_mt.__colorprint = function(self)
	return {self:GetColor(), self:GetPrintName()}
end

function ITEM:GetPrintName()
	if (self.Nickname) then
		return "\"" .. string.formatsafe(self.Nickname, self:GetDefaultName()) .. "\""
	end

	return self:GetDefaultName()
end

function ITEM:GetTab()
	if (SERVER) then
		local owner = player.GetBySteamID64(self.Owner)
		if (not IsValid(owner)) then
			return
		end

		local tab = pluto.inv.invs[owner][self.TabID]

		return tab
	end
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

	if (self.AffixMax) then
		affix = self.AffixMax
	elseif (istable(self.Tier)) then
		affix = self.Tier.affixes
	end

	if (self.Mods and self.Mods.implicit) then
		for _, modd in pairs(self.Mods.implicit) do
			local mod = pluto.mods.byname[modd.Mod]
			if (mod and mod.ExtraAffixes) then
				affix = affix + mod.ExtraAffixes
			end
		end
	end

	return affix
end

function ITEM:GetModCount(includeimplicit)
	local count = 0

	for type, modlist in pairs(self.Mods) do
		print(type)
		if (type == "implicit" and not includeimplicit) then
			continue
		end

		count = count + #modlist
	end

	return count
end

function ITEM:GetDefaultName()
	if (self.SpecialName) then
		return string.format(self.SpecialName, self:GetRawName(true))
	end

	return self:GetRawName()
end

function ITEM:GetRawName(ignoretier)
	if (self.Type == "Shard") then
		local tier = self.Tier
		if (istable(tier)) then
			tier = tier.Name
		end
		return tier .. " Tier Shard"
	elseif (self.Type == "Weapon") then -- item
		local w = baseclass.Get(self.ClassName)
		local tier = self.Tier
		if (istable(tier)) then
			tier = tier.Name
		end
		return (ignoretier and "" or tier .. " ") .. (w and w.PrintName or "N/A")
	elseif (self.Type == "Model") then
		return self.Model.Name .. " Model"
	end

	return "Unknown type: " .. tostring(self.Type)
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

function ITEM:GetColor()
	if (self.Color) then
		return self.Color
	elseif (self.Type == "Weapon") then
		return self.Tier.Color
	elseif (self.Type == "Model") then
		return self.Model.Color
	else
		return Color(0, 0, 0)
	end
end

function ITEM:GetDiscordEmbed()
	local embed = discord.Embed()
		:SetColor(self:GetColor())
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
			for ind, mod_data in ipairs(mods) do
				local mod = pluto.mods.byname[mod_data.Mod]

				if (not mod) then
					continue
				end
				
				local rolls = pluto.mods.getrolls(mod, mod_data.Tier, mod_data.Roll)

				local name = mod:GetPrintName()
				local tier = mod_data.Tier
				local tierroll = mod.Tiers[mod_data.Tier] or mod.Tiers[#mod.Tiers]

				local desc_fmt = {}

				for i, roll in ipairs(rolls) do
					desc_fmt[i] = "[" .. mod:FormatModifier(i, math.abs(roll), self.ClassName) .. "](https://pluto.gg)"
				end

				embed:AddField(name .. " " .. ToRomanNumerals(tier), pluto.mods.formatdescription(mod_data, self, desc_fmt))
			end
		end
	end

	if (self.Model) then
		embed:AddField("Description", self.Model.SubDescription)
	end

	return embed
end

function ITEM:GetTextMessage()
	local msg = {}
	table.insert(msg, self:GetPrintName())
	table.insert(msg, "\n")

	if (self.Tier) then
		local desc = self.SubDescription or self.Tier:GetSubDescription()

		if (self:GetMaxAffixes() > 0) then
			desc = desc .. (desc:len() > 0 and "\n" or "") .. "You can get up to " .. self:GetMaxAffixes() .. " modifiers on this item."
		end

		if (desc:len() > 0) then
			table.insert(msg, "\n")
			table.insert(msg, desc)
		end
	end
	
	if (self.Mods) then
		for type, mods in pairs(self.Mods) do
			for ind, mod_data in ipairs(mods) do
				local mod = pluto.mods.byname[mod_data.Mod]

				if (not mod) then
					continue
				end
				
				local rolls = pluto.mods.getrolls(mod, mod_data.Tier, mod_data.Roll)

				local name = mod:GetPrintName()
				local tier = mod_data.Tier
				local tierroll = mod.Tiers[mod_data.Tier] or mod.Tiers[#mod.Tiers]

				local desc_fmt = {}

				for i, roll in ipairs(rolls) do
					desc_fmt[i] = mod:FormatModifier(i, math.abs(roll), self.ClassName)
				end

				table.insert(msg, "\n")
				table.insert(msg, name .. " " .. ToRomanNumerals(tier) .. " - " .. pluto.mods.formatdescription(mod_data, self, desc_fmt))
			end
		end
	end

	if (self.Model) then
		table.insert(msg, "\n")
		table.insert(msg, self.Model.SubDescription)
	end

	return table.concat(msg) .. "\n"
end

function ITEM:Duplicate()
	local ret = setmetatable({}, pluto.inv.item_mt)

	for k, v in pairs(self) do
		ret[k] = type(v) == "table" and table.Copy(v) or v
	end

	ret.Owner = nil
	ret.TabID = nil
	ret.TabIndex = nil
	ret.RowID = nil
	ret.ID = nil

	return ret
end