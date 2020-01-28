local config = {
	db = {
		host = "45.76.27.165",
		username = "pluto",
		database = "pluto",
		password = "M34v@g#b&TrN",
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
				pprintf "Main database connected"
				hook.Run("PlutoDatabaseInitialize", db)
			elseif (connects > 1) then
				pprintf "Main database reconnected"
			end

			hook.Run("PlutoDatabaseConnected", db, connects)
		end

		function db:onConnectionFailed(err)
			pwarnf("Database disconnected: %s. Reconnecting.", err)
		end

		db:connect()
	end

	pluto.db_init = true
end