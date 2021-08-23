--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

hook.Add("PlutoWebsocketMessage", "pluto_snake", function(json)
	if (json.type ~= "snake" or not json.response.auth) then
		return
	end

	local ply = player.GetBySteamID64(json.response.info.steamid)
	if (not IsValid(ply)) then
		return
	end

	pluto.inv.message(ply)
		:write("snakeauth", json.response.auth)
		:send()
end)

function pluto.inv.readgetsnakeauth(cl)
	pluto.WS:write(util.TableToJSON {
		type = "snake",
		what = "add",
		steamid = cl:SteamID64(),
		displayname = cl:Nick(),
		avatar = cl.AvatarURL,
	})

	local sid64 = cl:SteamID64()

	timer.Create("deletesnake_" .. sid64, 30, 1, function()
		pluto.WS:write(util.TableToJSON {
			type = "snake",
			what = "delete",
			steamid = sid64
		})
	end)
end

function pluto.inv.writesnakeauth(cl, auth)
	net.WriteString(auth)
end