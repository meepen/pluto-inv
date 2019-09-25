require "mysqloo"
pluto.db = pluto.db or include "db.lua"(mysqloo.connect("paloma.meep.dev", "pluto", "M34v@g#b&TrN", "pluto"))