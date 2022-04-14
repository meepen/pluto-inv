--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]

--[[Player Scaling By Addi--]]

-- Holds everything in the addon
playerscaling = playerscaling or {}
-- Keeps track of which players are currently scaled
playerscaling.players = playerscaling.players or {}
-- Keeps track of which players are currently being scaled
playerscaling.lerp = playerscaling.lerp or {}

-- Scaling size to speed 1:1 doesn't feel natural, so here's a custom conversion
-- Only shared for pluto 
function playerscaling.getspeedmult(scale)
    if scale > 1 then -- Speeds players up less
        return 1 + (scale - 1) * 0.5
    else -- Slows players less
        return 1 - (1 - scale) * 0.8
    end
end

-- Gravity isn't predicted, so we simulate it by adding velocity each tick
local interval = engine.TickInterval()
hook.Add("Tick", "playerscaling_tickshared", function()
    -- Cycles through each currently scaled player
    for ply, info in pairs(playerscaling.players) do
        -- Skip gravity on invalid, dead, and grounded players
        if not IsValid(ply) or not ply:Alive() or ply:IsOnGround() then
            continue
        end

        -- Gets scale and skips unscaled players
        local scale = info.scale
        if not scale or scale == 1 then
            continue
        end

        -- Gravity affects everything the same so this is really more about simulating air resistance
        if scale > 1 then -- Increase acceleration for large players
            ply:SetVelocity(Vector(0, 0, interval * -200 * scale))
        else -- Decrease acceleration for small players
            ply:SetVelocity(Vector(0, 0, interval * math.min(500, 500 * (1 - scale)))) -- math.max prevents players from floating
        end
    end
end)

-- Handles player speed pluto-style
hook.Add("TTTUpdatePlayerSpeed", "playerscaling_plutospeed", function(ply, data)
    if not IsValid(ply) or not playerscaling.players[ply] or not playerscaling.players[ply].jump then
        return
    end

    -- Get scale, skip if none or 1
    local scale = playerscaling.players[ply].scale
    if not scale or scale == 1 then
        return
    end

    data.playerscaling = playerscaling.getspeedmult(scale)
end)