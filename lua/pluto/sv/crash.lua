--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local t = SysTime
local update_time = 0.2
local last_update = t()

hook.Remove("Tick", "pluto_crash_timer", function()
	if (last_update + update_time > t()) then
		return
	end

	SetGlobalInt("pluto_crash_time", GetGlobalInt("pluto_crash_time", 0) + 1)

	last_update = t()
end)