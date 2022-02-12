AddCSLuaFile()

ENT.PrintName = "Cage Grenade"
ENT.Base = "pluto_len_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"
DEFINE_BASECLASS("pluto_len_basegrenade")

function ENT:Explode()


    local cases = {
        [1] = Vector(60,0,55),
        [2] = Vector(0,60,55),
        [3] = Vector(-60,0,55),
        [4] = Vector(0,-60,55)
    }

    local angles = {
        [1] = Angle(1,0,0),
        [2] = Angle(1,90,0),
        [3] = Angle(1,0,0),
        [4] = Angle(1,270,0)
    }

    for i = 1,4,1 do
        local ent = ents.Create("prop_physics")
        if (not ent:IsValid()) then return end
        ent:SetModel("models/props_c17/fence02b.mdl")
        local thrower = self:GetOwner()
        local grenadepos = self:GetPos()
        ent:SetPos(grenadepos + cases[i])
        local ownangle = self:GetOwner():EyeAngles()
        local finangle = angles[i]
        ent:SetAngles(finangle)
        ent:DropToFloor()
        ent:Spawn()
        ent:GetPhysicsObject():EnableMotion(false)
        timer.Simple(3, function()
            if ent:IsValid() then
            ent:Remove()
            end
        end)
    end
    self:FireBomb()
    sound.Play("pluto/pop.ogg", self:GetPos(), 75, 100, 1)
end