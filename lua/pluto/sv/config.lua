local config = {
	db = {
		host = "45.76.27.165",
		username = "pluto",
		database = "pluto",
		password = "IwE6&60b^z%h$EM9",
		name = "Main",
	},
}

if (not pluto.db_init) then
	require "mysqloo"
	local init = include "db.lua"

	for k, info in pairs(config) do
		local db = mysqloo.connect(info.host, info.username, info.password, info.database)
		pluto[k] = init(db)

		local connects = 0
		function db:onConnected()
			db:setCharacterSet "utf8mb4"

			connects = connects + 1
			if (connects == 1) then
				pprintf("%s database connected", info.name)
				hook.Run("PlutoDatabaseInitialize", db)
			elseif (connects > 1) then
				pprintf("%s database reconnected", info.name)
			end

			hook.Run("PlutoDatabaseConnected", db, connects)
		end

		function db:onConnectionFailed(err)
			pwarnf("%s Database disconnected: %s. Reconnecting.", info.name, err)
		end

		db:connect()
	end

	pluto.db_init = true
end
