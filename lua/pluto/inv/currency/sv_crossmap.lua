--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
sql.Query "CREATE TABLE IF NOT EXISTS pluto_currency_crossmap (steamid BIGINT UNSIGNED NOT NULL, currency VARCHAR(32) NOT NULL, amount INT UNSIGNED NOT NULL DEFAULT 0, PRIMARY KEY(steamid, currency))"

pluto.currency = pluto.currency or {}

if (not pluto.currency.restored) then
	local q = sql.Query "SELECT * FROM pluto_currency_crossmap" or {}
	
	pluto.currency.restored = {}

	for _, data in pairs(q) do
		local plylist = pluto.currency.restored[data.steamid]
		if (not plylist) then
			plylist = {}
			pluto.currency.restored[data.steamid] = plylist
		end

		plylist[data.currency] = tonumber(data.amount)
	end

	sql.Query "DELETE FROM pluto_currency_crossmap WHERE 1"
end

hook.Add("ShutDown", "pluto_currency_crossmap", function()
	local list = {}
	for ent, ply in pairs(pluto.currency.spawned) do
		if (not IsValid(ent) or not IsValid(ply) or ply:IsBot()) then
			continue
		end

		if (ent.SkipCrossmap) then
			continue
		end

		local plylist = list[ply]
		if (not plylist) then
			plylist = {}
			list[ply] = plylist
		end

		local cur = ent:GetCurrencyType()

		plylist[cur] = (plylist[cur] or 0) + 1
	end

	for _, ply in pairs(player.GetAll()) do
		local spawns = pluto.currency.tospawn[ply]
		if (spawns) then
			list[ply] = list[ply] or {}

			list[ply].spawns = math.ceil(spawns)
		end
	end

	sql.Begin()
	for ply, list in pairs(list) do
		for currency, amount in pairs(list) do
			sql.Query("INSERT INTO pluto_currency_crossmap (steamid, currency, amount) VALUES (" .. ply:SteamID64() .. ", " .. sql.SQLStr(currency) .. ", " .. amount .. ")")
		end
	end
	sql.Commit()
end)

hook.Add("PlayerAuthed", "pluto_currency_crossmap", function(ply)
	local list = pluto.currency.restored[ply:SteamID64()]

	if (list) then
		pluto.currency.restored[ply:SteamID64()] = nil

		for currency, amount in pairs(list) do
			if (currency == "spawns") then
				pluto.currency.tospawn[ply] = (pluto.currency.tospawn[ply] or 0) + amount
				continue
			end
			for i = 1, amount do
				local curr = pluto.currency.spawnfor(ply, currency)
				curr:SetDieRound(ttt.GetRoundNumber() + 3)
			end
		end
	end
end)
