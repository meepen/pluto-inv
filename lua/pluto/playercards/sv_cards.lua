--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
function pluto.inv.readplayercardreq(requester)
	local ply = net.ReadEntity()
	pluto.db.simplequery("SELECT time_played FROM pluto_player_info WHERE steamid = ?", {ply:SteamID64()}, function(d)
		local playtime
		if (d["AFFECTED_ROWS"] != 0) then
			playtime = d[1].time_played
		else
			playtime = 0
		end

		pluto.inv.message(requester)
			:write("playercardinfo", ply, playtime)
		:send()
	end)
	
end

function pluto.inv.writeplayercardinfo(requester, target, playtime)
	net.WriteUInt(playtime, 32)
end