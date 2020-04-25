local config = {
	db = {
		host = "158.69.22.195",
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

		hook.Add("CheckPassword", "pluto_db_" .. tostring(db), function()
			if (player.GetCount() == 0) then
				db:ping()
			end
		end)
	
		hook.Add("TTTPrepareRound", "pluto_db_" .. tostring(db), function()
			if (player.GetCount() == 0) then
				db:ping()
			end
		end)
	end

	pluto.db_init = true
end

if (not gay) then
	---gay = true
	return
end

require "gluamysql"

local new_db = mysql.connect(
	config.db.host,
	config.db.username,
	config.db.password,
	config.db.database
)

hook.Add("MySQLConnection", "test", function(db, err)
	print("CONNECTO STATUSO", db, err)
end)

local query = new_db:query "SELECT 1"

function query:OnError(p)
	print("QUERY ERROR", p)
end

function query:OnData(data)
	print "QUERY DATA-O"
	PrintTable(data)
end

function query:OnFinish(data)
	print "QUERY FINISHO"
	PrintTable(data)
end

query:run()

print(query.OnFinish)