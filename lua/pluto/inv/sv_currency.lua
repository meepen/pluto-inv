pluto.currency.shares = 0

local function UpdateAndDecrement(ply, item, currency)
	local trans = pluto.weapons.update(item, function(id)
		if (not IsValid(ply)) then
			return
		end

		pluto.inv.message(ply)
			:write("item", item)
			:send()

	end, true)
	trans:addQuery(pluto.inv.addcurrency(ply, currency, -1, function() end, true))
	trans:start()
end

local function getnewmod(item, prefix_max, suffix_max, ignoretier)
	prefix_max = prefix_max or 3
	suffix_max = suffix_max or 3

	if (not item.Mods) then
		return
	end

	local prefixes = #item.Mods.prefix
	local suffixes = #item.Mods.suffix

	if (not ignoretier and prefixes + suffixes == item.Tier.affixes) then
		return
	end

	local have = {}

	for _, Mods in pairs(item.Mods) do
		for _, mod in pairs(Mods) do
			have[mod.Mod] = true
		end
	end

	local allowed = {}

	if (prefixes < prefix_max) then
		local t = {}
		for _, item in pairs(pluto.mods.prefix) do
			if (not have[item.InternalName]) then
				t[#t + 1] = item
			end
		end
		if (#t > 0) then
			allowed.prefix = t
		end
	end

	if (suffixes < suffix_max) then
		local t = {}
		for _, item in pairs(pluto.mods.suffix) do
			if (not have[item.InternalName]) then
				t[#t + 1] = item
			end
		end
		if (#t > 0) then
			allowed.suffix = t
		end
	end

	local mods, type = table.Random(allowed)

	local toadd = pluto.mods.bias(weapons.GetStored(item.ClassName), mods, tagbiases)[1]
	
	local newmod = pluto.mods.rollmod(toadd, item.Tier.rolltier, item.Tier.roll)
	
	table.insert(item.Mods[type], newmod)
end

for name, values in pairs {
	dice = {
		Shares = 500,
		Use = function(ply, item)
			if (not item.Mods) then
				return
			end
			local tier = item.Tier

			local changed = false
			for _, Mods in pairs(item.Mods) do
				for _, mod in pairs(Mods) do
					for k, num in ipairs(pluto.mods.rollmod(pluto.mods.byname[mod.Mod], function() return mod.Tier end, tier.roll).Roll) do
						mod.Roll[k] = num
						changed = true
					end
				end
			end

			if (changed) then
				UpdateAndDecrement(ply, item, "dice")
			end
		end,
	},
	droplet = {
		Shares = 5000,
		Use = function(ply, item)
			if (not item.Mods) then
				return
			end

			item.Mods = pluto.weapons.generatetier(item.Tier.InternalName, item.ClassName).Mods
			
			UpdateAndDecrement(ply, item, "droplet")
		end,
	},
	hand = {
		Shares = 400,
		Use = function(ply, item)
			if (not item.Mods) then
				return
			end

			local possible = {}
			local incr_possible = {}
			for _, Mods in pairs(item.Mods) do
				for i = 1, #Mods do
					local mod = Mods[i]
					local incr
					if (mod.Tier > 1) then
						table.insert(incr_possible, Mods[i])
						incr = #incr_possible
					end
					table.insert(possible, {
						Mods = Mods,
						Index = i,
						Incr = incr
					})
				end
			end

			if (#possible <= 1) then
				return
			end

			local rand = table.Random(possible)
			if (rand.Incr) then
				table.remove(incr_possible, rand.Incr)
			end

			table.remove(rand.Mods, rand.Index)

			local increase = table.Random(incr_possible)
			if (increase) then
				increase.Tier = increase.Tier - 1
			end

			UpdateAndDecrement(ply, item, "hand")
		end,
	},
	tome = {
		Shares = 0,
		Use = function(ply, item)
			if (not item.Mods) then
				return
			end

			local rand = math.floor(math.random(1, 12) / 2) + 1
			if (rand == 1) then     -- 2 mods
				getnewmod(item, 5, 3, true)
				getnewmod(item, 5, 3, true)
			elseif (rand == 2) then -- 1 mod
				getnewmod(item, 5, 3, true)
			elseif (rand == 3) then -- nothing
			elseif (rand == 4) then -- base gun change
				item.ClassName = pluto.weapons.randomgun()
			elseif (rand == 5) then -- tier change
				local newitem = pluto.weapons.generatetier(nil, item.ClassName)
				item.Tier = newitem.Tier
				item.Mods = newitem.Mods
			elseif (rand == 6) then -- reroll
				item.Mods = pluto.weapons.generatetier(item.Tier.InternalName, item.ClassName).Mods
			else
				return
			end

			table.insert(item.Mods.prefix, {
				Roll = {},
				Tier = 1,
				Mod = "unchanging"
			})

			UpdateAndDecrement(ply, item, "tome")
		end,
	},
	mirror = {
		Shares = 0,
		Use = function(item)
		end,
	},
	heart = {
		Shares = 5,
		Use = function(ply, item)
			getnewmod(item)

			UpdateAndDecrement(ply, item, "heart")
		end,
	},
	coin = {
		Shares = 2.5,
		Use = function(ply)
			local trans = pluto.inv.addtabs(ply, {"normal"}, function(tab)
				if (not tab or not IsValid(ply)) then
					return
				end

				tab = tab[1]

				if (not tab) then
					return
				end

				tab.Items = {}

				pluto.inv.invs[ply][tab.RowID] = tab
				pluto.inv.message(ply)
					:write("tab", tab)
					:send()

			end, true)

			trans:addQuery(pluto.inv.addcurrency(ply, "coin", -1, function() end, true))
			trans:start()
		end,
	}
} do
	table.Merge(pluto.currency.byname[name], values)
end

for _, item in pairs(pluto.currency.list) do
	pluto.currency.shares = pluto.currency.shares + item.Shares
	resource.AddFile("materials/" .. item.Icon)
end

function pluto.currency.random(n)
	if (not n) then
		n = math.random()
	end

	n = n * pluto.currency.shares

	for _, item in ipairs(pluto.currency.list) do
		n = n - item.Shares
		if (n <= 0) then
			return item
		end
	end
end

pluto.currency.navs = {
	total = 0,
}

function pluto.currency.randompos()
	if (pluto.currency.navs.total == 0) then
		for _, nav in pairs(navmesh.GetAllNavAreas()) do
			local dist = nav:GetCorner(2):Distance(nav:GetCorner(0))
	
			table.insert(pluto.currency.navs, {
				Size = dist,
				Nav = nav
			})
	
			pluto.currency.navs.total = pluto.currency.navs.total + dist
		end
	end

	local rand = math.random() * pluto.currency.navs.total
	local initial = rand

	for _, item in ipairs(pluto.currency.navs) do
		rand = rand - item.Size
		if (rand <= 0) then
			return item.Nav:GetRandomPoint()
		end
	end


	pwarnf("Initial rand: %.5f, rand end: %.5f, total: %.5f", initial, rand, pluto.currency.navs.total)
end

function pluto.currency.spawnfor(ply, currency, pos)
	local e = ents.Create "pluto_currency"

	if (not pos) then
		for i = 1, 100 do
			pos = pluto.currency.randompos()
			local mins, maxs = ply:GetHull()
			if (not util.TraceHull {
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
				collisiongroup = COLLISION_GROUP_PLAYER,
				mask = MASK_PLAYERSOLID,
			}.StartSolid) then
				break
			end
		end
	end

	if (not currency) then
		currency = pluto.currency.random()
	else
		currency = pluto.currency.byname[currency]
	end

	e:SetPos(pos + 20 * vector_up)
	e:SetOwner(ply)
	e:SetCurrency(currency)
	e:Spawn()

	return e
end

pluto.currency.tospawn = pluto.currency.tospawn or {}
pluto.currency.spawned = pluto.currency.spawned or {}

function pluto.currency.addpoints(ply, points)
	pluto.currency.tospawn[ply] = (pluto.currency.tospawn[ply] or 1) + points
end

hook.Add("DoPlayerDeath", function(vic, damager, dmg)
	local atk = dmg:GetAttacker()

	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	local points = 1

	if (atk:GetTeam() == vic:GetTeam()) then
		-- base on karma
		points = -vic:GetKarma() / atk:GetKarma()
	end

	pluto.currency.addpoints(atk, points)
end)

local tospawn_amt = 3.4

local start = CurTime()
local old_data

hook.Add("TTTBeginRound", "pluto_currency", function()
	start = CurTime()
	for _, item in pairs(round.GetStartingPlayers()) do
		if (item.Player.WasAFK or item.Player:GetRoleTeam() ~= "innocent") then
			continue
		end

		local points = (pluto.currency.tospawn[item.Player] or 1) * tospawn_amt

		for i = 1, points do
			local e = pluto.currency.spawnfor(item.Player)
			pluto.currency.spawned[e] = item.Player
		end

		if (points >= 0) then
			pluto.currency.tospawn[item.Player] = 1 + points - math.floor(points)
		end
	end
	old_data = table.Copy(pluto.currency.tospawn)
end)

hook.Add("TTTEndRound", "pluto_currency", function()
	if (CurTime() - start <= 60 and player.GetCount() <= 5) then
		pluto.currency.tospawn = old_data
	end
end)

hook.Add("TTTAddPermanentEntities", "pluto_currency", function()
	for ent, ply in pairs(pluto.currency.spawned) do
		if (IsValid(ent) and IsValid(ply)) then
			pluto.currency.tospawn[ply] = pluto.currency.tospawn[ply] + 1 / tospawn_amt / 2
		end
	end
end)

concommand.Add("pluto_spawn_cur", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local pos = ply:GetEyeTrace().HitPos

	pluto.currency.spawnfor(ply, args[1] or "droplet", pos)
end)
