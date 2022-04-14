--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

--[[Player Scaling By Addi
    
    This file contains serverside functions

    playerscaling.setscale(ply, scale, dospeed, dojump, length) is the function you can use to scale players in code
    playerscaling.multiplyscale(ply, mult, dospeed, dojump, length) lets you multiply the current or target scale--]]

-- Communicates scaling to players
util.AddNetworkString("playerscaling")

-- Player console command to scale themselves
concommand.Add("playerscale", function(ply, cmd, args)
    if not pluto.cancheat(ply) then
        return
    end

    playerscaling.setscale(ply, unpack(args))
end, nil, "Set your size multiplier. Other arguments are true/false for scale speed, scale jump")

-- Player command to multiply their scale
concommand.Add("playerscalemult", function(ply, cmd, args)
    if not pluto.cancheat(ply) then
        return
    end

    playerscaling.multiplyscale(ply, unpack(args))
end, nil, "Multiply your scale. Other arguments are true/false for scale speed, scale jump")

-- Moved getspeedmult to shared since it's needed for pluto

-- Scaling size to jump 1:1 doesn't feel natural, so here's a custom conversion
local function getjumpmult(scale)
    if scale > 1 then -- Upward jump scaling seems fine so far
        return 1 + (scale - 1) * 1
    else -- Lowers jump power less
        return 1 - (1 - scale) * 0.6
    end
end

-- Scaling step size 1:1 feels good except for when you're scaled down
local function getstepmult(scale)
    return (math.max(scale, 0.25))
end

-- Sets player scale. You can use this function when scaling players via code.
function playerscaling.setscale(ply, scale, dospeed, dojump, length)
    if not IsValid(ply) then
        return "Failed to scale: Invalid player"
    end

    -- Not used internally. Use the hook, returning true with an optional reason if you want to prevent scaling
    local preventscale, reason = hook.Run("playerscaling_preventscale", ply, scale, dospeed, dojump, length)
    if preventscale then
        return reason or "Failed to scale: Hook playerscaling_preventscale returned true"
    end

    -- Interrupt if already scaling
    if playerscaling.lerp[ply] then
        playerscaling.finish(ply, playerscaling.lerp[ply], "interrupted")
    end

    -- Overrides for default values
    dospeed = dospeed and tobool(dospeed) or true
    dojump = dojump and tobool(dojump) or true
    
    -- Get old scale values if there are any, or use mirrored values
    local old = table.Copy(playerscaling.players[ply]) or {
        scale = 1,
        speed = dospeed,
        jump = dojump,
    }

    -- If no old.scale was set for some reason
    old.scale = old.scale or 1

    -- Gets scale and returns if there are no changes
    scale = math.Clamp(tonumber(scale) or 1, 0.01, 25)
    if old.scale == scale and old.speed == dospeed and old.jump == dojump and old.view == playerscaling.doview then
        return "Failed to scale: Values unchanged"
    end

    -- Prepare scales. Divides the new scale by the old scale so that we can Lerp straight from the current scale to the target scale without having to reset to 1 first.
    local jumpscale = (dojump and getjumpmult(scale) or 1) / (old.jump and getjumpmult(old.scale) or 1)
    local viewscale = scale / old.scale
    local stepscale = getstepmult(scale) / getstepmult(old.scale)

    -- Sets up the lerp
    local shrinking = old.scale > scale
    local ratio = math.Clamp(shrinking and old.scale / scale or scale / old.scale, 0, 3)
    local length = length or ratio * math.max(shrinking and 0.2 or 0.3, 0.001)

    -- Overrides length if shrinking really small
    if shrinking and old.scale < 1.25 and scale < 0.75 then
        length = length / 1.5
    end
    
    -- Overrides length if player is dead
    if not ply:Alive() then
        length = 0
    end

    -- Saves the new scale information
    playerscaling.players[ply] = {
        speed = dospeed,
        jump = dojump,
    }

    -- Initializes the lerp. This will automatically be executed by the Tick hook in sh_init.lua
    playerscaling.lerp[ply] = {
        -- Lerp details
        alive = ply:Alive(),
        starttime = CurTime(),
        endtime = CurTime() + length,

        -- Prepare old values for the Lerp
        oldscale = old.scale,
        oldjump = ply:GetJumpPower(),
        oldview = ply:GetViewOffset(),
        oldviewducked = ply:GetViewOffsetDucked(),
        oldstep = ply:GetStepSize(),

        -- Prepare new values for the Lerp
        newscale = scale,
        newjump = ply:GetJumpPower() * jumpscale,
        newview = ply:GetViewOffset() * viewscale,
        newviewducked = ply:GetViewOffsetDucked() * viewscale,
        newstep = ply:GetStepSize() * stepscale,
    }

    -- Sends the player the updated scale
    net.Start("playerscaling")
        net.WriteFloat(scale)
        net.WriteFloat(length)
    net.Send(ply)

    return "Succeeded to scale"
