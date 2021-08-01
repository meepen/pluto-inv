local config = {
	db = {
		host = "108.61.81.41",
		username = "pluto",
		database = "pluto",
		password = "a*5E@KSbt?aJ5+^q", -- old: "IwE6&60b^z%h$EM9", new: "a*5E@KSbt?aJ5+^q",
		name = "Main",
		poolamount = 15
	},
}

include "mysql_pool.lua"
include "cmysql.lua"
pluto.pool = pool.create(config.db.poolamount, config.db.host, config.db.username, config.db.password, config.db.database)

timer.Create("pluto_pool_keepalive", 60, 0, function()
	pluto.pool:KeepAlive()	
end)

pluto.db = pluto.db or {}

function pluto.db.steamid64(obj)
	if (TypeID(obj) == TYPE_ENTITY) then
		return obj:SteamID64()
	end

	if (type(obj) == "string" and obj:StartWith "S") then
		obj = util.SteamIDTo64(obj)
	end

	if (not obj) then
		error("Bad object to convert to steamid: " .. tostring(obj))
	end

	return obj
end

local function noop() end

function pluto.db.simplequery(query, params, onfinish)
	onfinish = onfinish or noop

	local ret = pluto.db.instance(function(db)
		onfinish(mysql_stmt_run(db, query, unpack(params, 1, params.n)))
	end)
	
	return ret
end


--[[
	pluto.db.instance(function(db)
		-- cmysql bindings
	end)
]]
function pluto.db.instance(fn)
	local callbacks = {}

	function callbacks:AddCallback(fn)
		table.insert(self, fn)
	end

	pluto.pool:Request(function(db)
		cmysql(function()
			fn(db)
		end,
		function()
			pluto.pool:Return(db)
			for _, callback in ipairs(callbacks) do
				callback()
			end
		end)
	end)

	return callbacks
end


--[[
	pluto.db.transact(function(db)
		-- cmysql bindings
	end)
]]

function pluto.db.transact(fn)
	local callbacks = {}

	function callbacks:AddCallback(fn)
		table.insert(self, fn)
	end

	pluto.pool:Request(function(db)
		cmysql(function()
			mysql_autocommit(db, false)
			fn(db)
		end, function()
			local function finish()
				pluto.pool:Return(db)
				for _, callback in ipairs(callbacks) do
					callback()
				end
			end
			local function cont()
				db:autocommit(true):next(finish):catch(finish)
			end
			db:rollback():next(cont):catch(cont)
		end)
	end)

	return callbacks
end

hook.Add("Initialize", "pluto_database", function()
	hook.Run "PlutoDatabaseInitialize"
end)
