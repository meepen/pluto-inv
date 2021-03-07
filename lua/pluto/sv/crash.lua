local t = SysTime
local update_time = 0.2
local last_update = t()

hook.Add("Tick", "pluto_crash_timer", function()
	if (last_update + update_time > t()) then
		return
	end

	SetGlobalInt("pluto_crash_time", GetGlobalInt("pluto_crash_time", 0) + 1)

	last_update = t()
end)