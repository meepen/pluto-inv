local tbl = {"AK47.SlideBack","weapons/ak47_beast/rifle_slideback.ogg",
"AK47.ClipIn","weapons/ak47_beast/rifle_clip_in_1.ogg",
"AK47.SlideForward","weapons/ak47_beast/rifle_slideforward.ogg",
"AK47.Deploy","weapons/ak47_beast/rifle_deploy_1.ogg"
}
for i = 1,#tbl,2 do
	sound.Add(
	{
		name = tbl[i],
		channel = CHAN_WEAPON,
		volume = 1.0,
		soundlevel = 80,
		sound = tbl[i+1]
	})
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

SWEP.Primary.Sound 		= Sound "weapons/ak47_beast/rifle_fire_1.ogg"
SWEP.Primary.Damage 	= 29
SWEP.Primary.Recoil = 1.4
SWEP.Primary.ClipSize 	= 40
SWEP.Primary.Delay 		= 0.18
SWEP.Primary.DefaultClip= 120
SWEP.Primary.Automatic 	= true
SWEP.Primary.Ammo          = "Pistol"
SWEP.AmmoEnt               = "item_ammo_pistol_ttt"

SWEP.HeadshotMultiplier = 1.5

SWEP.NoPlayerModelHands = true
SWEP.Ironsights = {
	Pos = Vector(-6, 0, 1.2),
	Angle = Vector(-1.9, -4.34, 0),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.4,
	Zoom = 0.8,
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
	return math.max(0.02, 0.18 - self:GetKills() * 0.008)
end