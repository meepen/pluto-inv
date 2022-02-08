AddCSLuaFile()

ENT.PrintName = "Barrel Grenade"
ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"

function ENT:Explode()

    local ent = ents.Create("prop_physics")
    if (not ent:IsValid()) then return end
    ent:SetModel("models/props_c17/oildrum001_explosive.mdl")
    local thrower = self:GetOwner()
    local grenadepos = self:GetPos()
    ent:SetPos(grenadepos)
    local ownangle = self:GetOwner():EyeAngles()
    ent:SetOwner(self:GetOwner())
    ent:DropToFloor()
    ent:Spawn()
    ent:SetHealth(1)
    sound.Play("pluto/pop.ogg", self:GetPos(), 75, 100, 1)
    self:Remove()
end


function ENT:GrenadeBounce()
    self:Explode()
end