pluto.craft = pluto.craft or {
	tiers = {}
}

function pluto.craft.alloutcomes(tiers)
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
