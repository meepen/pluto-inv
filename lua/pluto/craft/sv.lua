pluto.craft = pluto.craft or {
	tiers = {}
}

function pluto.craft.getworth(item)
	if (not item) then
		return {}
	end

	if (item.Type == "Weapon") then
		local tier = item.Tier.Shares / pluto.tiers.bytype.Weapon.shares
		local junk = pluto.tiers.byname.junk.Shares / pluto.tiers.bytype.Weapon.shares
		return {
			[item.ClassName] = junk / tier
		}
	end
	return {}
end

function pluto.craft.totalpercent(total)
	return math.min(0.95, total / 3000)
end

function pluto.craft.translateworth(worth)
	local out = {}
	local total = 0

	for _, amount in pairs(worth) do
		total = total + amount
	end

	local totalpercent = pluto.craft.totalpercent(total)

	for class, amount in pairs(worth) do
		out[class] = string.format("Chance to get %s: %.02f%%", baseclass.Get(class).PrintName, totalpercent * amount / total * 100)
	end
	return out
end

function pluto.craft.alloutcomes(items)
	local tiers = {
		items[1].Tier.InternalName,
		items[2].Tier.InternalName,
		items[3].Tier.InternalName,
	}

	local out = {
		Info = {}
	}
	local got = {}

	local function insert(t1, t2, t3)
		local t = pluto.tiers.craft {
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

	local count = {}
	for i = 4, 7 do
		local item = items[i]

		if (item and item.Type == "Weapon") then
			count[item.ClassName] = (count[item.ClassName] or 0) + 1
		end

		for k, v in pairs(pluto.craft.getworth(item)) do
			out.Info[k] = (out.Info[k] or 0) + v
		end
	end

	for class, amount in pairs(count) do
		out.Info[class] = out.Info[class] ^ (1 + 0.025 * (amount - 1))
	end


	out.Info = pluto.craft.translateworth(out.Info)

	return out
end

function pluto.inv.readrequestcraftresults(cl)
	local items = {}

	local failed = false
	local notcomplete = false
	for i = 1, 7 do
		local item
		if (net.ReadBool()) then
			item = pluto.inv.items[net.ReadUInt(32)]
			if (not item or item.Owner ~= cl:SteamID64()) then
				failed = true
				continue
			end

			items[i] = item
		end
		
		if (i <= 3 and (not item or item.Type ~= "Shard")) then
			notcomplete = true
			continue
		end
	end

	if (notcomplete) then
		return
	end

	if (failed) then
		pluto.inv.sendfullupdate(cl)
		return 
	end

	local outcomes = pluto.craft.alloutcomes(items)

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

function pluto.inv.writecraftresults(cl, outcomes)
	net.WriteUInt(#outcomes, 8)
	for i = 1, #outcomes do
		pluto.inv.writebaseitem(cl, outcomes[i])
	end

	for k, v in pairs(outcomes.Info) do
		net.WriteBool(true)
		net.WriteString(k)
		net.WriteString(v)
	end
	net.WriteBool(false)
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

		if (not cur.Crafted) then
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

	local wpn = pluto.weapons.generatetier(pluto.tiers.craft(tiers))

	wpn.TabID = i1.TabID
	wpn.TabIndex = i1.TabIndex
	wpn.Owner = i1.Owner

	if (cur) then
		local crafted = pluto.currency.byname[cur.Currency].Crafted

		if (not crafted) then
			pluto.inv.sendfullupdate(cl)
			return
		end

		local chance = pluto.mods.chance(crafted, cur.Amount)

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
	pluto.inv.deleteitem(cl, i1.RowID, print, transact)
	pluto.inv.deleteitem(cl, i2.RowID, print, transact)
	pluto.inv.deleteitem(cl, i3.RowID, print, transact)
	pluto.weapons.save(wpn, cl, nil, transact)

	if (cur) then
		pluto.inv.addcurrency(cl, cur.Currency, -cur.Amount, nil, transact)
	end

	transact:Run()
end
