local sv_visiblemaxplayers = GetConVar "sv_visiblemaxplayers"

hook.Add("CheckPassword", "pluto_maxplayers", function(sid64, ipaddr, svpwd, clpwd)
	if (sv_visiblemaxplayers:GetInt() == -1 or sv_visiblemaxplayers:GetInt() > player.GetCount()) then
		return
	end

	pluto.db.simplequery("SELECT rank FROM pluto_player_info WHERE steamid = ?", {sid64}, function(d, err)
		if (not d) then
			return
		end

		local rank = d[1] and d[1].rank or "user"

		if (not admin.hasperm(rank, "bypass_max")) then
			game.KickID(util.SteamIDFrom64(sid64), "Could not connect - server is full.")
		end
	end)
end)
