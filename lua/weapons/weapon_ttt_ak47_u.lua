local tbl = {
	"AK47.SlideBack","weapons/ak47_beast/rifle_slideback.ogg",
	"AK47.ClipIn","weapons/ak47_beast/rifle_clip_in_1.ogg",
	"AK47.SlideForward","weapons/ak47_beast/rifle_slideforward.ogg",
	"AK47.Deploy","weapons/ak47_beast/rifle_deploy_1.ogg",
	"AK47.Shoot", "weapons/ak47_beast/rifle_fire_1.ogg",
}
for i = 1,#tbl,2 do
	sound.Add {
		name = tbl[i],
		channel = CHAN_WEAPON,
		volume = 1.0,
		soundlevel = 80,
		sound = tbl[i+1]
	}
end

AddCSLuaFile()
SWEP.ViewModelFOV	= 60

SWEP.PrintName 		= "Soulseeker"
SWEP.Slot 			= 2
SWEP.SlotPos 		= 1

SWEP.Base 		= "weapon_tttbase"
SWEP.HoldType 	= "ar2"

SWEP.Ortho = {0, 7, size = 0.7, angle = Angle(45, 180, -60)}

SWEP.ViewModel 	= "models/cf/c_ak47_beast.mdl"
SWEP.WorldModel = "models/cf/w_ak47_beast.mdl"

SWEP.Primary.Sound 		= "AK47.Shoot"
SWEP.Primary.Damage 	= 29
SWEP.Primary.Recoil = 1.4
SWEP.Primary.ClipSize 	= 40
SWEP.Primary.Delay 		= 0.19
SWEP.Primary.DefaultClip= 120
SWEP.Primary.Automatic 	= true
SWEP.Primary.Ammo          = "Pistol"

SWEP.HeadshotMultiplier = 1.5

SWEP.NoPlayerModelHands = true
SWEP.UseHands = true

SWEP.DeployAnim = ACT_VM_DEPLOY
SWEP.DeploySpeed = 1.5

SWEP.Ironsights = {
	Pos = Vector(-6, 0, 1.2),
	Angle = Vector(-1.9, -4.34, 0),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.4,
	Zoom = 0.8,
}

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.015, 0.015),
	TracerName = "AR2Tracer",
}

DEFINE_BASECLASS "weapon_tttbase"

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("Kills", "Int", 0)
end

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("DoPlayerDeath", self, function(self, pl, atk, dmg)
		if (atk == self:GetOwner() and dmg:GetInflictor() == self) then
			self:SetKills(self:GetKills() + 1)
		end
	end)
end

function SWEP:GetDelay()
	local base_rpm = 400
	local per_kill = 50
	return 60 / (base_rpm + self:GetKills() * per_kill)
end

local pow = 3
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-6, -2),
	pow * Angle(-4, -2),
	pow * Angle(-2, 3),
	pow * Angle(-1, 2.5),
	pow * Angle(-3, 0),
	pow * Angle(-3, 1),
	pow * Angle(-3, -3),
}