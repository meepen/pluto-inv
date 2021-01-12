pluto.currency.shares = 0

local global_multiplier = 2

local currency_per_round = 3

local pluto_currency_spawnrate = CreateConVar("pluto_currency_spawnrate", "0.9")

local function UpdateAndDecrement(ply, item, currency)
	pluto.db.transact(function(db)
		pluto.weapons.update(db, item)
		if (pluto.inv.addcurrency(db, ply, currency, -1)) then
			mysql_commit(db)
		else
			mysql_rollback(db)
		end
	end)

	pluto.inv.message(ply)
		:write("item", item)
		:send()

end

local crate1_fill = 750 / (5 + 6 + 9)
local xmas2020_fill = 200 / (11)

function pluto.inv.percents(contents)
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
		Shares = 1500,
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
						if (item:GetModCount() < item:GetMaxAffixes() + 2) then
							pluto.weapons.generatemod(item, 6, 3, true)
						end
					end
				},
				add2mod = {
					Type = "good",
					Shares = 1,
					Use = function(item)
						for i = 1, 2 do
							if (item:GetModCount() < item:GetMaxAffixes() + 2) then
								pluto.weapons.generatemod(item, 6, 3, true)
							end
						end
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

			if (item.Tier.InternalName == "easter_unique") then
				outcomes.classreroll.Shares = 0
			end

			local was_tomed = item:GetMod "tomed"
			if (was_tomed) then
				for k,v in pairs(outcomes) do
					if (v.Type == "good") then
						v.Shares = v.Shares * 3
					end
				end

				outcomes.modreroll.Shares = outcomes.modreroll.Shares / 2
				outcomes.nothing.Shares = 0

				outcomes.implicit = {
					Shares = 2,
					Use = function(item)
						local implicits = item:GetModCount(true) - item:GetModCount(false)

						if (implicits > 5) then -- 3 max, already has 2 from tomed and touch of arcane
							return
						end

						local notallowed = {}
						for k, v in pairs(item.Mods.implicit or {}) do
							notallowed[v.Mod] = true
						end

						local mod = table.shuffle(pluto.mods.getfor(baseclass.Get(item.ClassName), function(mod)
							return mod.Type == "implicit" and mod.Tomeable and not notallowed[mod.InternalName]
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

			if (was_tomed) then -- some outcomes can remove tomed
				pluto.weapons.addmod(item, "tomed")
				pluto.weapons.addmod(item, "arcane")
			end

			if (not item:GetMod "tomed" or math.random() < 0.125) then
				pluto.weapons.addmod(item, "unchanging")
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

			pluto.db.transact(function(db)
				if (not pluto.inv.addcurrency(db, ply, "mirror", -1)) then
					mysql_rollback(db)
					return
				end

				new_item.CreationMethod = "MIRROR"
				pluto.inv.savebufferitem(db, ply, new_item)

				mysql_commit(db)
			end)
		end,
		Types = "Weapon",
	},
	heart = {
		Shares = 7.5,
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
			pluto.db.transact(function(db)
				if (not pluto.inv.addcurrency(db, ply, "coin", -1)) then
					mysql_rollback(db)
					return
				end

				local tab = pluto.inv.addtabs(db, ply, {"normal"})[1]

				mysql_commit(db)
				tab.Items = {}
				pluto.inv.invs[ply][tab.RowID] = tab

				pluto.inv.message(ply)
					:write("tab", tab)
					:send()
			end)
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
	xmas2020 = {
		Shares = 30,
		Contents = {
			tfa_cso_m1887xmas = {
				Shares = 0.2,
				Tier = "unique",
				Rare = true,
			},
			model_tfacso2natalie01 = {
				Shares = 1,
				Rare = true
			},
			model_kleiaorgana = {
				Shares = 1,
				Rare = true
			},
			model_xmas_imp = {
				Shares = 1,
				Rare = true
			},
			model_ghilliewinter01 = {
				Shares = 1,
				Rare = true
			},
			model_xmas_spiderman = {
				Shares = 1,
				Rare = true
			},
			tfa_cso_m95_xmas = {
				Tier = "festive",
				Shares = 20,
			},

			model_elftrooper = xmas2020_fill,
			model_santatrooper = xmas2020_fill,
			model_treetrooper = xmas2020_fill,
			model_snowmantrooper = xmas2020_fill,
			model_hannukahtrooper = xmas2020_fill,
			model_reindeertrooper = xmas2020_fill,
			model_snow7 = xmas2020_fill,
			model_snow6 = xmas2020_fill,
			model_snow5 = xmas2020_fill,
			model_snow4 = xmas2020_fill,
			model_snow3 = xmas2020_fill,
			model_snow2 = xmas2020_fill,
			model_snow1 = xmas2020_fill,
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
		Shares = 0.2,
		Use = function(ply, item)
		end,
		Types = "Weapon",
	},
	tp = {
		Shares = 1,
	},
	crate3 = {
		Shares = 0,
		Types = "None",
		DefaultTier = "easter_unique",
		Contents = {
			tfa_cso_serpent_blade = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_dreadnova = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_ruyi = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_mp7unicorn = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_pchan = {
				Rare = true,
				Shares = 1
			}
		},

		Pickup = function(ply)
			if (player.GetCount() >= 8) then
				pluto.rounds.prepare "posteaster"
			end

			return true
		end
	},
	crate3_n = {
		Shares = 0,
		Types = "None",
		Contents = {
			-- consumed versions
			tfa_cso_serpent_blade = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_dreadnova = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_ruyi = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_mp7unicorn = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_pchan = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_ethereal = {
				Rare = true,
				Shares = 0--.1,
			},

			tfa_cso_m82 = {
				Tier = "unusual",
				Shares = 150
			},

			tfa_cso_charger5 = {
				Tier = "unusual",
				Shares = 150,
			},
			tfa_cso_m95 = {
				Tier = "unusual",
				Shares = 150,
			},
			tfa_cso_darkknight_v6 = {
				Rare = true,
				Tier = "easter_unique",
				Shares = 0.1,
			},
		},
	},
	_lightsaber = {
		Shares = 0,
		Global = true,
		Pickup = function(ply)
			local found = false
			for _, wep in pairs(ply:GetWeapons()) do
				if (wep.Slot == 0 and not rb655_IsLightsaber(wep)) then
					found = true
					wep:Remove()
				end
			end

			if (not found) then
				return false
			end

			timer.Simple(1, function()
				if (IsValid(ply) and ply:Alive()) then
					pluto.NextWeaponSpawn = false
					ply:Give "weapon_rb566_lightsaber"
				end
			end)

			return true
		end,
	},
	eye = {
		Shares = 0,
	},
	_banna = {
		Shares = 0,
		Global = true,
		Pickup = function(ply)
			if (ttt.GetCurrentRoundEvent() == "chimp" and ttt.GetRoundState() == ttt.ROUNDSTATE_ACTIVE) then
				hook.Run("PlutoBannaPickup", ply)
			elseif (ttt.GetCurrentRoundEvent() ~= "chimp") then
				if (player.GetCount() >= 6) then
					pluto.rounds.prepare "chimp"
				end

				pluto.db.instance(function(db)
					pluto.inv.addcurrency(db, ply, "brainegg", 1)
					ply:ChatPrint(white_text, "You have received 1 ", pluto.currency.byname.brainegg, white_text, " for finding a banna!")
				end)
			end

			return true
		end,
	},
	brainegg = {
		Shares = 0,
		Types = "None",
		Contents = {
			--model_ghostface = 1,
			tfa_cso_tbarrel = {
				Rare = true,
				Shares = 0.5,
			},
			tfa_cso_tomahawk = {
				Rare = true,
				Shares = 0.6,
			},
			tfa_cso_thanatos9 = {
				Rare = true,
				Shares = 0.7,
			},

			model_jason_unmask = {
				Rare = true,
				Shares = 1,
			},
			model_joker_2019 = {
				Rare = true,
				Shares = 1,
			},
			model_terminator = {
				Rare = true,
				Shares = 2,
			},

			model_richtofen        = {
				Rare = true,
				Shares = 5,
			},
			model_dempsey          = {
				Rare = true,
				Shares = 5,
			},
			model_nikolai          = {
				Rare = true,
				Shares = 5,
			},
			model_takeo            = {
				Rare = true,
				Shares = 5,
			},
			model_ghostfacereddevi = {
				Rare = true,
				Shares = 5,
			},

			model_darkwraith       = 6,
			model_jason            = 7,
			model_husk             = 7,
			model_scarecrow        = 8,
			model_ghostfacetheghos = 9,
			model_death            = 11,

			model_ghostfaceclassic = 12,
			model_blackmask        = 14,
			model_death_paint      = 15,
			model_ghost_rider      = 16,
			model_death_class      = 17,

			--[[
			model_markus_1 = 1,
			model_markus_3 = 1,
			model_markus_2 = 1,
			model_detr_connor = 1,]]
		},
	},
	stardust = {
		Shares = 1500,
	},
	_toy_blue = {
		Shares = 0,
		Global = true,
		Pickup = function(ply, cur)
			hook.Run("PlutoToyPickup", ply, "blue", cur)
			if (ttt.GetCurrentRoundEvent() ~= "cheer" and player.GetCount() >= 6) then
				pluto.rounds.prepare "cheer"
			end
			return true
		end,
	},
	_toy_green = {
		Shares = 0,
		Global = true,
		Pickup = function(ply, cur)
			hook.Run("PlutoToyPickup", ply, "green", cur)
			if (ttt.GetCurrentRoundEvent() ~= "cheer" and player.GetCount() >= 6) then
				pluto.rounds.prepare "cheer"
			end
			return true
		end,
	},
	_toy_red = {
		Shares = 0,
		Global = true,
		Pickup = function(ply, cur)
			hook.Run("PlutoToyPickup", ply, "red", cur)
			if (ttt.GetCurrentRoundEvent() ~= "cheer" and player.GetCount() >= 6) then
				pluto.rounds.prepare "cheer"
			end
			return true
		end,
	},
	_toy_yellow = {
		Shares = 0,
		Global = true,
		Pickup = function(ply, cur)
			hook.Run("PlutoToyPickup", ply, "yellow", cur)
			if (ttt.GetCurrentRoundEvent() ~= "cheer" and player.GetCount() >= 6) then
				pluto.rounds.prepare "cheer"
			end

			return true
		end
	},
	_shootingstar = {
		Shares = 0,
		Global = true,
		Pickup = function(ply, self)
			if (ply:Alive()) then
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_BURN)
				dmg:SetDamage(math.random(3, 5))
				ply:TakeDamageInfo(dmg)
			end

			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, "stardust", 1)
				ply:ChatPrint(white_text, "You got a ", pluto.currency.byname.stardust, white_text, " but ouch, that burns!")
			end)

			return true
		end,
	},
	_chancedice = {
		Shares = 0,
		Global = true,
		Pickup = function(ply, self)
			if (not ply:Alive()) then
				return true
			end

			local chances = {
				function()
					ply:SetMaxHealth(ply:GetMaxHealth() + 10)
					ply:SetHealth(ply:Health() + 10)
					ply:ChatPrint(white_text, "You gained max health!!")
				end,
				function()
					ply:SetJumpPower(ply:GetJumpPower() + 20)
					ply:ChatPrint(white_text, "You gained jump power!")
				end,
				function()
					ply:SetMaxArmor(ply:GetMaxArmor() + 10)
					ply:SetArmor(ply:Armor() + 10)
					ply:ChatPrint(white_text, "You gained 10 armor!!")
				end,
				function()
					pluto.db.instance(function(db)
						pluto.inv.addcurrency(db, ply, "dice", 10)
						ply:ChatPrint(white_text, "You got an additional 10 ", pluto.currency.byname.dice, white_text, "!")
					end)
				end,
				function()
					if (pluto.rounds and pluto.rounds.speeds) then
						pluto.rounds.speeds[ply] = (pluto.rounds.speeds[ply] or 1) + 0.1
						net.Start "mini_speed"
							net.WriteFloat(pluto.rounds.speeds[ply])
						net.Send(ply)
						ply:ChatPrint(white_text, "You gained speed!")
					end
				end,
				function()
					local dmg = DamageInfo()
					dmg:SetDamageType(DMG_BURN)
					dmg:SetDamage(math.random(20, 40))
					ply:TakeDamageInfo(dmg)
					ply:ChatPrint(white_text, "Uh oh, looks like that was a bad one!")
				end,
			}

			pluto.db.instance(function(db)
				pluto.inv.addcurrency(db, ply, "dice", 1)
				ply:ChatPrint(white_text, "You got a ", pluto.currency.byname.dice, white_text, "!")
			end)

			chances[math.random(6)]()

			return true
		end,
	},
} do
	table.Merge(pluto.currency.byname[name], values)
end

for _, item in pairs(pluto.currency.list) do
	pluto.currency.shares = pluto.currency.shares + item.Shares
end

function pluto.ghost_killed(e, dmg)
	local atk = dmg:GetAttacker()
	if (not IsValid(atk) or not atk:IsPlayer()) then
		return
	end

	hook.Run("PlutoPlayerKilledGhost", atk)

	admin.chatf(white_text, "A ", ttt.teams.traitor.Color, "ghost ", white_text, "has been vanquished.")

	local rand = pluto.inv.roll {
		all = 1,
		self = 15,
		nothin = 7,
		share = 2,
		multi = 0.05,
	}

	if (rand == "self") then
		atk:ChatPrint(white_text, "You have been granted a ", pluto.currency.byname.tome, white_text, " by the ghost")
		pluto.currency.spawnfor(atk, "tome", atk:GetPos())
	elseif (rand == "all") then
		admin.chatf(white_text, "The server has been blessed with ", pluto.currency.byname.tome)
		for _, ply in pairs(player.GetHumans()) do
			pluto.currency.spawnfor(ply, "tome")
		end
	elseif (rand == "share") then
		for _, oply in RandomPairs(player.GetHumans()) do
			if (oply ~= atk) then
				atk:ChatPrint("You have shared two ", pluto.currency.byname.tome, "s", white_text, " with ", ttt.teams.traitor.Color, oply:Nick())
				oply:ChatPrint("You have been granted two ", pluto.currency.byname.tome, "s", white_text, " by ", ttt.teams.traitor.Color, atk:Nick())
				for i = 1, 3 do
					pluto.currency.spawnfor(oply, "tome")
					pluto.currency.spawnfor(atk, "tome")
				end
				break
			end
		end
	elseif (rand == "multi") then
		for name, cur in pairs(pluto.currency.byname) do
			if (cur.Fake or not cur.Shares or cur.Shares <= pluto.currency.byname.mirror.Shares) then
				continue
			end
			
			pluto.currency.spawnfor(atk, name)
		end
	else
		atk:ChatPrint(white_text, "That ghost was a ", pluto.currency.byname.tome.Color, "mirage")
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
	end,
	random = function()
		local state = {}
		for i, nav in ipairs(pluto.currency.navs) do
			state[i] = {
				Random = math.random() * nav.Size,
				Nav = nav.Nav
			}
		end
		
		table.sort(state, function(a, b)
			return a.Random < b.Random
		end)

		for i, nav in pairs(state) do
			state[i] = nav.Nav
		end

		return ipairs(state)
	end,
	randomsingle = function()
		for _, item in pluto.currency.navs.random() do
			if (type(_) ~= "number") then
				continue
			end
			return item
		end
	end
}

