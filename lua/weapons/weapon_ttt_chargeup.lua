SWEP.PrintName = "ӜӔἮꞬʍʥȳ"
AddCSLuaFile()

SWEP.HoldType              = "ar2"

SWEP.Slot               = 2

SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = 64

SWEP.Ortho = {-5.5, 8, angle = Angle(0, -55, 0), size = 0.9}

SWEP.Base                  = "weapon_tttbase"

SWEP.ViewModelFOV          = 85

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 5300,
	DamageDropoffRangeMax = 9600,
	DamageMinimumPercent = 0.1,
	Spread = vector_origin,
	TracerName = "tfa_tracer_awp_ss"
}
--[[
SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("tfa_cso2/scope/scope_gauss_a.png", "smooth"),
	["ScopeBorder"] = color_black,
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 1 }
}]]

SWEP.Primary.Damage        = 80
SWEP.Primary.Delay         = 1
SWEP.Primary.HoldTime      = 0.8
SWEP.Primary.Recoil        = 5.2
SWEP.Primary.RecoilTiming  = 0.09
SWEP.Primary.Automatic     = true
SWEP.Primary.Ammo          = "357"
SWEP.Primary.ClipSize      = 7
SWEP.Primary.DefaultClip   = 21
SWEP.Primary.Sound         = Sound "tfa_cso2_awmgauss.1"

SWEP.Secondary.Sound       = Sound "Default.Zoom"

SWEP.HeadshotMultiplier    = 1.5
SWEP.DeploySpeed = 1

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.AutoSpawnable         = false
SWEP.Spawnable             = false
SWEP.AmmoEnt               = "item_ammo_357_ttt"

SWEP.ViewModel			= "models/weapons/tfa_cso2/c_awp_ss.mdl" --Viewmodel path
SWEP.WorldModel			= "models/weapons/tfa_cso2/w_awp_ss.mdl" -- Weapon world model path

SWEP.ViewModelFlip = true
SWEP.HasScope = true
SWEP.IsSniper = true

SWEP.Ironsights = {
	Pos = Vector(-3, 0, 2.44),
	Angles = Vector(0, 0, 4.756),
	TimeTo = 0.075,
	TimeFrom = 0.1,
	SlowDown = 0.3,
	Zoom = 0.2,
}


SWEP.Offset = {
	Pos = {
		Up = 0.25,
		Right = 0.5,
		Forward = 3
	},
	Ang = {
		Up = -1,
		Right = -9,
		Forward = 178
	},
	Scale = 1.0
}

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-70),
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetVar("StartShot", "Float", -math.huge)
end

function SWEP:PrimaryAttack()
	if (self:CanPrimaryAttack() and self:GetStartShot() == -math.huge) then
		self:SetStartShot(CurTime())
	end
end

function SWEP:Think()
	if (self:GetStartShot() ~= -math.huge) then
		local reset = false
		if (IsValid(self:GetOwner())) then
			if (not self:GetOwner():KeyDown(IN_ATTACK) and self:CanPrimaryAttack()) then
				if (self.Primary.Sound) then
					self:EmitSound(self.Primary.Sound, self.Primary.SoundLevel or 1)
				end

				self:ShootBullet {
					Penetration = 0,
				}

				self:TakePrimaryAmmo(1)
				reset = true
			end
		else
			reset = true
		end
		if (reset) then
			self:SetStartShot(-math.huge)
			self:SetNextPrimaryFire(CurTime() + self:GetDelay())
		end
	end

	BaseClass.Think(self)
end

function SWEP:Deploy()
	self:SetStartShot(-math.huge)
	return BaseClass.Deploy(self)
end

function SWEP:GetCharge()
	local timepassed = CurTime() - self:GetStartShot()
	if (timepassed == math.huge) then
		return 0
	end
	return math.Clamp(timepassed / self.Primary.HoldTime, 0, 1)
end

function SWEP:GetDamage()
	return BaseClass.GetDamage(self) * self:GetCharge()
end

function SWEP:DrawHUD()
	local w = 15
	local left = ScrW() / 2 - 50 - w / 2
	local h = 60
	local top = ScrH() / 2 - h / 2

	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(left, top, w, h)

	if (self:GetCharge() > 0.5) then
		surface.SetDrawColor(0, 255, 255)
	else
		surface.SetDrawColor(0, 255, 0)
	end
	local real_tall = math.Round((h - 2) * self:GetCharge())
	surface.DrawRect(left + 1, top + 1 + (h - 2) - real_tall, w - 2, real_tall)

	BaseClass.DrawHUD(self)
end

function SWEP:FireBulletsCallback(tr, dmg, data)
	dmg:SetDamage(self:GetDamage())

	local lifetime = 5
	if (IsValid(tr.Entity) and tr.Entity:IsPlayer() and data.Penetration <= 2 and self:GetCharge() > 0.5) then
		data.Penetration = data.Penetration + 1
		data.IgnoreEntity = tr.Entity
		self:ScaleDamage(tr.HitGroup, dmg)
		dmg:SetDamageCustom(tr.HitGroup)
		self:DoFireBullets(tr.HitPos, tr.Normal, data)
	end
end