local _net = net

co_net = co_net or {
	coroutines = {},
	max_packet = 0xfe00 * 8,
}

for _, index in pairs {
	"Angle",
	"Bit",
	"Bool",
	"Color",
	"Data",
	"Double",
	"Entity",
	"Float",
	"Int",
	"Matrix",
	"Normal",
	"String",
	"Table",
	"Type",
	"UInt",
	"Vector",
} do
	co_net["Write" .. index] = function(...)
		local wt = co_net.BitsWritten()
		if (wt > co_net.max_packet) then
			pprintf("Bits written: %u", wt)
			net = _net
			co_net.finish_fn()
			co_net.Start(co_net.CurrentMessage, co_net.finish_fn)
		end

		_net["Write" .. index](...)
	end

	co_net["Read" .. index] = function(...)
		local rd = co_net.BitsRead()
		if (rd > co_net.max_packet) then
			pprintf("Bits overflow: %u", rd)
			coroutine.yield()
		end

		return _net["Read" .. index](...)
	end
end

function co_net.BitsWritten()
	return select(2, _net.BytesWritten()) - co_net.BitsAtStart
end

function co_net.BitsRead()
	return co_net.BitsAtStartRead - select(2, _net.BytesLeft())
end

function co_net.Start(name, finish)
	co_net.CurrentMessage = name
	_net.Start(name)
	net = co_net

	co_net.BitsAtStart = select(2, _net.BytesWritten())
	co_net.finish_fn = finish
end

function co_net.Finish()
	net = _net
	co_net.finish_fn()
	co_net.CurrentMessage = nil
end

function co_net.Receive(name, fn)
	_net.Receive(name, function(len, cl)
		local co = co_net.coroutines[name]
		if (not co or coroutine.status(co) == "dead") then
			co = coroutine.create(fn)
			co_net.coroutines[name] = co
		end
		co_net.BitsAtStartRead = select(2, _net.BytesLeft())
		net = co_net
		local succ, err = coroutine.resume(co, len, cl)

		net = _net
		if (not succ) then
			error(err)
		end
	end)
end