pluto.craft = pluto.craft or {
	tiers = {}
}

function pluto.craft.itemworth(item)
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

function pluto.craft.translateworths(worth)
	local out_text, out_percents = {}, {}
	local total = 0

	for _, amount in pairs(worth) do
		total = total + amount
	end

	local totalpercent = pluto.craft.totalpercent(total)

	for class, amount in pairs(worth) do
		out_text[class] = string.format("Chance to get %s: %.02f%%", baseclass.Get(class).PrintName, totalpercent * amount / total * 100)
		out_percents[#out_percents + 1] = {
			ClassName = class,
			Percent = totalpercent * amount / total
		}
	end

	return out_text, out_percents
end

function pluto.craft.itemsworth(items)
	local count = {}
	local info = {}

	for i = 4, 7 do
		local item = items[i]

		if (item and item.Type == "Weapon") then
			count[item.ClassName] = (count[item.ClassName] or 0) + 1
		end

		for k, v in pairs(pluto.craft.itemworth(item)) do
			info[k] = (info[k] or 0) + v
		end
	end

	for class, amount in pairs(count) do
		info[class] = info[class] ^ (1 + 0.025 * (amount - 1))
	end


	return info
end

function pluto.craft.alloutcomes(items)
	local tiers = {
		items[1].Tier.InternalName,
		items[2].Tier.InternalName,
		items[3].Tier.InternalName,
	}

	local out = {}
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

	out.Info = pluto.craft.translateworths(pluto.craft.itemsworth(items))

	return out
end

function pluto.craft.readheader(cl)
	local items = {}
	local got = {}

	local failed = false
	local notcomplete = false
	for i = 1, 7 do
		local item
		if (net.ReadBool()) then
			item = pluto.inv.items[net.ReadUInt(32)]
			if (not item or item.Owner ~= cl:SteamID64() or got[item]) then
				failed = true
				continue
			end

			got[item] = true
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

	if (pluto.craft.valid(items)) then
		return
	end

	return items
end

function pluto.inv.readrequestcraftresults(cl)
	local items = pluto.craft.readheader(cl)

	if (not items) then
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
	local items = pluto.craft.readheader(cl)

	if (not items) then
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

	local tiers = {
		{
			tier = items[1].Tier.InternalName,
			r = math.random(),
		},
		{
			tier = items[2].Tier.InternalName,
			r = math.random(),
		},
		{
			tier = items[3].Tier.InternalName,
			r = math.random(),
		},
	}

	table.sort(tiers, function(a, b)
		return a.r < b.r
	end)

	for i, tier in pairs(tiers) do
		tiers[i] = tier.tier
	end

	local class

	local out_text, out_percents = pluto.craft.translateworths(pluto.craft.itemsworth(items))

	local rand = math.random()
	for _, data in pairs(out_percents) do
		rand = rand - data.Percent
		if (rand < 0) then
			class = data.ClassName
			break
		end
	end

	local wpn = pluto.weapons.generatetier(pluto.tiers.craft(tiers), class)

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
	for _, item in pairs(items) do
		pluto.inv.deleteitem(cl, item.RowID, print, transact)
	end
	pluto.inv.savebufferitem(cl, wpn, transact)

	if (cur) then
		pluto.inv.addcurrency(cl, cur.Currency, -cur.Amount, nil, transact)
	end

	transact:Run()
end
