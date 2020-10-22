include "promise.lua"
require "gluamysql"

-- hijack think thing
RunConsoleCommand("sv_hibernate_think", GetConVar "sv_hibernate_think":GetInt() + 1)

pool = pool or {}

pool.mt = pool.mt or {
	__index = {}
}

local MT = pool.mt.__index

function MT:Request(request)
	if (#self.connections > 0) then
		local db = self.connections[1]
		table.remove(self.connections, 1)

		self.statuses[db] = request
		request(db)
	else
		table.insert(self.requests, request)
	end
end

function MT:Return(db)
	self.statuses[db] = nil

	if (#self.requests > 0) then
		local request = self.requests[1]
		table.remove(self.requests, 1)

		self.statuses[db] = request
		request(db)
	else
		table.insert(self.connections, db)
	end
end

function MT:KeepAlive()
	while (#self.connections > 0) do
		self:Request(function(db)
			db:ping():next(function()
				self:Return(db)
			end)
		end)
	end
end

function pool.create(amount, ...)
	local ret = setmetatable({
		connections = {},
		requests = {},
		statuses = {},
	}, pool.mt)

	for i = 1, amount do
		mysql.connect(...)
			:next(function(db)
				db:autocommit(true):next(function()
					db:query("SET CHARACTER SET utf8mb4"):next(function()
						ret:Return(db)
					end):catch(function(e)
						ErrorNoHalt("Couldn't set character set: " .. e)
					end)
				end):catch(function(e)
					ErrorNoHalt("Couldn't autocommit: " .. e)
				end)
			end)
			:catch(function(e)
				ErrorNoHalt("Couldn't connect to pool: " .. e)
			end)
	end

	return ret
end