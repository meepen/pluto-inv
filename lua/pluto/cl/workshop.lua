local downloads = {
	"20191113",
}
local fname = "pluto_" .. downloads[1] .. ".dat"

for i = 2, #downloads do
	file.Delete("pluto_" .. downloads[i] .. ".dat")
end

local function mount()
	local succ, fs = game.MountGMA("data/" .. fname)

	if (not succ) then
		print "couldn't mount addon"
	end
end

if (not file.Exists(fname, "DATA")) then
	http.Fetch("https://pluto.gg/datastore/content.gma", function(b)
		file.Write(fname, b)
		mount()
	end)
else
	mount()
end