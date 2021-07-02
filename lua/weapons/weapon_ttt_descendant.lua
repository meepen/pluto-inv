AddCSLuaFile()

SWEP.HoldType           = "normal"

SWEP.PrintName          = "Descendant Scanner"
SWEP.Slot               = 7

SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = -100
SWEP.DrawCrosshair          = false

SWEP.AllowDrop = false

SWEP.IconLetter         = "w"

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Automatic     = false
SWEP.Primary.Delay          = 1
SWEP.Primary.Ammo          = "none"
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "none"

SWEP.AutoSpawnable         = false
SWEP.PlutoSpawnable		   = false
SWEP.Spawnable             = false

SWEP.ViewModel             = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel            = "models/weapons/w_crowbar.mdl"

DEFINE_BASECLASS "weapon_tttbase"

local CHARGE_TIME = 10
local SCAN_TIME = 20

function SWEP:Initialize()
    BaseClass.Initialize(self)

    self.Target = nil
end

function SWEP:NetVar(...)
    BaseClass.NetVar(self, ...)
end

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)

    self:NetVar("Charge", "Float", 0)
    self:NetVar("Scanning", "Bool", false)
    self:NetVar("Target", "String", "")	
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	if (self:GetScanning() or self:GetCharge() < 1) then
		return
	end

	self:SetCharge(0)

    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local owner = self:GetOwner()

    if (not IsValid(owner)) then
		return
	end
	
    local bullet = {}
    bullet.Num    = 1
    bullet.Src    = owner:GetShootPos()
    bullet.Dir    = owner:GetAimVector()
    bullet.Spread = 0
    bullet.Tracer = 1
    bullet.Force  = 0
    bullet.Damage = 0
    bullet.TracerName = "ManhackSparks"

    bullet.Callback = function(att, tr, dmginfo)
		if (not IsValid(owner) or not owner:Alive()) then
			return
		end

        local ent = tr.Entity
        if (SERVER and IsValid(ent) and ent:IsPlayer() and ent:Alive()) then
            self:SetTarget(ent:Nick())
			self:SetScanning(true)
			self.Target = ent

			pluto.rounds.Notify(string.format("You have begun scanning %s!", ent:Nick()), ttt.roles.Descendant.Color, owner)
			pluto.rounds.Notify("You feel a slight sting...", ttt.roles.Descendant.Color, ent)
        end
    end

    owner:FireBullets(bullet)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	if SERVER and IsValid(self:GetOwner()) then
	self:GetOwner():DrawViewModel(false)
	end

	self:DrawShadow(false)

	return true
end

function SWEP:Holster()
	return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

function SWEP:Think()
    BaseClass.Think(self)

    local owner = self:GetOwner()

    if (CLIENT or not IsValid(owner)) then
        return 
    end

    if (self:GetScanning()) then
        if (not IsValid(self.Target) or not self.Target:Alive()) then
			self:SetScanning(false)
			self.Target = nil
		elseif (self:GetCharge() >= 1) then
			self:SetScanning(false)
			self:SetCharge(0)
			self:SetTarget("")

			pluto.rounds.Notify(string.format("Scan Complete. The role of %s is: %s!", self.Target:Nick(), self.Target:GetRole()), self.Target:GetRoleData().Color, owner)
			pluto.rounds.Notify("The Descendant has just finished scanning your role!", ttt.roles.Descendant.Color, self.Target)
	
			self.Target = nil
		else
			self:SetCharge(math.min(1, self:GetCharge() + FrameTime() / SCAN_TIME))
		end
    elseif (self:GetCharge() < 1) then
        self:SetCharge(math.min(1, self:GetCharge() + FrameTime() / CHARGE_TIME))
    end
end

if (CLIENT) then
    local _x = ScrW() / 2.0
    local _y = ScrH() / 2.0

    surface.CreateFont("pluto_descendant", {
        font = "Roboto",
        size = 18,
    })

    function SWEP:DrawHUD()
        local x = _x
        local y = _y
        local nxt = self:GetNextPrimaryFire()
        local charge = self:GetCharge()

        surface.SetDrawColor(color_black)

        local length = 8
        local gap = 4

        surface.DrawLine(x - length, y, x - gap, y)
        surface.DrawLine(x + length, y, x + gap, y)
        surface.DrawLine(x, y - length, x, y - gap)
        surface.DrawLine(x, y + length, x, y + gap)

        if (charge > 0) then
            y = y + (y / 3)

            local w, h = 120, 18

            surface.DrawOutlinedRect(x - w/2, y - h, w, h)

            surface.SetDrawColor(ttt.roles.Descendant.Color)

            surface.DrawRect(x - w/2 + 1, y - h + 1, w * charge - 2, h - 2)

			local msg
			if (self:GetScanning() and self:GetTarget() ~= "") then
				msg = string.format("Scanning target: %s", self:GetTarget())
			elseif (self:GetCharge() < 1) then
				msg = "Charging..."
			else
				msg = "Ready to scan"
			end

			draw.SimpleTextOutlined(msg, "pluto_descendant", x, y - h - 12, ttt.roles.Descendant.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
        end
    end
end