local std_mins, std_maxs = Vector(-16, -16, 0), Vector(16, 16, 48)


function pluto.currency.initpositions()
	if (pluto.currency.cached_positions) then
		return
	end

	local cache = {}
	local n = 1

	for i = 1, 5000 do
		local nav = pluto.currency.navs.randomsingle()
		local pos = pluto.currency.validpos(nav, std_mins, std_maxs)
		if (pos) then
			cache[n] = pos
			n = n + 1
		end
	end

	pluto.currency.cached_positions = cache
end

timer.Simple(0, function()
	pluto.currency.navs.start()
	pluto.currency.initpositions()
end)

function pluto.currency.randompos(mins, maxs)
	pluto.currency.navs.start()
	if (not mins and not maxs) then
		pluto.currency.initpositions()

		return table.Random(pluto.currency.cached_positions)
	end

	if (not mins) then
		mins = Vector(-16, -16, 0)
	end
	if (not maxs) then
		maxs = Vector(16, 16, 48)
	end

	for i, item in pluto.currency.navs.random() do
		if (not isnumber(i)) then
			continue
		end

		local pos = pluto.currency.validpos(item, mins, maxs)
		if (pos) then
			return pos, item
		end
	end

	pwarnf("Initial rand: %.5f, rand end: %.5f, total: %.5f", initial, rand, pluto.currency.navs.total)

	return vector_origin
