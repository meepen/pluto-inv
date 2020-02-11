local sprite = "particles/balloon_bit"

local function RandVector(spread)
    for i = 1, 1000 do
        local v = Vector(math.random(-spread, spread), math.random(-spread, spread), math.random(-spread, spread))
        if (v:LengthSqr() < spread * spread) then
            return v
        end
    end
    return vector_origin
end

function EFFECT:Init(data)
    local pos = data:GetStart()
    local dir = data:GetOrigin() - pos
    local start_size = data:GetScale()
    dir:Normalize()
    local emitter = ParticleEmitter(pos, false)
    if not IsValid(emitter) then return end
    
    local endPoint = Vector(pos + dir * 250)

    for i = 1, data:GetMagnitude() * 100 do
        local particle = emitter:Add(sprite, pos)

        if particle then
            particle:SetLifeTime(0)
            particle:SetDieTime(4)
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(50)
            particle:SetStartSize(start_size)
            particle:SetEndSize(0)
            particle:SetCollide(false)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-2, 2))
            particle:SetAirResistance(50)
            particle:SetGravity(Vector(0, 0, -222))
            local colour = HSVToColor(math.random(0, 360), 1, 1)
            particle:SetColor(colour.r, colour.g, colour.b)
            particle:SetLighting(false)
            particle:SetCollide(true)
            particle:SetVelocity(endPoint + RandVector(data:GetRadius()) - pos)
        end
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end