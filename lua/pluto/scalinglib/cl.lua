--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
pluto.scaling = pluto.scaling or 1

hook.Add("TTTUpdatePlayerSpeed", "PlutoScaling", function(ply, data)
    data.scaling = pluto.scaling
end)

net.Receive("PlutoScaling", function()
    pluto.scaling = math.max(net.ReadFloat(), 0.4)
end)