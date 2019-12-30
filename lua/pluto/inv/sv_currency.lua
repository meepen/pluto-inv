pluto.currency.shares = 0

local tospawn_amt = CreateConVar("pluto_currency_spawnrate", "2.7")

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

local crate0_contents = {
	model_jacket = 400,
	model_sauron = 200,
	model_odst = 100,
	model_helga = 100,
	model_wonderw = 100,
	model_plague = 70,
	model_bigboss = 70,
	model_daedric = 40,
	model_chewie = 30,
	model_lilith = 25,
	model_a2lh = 15,
	model_a2 = 15,
	model_wick2 = 3,
	weapon_ttt_ak47_u = 0.5,
	weapon_ttt_deagle_u = 0.5,
}

local fill = 750 / (5 + 6 + 9)
local crate1_contents = {
	model_osrsbob = 50,
	model_puggamax = 40,
	model_santa = 5,
	model_weebshit = 1,
	model_tomb = 20,
	model_warmor = 100,
	model_cayde6 = 20,
	model_nigt1 = 100,
	model_nigt2 = 100,

	model_metro_female_5 = fill,
	model_metro_female_4 = fill,
	model_metro_female_3 = fill,
	model_metro_female_2 = fill,
	model_metro_female_1 = fill,

	model_metro6 = fill,
	model_metro5 = fill,
	model_metro4 = fill,
	model_metro3 = fill,
	model_metro2 = fill,
	model_metro1 = fill,

	model_metro_male_9 = fill,
	model_metro_male_8 = fill,
	model_metro_male_7 = fill,
	model_metro_male_6 = fill,
	model_metro_male_5 = fill,
	model_metro_male_4 = fill,
	model_metro_male_3 = fill,
	model_metro_male_2 = fill,
	model_metro_male_1 = fill,

	model_hansolo = 30,
	model_zerosamus = 2,
}

local function process_percents(contents)
	local shares = 0
	for k, n in pairs(contents) do
		shares = shares + n
	end

	for k, n in SortedPairsByValue(contents) do
		pprintf("%.02f%% - %s", (n / shares) * 100, k)
	end
end

process_percents(crate1_contents)

local function rollcrate(crate)
	local m = math.random()

	local total = 0
	for _, v in pairs(crate) do
		total = total + v
	end

	m = m * total

	for itemname, val in pairs(crate) do
		m = m - val
		if (m <= 0) then
			return itemname, val / total
		end
	end
end

for name, values in pairs {
	dice = {
		Shares = 500,
		Use = function(ply, item)
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
		Types = "Weapon",
		Crafted = {
			Chance = 1 / 3,
			Mod = "diced",
		},
	},
	droplet = {
		Shares = 3000,
		Use = function(ply, item)
			local affixes = item:GetMaxAffixes()

			if (affixes >= 4 and not item:GetMod "dropletted") then
				affixes = affixes - 1
			end

			local new_mods = pluto.weapons.generatetier(item.Tier, item.ClassName, nil, nil, function(mod, tier)
				local needed = #mod.Tiers[tier] / 2

				local retn = {}
				for i = 1, needed do
					retn[i] = math.random() * 2 / 3
				end

				return retn
			end, affixes).Mods

			item.Mods.prefix = new_mods.prefix
			item.Mods.suffix = new_mods.suffix

			for _, mods in pairs(new_mods) do
				for _, mod in pairs(mods) do
					pluto.weapons.onrollmod(item, mod)
				end
			end

			UpdateAndDecrement(ply, item, "droplet")
		end,
		Types = "Weapon",
		Crafted = {
			Chance = 1 / 3,
			Mod = "dropletted",
		},
	},
	hand = {
		Shares = 400,
		Use = function(ply, item)
			local possible = {}
			local incr_possible = {}
			for typ, Mods in pairs(item.Mods) do
				if (typ == "implicit") then
					continue
				end

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
		Types = "Weapon",
		Crafted = {
			Chance = 1 / 3,
			Mod = "handed",
		},
	},
	tome = {
		Shares = 20,
		Use = function(ply, item)
			local rand = math.floor(math.random(1, 12) / 2) + 1
			if (rand == 1) then     -- 2 mods
				pluto.weapons.generatemod(item, 5, 3, true)
				pluto.weapons.generatemod(item, 5, 3, true)
			elseif (rand == 2) then -- 1 mod
				pluto.weapons.generatemod(item, 5, 3, true)
			elseif (rand == 3) then -- nothing
			elseif (rand == 4) then -- base gun change
				item.ClassName = pluto.weapons.randomgun()
			elseif (rand == 5) then -- tier change
				local newitem = pluto.weapons.generatetier(nil, item.ClassName)
				item.Tier = newitem.Tier
				item.Mods = newitem.Mods
			elseif (rand == 6) then -- reroll
				local new_mods = pluto.weapons.generatetier(item.Tier.InternalName, item.ClassName).Mods

				item.Mods.prefix = new_mods.prefix
				item.Mods.suffix = new_mods.suffix

				for _, mods in pairs(new_mods) do
					for _, mod in pairs(mods) do
						pluto.weapons.onrollmod(item, mod)
					end
				end
			else
				return
			end

			item.Mods.implicit = item.Mods.implicit or {}

			pluto.weapons.addmod(item, "unchanging")

			UpdateAndDecrement(ply, item, "tome")
		end,
		Types = "Weapon",
		Crafted = {
			Chance = 0,
			Mod = "tomeded",
		},
	},
	mirror = {
		Shares = 0.1,
		Use = function(item)
		end,
		Types = "Weapon",
		Crafted = {
			Chance = 0,
			Mod = "mirrorered",
		},
	},
	heart = {
		Shares = 8.5,
		Use = function(ply, item)
			if (pluto.weapons.generatemod(item)) then
				UpdateAndDecrement(ply, item, "heart")
			end
		end,
		Types = "Weapon",
		Crafted = {
			Chance = 0.95,
			Mod = "hearted",
		},
	},
	coin = {
		Shares = 0.7,
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
		Types = "None",
		Crafted = {
			Chance = 0.5,
			Mod = "coined",
		},
	},
	crate0 = {
		Shares = 39,
		Use = function(ply)
			local gotten = rollcrate(crate0_contents)
			local type = pluto.inv.itemtype(gotten)

			if (type == "Model") then -- model
				local id = pluto.inv.generatebuffermodel(ply, gotten:match "^model_(.+)$")

				pluto.inv.message(ply)
					:write("crate_id", id)
					:send()
			elseif (type == "Weapon") then -- unique
				local id = pluto.inv.generatebufferweapon(ply, "unique", gotten)

				pluto.inv.message(ply)
					:write("crate_id", id)
					:send()
			end

			pluto.inv.addcurrency(ply, "crate0", -1, function() end)
		end,
		Types = "None",
		Crafted = {
			Chance = 0,
			Mod = "crated",
		},
	},
	crate1 = {
		Shares = 90,
		Use = function(ply)
			local gotten = rollcrate(crate1_contents)
			local type = pluto.inv.itemtype(gotten)

			if (type == "Model") then -- model
				local id = pluto.inv.generatebuffermodel(ply, gotten:match "^model_(.+)$")

				pluto.inv.message(ply)
					:write("crate_id", id)
					:send()
			elseif (type == "Weapon") then -- unique
				local id = pluto.inv.generatebufferweapon(ply, "unique", gotten)

				pluto.inv.message(ply)
					:write("crate_id", id)
					:send()
			end

			pluto.inv.addcurrency(ply, "crate1", -1, function() end)
		end,
		Types = "None",
		Crafted = {
			Chance = 0,
			Mod = "crated",
		},
	},
} do
	table.Merge(pluto.currency.byname[name], values)
