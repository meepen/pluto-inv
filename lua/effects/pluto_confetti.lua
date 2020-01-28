local sprite = "particles/balloon_bit"
local spread = 50
local count = 50

function EFFECT:Init(data)
    local pos = data:GetOrigin()
    local dir = data:GetNormal()
    local emitter = ParticleEmitter(pos, false)
    if not IsValid(emitter) then return end
    local endPoint = Vector(pos + dir * 100)

    for i = 1, count do
        local particle = emitter:Add(sprite, pos)

        if particle then
            particle:SetLifeTime(0)
            particle:SetDieTime(1)
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(50)
            particle:SetStartSize(2)
            particle:SetEndSize(2)
            particle:SetCollide(false)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-2, 2))
            particle:SetAirResistance(100)
            particle:SetGravity(Vector(0, 0, -5))
            local colour = HSVToColor(math.random(0, 360), 1, 1)
            particle:SetColor(colour.r, colour.g, colour.b)
            particle:SetLighting(true)
            particle:SetCollide(true)
            particle:SetVelocity(endPoint + Vector(math.random(-spread, spread), math.random(-spread, spread), math.random(-spread, spread)) - pos)
        end
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end