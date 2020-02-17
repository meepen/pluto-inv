pluto.craft = pluto.craft or {
	tiers = {}
}

local function CombineColors(...)
	local cols = {
		h = 0,
		s = 0,
		v = 0,
		a = 255
	}

	local num = select("#", ...)
	for i = 1, num do
		local h, s, v = ColorToHSV((select(i, ...)))

		cols.h = cols.h + h / num
		cols.s = cols.s + s / num
		cols.v = cols.v + v / num
	end

	local c = HSVToColor(cols.h, cols.s, cols.v, cols.a)
	return Color(c.r, c.g, c.b, c.a)
end

function pluto.craft.tier(tiers)
	for i, t in pairs(tiers) do
		tiers[i] = pluto.tiers[tiers[i]]
	end

	local t1, t2, t3 = tiers[1], tiers[2], tiers[3]

	if (t1 == t2 and t2 == t3) then
		return t1
	end

	local name = t1.InternalName .. "-" .. t2.InternalName .. "-" .. t3.InternalName

	if (pluto.craft.tiers[name]) then
		return pluto.craft.tiers[name]
	end

	local tier = setmetatable({
		Name = "Crafted",
		InternalName = "crafted",
		Tiers = {
			t1.InternalName,
			t2.InternalName,
			t3.InternalName,
		},
	}, pluto.tier_mt)

	pluto.craft.tiers[name] = tier

	tier.SubDescription = {
		string.format("Crafted from %s, %s and %s shards", t1.Name, t2.Name, t3.Name)
	}

	if (t2.tags) then
		table.insert(tier.SubDescription, t2.SubDescription.tags)
		tier.tags = t2.tags
	end

	if (t3.rolltier) then
		table.insert(tier.SubDescription, t3.SubDescription.rolltier)
		tier.rolltier = t3.rolltier
	end

	tier.affixes = t1.affixes or 0
	tier.Color = CombineColors(t1.Color, t1.Color, t1.Color, t1.Color, t1.Color, t1.Color, t1.Color, t2.Color, t2.Color, t3.Color)

	return tier
end

function pluto.craft.alloutcomes(tiers)
	local out = {}
	local got = {}

	local function insert(t1, t2, t3)
		local t = pluto.craft.tier {
			t1,
			t2,
			t3
		}

		if (got[t]) then
			return
		end

		got[t] = true

		out[#out + 1] = t
	end
	
	insert(tiers[1], tiers[2], tiers[3])
	insert(tiers[1], tiers[3], tiers[2])
	insert(tiers[2], tiers[1], tiers[3])
	insert(tiers[2], tiers[3], tiers[1])
	insert(tiers[3], tiers[1], tiers[2])
	insert(tiers[3], tiers[2], tiers[1])

	return out
end

function pluto.inv.readrequestcraftresults(cl)
	local i1 = net.ReadUInt(32)
	local i2 = net.ReadUInt(32)
	local i3 = net.ReadUInt(32)

	i1 = pluto.inv.items[i1]
	i2 = pluto.inv.items[i2]
	i3 = pluto.inv.items[i3]

	if (i1 and i2 and i3 and i1.Type == "Shard" and i2.Type == "Shard" and i3.Type == "Shard") then
		local outcomes = pluto.craft.alloutcomes {
			i1.Tier.InternalName,
			i2.Tier.InternalName,
			i3.Tier.InternalName,
		}

		for i = 1, #outcomes do
			outcomes[i] = setmetatable({
				Type = "Shard",
				ClassName = "shard",
				SpecialName = "Random Crafted Weapon",
				Tier = outcomes[i]
			}, pluto.inv.item_mt)
		end

		pluto.inv.message(cl)
			:write("craftresults", outcomes)
			:send()
	end
end

function pluto.inv.writecraftresults(cl, outcomes)
	net.WriteUInt(#outcomes, 8)
	for i = 1, #outcomes do
		pluto.inv.writebaseitem(cl, outcomes[i])
	end
end

function pluto.inv.readcraft(cl)
	local i1, i2, i3 = net.ReadUInt(32), net.ReadUInt(32), net.ReadUInt(32)

	if (i1 == i2 or i1 == i3 or i1 == i2) then
		pluto.inv.sendfullupdate(cl)
		return
	end

	local cur
	if (net.ReadBool()) then
		cur = {
			Currency = net.ReadString(),
		}

		cur.Amount = math.min(10, net.ReadUInt(32))

		local cur = pluto.currency.byname[cur.Currency]

		if (cur.CanCraft == false) then
			pluto.inv.sendfullupdate(cl)
			return
		end
	end
	
	i1 = pluto.inv.items[i1]
	i2 = pluto.inv.items[i2]
	i3 = pluto.inv.items[i3]

	if (not i1 or not i2 or not i3) then
		return
	end

	if (i1.Owner ~= i2.Owner or i3.Owner ~= i1.Owner or i1.Owner ~= cl:SteamID64()) then
		pluto.inv.sendfullupdate(cl)
		return
	end

	if (i1.Type ~= "Shard" and i2.Type ~= "Shard" and i3.Type ~= "Shard") then
		pluto.inv.sendfullupdate(cl)
		return
	end

	local tiers = {
		{
			tier = i1.Tier.InternalName,
			r = math.random(),
		},
		{
			tier = i2.Tier.InternalName,
			r = math.random(),
		},
		{
			tier = i3.Tier.InternalName,
			r = math.random(),
		},
	}

	table.sort(tiers, function(a, b)
		return a.r < b.r
	end)

	for i, tier in pairs(tiers) do
		tiers[i] = tier.tier
	end

	local wpn = pluto.weapons.generatetier(pluto.craft.tier(tiers))

	wpn.TabID = i1.TabID
	wpn.TabIndex = i1.TabIndex
	wpn.Owner = i1.Owner

	if (cur) then
		local crafted = pluto.currency.byname[cur.Currency].Crafted

		if (not crafted) then
			pluto.inv.sendfullupdate(cl)
			return
		end

		if (not pluto.inv.currencies[cl] or not pluto.inv.currencies[cl][cur.Currency] or pluto.inv.currencies[cl][cur.Currency] < cur.Amount) then
			pluto.inv.sendfullupdate(cl)
			return
		end

		local chance = crafted.Chance
		chance = chance * (1 + cur.Amount / 10)

		if (math.random() < chance) then
			pluto.weapons.addmod(wpn, crafted.Mod)

			wpn.SpecialName = pluto.mods.byname[crafted.Mod].Name .. " %s"
		end
	end

	if (wpn:GetMaxAffixes() >= 4) then
		discord.Message():AddEmbed(
			wpn:GetDiscordEmbed()
				:SetAuthor(cl:Nick() .. "'s", "https://steamcommunity.com/profiles/" .. cl:SteamID64())
		):Send "drops"
	end

	local transact = pluto.db.transact()
	pluto.weapons.save(wpn, cl, nil, transact)

	pluto.inv.deleteitem(cl, i2.RowID, print, transact)
	pluto.inv.deleteitem(cl, i3.RowID, print, transact)
	if (cur) then
		pluto.inv.addcurrency(cl, cur.Currency, -cur.Amount, nil, transact)
	end

	transact:Run()
end
