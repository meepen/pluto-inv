pluto.inv = pluto.inv or {}

pluto.inv.messages = {
	cl2sv = {
		[0] = "end",
		[1] = "tabswitch",
		[2] = "itemdelete",
		[3] = "currencyuse",
		[4] = "tabrename",
	},
	sv2cl = {
		[0] = "end",
		[1] = "item",
		[2] = "mod",
		[3] = "tab",
		[4] = "status",
		[5] = "tabupdate",
		[6] = "currencyupdate",
	}
}

for k, v in pairs(pluto.inv.messages.cl2sv) do
	pluto.inv.messages.cl2sv[v] = k
end
for k, v in pairs(pluto.inv.messages.sv2cl) do
	pluto.inv.messages.sv2cl[v] = k
end

net.Receive("pluto_inv_data", function(len, cl)
	pprintf("Collecting %i bits of inventory data...", len)

	while (not pluto.inv.readmessage(cl)) do
	end
end)

function pluto.inv.readmessage(cl)
	local uid = net.ReadUInt(8)
	local id = (SERVER and pluto.inv.messages.cl2sv or pluto.inv.messages.sv2cl)[uid]

	if (id == "end") then
		pluto.inv.readend()
		return true
	end

	local fn = pluto.inv["read" .. id]

	if (not fn) then
		pwarnf("no function for %i", uid)
		return false
	end

	fn(cl)
end

local a = {
	__index = {
		write = function(self, what, ...)
			if (SERVER) then
				pluto.inv.send(self.Player, what, ...)
			else
				pluto.inv.send(what, ...)
			end
			return self
		end,
		send = function(self)
			self:write("end")
			if (SERVER) then
				net.Send(self.Player)
			else
				net.SendToServer()
			end
		end
	}
}

function pluto.inv.message(ply)
	net.Start "pluto_inv_data"

	return setmetatable({
		Player = ply
	}, a)
end