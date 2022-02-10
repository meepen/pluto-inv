AddCSLuaFile()

ENT.PrintName = "Barrier Grenade"
ENT.Base = "ttt_basegrenade"
ENT.Model = "models/weapons/w_eq_smokegrenade_thrown.mdl"
DEFINE_BASECLASS("pluto_len_basegrenade")

function ENT:Explode()


    local ent = ents.Create("prop_physics")
    if (not ent:IsValid()) then return end
    ent:SetModel("models/props_interiors/Furniture_shelf01a.mdl")
    local thrower = self:GetOwner()
    local grenadepos = self:GetPos()
    ent:SetPos(grenadepos + Vector(0,0,20))
    local ownangle = self:GetOwner():EyeAngles()
    local finangle = Angle(180,ownangle.y,90)
    ent:SetAngles(finangle)
    ent:DropToFloor()
    ent:Spawn()
    ent:GetPhysicsObject():EnableMotion(false)
    ent:SetHealth(300)
    self:FireBomb()
    sound.Play("pluto/pop.ogg", self:GetPos(), 75, 100, 1)
    self:Remove()
end


function ENT:GrenadeBounce()
    self:Explode()
end