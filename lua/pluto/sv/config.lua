if (not pluto.db_init) then
	require "mysqloo"
	include "db.lua"(mysqloo.connect("45.76.27.165", "pluto", "M34v@g#b&TrN", "pluto"))
	pluto.db_init = true
end