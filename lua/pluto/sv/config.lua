if (not pluto.db_init) then
	require "mysqloo"
	include "db.lua"(mysqloo.connect("paloma.meep.dev", "pluto", "M34v@g#b&TrN", "pluto"))
	pluto.db_init = true
end