color_nitro = Color(238, 148, 238)

local NitroRewards = {
	{
		Since = os.time {
			day = 31,
			hour = 0,
			year = 2020,
			month = 1,
			min = 0,
		},
		Reward = function(db, ply)
			mysql_cmysql()

			pluto.inv.generatebufferweapon(db, ply, "REWARD", "unique", "weapon_noise_nitro")
			ttt.chat(color_nitro, ply:Nick(), white_text, " has received the original ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Noise Maker!")
			hook.Add("PlayerSpawn", "confetti_" .. ply:SteamID64(), function(p)
				if (p ~= ply) then
					return
				end

				hook.Remove("PlayerSpawn", "confetti_" .. ply:SteamID64())
				sound.Play("pluto_confetti", ply:GetPos())
			end)
			mysql_commit(db)
		end
	},
	{
		Since = os.time {
			day = 11,
			hour = 0,
			year = 2020,
			month = 2,
			min = 0,
		},
		Reward = function(db, ply)
			mysql_cmysql()

			pluto.inv.generatebufferweapon(db, ply, "REWARD", "unique", "weapon_ttt_confetti_grenade")

			ttt.chat(color_nitro, ply:Nick(), white_text, " has received the second ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Confetti Grenade!")
			hook.Add("PlayerSpawn", "nade_" .. ply:SteamID64(), function(p)
				if (p ~= ply) then
					return
				end

				hook.Remove("PlayerSpawn", "nade_" .. ply:SteamID64())
				sound.Play("pluto_confetti", ply:GetPos())
			end)
			mysql_commit(db)
		end
	},
	{
		Since = os.time {
			day = 27,
			hour = 0,
			year = 2020,
			month = 2,
			min = 0,
		},
		Reward = function(db, ply)
			mysql_cmysql()

			pluto.inv.generatebufferweapon(db, ply, "REWARD", "unique", "weapon_ttt_golden_pan")

			ttt.chat(color_nitro, ply:Nick(), white_text, " has received the third ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Golden Pan!")
			hook.Add("PlayerSpawn", "pan_" .. ply:SteamID64(), function(p)
				if (p ~= ply) then
					return
				end

				hook.Remove("PlayerSpawn", "pan_" .. ply:SteamID64())
				sound.Play("pluto_confetti", ply:GetPos())
			end)
			mysql_commit(db)
		end
	},
	{
		Since = os.time {
			day = 30,
			hour = 0,
			year = 2020,
			month = 3,
			min = 0,
		},
		Reward = function(db, ply)
			mysql_cmysql()

			pluto.inv.generatebuffermodel(db, ply, "spy")

			ttt.chat(color_nitro, ply:Nick(), white_text, " has received the fourth ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Spy Model!")
			hook.Add("PlayerSpawn", "spy_" .. ply:SteamID64(), function(p)
				if (p ~= ply) then
					return
				end

				hook.Remove("PlayerSpawn", "spy_" .. ply:SteamID64())
				sound.Play("pluto_confetti", ply:GetPos())
			end)
			mysql_commit(db)
		end
	},
	{
		Since = os.time {
			day = 14,
			hour = 0,
			year = 2020,
			month = 5,
			min = 0,
		},
		Reward = function(db, ply)
			mysql_cmysql()

			pluto.inv.generatebufferweapon(db, ply, "REWARD", "unique", "weapon_nitro_rope")

			ttt.chat(color_nitro, ply:Nick(), white_text, " has received the fifth ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Nitro Web!")
			hook.Add("PlayerSpawn", "web_" .. ply:SteamID64(), function(p)
				if (p ~= ply) then
					return
				end

				hook.Remove("PlayerSpawn", "web_" .. ply:SteamID64())

				sound.Play("pluto_confetti", ply:GetPos())
			end)
			mysql_commit(db)
		end
	},
}


hook.Add("PlutoInventoryLoad", "pluto_admin", function(p)
	local sid = pluto.db.steamid64(p)

	local boost, rewards

	local function try_finish(_boost, _rewards)
		if (not IsValid(p)) then
			return
		end

		if (_boost ~= nil) then
			boost = _boost
			if (not _boost) then
				pwarnf("Failed finding boost data for %s", sid)
				return
			end
		end

		if (_rewards ~= nil) then
			rewards = _rewards
			if (not _rewards) then
				pwarnf("No reward data for %s", sid)
				return
			end
		end

		if (not boost or not rewards or not boost.boosting_since) then
			return
		end

		for reward_num, reward in ipairs(NitroRewards) do
			-- see if boosting since was before specified date
			if (reward.Since > boost.boosting_since) then
				-- if it is, make sure not already awarded

				local gotten = false
				for _, done in pairs(rewards) do
					if (done.reward_num == reward_num) then
						gotten = true
						break
					end
				end

				if (gotten) then
					pprintf("%s already got reward %i", sid, reward_num)
					continue
				end

				pluto.db.transact(function(db)
					reward.Reward(db, p)
					local succ = mysql_stmt_run("INSERT INTO pluto_nitro_rewards (steamid, reward_num, assoc_discordid) VALUES(?, ?, ?)", sid, reward_num, boost.discordid)
					if (not succ) then
						mysql_rollback(db)
						return
					end
					mysql_commit(db)
					for _, ply in pairs(player.GetAll()) do
						pluto.inv.message(ply)
							:write("nitro", reward_num, p)
							:send()
					end
				end)
			end
		end

		-- finished!
	end

	pluto.db.simplequery("SELECT CAST(discordid as CHAR) as discordid, UNIX_TIMESTAMP(boosting_since) as boosting_since, UNIX_TIMESTAMP(first_boost) as first_boost from styx.nitro N \
		inner join forums.discord_users D on N.discordid = D.snowflake \
		inner join forums.core_members C on C.member_id = D.forum_id \
			where C.steamid = ?", {sid}, 
		function(dat, err)
			if (not dat) then
				try_finish(false, nil)
				return
			end

			try_finish(dat[1] or false, nil)
		end
	)

	pluto.db.simplequery("SELECT reward_num, assoc_discordid FROM pluto_nitro_rewards WHERE steamid = ?", {sid}, function(dat, err)
		if (not dat) then
			try_finish(nil, false)
			return
		end

		try_finish(nil, dat)
	end)
end)

function pluto.inv.writenitro(cl, reward_num, ply)
	net.WriteEntity(ply)
	net.WriteUInt(reward_num, 16)
end