end

function pluto.currency.validpos(nav, mins, maxs)
	for i = 1, 25 do
		local pos = nav:GetRandomPoint()

		local tr = util.TraceHull {
			start = pos,
			endpos = pos,
			mins = mins,	
			maxs = maxs,
			filter = player.GetAll(),
			mask = MASK_PLAYERSOLID
		}

		if (tr.Hit) then
			continue
		end

		local contents = util.PointContents(pos)

		if (bit.band(contents, CONTENTS_WATER) == CONTENTS_WATER) then
			continue
		end

		return pos
	end
end

function pluto.currency.navs_filter(filter)
	pluto.currency.navs.start()
	
	local n = 1
	local ret = {}

	for _, item in ipairs(pluto.currency.navs) do
		if (not filter(item.Nav)) then
			continue
		end

		ret[n], n = item.Nav, n + 1
	end

	return ret
end

function pluto.currency.spawnfor(ply, currency, pos, global)
	if (not pos) then
		pos = pluto.currency.randompos()
	end

	if (not currency) then
		currency = pluto.currency.random()
	else
		currency = pluto.currency.byname[currency]
	end

	

	local ent = pluto.currency.entity()
	ent:SetSize(22)
	ent:SetPos(pos + vector_up * ent:GetSize())
	ent:SetCurrencyType(currency.InternalName)
	if (global == true or currency.Global) then
		ent:AddListener(player.GetHumans())
	else
		ent:AddListener(ply)
	end

	if (currency.Shares and currency.Shares <= pluto.currency.byname.heart.Shares and not currency.SkipNotify) then
		ply:ChatPrint(currency.Color, "... ", white_text, "You feel the essence of a ", currency.Color, "rare currency ", white_text, "vibrate your soul")
	end

	pluto.currency.spawned[ent] = ply

	return ent
