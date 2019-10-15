local map_lookup = {
	ttt_innocentmotel_v1 = "285372790",
	["ttt_pluto_test.*"] = "1851705099",
	ttt_penitentiary = "1335770232",
	ttt_chaser_v2 = "109410344",
	ttt_magma_v2a  = "208061322",
	de_dolls = "821268438",
}

for k, wsid in pairs(map_lookup) do
	if (game.GetMap():match("^" .. k .. "$")) then
		resource.AddWorkshop(wsid)
		break
	end
end