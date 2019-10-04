pluto.inv = pluto.inv or {}

pluto.inv.messages = {
	cl2sv = {
		[0] = "end",
	},
	sv2cl = {
		[0] = "end",
		[1] = "item",
		[2] = "mod",
		[3] = "tab",
		[4] = "status",
		[5] = "tabupdate"
	}
}

for k, v in pairs(pluto.inv.messages.cl2sv) do
	pluto.inv.messages.cl2sv[v] = k
end
for k, v in pairs(pluto.inv.messages.sv2cl) do
	pluto.inv.messages.sv2cl[v] = k
end