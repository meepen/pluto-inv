if (not pluto.db) then
	require "mysqloo"
	pluto.db = include "db.lua"(mysqloo.connect("paloma.meep.dev", "pluto", "M34v@g#b&TrN", "pluto"))
end