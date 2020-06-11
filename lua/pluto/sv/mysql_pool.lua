require "gluamysql"

include "pluto/sv/cmysql.lua"

pool = pool or {}

pluto.mt = pluto.mt or {
	__index = {}
}

local MT = pluto.mt.__index

function MT:Request(request)
	if (#self.connections > 0) then
		local db = self.connections[1]
		table.remove(self.connections, 1)

		self.statuses[db] = request
		return cmysql(function() fn(db) end)
	else
		table.insert(self.requests, request)
	end
end

function MT:Return(db)
	self.statuses[db] = nil

	if (#self.requests > 0) then
		local request = self.request[1]
		table.remove(self.request, 1)

		self.statuses[db] = request
		return cmysql(function() request(db) end)
	else
		table.insert(self.connections, db)
	end
end

function pool.create(amount, ...)
	local ret = setmetatable({
		connections = {},
		requests = {},
		statuses = {},
	}, MT)

	for i = 1, amount do
		mysql.connect(...)
			:next(function(db)
				ret:Return(db)
			end)
			:catch(function(e)
				ErrorNoHalt("Couldn't connect to pool: " .. e)
			end)
	end

	return ret
end