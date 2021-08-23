--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local sprite = "particles/balloon_bit"

local function rand()
    return math.random() * 2 - 1
end

local function RandVector(spread)
    for i = 1, 1000 do
        local v = Vector(rand(), rand(), rand())
        if (v:LengthSqr() < 1) then
            return v * spread
        end
    end
    return vector_origin
end

local christmas_colors = {
    Color(255, 255, 255),
    Color(255, 50, 20),
    Color(50, 255, 20)
}

function EFFECT:Init(data)
    local pos = data:GetStart()
    local dir = data:GetOrigin() - pos
    local start_size = data:GetScale()
    dir:Normalize()
    local emitter = ParticleEmitter(pos, false)
    local flags = data:GetFlags()

    if (not IsValid(emitter)) then
        return
    end

    local speed = ({
        [0] = 100,
        [CONFETTI_GRENADE] = 250,
        [CONFETTI_SHOT] = 2000,
    })[bit.band(flags, 3)]

    local is_christmas = bit.band(flags, 4) == 4
    
    local endPoint = Vector(pos + dir * speed)

    for i = 1, data:GetMagnitude() * 100 do
        local particle = emitter:Add(sprite, pos)

        if particle then
            particle:SetLifeTime(0)
            if (is_grenade) then
                particle:SetDieTime(15 + math.random() * 5)
            else
                particle:SetDieTime(4)
            end
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(50)
            if (is_grenade) then
                particle:SetStartSize(math.random() * start_size / 2 + start_size / 2)
            else
                particle:SetStartSize(start_size)
            end
            particle:SetEndSize(0)
            particle:SetCollide(false)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(rand() * 2)
            if (is_grenade) then
                particle:SetAirResistance(50)
            else
                particle:SetAirResistance(50)
            end

            if (is_grenade) then
                particle:SetGravity(Vector(0, 0, -20))
            else
                particle:SetGravity(Vector(0, 0, -222))
            end
            local colour = HSVToColor(math.random() * 360, 1, 1)

            if (is_christmas) then
                colour = table.Random(christmas_colors)
            end
            particle:SetColor(colour.r, colour.g, colour.b)
            particle:SetLighting(false)
            particle:SetCollide(true)
            local r = RandVector(data:GetRadius())
            if (is_grenade) then
                r.z = r.z * 0.25
            end
            particle:SetVelocity(endPoint + r - pos)
        end
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end