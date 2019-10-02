pluto.db = pluto.db or {
	backlogs = {},
	queries = {},
	prepared = {},
}

local SHUTDOWN = false

local function err(...)
	pwarnf("DATABASE ERROR: %s\n%s", string.format(...), debug.traceback())
end


function pluto.db.query(query, args, cb, data, nostart)
	if (not pluto.db.db) then
		table.insert(pluto.db.backlogs, {"query", query, args, cb, data, nostart})
		return
	end

	local q

	if (not args) then
		q = pluto.db.db:query(query)
	else
		q = pluto.db.prepared[query]
		if (not q) then
			q = pluto.db.db:prepare(query)
			pluto.db.prepared[query] = q
		end

		for ind, arg in pairs(args) do
			if (type(arg) == "number") then
				q:setNumber(ind, arg)
			elseif (type(arg) == "string") then
				q:setString(ind, arg)
			elseif (type(arg) == "boolean") then
				q:setBoolean(ind, arg)
			else
				q:setNull(ind)
			end
		end

		q.oldstart = q.oldstart or q.start
		q.start = function(self, ...)
			q:oldstart(...)
			
			for ind, arg in pairs(args) do
				q:setNull(ind)
			end
		end

	end

	last = q

	function q:onAborted()
		err("abort")
		if (not cb) then
			return
		end

		cb("aborted", self)
	end

	function q:onError(e, sql)
		err("%s: %s", e, sql)
		if (not cb) then
			return
		end

		cb(e, self, sql)
	end

	function q:onSuccess(d)
		print "3?"
		if (not cb) then
			return
		end

		cb(nil, self, d)
	end

	if (data) then
		function q:onData(d)
			print "4?"
			data(self, d)
		end
	end

	if (not nostart) then
		q:start()
	end

	return q
end

function pluto.db.transact(queries, cb, nostart)
	if (not pluto.db.db) then
		table.insert(pluto.db.backlogs, {"transact", queries, cb, nostart})
		return
	end

	local transact = pluto.db.db:createTransaction()

	local start

	for i, query in ipairs(queries) do
		if (type(query) == "table") then
			query[5] = true -- nostart
			local old = query[3]
			query[3] = function(...)
				pprintf("Transaction query #%i: %.5f", i, SysTime() - start)
				if (old) then
					old(...)
				end
			end
			queries[i] = pluto.db.query(unpack(query, 1, 5))
		elseif (type(query) == "string") then
			queries[i] = pluto.db.query(query, nil, function(...)
				pprintf("Transaction query #%i: %.5f", i, SysTime() - start)
			end, nil, true)
		end

		transact:addQuery(queries[i])
	end

	function transact:onSuccess(...)
		print "5?"
		if (not cb) then
			return
		end

		cb(nil, self)
	end

	function transact:onError(e)
		err("%s", e)
		if (not cb) then
			return
		end

		cb(e, self)
	end

	start = SysTime()

	if (not nostart) then
		transact:start()
	end

	return transact, queries
end

function pluto.db.steamid64(obj)
	if (TypeID(obj) == TYPE_ENTITY) then
		return obj:SteamID64()
	end

	if (obj:StartWith "S") then
		obj = util.SteamIDTo64(obj)
	end

	if (not obj or obj == 0) then
		error("Bad object to convert to steamid: " .. tostring(obj))
	end

	return obj
end

hook.Add("PlutoDatabaseConnected", "pluto_backlogs", function()
	for _, cmd in ipairs(pluto.db.backlogs) do
		pluto.db[cmd[1]](unpack(cmd, 2))
	end

	pluto.db.backlogs = {}
end)

hook.Add("ShutDown", "pluto_save", function()
	SHUTDOWN = true
end)

return function(db)
	local connects = 0
	function db:onConnected()
		db:setCharacterSet "utf8mb4"
		pprintf("Database connected!")
		connects = connects + 1
		if (connects == 1) then
			hook.Run("PlutoDatabaseInitialize", db)
		end
		hook.Run("PlutoDatabaseConnected", db, connects)
	end

	function db:onConnectionFailed(err)
		pwarnf("Database disconnected. Reconnecting.")
		hook.Run("PlutoDatabaseConnectionFailed", err)
	end

	db:connect()

	pluto.db.db = db
end