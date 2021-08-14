pluto.scaling = pluto.scaling or 1

hook.Add("TTTUpdatePlayerSpeed", "PlutoScaling", function(ply, data)
    data.scaling = pluto.scaling
end)

net.Receive("PlutoScaling", function()
    pluto.scaling = math.max(net.ReadFloat(), 0.4)
end)