pluto.currency.shares = 0

local global_multiplier = 2

local currency_per_round = 3

local pluto_currency_spawnrate = CreateConVar("pluto_currency_spawnrate", "0.9")

local function UpdateAndDecrement(ply, item, currency)
	local transact = pluto.db.transact()
	pluto.weapons.update(item, function(id)
		if (not IsValid(ply)) then
			return
		end

		if (not id) then
			ply:ChatPrint("Error modifying gun!")
		end
	end, transact)

	pluto.inv.message(ply)
		:write("item", item)
		:send()

	pluto.inv.addcurrency(ply, currency, -1, nil, transact)

	transact:Run()
end

local crate1_fill = 750 / (5 + 6 + 9)

local function process_percents(contents)
	local shares = 0
	for k, n in pairs(contents) do
		shares = shares + (istable(n) and n.Shares or n)
	end

	for k, n in pairs(contents) do
		pprintf("%.02f%% - %s", ((istable(n) and n.Shares or n) / shares) * 100, k)
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
	},
	tome = {
		Shares = 20,
		Use = function(ply, item)
			local outcomes = {
				add1mod = {
					Type = "good",
					Shares = 2,
					Use = function(item)
						pluto.weapons.generatemod(item, 6, 3, true)
					end
				},
				add2mod = {
					Type = "good",
					Shares = 1,
					Use = function(item)
						pluto.weapons.generatemod(item, 6, 3, true)
						pluto.weapons.generatemod(item, 6, 3, true)
					end
				},
				nothing = {
					Type = "normal",
					Shares = 2,
					Use = function() end,
				},
				classreroll = {
					Type = "critical",
					Shares = 2,
					Use = function(item)
						item.ClassName = pluto.weapons.randomoftype(pluto.weapons.type(baseclass.Get(item.ClassName)))
					end
				},
				tierreroll = {
					Type = "critical",
					Shares = 2,
					Use = function(item)
						local newitem = pluto.weapons.generatetier(nil, item.ClassName)
						item.Tier = newitem.Tier
						item.Mods = newitem.Mods
					end
				},
				modreroll = {
					Type = "critical",
					Shares = 2,
					Use = function(item)
						local new_mods = pluto.weapons.generatetier(item.Tier.InternalName, item.ClassName).Mods
		
						item.Mods.prefix = new_mods.prefix
						item.Mods.suffix = new_mods.suffix
		
						for _, mods in pairs(new_mods) do
							for _, mod in pairs(mods) do
								pluto.weapons.onrollmod(item, mod)
							end
						end
					end
				}

			}
			if (item:GetMod "tomed") then
				for k,v in pairs(outcomes) do
					if (v.Type == "good") then
						v.Shares = v.Shares * 3
					end
				end

				outcomes.modreroll.Shares = outcomes.modreroll.Shares / 2
				outcomes.implicit = {
					Shares = 2,
					Use = function(item)
						local notallowed = {}
						for k, v in pairs(item.Mods.implicit or {}) do
							notallowed[v.Mod] = true
						end

						local mod = table.shuffle(pluto.mods.getfor(baseclass.Get(item.ClassName), function(mod)
							return mod.Type == "implicit" and not mod.PreventChange and not notallowed[mod.InternalName]
						end))[1]

						if (mod) then
							pluto.weapons.addmod(item, mod.InternalName)
						end
					end
				}
			end
			
			for i = 1, 1 do
				local outcome = outcomes[pluto.inv.roll(outcomes)]

				
				outcome.Use(item)
			end

			if (not item:GetMod "tomed" or math.random() < 0.25) then
				pluto.weapons.addmod(item, "unchanging")
			else
				pluto.weapons.addmod(item, "arcane")
			end

			UpdateAndDecrement(ply, item, "tome")
		end,
		Types = "Weapon",
	},
	mirror = {
		Shares = 0.01,
		Use = function(ply, item)
			local new_item = item:Duplicate()
			pluto.weapons.addmod(new_item, "mirror")

			local transact = pluto.db.transact()

			pluto.inv.savebufferitem(ply, new_item, transact)

			pluto.inv.addcurrency(ply, "mirror", -1, nil, transact)

			transact:Run()
		end,
		Types = "Weapon",
	},
	heart = {
		Shares = 8.5,
		Use = function(ply, item)
			if (pluto.weapons.generatemod(item)) then
				UpdateAndDecrement(ply, item, "heart")
			end
		end,
		Types = "Weapon",
	},
	coin = {
		Shares = 0.3,
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
			end)

			pluto.inv.addcurrency(ply, "coin", -1, function() end, trans)

			trans:Run()
		end,
		Types = "None",
	},
	crate0 = {
		Shares = 39,
		Contents = {
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
			model_a2lh = {
				Rare = true,
				Shares = 15,
			},
			model_a2 = {
				Rare = true,
				Shares = 15,
			},
			model_wick2 = {
				Rare = true,
				Shares = 3,
			},
			weapon_ttt_ak47_u = {
				Rare = true,
				Tier = "unique",
				Shares = 0.5,
			},
			weapon_ttt_deagle_u = {
				Rare = true,
				Tier = "unique",
				Shares = 0.5,
			},
		},
		Types = "None",
	},
	crate1 = {
		Shares = 0,
		Contents = {
			model_osrsbob = 50,
			model_puggamax = 40,
			model_warmor = 100,
			model_nigt1 = 100,
			model_nigt2 = 100,

			model_metro_female_5 = crate1_fill,
			model_metro_female_4 = crate1_fill,
			model_metro_female_3 = crate1_fill,
			model_metro_female_2 = crate1_fill,
			model_metro_female_1 = crate1_fill,

			model_metro6 = crate1_fill,
			model_metro5 = crate1_fill,
			model_metro4 = crate1_fill,
			model_metro3 = crate1_fill,
			model_metro2 = crate1_fill,
			model_metro1 = crate1_fill,

			model_metro_male_9 = crate1_fill,
			model_metro_male_8 = crate1_fill,
			model_metro_male_7 = crate1_fill,
			model_metro_male_6 = crate1_fill,
			model_metro_male_5 = crate1_fill,
			model_metro_male_4 = crate1_fill,
			model_metro_male_3 = crate1_fill,
			model_metro_male_2 = crate1_fill,
			model_metro_male_1 = crate1_fill,

			model_cayde6 = {
				Rare = true,
				Shares = 20,
			},
			model_hansolo = {
				Rare = true,
				Shares = 30,
			},
			model_tomb = {
				Rare = true,
				Shares = 20,
			},
			model_zerosamus = {
				Rare = true,
				Shares = 2,
			},
			model_weebshit = {
				Rare = true,
				Shares = 1,
			},
			model_santa = {
				Rare = true,
				Shares = 5,
			},
		},
		Types = "None",
	},
	crate2 = {
		Shares = 19,
		Contents = {
			weapon_ttt_chargeup = {
				Rare = true,
				Shares = 1,
			},
			weapon_tfa_cso2_m3dragon = {
				Rare = true,
				Shares = 1
			},

			model_ciri = {
				Rare = true,
				Shares = 4
			},
			model_spacesuit = {
				Rare = true,
				Shares = 4
			},
			model_zer0 = {
				Rare = true,
				Shares = 4
			},
			model_deadpool = {
				Rare = true,
				Shares = 4,
			},

			model_tachanka = {
				Rare = true,
				Shares = 12,
			},
			model_noob_saibo = {
				Rare = true,
				Shares = 12,
			},
			model_raincoat = {
				Rare = true,
				Shares = 12,
			},
			model_psycho = {
				Rare = true,
				Shares = 12,
			},

			model_tron_anon = 30,

			model_wolffe = 50,
			model_bomb_squad = 50,
			model_lieutenant = 50,
			model_clone = 50,
			model_commander = 50,
			model_general = 50,
			model_sergeant = 50,
			model_captain = 50,
			model_brown_spar = 30,
			model_white_spar = 30,
			model_teal_spart = 30,
			model_red_sparta = 30,
			model_purple_spa = 30,
			model_olive_spar = 30,
			model_cyan_spart = 30,
			model_cobalt_spa = 30,
			model_crimson_sp = 30,
			model_sage_spart = 30,
			model_master_chi = 30,
			model_blue_spart = 30,
			model_tan_sparta = 30,
			model_steel_spar = 30,
			model_orange_spa = 30,
			model_green_spar = 30,
			model_pink_spart = 30,
			model_gold_spart = 30,
			model_violet_spa = 30,
		},
		Types = "None",
	},
	aciddrop = {
		Shares = 30,
		Use = function(ply, item)
			local affixes = item:GetMaxAffixes()

			local new_mods = pluto.weapons.generatetier(item.Tier, item.ClassName, nil, nil, function(mod, tier)
				local needed = #mod.Tiers[tier] / 2

				local retn = {}
				for i = 1, needed do
					retn[i] = math.random() * 2 / 3
				end

				return retn
			end, 3, math.min(3, affixes - #(item.Mods.suffix or {})), 0).Mods

			item.Mods.prefix = new_mods.prefix

			for _, mods in pairs(new_mods) do
				for _, mod in pairs(mods) do
					pluto.weapons.onrollmod(item, mod)
				end
			end

			UpdateAndDecrement(ply, item, "aciddrop")
		end,
		Types = "Weapon",
	},
	pdrop = {
		Shares = 20,
		Use = function(ply, item)
			local affixes = item:GetMaxAffixes()

			local new_mods = pluto.weapons.generatetier(item.Tier, item.ClassName, nil, nil, function(mod, tier)
				local needed = #mod.Tiers[tier] / 2

				local retn = {}
				for i = 1, needed do
					retn[i] = math.random() * 2 / 3
				end

				return retn
			end, 3, 0, math.min(3, affixes - #(item.Mods.prefix or {}))).Mods

			item.Mods.suffix = new_mods.suffix

			for _, mods in pairs(new_mods) do
				for _, mod in pairs(mods) do
					pluto.weapons.onrollmod(item, mod)
				end
			end

			UpdateAndDecrement(ply, item, "pdrop")
		end,
		Types = "Weapon",
	},
	quill = {
		Shares = 0.3,
		Use = function(ply, item)
		end,
		Types = "Weapon",
	},
	tp = {
		Shares = 4.8,
	}
} do
	table.Merge(pluto.currency.byname[name], values)
end

process_percents(pluto.currency.byname.crate0.Contents)

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

	if (currency.Shares and currency.Shares <= pluto.currency.byname.heart.Shares) then
		ply:ChatPrint(currency.Color, "... ", white_text, "You feel the essence of a ", currency.Color, "rare currency ", white_text, "vibrate your soul")
	end

	pluto.currency.spawned[e] = ply

	return e
end

pluto.currency.tospawn = pluto.currency.tospawn or {}
pluto.currency.spawned = pluto.currency.spawned or {}

hook.Add("DoPlayerDeath", "pluto_currency_add", function(vic, damager, dmg)
	local atk = dmg:GetAttacker()

	if (ttt.GetRoundState() ~= ttt.ROUNDSTATE_ACTIVE) then
		return
	end

	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	local points = 1

	if (atk:GetRoleTeam() == vic:GetRoleTeam()) then
		-- base on karma
		points = -vic:GetKarma() / atk:GetKarma()
	elseif (atk:GetRoleData().IsEvil) then
		points = points * 0.8
	end

	local gun = dmg:GetInflictor()

	if (gun.RunModFunctionSequence) then
		local state = {
			Points = points
		}
		gun:RunModFunctionSequence("UpdateSpawnPoints", state, atk, vic)
		points = state.Points
	end

	pluto.currency.givespawns(atk, points)
end)

function pluto.currency.givespawns(ply, amt)
	pluto.currency.tospawn[ply] = (pluto.currency.tospawn[ply] or currency_per_round) + amt * pluto_currency_spawnrate:GetFloat() * math.min(2, pluto.currency.navs.total / 70000 * 1.3) * global_multiplier
end

function pluto.inv.readrename(cl)
	local id = net.ReadUInt(32)
	local name = net.ReadString()

	local gun = pluto.itemids[id]

	local sid = pluto.db.steamid64(cl)

	if (not gun or gun.Owner ~= sid) then
		pluto.inv.sendfullupdate(cl)
		return
	end

	gun.LastUpdate = (gun.LastUpdate or 0) + 1
	gun.Nickname = name

	pluto.inv.message(cl)
		:write("item", gun)
		:send()
	
	local transact = pluto.db.transact()

	transact:AddQuery("UPDATE pluto_items set nick = ? WHERE idx = ?", {name, id}, function(err, q)
		if (err) then
			pluto.inv.sendfullupdate(cl)
			return
		end
	end)

	pluto.inv.addcurrency(cl, "quill", -1, nil, transact)

	transact:Run()
end


hook.Add("TTTBeginRound", "pluto_currency", function()
	pluto.currency.navs.start()

	for _, item in pairs(round.GetStartingPlayers()) do
		if (item.Player.WasAFK or item.Player:GetRoleTeam() ~= "innocent") then
			continue
		end

		local points = pluto.currency.tospawn[item.Player] or currency_per_round

		for i = 1, math.floor(points) do
			local e = pluto.currency.spawnfor(item.Player)
		end

		pluto.currency.tospawn[item.Player] = currency_per_round + points - math.floor(points)
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