end

pluto.currency.tospawn = pluto.currency.tospawn or {}
pluto.currency.spawned = pluto.currency.spawned or {}

hook.Add("DoPlayerDeath", "pluto_currency_add", function(vic, damager, dmg)
	if (pluto.rounds.getcurrent()) then
		return
	end

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
	elseif (atk:GetRoleData().Evil) then
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

	if (not gun or gun.Owner ~= sid or gun.Nickname) then
		pluto.inv.sendfullupdate(cl)
		return
	end

	gun.LastUpdate = (gun.LastUpdate or 0) + 1
	gun.Nickname = name

	pluto.inv.message(cl)
		:write("item", gun)
		:send()
	
	pluto.db.transact(function(db)
		if (not pluto.inv.addcurrency(db, cl, "quill", -1)) then
			mysql_rollback(db)
			return
		end

		mysql_stmt_run(db, "UPDATE pluto_items set nick = ? WHERE idx = ? and nick is NULL", name, id)

		mysql_commit(db)
	end)
end

function pluto.inv.readunname(cl)
	local id = net.ReadUInt(32)

	local gun = pluto.itemids[id]

	local sid = pluto.db.steamid64(cl)

	if (not gun or gun.Owner ~= sid or not gun.Nickname) then
		pluto.inv.sendfullupdate(cl)
		return
	end

	gun.LastUpdate = (gun.LastUpdate or 0) + 1
	gun.Nickname = nil

	pluto.inv.message(cl)
		:write("item", gun)
		:send()
	
	pluto.db.transact(function(db)
		if (not pluto.inv.addcurrency(db, cl, "hand", -100)) then
			mysql_rollback(db)
			return
		end

		mysql_stmt_run(db, "UPDATE pluto_items set nick = NULL WHERE idx = ?", id)
		mysql_commit(db)
	end)
end


hook.Add("TTTBeginRound", "pluto_currency", function()
	pluto.currency.navs.start()

	for _, item in pairs(round.GetStartingPlayers()) do
		if (item.Player.WasAFK) then
			pluto.currency.tospawn[item.Player] = 0
			continue
		end
		if (item.Player:GetRoleTeam() ~= "innocent") then
			continue
		end

		local points = pluto.currency.tospawn[item.Player] or currency_per_round

		for i = 1, math.floor(points) do
			local e = pluto.currency.spawnfor(item.Player)
		end

		pluto.currency.tospawn[item.Player] = currency_per_round + points - math.floor(points)
	end

	-- ghosts
	local pct = 1 / 7
	if (player.GetCount() < 8) then
		pct = 1 / 6
	elseif (player.GetCount() < 16) then
		pct = 1 / 4
	else
		pct = 1 / 3
	end

	if (false and math.random() < pct) then
		admin.chatf(white_text, "Multiple ", ttt.teams.traitor.Color, "spirits ", white_text, "have entered this realm.")
		local ghosts = {}
		for i = 1, 7 + player.GetCount() / 6 do
			ghosts[i] = ents.Create "pluto_ghost"
			ghosts[i]:SetPos(pluto.currency.randompos())
			ghosts[i]:Spawn()
		end
		timer.Simple(60, function()
			local had_ghosts = false
			for _, ghost in pairs(ghosts) do
				if (IsValid(ghost)) then
					ghost:Remove()
					had_ghosts = true
				end
			end

			if (had_ghosts) then
				admin.chatf(white_text, "The remaining ", ttt.teams.traitor.Color, "spirits ", white_text, "have left this realm.")
			else
				admin.chatf(white_text, "The ", ttt.teams.traitor.Color, "spirits ", white_text, "were silenced this time.")
			end
		end)
	end
end)