local sprite = "particles/balloon_bit"
local spread = 70
local count = 100

function EFFECT:Init(data)
    local pos = data:GetStart()
    local dir = data:GetOrigin() - pos
    dir:Normalize()
    local emitter = ParticleEmitter(pos, false)
    if not IsValid(emitter) then return end
    
    local endPoint = Vector(pos + dir * 100)

    for i = 1, count do
        local particle = emitter:Add(sprite, pos)

        if particle then
            particle:SetLifeTime(0)
            particle:SetDieTime(4)
            particle:SetStartAlpha(255)
            particle:SetEndAlpha(50)
            particle:SetStartSize(2)
            particle:SetEndSize(0)
            particle:SetCollide(false)
            particle:SetRoll(math.Rand(0, 360))
            particle:SetRollDelta(math.Rand(-2, 2))
            particle:SetAirResistance(100)
            particle:SetGravity(Vector(0, 0, -222))
            local colour = HSVToColor(math.random(0, 360), 1, 1)
            particle:SetColor(colour.r, colour.g, colour.b)
            particle:SetLighting(false)
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