end

-- Lets you multiply a player's current scale (or target scale if they're in the middle of a lerp)
function playerscaling.multiplyscale(ply, mult, dospeed, dojump, length)
    if not IsValid(ply) or not ply:Alive() then
        return
    end

    -- Gets the player's target scale or their current scale if no lerp
    local info = playerscaling.lerp[ply]
    local scale = info and info.newscale or ply:GetModelScale()

    -- Setscale takes care of the rest of it
    return playerscaling.setscale(ply, scale * mult, dospeed, dojump, length)
end

-- Mark the scaling as finished
function playerscaling.finish(ply, info, reason)
    if not IsValid(ply) then
        return
    end

    -- Not used in this addon but may be useful in implementation
    hook.Run("playerscaling_finish", ply, table.Copy(info), reason or "unknown")

    -- Stop the scaling
    playerscaling.lerp[ply] = nil
end

-- Negates fall damage for certain scaled up players
hook.Add("GetFallDamage", "playerscaling_fall", function(ply, speed)
    if not IsValid(ply) or not playerscaling.players[ply] then
        return
    end

    -- Negates fall damage for large players under a certain speed
    local scale = playerscaling.players[ply].scale or 1
    if speed < 250 * (1 + scale) then
        return 0
    end
end)

-- Utility function to check if the player will fit in a given spot
local function playerwillfit(ply, pos, scale)
    if not IsValid(ply) then
        return
    end

    -- Use defaults for these if they weren't provided in the function call
    pos = pos or ply:GetPos()
    scale = scale or ply:GetModelScale()
    
    local tr = {
        start = pos,
        endpos = pos,
        filter = ply,
        mins = 1 * scale * Vector(-16, -16, 0),
        maxs = 1 * scale * Vector(16, 16, ply:Crouching() and 36 or 72),
        mask = MASK_PLAYERSOLID,
    }
    local trace = util.TraceHull(tr)

    -- If they will, see if they can be moved away
    if trace.Hit then
        return false
    end

    return true
end

-- Used in Lerping 
local interval = engine.TickInterval()

