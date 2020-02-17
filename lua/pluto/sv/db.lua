local TRANSACT = {}
transact_mt = transact_mt or {
	__index = TRANSACT
}

function TRANSACT:AddQuery(query, args, cb, data)
	return self, self.transaction:addQuery(self.db.query(query, args, cb, data, true))
end

function TRANSACT:Halt()
	self.halt = true
	return self
end

function TRANSACT:AddCallback(cb)
	self.callbacks = self.callbacks or {}
	self.callbacks[#self.callbacks + 1] = cb
end

function TRANSACT:Run(_cb)
	local function cb(err, q)
		for _, fn in ipairs(self.callbacks or {}) do
			fn(err, q)
		end

		if (_cb) then
			_cb(err, q)
		end
	end

	function self.transaction:onSuccess(...)
		if (not cb) then
			return
		end

		cb(nil)
	end

	function self.transaction.onError(_, e)
		self.err("%s", e)
		if (not cb) then
			return
		end

		cb(e)
	end

	self.transaction:start()

	if (self.halt) then
		self.transaction:wait(true)
	end
	return self
end

return function(obj)
	local db = {
		queries = {},
		prepared = {},
		db = obj
	}

	local function err(...)
		pwarnf("DATABASE ERROR: %s\n%s", string.format(...), debug.traceback())
	end


	function db.query(query, args, cb, data, nostart)
		local q

		if (args) then
			q = db.prepared[query]
			if (not q) then
				q = db.db:prepare(query)
				db.prepared[query] = q
				q.args = {}
			elseif (q.args) then
				for ind in pairs(q.args) do
					q:setNull(ind)
				end
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

				q.args[ind] = true
			end
		else
			q = db.db:query(query)
		end

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
			if (not cb) then
				return
			end

			cb(nil, self, d)
		end

		if (data) then
			function q:onData(d)
				data(self, d)
			end
		end

		if (not nostart) then
			q:start()
		end

		return q
	end

	function db.transact()
		return setmetatable({
			transaction = db.db:createTransaction(),
			db = db,
			err = err
		}, transact_mt)
	end

	function db.transact_or_query(transact, ...)
		if (transact) then
			local _, q = transact:AddQuery(...)
			return q
		else
			return pluto.db.query(...)
		end
	end

	function db.steamid64(obj)
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

	return db
end