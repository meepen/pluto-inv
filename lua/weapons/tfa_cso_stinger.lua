SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze" --Author Tooltip
SWEP.PrintName = "Explosive Crossbow"
SWEP.Slot = 6

SWEP.Equipment = {
	Name		   = "Explosive Crossbow",
	Desc 		   = "Explosive arrows. From a crossbow.",
	CanBuy	       = { traitor = true },
	Cost 	   	   = 1,
	Limit	       = 1,
	Icon           = "materials/tttrw/equipment/flaregun.png"
}

SWEP.GrenadeEntity = "ttt_sticky_grenade"
SWEP.ThrowVelocity = 10000
SWEP.Bounciness = 0


SWEP.Primary.Sound 			= Sound "Stinger.Fire"
SWEP.Primary.Damage		= 20
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.Delay				= 60 / 90

SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip			= 3
SWEP.Primary.Ammo			= "none"

SWEP.ViewModel			= "models/weapons/tfa_cso/c_stinger.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.WorldModel			= "models/weapons/tfa_cso/w_stinger.mdl" -- Weapon world model path
SWEP.HoldType 				= "ar2"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -3,
		Right = 0.8,
		Forward = 14.5,
	},
	Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
	},
	Scale = 1.2
}
DEFINE_BASECLASS(SWEP.Base)
function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("ThrowStart", "Float", math.huge)
end


function SWEP:DoFireBullets(src, dir, data)
	local e
	if (SERVER) then
		e = ents.Create(self.GrenadeEntity)
		e.DoRemove = true
	end

	if (IsValid(e)) then
		e:SetOrigin(self:GetOwner():EyePos())
		e:SetOwner(self:GetOwner())
		e.Owner = self:GetOwner()
		e:SETVelocity(self:GetOwner():GetAimVector() * self.ThrowVelocity + self:GetOwner():GetVelocity() * 0.8)
		e:SetDieTime(CurTime() + self.Primary.Delay)
		e:SetBounciness(self.Bounciness)
		e:SetWeapon(self)
		e:Spawn()

		self:SetThrowStart(math.huge)
	end
end

SWEP.Ironsights = false