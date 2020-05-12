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
		Reward = function(ply)
			local transact = pluto.inv.generatebufferweapon(ply, "unique", "weapon_noise_nitro")
			transact:AddCallback(function(e)
				if (e) then
					return
				end
				ttt.chat(color_nitro, ply:Nick(), white_text, " has received the original ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Noise Maker!")
				hook.Add("PlayerSpawn", "confetti_" .. ply:SteamID64(), function(p)
					if (p ~= ply) then
						return
					end

					hook.Remove("PlayerSpawn", "confetti_" .. ply:SteamID64())
					local ang = ply:EyeAngles()
					ang.p = 0

			--[[
					for i = 0, 360, 30 do
						ang:RotateAroundAxis(ang:Up(), 30)
			
						local data = EffectData()
						data:SetStart(ply:GetShootPos())
						data:SetOrigin(data:GetStart() + ang:Forward())
						data:SetMagnitude(1)
						data:SetRadius(50)
						data:SetFlags(0)
						util.Effect("pluto_confetti", data, true, true)
					end]]
					sound.Play("pluto_confetti", ply:GetPos())
				end)
			end)

			return transact
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
		Reward = function(ply)
			local transact = pluto.inv.generatebufferweapon(ply, "unique", "weapon_ttt_confetti_grenade")
			transact:AddCallback(function(err)
				if (err) then
					return
				end

				ttt.chat(color_nitro, ply:Nick(), white_text, " has received the second ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Confetti Grenade!")
				hook.Add("PlayerSpawn", "nade_" .. ply:SteamID64(), function(p)
					if (p ~= ply) then
						return
					end

					hook.Remove("PlayerSpawn", "nade_" .. ply:SteamID64())
					local ang = ply:EyeAngles()
					ang.p = 0
			--[[
					for i = 0, 360, 30 do
						ang:RotateAroundAxis(ang:Up(), 30)
			
						local data = EffectData()
						data:SetStart(ply:GetShootPos())
						data:SetOrigin(data:GetStart() + ang:Forward())
						data:SetMagnitude(1)
						data:SetRadius(50)
						data:SetFlags(0)
						util.Effect("pluto_confetti", data, true, true)
					end]]

					sound.Play("pluto_confetti", ply:GetPos())
				end)
			end)

			return transact
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
		Reward = function(ply)
			local transact = pluto.inv.generatebufferweapon(ply, "unique", "weapon_ttt_golden_pan")
			transact:AddCallback(function(err)
				if (err) then
					return
				end

				ttt.chat(color_nitro, ply:Nick(), white_text, " has received the third ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Golden Pan!")
				hook.Add("PlayerSpawn", "pan_" .. ply:SteamID64(), function(p)
					if (p ~= ply) then
						return
					end

					hook.Remove("PlayerSpawn", "pan_" .. ply:SteamID64())
					local ang = ply:EyeAngles()
					ang.p = 0
			--[[
					for i = 0, 360, 30 do
						ang:RotateAroundAxis(ang:Up(), 30)
			
						local data = EffectData()
						data:SetStart(ply:GetShootPos())
						data:SetOrigin(data:GetStart() + ang:Forward())
						data:SetMagnitude(1)
						data:SetRadius(50)
						data:SetFlags(0)
						util.Effect("pluto_confetti", data, true, true)
					end]]

					sound.Play("pluto_confetti", ply:GetPos())
				end)
			end)

			return transact
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
		Reward = function(ply)
			local transact = pluto.inv.generatebuffermodel(ply, "spy")
			transact:AddCallback(function(err)
				if (err) then
					return
				end

				ttt.chat(color_nitro, ply:Nick(), white_text, " has received the fourth ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Spy Model!")
				hook.Add("PlayerSpawn", "spy_" .. ply:SteamID64(), function(p)
					if (p ~= ply) then
						return
					end

					hook.Remove("PlayerSpawn", "spy_" .. ply:SteamID64())
					local ang = ply:EyeAngles()
					ang.p = 0
			--[[
					for i = 0, 360, 30 do
						ang:RotateAroundAxis(ang:Up(), 30)
			
						local data = EffectData()
						data:SetStart(ply:GetShootPos())
						data:SetOrigin(data:GetStart() + ang:Forward())
						data:SetMagnitude(1)
						data:SetRadius(50)
						data:SetFlags(0)
						util.Effect("pluto_confetti", data, true, true)
					end]]

					sound.Play("pluto_confetti", ply:GetPos())
				end)
			end)

			return transact
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
		Reward = function(ply)
			local transact = pluto.inv.generatebufferweapon(ply, "unique", "weapon_nitro_rope")
			transact:AddCallback(function(err)
				if (err) then
					return
				end

				ttt.chat(color_nitro, ply:Nick(), white_text, " has received the fifth ", color_nitro, "Nitro Booster ", white_text, "reward: ", color_nitro, "Nitro Web!")
				hook.Add("PlayerSpawn", "web_" .. ply:SteamID64(), function(p)
					if (p ~= ply) then
						return
					end

					hook.Remove("PlayerSpawn", "web_" .. ply:SteamID64())
					local ang = ply:EyeAngles()
					ang.p = 0
			--[[
					for i = 0, 360, 30 do
						ang:RotateAroundAxis(ang:Up(), 30)
			
						local data = EffectData()
						data:SetStart(ply:GetShootPos())
						data:SetOrigin(data:GetStart() + ang:Forward())
						data:SetMagnitude(1)
						data:SetRadius(50)
						data:SetFlags(0)
						util.Effect("pluto_confetti", data, true, true)
					end]]

					sound.Play("pluto_confetti", ply:GetPos())
				end)
			end)

			return transact
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

				local transact = reward.Reward(p)

				for _, ply in pairs(player.GetAll()) do
					pluto.inv.message(ply)
						:write("nitro", reward_num, p)
						:send()
				end
				
				pluto.db.transact_or_query(transact, "INSERT INTO pluto_nitro_rewards (steamid, reward_num, assoc_discordid) VALUES(?, ?, ?)", {sid, reward_num, boost.discordid}, function(err, q)
					if (err) then
						pwarnf("Error inserting nitro reward data for %s", sid)
					end
				end)

				if (transact) then
					transact:Run()
				end
			end
		end

		-- finished!
	end

	pluto.db.query("SELECT CAST(discordid as CHAR) as discordid, UNIX_TIMESTAMP(boosting_since) as boosting_since, UNIX_TIMESTAMP(first_boost) as first_boost from styx.nitro N \
		inner join forums.discord_users D on N.discordid = D.snowflake \
		inner join forums.core_members C on C.member_id = D.forum_id \
			where C.steamid = ?", {sid}, 
		function(err, q)
			if (err) then
				try_finish(false, nil)
				return
			end

			try_finish(q:getData()[1] or false, nil)
		end
	)

	pluto.db.query("SELECT reward_num, assoc_discordid FROM pluto_nitro_rewards WHERE steamid = ?", {sid}, function(err, q)
		if (err) then
			try_finish(nil, false)
			return
		end

		try_finish(nil, q:getData() or false)
	end)
end)

function pluto.inv.writenitro(cl, reward_num, ply)
	net.WriteEntity(ply)
	net.WriteUInt(reward_num, 16)
end