end

for _, item in pairs(pluto.currency.list) do
	pluto.currency.shares = pluto.currency.shares + item.Shares
	resource.AddFile("materials/" .. item.Icon)
end

function pluto.ghost_killed(e, dmg)
	local atk = dmg:GetAttacker()
	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	pluto.currency.spawnfor(atk, "tome", atk:GetPos())

	admin.chatf(white_text, "A ", ttt.teams.traitor.Color, "ghost ", white_text, "has been vanquished.")

	for _, ply in pairs(player.GetAll()) do
		pluto.currency.spawnfor(ply, "tome")
	end

	return true
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
	start = function()
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
	end
}

function pluto.currency.randompos()
	pluto.currency.navs.start()
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

hook.Add("DoPlayerDeath", "pluto_currency_add", function(vic, damager, dmg)
	local atk = dmg:GetAttacker()

	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	local points = 0.3

	if (atk:GetRoleTeam() == vic:GetRoleTeam()) then
		-- base on karma
		--points = -vic:GetKarma() / atk:GetKarma()
	end

	pluto.currency.givespawns(atk, points)
end)

function pluto.currency.givespawns(ply, amt)
	pluto.currency.tospawn[ply] = (pluto.currency.tospawn[ply] or 0) + amt
end


hook.Add("TTTBeginRound", "pluto_currency", function()
	pluto.currency.navs.start()

	for _, item in pairs(round.GetStartingPlayers()) do
		if (item.Player.WasAFK or item.Player:GetRoleTeam() ~= "innocent") then
			continue
		end

		local points = (pluto.currency.tospawn[item.Player] or 1) * tospawn_amt:GetFloat() * pluto.currency.navs.total / 70000

		for i = 1, points do
			local e = pluto.currency.spawnfor(item.Player)
			pluto.currency.spawned[e] = item.Player
		end

		if (points >= 0) then
			pluto.currency.tospawn[item.Player] = 1 + points - math.floor(points)
		end
	end

	-- ghosts
	if (false and math.random(10) == 1) then
		admin.chatf(white_text, "A horde of ", ttt.teams.traitor.Color, "spirits ", white_text, "have entered this realm.")
		local ghosts = {}
		for i = 1, 5 do
			ghosts[i] = ents.Create "pluto_ghost"
			ghosts[i]:SetPos(pluto.currency.randompos())
			ghosts[i]:Spawn()
		end
		timer.Simple(60, function()
			for _, ghost in pairs(ghosts) do
				if (IsValid(ghost)) then
					ghost:Remove()
				end
			end

			admin.chatf(white_text, "The remaining ", ttt.teams.traitor.Color, "spirits ", white_text, "have left this realm.")
		end)
	end
end)

concommand.Add("pluto_spawn_cur", function(ply, cmd, args)
	if (not pluto.cancheat(ply)) then
		return
	end

	local pos = ply:GetEyeTrace().HitPos

	pluto.currency.spawnfor(ply, args[1] or "droplet", pos)
end)
