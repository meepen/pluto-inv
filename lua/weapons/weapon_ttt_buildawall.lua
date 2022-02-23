AddCSLuaFile()
SWEP.Base                   = "weapon_tttbase"

DEFINE_BASECLASS "weapon_tttbase"

SWEP.HoldType               = "pistol"

SWEP.PrintName           = "Build-A-Barrier"
SWEP.Slot                = 4

SWEP.DrawCrosshair       = true
SWEP.ViewModelFlip       = false
SWEP.ViewModelFOV = 90

SWEP.AutoSpawnable          = false

SWEP.ViewModel              = Model "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel             = Model "models/weapons/w_stunbaton.mdl"

SWEP.Primary.ClipSize       = 2
SWEP.Primary.DefaultClip    = 2
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 3

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true 
SWEP.Secondary.Ammo         = "none"
SWEP.Secondary.Delay        = 0.5

SWEP.AllowDelete            = false
SWEP.AllowDrop              = false
SWEP.NoSights               = true

SWEP.NextReload = 0
SWEP.PosLock = nil
SWEP.Rotahtae = 0
SWEP.VertOffset1 = 0

function SWEP:Think()
    if (CLIENT) then
        if(!IsValid(self.c_Model)) then
		    self.c_Model = ents.CreateClientProp()
            local ownaimvec = self:GetOwner():GetAimVector()
            local infront = (ownaimvec * 150) + self:GetOwner():GetPos() + Vector(0,0,65)
            local hitpos = self:GetOwner():GetEyeTrace().HitPos
            
            if self:GetOwner():GetPos():DistToSqr(infront) <= self:GetOwner():GetPos():DistToSqr(hitpos) then
                self.c_Model:SetPos(infront)
            else
                self.c_Model:SetPos(hitpos)
            end
		    self.c_Model:SetModel("models/pluto/barricade.mdl")
            local ownangle = self:GetOwner():EyeAngles()
            local finangle = Angle(0,ownangle.y + 90,0)
            self.c_Model:SetAngles(finangle)
            self.c_Model:SetMaterial("models/props_lab/xencrystal_sheet")
		    self.c_Model:Spawn()
		    self.c_Model:SetNoDraw(false)		
		else
            if self.PosLock == nil then
                local ownaimvec = self:GetOwner():GetAimVector()
                local infront = (ownaimvec * 150) + self:GetOwner():GetPos() + Vector(0,0,65)
                local hitpos = self:GetOwner():GetEyeTrace().HitPos + Vector(0,0,25)
                if self:GetOwner():GetPos():DistToSqr(infront) <= self:GetOwner():GetPos():DistToSqr(hitpos) then
                    self.c_Model:SetPos(infront)
                else
                    self.c_Model:SetPos(hitpos + Vector(0,0,self.VertOffset1))
                end
            else
                self.c_Model:SetPos(self.PosLock + Vector(0,0,25))
            end
            local ownangle = self:GetOwner():EyeAngles()
            local finangle = Angle(90*self.Rotahtae,ownangle.y + 90,0)
            self.c_Model:SetAngles(finangle)
        end
    end
end

function SWEP:Deploy()
if CLIENT && IsValid(self.c_Model) then self.c_Model:SetNoDraw(false) end
end

function SWEP:PrimaryAttack()
    if (!self:CanPrimaryAttack()) then return end
    if (CLIENT) then self.PosLock = nil return end
    local ent = ents.Create("pluto_barricade")
    if (!ent:IsValid()) then return end
    if self.PosLock ~= nil then
        ent:SetPos(self.PosLock + Vector(0,0,25))
    else
        local ownaimvec = self:GetOwner():GetAimVector()
        local infront = (ownaimvec * 150) + self:GetOwner():GetPos() + Vector(0,0,65)
        local hitpos = self:GetOwner():GetEyeTrace().HitPos + Vector(0,0,25)

        if self:GetOwner():GetPos():DistToSqr(infront) <= self:GetOwner():GetPos():DistToSqr(hitpos) then
            ent:SetPos(infront)
        else
            ent:SetPos(hitpos + Vector(0,0,self.VertOffset1))
        end
    end
    local ownangle = self:GetOwner():EyeAngles()
    local finangle = Angle(90*self.Rotahtae,ownangle.y+90,0)
    ent:SetAngles(finangle)
    ent:Spawn()
    local inside = false
    local aabbstart,aabbend = ent:GetPhysicsObject():GetAABB()
    local tracedata = {}
    tracedata.start = aabbstart + ent:GetPhysicsObject():GetPos()
    tracedata.endpos = aabbend + ent:GetPhysicsObject():GetPos()
    tracedata.filter = ent
    tracedata.collisiongroup = 4
    tracedata.ignoreworld = true
    local trace = util.TraceHull(tracedata)
    self.PosLock = nil
    if (trace.Hit) then
        ent:Remove()
        return 
    end
    ent:GetPhysicsObject():EnableMotion(false)


    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + self:GetDelay())
end

function SWEP:SecondaryAttack()
    local infront = (self:GetOwner():GetAimVector() * 150) + self:GetOwner():GetPos() + Vector(0,0,40)
    local hitpos = self:GetOwner():GetEyeTrace().HitPos

    if self:GetOwner():GetPos():DistToSqr(infront) <= self:GetOwner():GetPos():DistToSqr(hitpos) then
        self.PosLock = infront
    else
        self.PosLock = hitpos
    end

end

function SWEP:Reload()
    if (self.NextReload > CurTime()) then return end
    if self.Rotahtae == 0 then
        self.Rotahtae = 1
        self.VertOffset1 = 15
    else
        self.Rotahtae = 0
        self.VertOffset1 = 0
    end
    self.NextReload = CurTime() + 0.5
end

function SWEP:OnRemove()
	if (CLIENT) && IsValid(self.c_Model) then self.c_Model:Remove() self.PosLock = nil end
end

function SWEP:Holster(plr)
	if (CLIENT && self.c_Model ~= nil) then self.c_Model:SetNoDraw(true) end
    self.PosLock = nil
	return true
end