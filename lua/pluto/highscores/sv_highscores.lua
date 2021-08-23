--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]


local function invalidkill(vic, atk, canbesameteam, canbespecialround)
	if (not IsValid(vic) or not IsValid(atk) or not atk:IsPlayer()) then
		return true
	end

	if (vic == atk) then
		return true
	end

	if (vic:GetRoleTeam() == atk:GetRoleTeam() and not canbesameteam) then
		return true
	end

	if (ttt.GetCurrentRoundEvent() ~= "" and not canbespecialround) then
		return true
	end

	return
end

local function getweapon(inf, atk)
	if (inf and inf:IsWeapon()) then
		return inf
	end

	if (not IsValid(atk)) then
		return
	end

	local wep = atk:GetActiveWeapon()

	if (wep) then
		return wep
	end
end

for name, values in pairs {
	-- Kills
    totalkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_totalkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "totalkills", 1)
				end)
			end)
		end,
	},
    detectivekills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_detectivekills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				if (vic:GetRole() ~= "Detective") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "detectivekills", 1)
				end)
			end)
		end,
	},
    traitorkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_traitorkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				if (vic:GetRoleTeam() ~= "traitor") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "traitorkills", 1)
				end)
			end)
		end,
	},
    innocentkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_innocentkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				if (vic:GetRoleTeam() ~= "innocent" or vic:GetRole() == "Detective") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "innocentkills", 1)
				end)
			end)
		end,
	},
    uniquekills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_uniquekills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or not wep.GetInventoryItem) then
					return
				end

				local data = wep:GetInventoryItem()

				if (not data or not data.Tier or not data.Tier.InternalName or data.Tier.InternalName ~= "unique") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "uniquekills", 1)
				end)
			end)
		end,
	},
    confusedkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_confusedkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or not wep.GetInventoryItem) then
					return
				end

				local data = wep:GetInventoryItem()

				if (not data or not data.Tier or not data.Tier.InternalName or data.Tier.InternalName ~= "confused") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "confusedkills", 1)
				end)
			end)
		end,
	},
    meleekills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_meleekills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or not wep.GetSlot or wep:GetSlot() ~= 0) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "meleekills", 1)
				end)
			end)
		end,
	},
    secondarykills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_secondarykills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or not wep.GetSlot or wep:GetSlot() ~= 1) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "secondarykills", 1)
				end)
			end)
		end,
	},
    primarykills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_primarykills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or not wep.GetSlot or not wep:GetSlot() ~= 2) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "primarykills", 1)
				end)
			end)
		end,
	},
    --[[grenadekills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_grenadekills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or wep:GetSlot() ~= 4) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "grenadekills", 1)
				end)
			end)
		end,
	},--]]
    tweaponkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_tweaponkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				local wep = getweapon(inf, atk)

				if (not wep or not wep.Equipment or not wep.Equipment.CanBuy or not wep.Equipment.CanBuy.traitor) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "tweaponkills", 1)
				end)
			end)
		end,
	},
    --[[headshotkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_headshotkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "headshotkills", 1)
				end)
			end)
		end,
	},--]]
    postmortemkills = {
		Init = function()
			hook.Add("PlayerDeath", "pluto_highscores_postmortemkills", function(vic, inf, atk)
				if invalidkill(vic, atk) then
					return
				end

				if (atk:Alive()) then
					return 
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "postmortemkills", 1)
				end)
			end)
		end,
	},
    specialkills = {
		Init = function()
			local kills = {}

			hook.Add("TTTRoundStart", "pluto_highscores_specialkills", function(plys)
				if (ttt.GetCurrentRoundEvent() == "") then
					return
				end

				for k, ply in ipairs(plys) do
					kills[ply] = 0
				end
			end)

			hook.Add("PlayerDeath", "pluto_highscores_specialkills", function(vic, inf, atk)
				if invalidkill(vic, atk, true, true) then
					return
				end

				if (ttt.GetCurrentRoundEvent() == "") then
					return
				end

				kills[atk] = (kills[atk] or 0) + 1

				if (kills[atk] > 10) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, atk, "specialkills", 1)
				end)
			end)
		end,
	},
	-- Performance
    creditsspent = {
		Init = function()
			hook.Add("TTTOrderedEquipment", "pluto_highscores_creditsspent", function(ply, class, is_item, cost)
				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "creditsspent", cost)
				end)
			end)
		end,
	},
    roundswon = {
		Init = function()
			hook.Add("TTTRoundEnd", "pluto_highscores_roundswon", function(winning_team, winners, why)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end

				for k, ply in ipairs(winners) do
					if (not IsValid(ply.Player)) then
						continue
					end

					pluto.db.instance(function(db)
						pluto.highscores.addscore(db, ply.Player, "roundswon", 1)
					end)
				end
			end)
		end,
	},
    roundssurvived = {
		Init = function()
			hook.Add("TTTEndRound", "pluto_highscores_roundssurvived", function()
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end

				for k, ply in ipairs(player.GetAll()) do
					if (not ply:Alive()) then
						continue
					end

					pluto.db.instance(function(db)
						pluto.highscores.addscore(db, ply, "roundssurvived", 1)
					end)
				end
			end)
		end,
	},
    totalhealing = {
		Init = function()
			hook.Add("OnPlutoHealthGain", "pluto_highscores_totalhealing", function(ply, amt)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "totalhealing", amt)
				end)
			end)
		end,
	},
    timesurvived = {
		Init = function()
			local players = {}
			local start = 0

			hook.Add("TTTRoundStart", "pluto_highscores_timesurvived", function(plys)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end
				
				start = CurTime()

				for k, ply in ipairs(plys) do
					players[ply] = true
				end
			end)

			hook.Add("PlayerDeath", "pluto_highscores_timesurvived", function(vic, inf, atk)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end
				
				if (not start or start == 0 or not players[vic]) then
					return 
				end

				players[vic] = nil

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, vic, "timesurvived", math.min(600, CurTime() - start))
				end)
			end)
			
			hook.Add("TTTEndRound", "pluto_highscores_timesurvived", function()
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end
				
				if (not start or start == 0 or not players) then
					return 
				end

				for ply, bool in pairs(players) do
					pluto.db.instance(function(db)
						pluto.highscores.addscore(db, ply, "timesurvived", math.min(600, CurTime() - start))
					end)
				end
			end)
		end,
	},
    specialswon = {
		Init = function()
			hook.Add("PlutoSpecialWon", "pluto_highscores_specialswon", function(winners)
				for k, ply in ipairs(winners) do
					if (not IsValid(ply)) then
						continue
					end

					pluto.db.instance(function(db)
						pluto.highscores.addscore(db, ply, "specialswon", 1)
					end)
				end
			end)
		end,
	},
    bodiesidentified = {
		Init = function()
			hook.Add("TTTBodyIdentified", "pluto_highscores_bodiesidentified", function(vic, ply)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end
				
				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "bodiesidentified", 1)
				end)
			end)
		end,
	},
    dnatracks = {
		Init = function()
			local tracks = {}

			hook.Add("TTTRoundStart", "pluto_highscores_dnatracks", function(plys)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end
				
				tracks = {}
			end)

			hook.Add("TTTFoundDNA", "pluto_highscores_dnatracks", function(ply, own, ent)
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end

				if (not IsValid(ply) or not IsValid(own)) then
					return
				end

				if (not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll") then
					return
				end

				if (not own:IsPlayer() or own:GetRoleTeam() ~= "traitor") then
					return
				end

				tracks[ply] = tracks[ply] or {}

				tracks[ply][own] = true
			end)

			hook.Add("TTTEndRound", "pluto_highscores_dnatracks", function()
				if (ttt.GetCurrentRoundEvent() ~= "") then
					return
				end

				for ply, tracked in pairs(tracks) do
					pluto.db.instance(function(db)
						pluto.highscores.addscore(db, ply, "dnatracks", table.Count(tracked))
					end)
				end
			end)
		end,
	},
	-- Quests
    hourlyquests = {
		Init = function()
			hook.Add("PlutoQuestCompleted", "pluto_highscores_hourlyquests", function(ply, quest, typ)
				if (typ ~= "hourly") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "hourlyquests", 1)
				end)
			end)
		end,
	},
    dailyquests = {
		Init = function()
			hook.Add("PlutoQuestCompleted", "pluto_highscores_dailyquests", function(ply, quest, typ)
				if (typ ~= "daily") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "dailyquests", 1)
				end)
			end)
		end,
	},
    weeklyquests = {
		Init = function()
			hook.Add("PlutoQuestCompleted", "pluto_highscores_weeklyquests", function(ply, quest, typ)
				if (typ ~= "weekly") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "weeklyquests", 1)
				end)
			end)
		end,
	},
    uniquequests = {
		Init = function()
			hook.Add("PlutoQuestCompleted", "pluto_highscores_uniquequests", function(ply, quest, typ)
				if (typ ~= "unique") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "uniquequests", 1)
				end)
			end)
		end,
	},
	-- Crafting
    totalcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_totalcrafts", function(ply, wpn, items, cur)
				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "totalcrafts", 1)
				end)
			end)
		end,
	},
    twomodcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_twomodcrafts", function(ply, wpn, items, cur)
				if (wpn:GetMaxAffixes() ~= 2) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "twomodcrafts", 1)
				end)
			end)
		end,
	},
    threemodcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_threemodcrafts", function(ply, wpn, items, cur)
				if (wpn:GetMaxAffixes() ~= 3) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "threemodcrafts", 1)
				end)
			end)
		end,
	},
    fourmodcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_fourmodcrafts", function(ply, wpn, items, cur)
				if (wpn:GetMaxAffixes() ~= 4) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "fourmodcrafts", 1)
				end)
			end)
		end,
	},
    fivemodcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_fivemodcrafts", function(ply, wpn, items, cur)
				if (wpn:GetMaxAffixes() ~= 5) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "fivemodcrafts", 1)
				end)
			end)
		end,
	},
    sixmodcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_sixmodcrafts", function(ply, wpn, items, cur)
				if (wpn:GetMaxAffixes() ~= 6) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "sixmodcrafts", 1)
				end)
			end)
		end,
	},
    sevenmodcrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_sevenmodcrafts", function(ply, wpn, items, cur)
				if (wpn:GetMaxAffixes() ~= 7) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "sevenmodcrafts", 1)
				end)
			end)
		end,
	},
    currencycrafts = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_currencycrafts", function(ply, wpn, items, cur)
				if (not cur or not cur.Amount) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "currencycrafts", cur.Amount)
				end)
			end)
		end,
	},
    wepssacrificed = {
		Init = function()
			hook.Add("PlutoWeaponCrafted", "pluto_highscores_wepssacrificed", function(ply, wpn, items, cur)
				if (not items or table.Count(items) <= 3) then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "wepssacrificed", table.Count(items))
				end)
			end)
		end,
	},
	-- Currency
    currencyused = {
		Init = function()
			hook.Add("PlayerCurrencyUse", "pluto_highscores_currencyused", function(ply, wpn, cur, amt)
				if (not cur) then
					return
				end
				
				if (not pluto.currency.byname[cur] or pluto.currency.byname[cur].Category ~= "Modify") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "currencyused", amt or 1)
				end)
			end)
		end,
	},
    unboxablesopened = {
		Init = function()
			hook.Add("PlayerCurrencyUse", "pluto_highscores_unboxablesopened", function(ply, wpn, cur, amt)
				if (not cur) then
					return
				end
				
				if (not pluto.currency.byname[cur] or pluto.currency.byname[cur].Category ~= "Unbox") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "unboxablesopened", amt or 1)
				end)
			end)
		end,
	},
    stardustspent = {
		Init = function()
			hook.Add("PlutoCurrencySpent", "pluto_highscores_stardustspent", function(ply, cur, amt)
				if (cur ~= "stardust") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "stardustspent", amt or 1)
				end)
			end)
		end,
	},
    refiniumspent = {
		Init = function()
			hook.Add("PlutoCurrencySpent", "pluto_highscores_refiniumspent", function(ply, cur, amt)
				if (cur ~= "tp") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "refiniumspent", amt or 1)
				end)
			end)
		end,
	},
    specialsstarted = {
		Init = function()
			hook.Add("PlutoSpecialStarted", "pluto_highscores_specialsstarted", function(ply, event)
				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "specialsstarted", 1)
				end)
			end)
		end,
	},
	-- Drops
    rareshards = {
		Init = function()
			hook.Add("PlutoRareDrop", "pluto_highscores_rareshards", function(ply, typ)
				if (typ ~= "Shard") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "rareshards", 1)
				end)
			end)
		end,
	},
    rareweapons = {
		Init = function()
			hook.Add("PlutoRareDrop", "pluto_highscores_raredrops", function(ply, typ)
				if (typ ~= "Weapon") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "rareweapons", 1)
				end)
			end)
		end,
	},
    raremodels = {
		Init = function()
			hook.Add("PlutoRareDrop", "pluto_highscores_raremodels", function(ply, typ)
				if (typ ~= "Model") then
					return
				end

				pluto.db.instance(function(db)
					pluto.highscores.addscore(db, ply, "raremodels", 1)
				end)
			end)
		end,
	},
} do
	table.Merge(pluto.highscores.byname[name], values)
