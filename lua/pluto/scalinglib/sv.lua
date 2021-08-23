--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
util.AddNetworkString "PlutoScaling"

pluto.scaling = pluto.scaling or {}

--[[Not functional
--hook.Add("PlayerRagdollCreated", "PlutoScaling", function(ply, rag)
    timer.Simple(1, function()
    print("PlayerRagdollCreated", ply, rag)

    if (not IsValid(ply) or not IsValid(rag) or not pluto.scaling[ply]) then
        print("Returning from PlayerRagdollCreated")
        return
    end

    rag:SetModelScale(pluto.scaling[ply].Scale)
    end)
end)--]]

hook.Add("TTTUpdatePlayerSpeed", "PlutoScaling", function(ply, data)
    if (not pluto.scaling[ply] or not pluto.scaling[ply].Speed) then
        return 
    end
    
    data.scaling = math.max(pluto.scaling[ply].Scale, 0.4)
end)

hook.Add("PlayerDeath", "PlutoScaling", function(ply)
    if (not pluto.scaling[ply] or not pluto.scaling[ply].Death) then
        return
    end

    pluto.scaling.reset(ply)
end)

function pluto.scaling.set(ply, scale, do_speed, do_death_reset)
    if (not IsValid(ply)) then
        return
    end

    if (scale == 1) then
        pluto.scaling.reset(ply)
        return
    end

    if (pluto.scaling[ply]) then
        pluto.scaling.reset(ply)
    end

    ply:SetModelScale(scale)
    ply:SetViewOffset(ply:GetViewOffset() * scale)
    ply:SetViewOffsetDucked(ply:GetViewOffsetDucked() * scale)

    if (do_jump) then
        ply:SetJumpPower(ply:GetJumpPower() * scale)
    end

    if (do_speed) then
        net.Start "PlutoScaling"
            net.WriteFloat(scale)
        net.Send(ply)
    end

    pluto.scaling[ply] = {
        Scale = scale,
        Speed = do_speed,
        Jump = do_jump,
        Death = do_death_reset,
    }
end

function pluto.scaling.get(ply)
    return pluto.scaling[ply] and pluto.scaling[ply].Scale or 1
end

function pluto.scaling.reset(ply)
    if (not IsValid(ply) or not pluto.scaling[ply]) then
        return
    end

    ply:SetModelScale(1)
    ply:SetViewOffset(ply:GetViewOffset() / pluto.scaling[ply].Scale)
    ply:SetViewOffsetDucked(ply:GetViewOffsetDucked() / pluto.scaling[ply].Scale)

    if (pluto.scaling[ply].Jump) then
        ply:SetJumpPower(ply:GetJumpPower() / pluto.scaling[ply].Scale)
    end

    if (pluto.scaling[ply].Speed) then
        net.Start "PlutoScaling"
            net.WriteFloat(pluto.scaling[ply].Scale)
        net.Send(ply)
    end

    pluto.scaling[ply] = nil
end