-- Lerps the scale servside to scale players up and down
hook.Add("Tick", "playescaling_tickserver", function()
    -- Attempt to scale players
    for ply, info in pairs(playerscaling.lerp) do
        if not IsValid(ply) then
            continue
        end

        -- Not used internally. Use the hook, returning true with an optional reason if you want to pause scaling
        local pausescale = hook.Run("playerscaling_pausescale", ply, info)
        if pausescale then
            continue
        end

        -- If the player dies while scaling it needs to end
        if ply:Alive() ~= info.alive then
            playerscaling.finish(ply, info, "death")

            -- Reset scale on death
            playerscaling.setscale(ply, 1)

            continue
        end

        -- Get the proportional progress for the lerp
        local progress = (CurTime() - info.starttime) / math.max((info.endtime - info.starttime), 0.001)
        local newscale = info.newscale
        local oldscale = info.oldscale

        -- Gets the current step and next step of scaling
        local curscale = ply:GetModelScale()
        local nextscale = Lerp(progress, oldscale, newscale)

        -- If the player is growing, alive, and not noclipping, we need to avoid clipping
        if curscale < nextscale and ply:Alive() and ply:GetMoveType() ~= MOVETYPE_NOCLIP then
            -- See if they are going to clip anything
            local pos = ply:GetPos()
            if not playerwillfit(ply, pos, nextscale) then
                -- If they will clip in their current position, see if we can move them 
                local scalediff = nextscale - curscale
                local horidiff = 16 * scalediff
                local vertdiff = (ply:Crouching() and 36 or 72) * scalediff

                -- Check each direction for obstruction with the old scale
                local xpos = playerwillfit(ply, pos + Vector(horidiff, 0, 0), curscale)
                local xneg = playerwillfit(ply, pos - Vector(horidiff, 0, 0), curscale)
                local ypos = playerwillfit(ply, pos + Vector(0, horidiff, 0), curscale)
                local yneg = playerwillfit(ply, pos - Vector(0, horidiff, 0), curscale)
                local zpos = playerwillfit(ply, pos + Vector(0, 0, vertdiff), curscale)
                local zneg = playerwillfit(ply, pos - Vector(0, 0, vertdiff), curscale)

                -- Ends the lerp early if any direction fails both ways
                if not (xpos or xneg) or not (ypos or yneg) or not (zpos or zneg) then
                    info.starttime = info.starttime + interval
                    info.endtime = info.endtime + interval
                    continue
                end

                -- Otherwise, we can likely move the player
                local xoff = (xpos and xneg and 0) or (xpos and 1) or -1
                local yoff = (ypos and yneg and 0) or (ypos and 1) or -1
                local zoff = (zpos and 0) or -1
                local newpos = pos + Vector(xoff * 16 * scalediff, yoff * 16 * scalediff, zoff * (ply:Crouching() and 36 or 72) * scalediff)

                -- If the new position works, move the player
                if playerwillfit(ply, newpos, nextscale) then
                    ply:SetPos(newpos)
                else -- Otherwise, pause
                    info.starttime = info.starttime + interval
                    info.endtime = info.endtime + interval
                    continue
                end
            end
        end

        -- Successfully scale the player
        playerscaling.players[ply].scale = nextscale
        ply:SetModelScale(nextscale)
        ply:SetJumpPower(Lerp(progress, info.oldjump, info.newjump))
        ply:SetViewOffset(Lerp(progress, info.oldview, info.newview))
        ply:SetViewOffsetDucked(Lerp(progress, info.oldviewducked, info.newviewducked))
        ply:SetStepSize(Lerp(progress, info.oldstep, info.newstep))

        -- For some reason this has to be manual or player view switches to standing
        if ply:Crouching() then
            ply:SetCurrentViewOffset(ply:GetViewOffsetDucked())
        end

        -- End the lerp
        if progress >= 1 then
            -- Occasionally players will get stuck in the final tick of the Lerp, so this will get them unstuck
            if not playerwillfit(ply, ply:GetPos(), ply:GetModelScale()) and ply:Alive() and ply:GetMoveType() ~= MOVETYPE_NOCLIP then
                playerscaling.setscale(ply, info.newscale * 0.95, info.dospeed, info.dojump, 0)
                continue
            end

            playerscaling.finish(ply, info, "complete")
            continue
        end
    end
end)

-- Resets player scaling on death
hook.Add("PlayerDeath", "playerscaling_death", function(ply, inf, att)
    if not IsValid(ply) or (playerscaling.lerp[ply]) then
        return
    end

    local info = playerscaling.players[ply]
    if info then
        playerscaling.setscale(ply, 1)
    end
end)

-- Reset player scaling after round
hook.Add("TTTEndRound", "playerscaling_reset", function()
    for ply, info in pairs(playerscaling.players) do
        if (not IsValid(ply)) then
            continue
        end

        playerscaling.setscale(ply, 1)
    end
end)