pluto.currency.shares = 0

for name, values in pairs {
	dice = {
		Shares = 700,
		Use = function(item)
		end,
	},
	droplet = {
		Shares = 5000,
		Use = function(item)
		end,
	},
	hand = {
		Shares = 400,
		Use = function(item)
		end,
	},
	tome = {
		Shares = 300,
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
		Use = function(item)
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

for _, nav in pairs(navmesh.GetAllNavAreas()) do
	local dist = nav:GetCorner(2):Distance(nav:GetCorner(0))

	table.insert(pluto.currency.navs, {
		Size = dist,
		Nav = nav
	})

	pluto.currency.navs.total = pluto.currency.navs.total + dist
end

function pluto.currency.randompos()
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
			--continue
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

concommand.Add("pluto_spawn_cur", function(ply)
	local pos = ply:GetEyeTrace().HitPos

	pluto.currency.spawnfor(ply, "droplet", pos)
end)