end

function pluto.highscores.addscore(db, ply, highscore, amt)
	mysql_cmysql()

	steamid = pluto.db.steamid64(ply)

	if (not steamid or not pluto.highscores.byname[highscore]) then
		-- possible error
		return false
	end

	if (pluto.highscores.byname[highscore].MinPlayers and #player.GetAll() < pluto.highscores.byname[highscore].MinPlayers) then
		-- no error, just too few players
		return false
	end

	local succ, err = mysql_stmt_run(db, "INSERT INTO pluto_highscores (player, highscore, score) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE score = score + VALUE(score)", steamid, highscore, amt)

	if (err) then
		print(err)
		-- possible error
		return false
	end

	--print(string.format("%s of %s incremented by %i for %s of steamid %s", highscore, pluto.highscores.byname[highscore].Category, amt, ply:Nick(), steamid))

	return true
end

-- temporary getter for testing
function pluto.highscores.getscore(db, ply, highscore)
	mysql_cmysql()

	steamid = pluto.db.steamid64(ply)

	local info, err = mysql_stmt_run(db, "SELECT score FROM pluto_highscores WHERE player = ? AND highscore = ?", steamid, highscore)

	if (not info or not info[1] or not info[1].score) then
		pwarnf("NO SCORE FOR %s: %s", steamid, err)
		return false
	end

	return info[1].score
end

for highscore, info in pairs(pluto.highscores.byname) do
	if (info.Init) then
		info.Init()
	end
end

--[[concommand.Add("pluto_lookup_highscore", function(ply, cmd, args)
	if (not IsValid(ply)) then
		return 
	end

	if (not args or not args[1] or not pluto.highscores.byname[args[1] ]) then
		ply:ChatPrint("Invalid score")
		return
	end

	pluto.db.instance(function(db)
		ply:ChatPrint(string.format("%s: %i", pluto.highscores.byname[args[1] ].Name, pluto.highscores.getscore(db, ply, args[1]) or 0))
	end)
end)--]]

concommand.Add("pluto_lookup_highscores", function(ply, cmd, args)
	if (not IsValid(ply)) then
		return 
	end

	pluto.db.instance(function(db)
		for name, highscore in pairs(pluto.highscores.byname) do
			ply:ChatPrint(string.format("%s: %i", highscore.Name, pluto.highscores.getscore(db, ply, name) or 0))
		end
	end)
end)