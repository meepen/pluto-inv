local env = setmetatable({}, {__index = getfenv(0)})

local function handle_returns(success, ...)
	if (not success) then
		error(...)
	end

	return ...
end

local function handle_resume(success, err)
	if (not success) then
		print("ERROR IN RESUME", err)
	end
end

local function wait_promise(promise)
	local co = coroutine.running()
	print "WAITING"

	promise
		:next(function(...)
			handle_resume(coroutine.resume(co, true, ...))
		end)
		:catch(function(...)
			handle_resume(coroutine.resume(co, false, ...))
		end)

	return handle_returns(coroutine.yield())
end

function env.mysql_init(...)
	return wait_promise(select(2, mysql.connect(...)))
end

function env.mysql_query(db, query)
	return wait_promise(db:query(query))
end

function cmysql(func)
	setfenv(func, env)
	handle_resume(coroutine.resume(coroutine.create(func)))
end