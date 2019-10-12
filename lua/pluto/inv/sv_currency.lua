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

			item.Mods = pluto.weapons.generatetier(item.Tier, item.ClassName).Mods
			
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
			for _, Mods in pairs(item.Mods) do
				for i = 1, #Mods do
					table.insert(possible, {
						Mods = Mods,
						Index = i,
					})
				end
			end

			if (#possible <= 1) then
				return
			end

			local rand = table.Random(possible)

			table.remove(rand.Mods, rand.Index)

			UpdateAndDecrement(ply, item, "hand")
		end,
	},
	tome = {
		Shares = 100,
		Use = function(item)
		end,
	},
	mirror = {
		Shares = 1,
		Use = function(item)
		end,
	},
	heart = {
		Shares = 5,
		Use = function(ply, item)
			if (not item.Mods) then
				return
			end

			local prefixes = #item.Mods.prefix
			local suffixes = #item.Mods.suffix

			if (prefixes + suffixes == item.Tier.affixes) then
				return
			end
			
			local have = {}

			for _, Mods in pairs(item.Mods) do
				for _, mod in pairs(Mods) do
					have[mod.Mod] = true
				end
			end

			local potential = {}

			local allowed = {}

			if (prefixes < 3) then
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

			if (suffixes < 3) then
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

			UpdateAndDecrement(ply, item, "heart")
		end,
	},
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
		pos = pluto.currency.randompos()
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

hook.Add("TTTBeginRound", "pluto_currency", function()
	for _, item in pairs(round.GetStartingPlayers()) do
		if (item.Player.WasAFK) then
			continue
		end

		local points = (pluto.currency.tospawn[item.Player] or 1) * 4

		for i = 1, points do
			pluto.currency.spawnfor(item.Player)
		end

		if (points >= 0) then
			pluto.currency.tospawn[item.Player] = 1
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