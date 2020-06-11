SWEP.Base							= "weapon_tttbase"
SWEP.Category						= "Destiny Weapons"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Delta"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Thunderlord"
SWEP.Type							= "They return from fields afar. The eye has passed, the end nears. Do not fade quietly. Let thunder reign again."
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 70
SWEP.Slot							= 2
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= true
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= true
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= nil
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 60
SWEP.Primary.DefaultClip			= 240
SWEP.Primary.Ammo          = "AirboatGun"
SWEP.Primary.Range 					= 40000
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= 150
SWEP.Primary.Delay				    = 60 / 450
SWEP.Primary.Sound 					= Sound ("TFA_TH_FIRE.1");
SWEP.Primary.ReloadSound 			= Sound ("weapons/ThunderlordReload.ogg");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 22
SWEP.HeadshotMultiplier = 32 / 22
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= DMG_SHOCK

SWEP.DoMuzzleFlash 					= true

SWEP.FireModes = {
	"FullAuto",
}


SWEP.IronRecoilMultiplier			= 0.75
SWEP.CrouchRecoilMultiplier			= 0.85
SWEP.JumpRecoilMultiplier			= 2
SWEP.WallRecoilMultiplier			= 1.1
SWEP.ChangeStateRecoilMultiplier	= 1.2
SWEP.CrouchAccuracyMultiplier		= 0.8
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 10
SWEP.WalkAccuracyMultiplier			= 1.8
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.25
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 2
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil


SWEP.ViewModel						= "models/weapons/c_thunderlord.mdl"
--SWEP.WorldModel						= "models/weapons/c_thorn.mdl"
SWEP.ViewModelFOV					= 78
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
SWEP.ReloadHoldTypeOverride 		= "ar2"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0, math.random(-3, -6), 0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 1.3
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "Thunderlord_Tracer_Old"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0
SWEP.ImpactEffect 					= nil
SWEP.ImpactDecal 					= "SmallScorch"

function SWEP:DoImpactEffect( tr, nDamageType )
	if ( tr.HitSky ) then return end -- Do not draw effects vs. the sky.
	ParticleEffect( "astra_hit", tr.HitPos, self.Owner:EyeAngles(), self )
	return false
end

SWEP.IronSightTime 					= 0.4
SWEP.Primary.KickUp					= 0.1
SWEP.Primary.KickDown				= 0.1
SWEP.Primary.KickHorizontal			= 0.1
SWEP.Primary.StaticRecoilFactor 	= 0.8
SWEP.Primary.Spread					= 0.02
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 0.85
SWEP.IronSightsMoveSpeed 			= 0.75

SWEP.IronSightsPos = Vector(-8.222, -18, -0.761)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)	

SWEP.Skin = 0

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = { "better_tracers" }, order = 1 },
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1, 1, 1), pos = Vector(0.925, -0.926, 0.925), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["reticle"] = { type = "Model", model = "models/hunter/plates/plate1x1.mdl", bone = "ReloadBone", rel = "", pos = Vector(1.775, 4.65, 0), angle = Angle(0, 180, 90), size = Vector(0.023, 0.023, 0), color = Color(255, 255, 255, 255), surpresslightning = false, material = "reticle/ThunderlordReticle", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["world"] = { type = "Model", model = "models/weapons/c_thunderlord.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-10.601, 5.714, -7.6), angle = Angle(-8.183, -1.17, 180), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.ViewModelChange = {
	Pos = Vector(2, 0, -2),
	Ang = Vector(0, -9, 0)
}
SWEP.ThirdPersonReloadDisable		= false
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "" 
SWEP.Secondary.ScopeZoom 			= 3
SWEP.ScopeReticule_Scale 			= {0.875,0.875}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end

DEFINE_BASECLASS( SWEP.Base )

function SWEP:GetDelay()
	return 60 / math.Clamp(400 + self:GetConsecutiveShots() * 15, 400, 600)
end

function SWEP:ShootBullet(data)
	BaseClass.ShootBullet(self, data)
end

function SWEP:Think(...)
	if CLIENT then
		if self:GetIronsights() then
			self.VElements["reticle"].color = Color(255, 255, 255, 255)
		else
			self.VElements["reticle"].color = Color(255, 255, 255, 0)
		end
	end
	return BaseClass.Think(self, ...)
end

hook.Add("OnNPCKilled", "Killed_NPC_THUNDERLORD", function(victim, attacker)
	
		if victim == attacker then return end
		if not attacker.IsPlayer() || attacker.IsNPC() then return end
		if (attacker:GetActiveWeapon():GetClass() == "destiny_thunderlord" && IsValid(attacker) ) then
			local weapon = attacker:GetActiveWeapon()
			weapon:SetClip1(math.Clamp( weapon:Clip1() + math.random(15, 20), 0, weapon:GetMaxClip1()))
		else return end

end)
hook.Add("PlayerDeath", "Killed_Player_THUNDERLORD", function(victim, attacker)
	
	if victim == attacker then return end
	if not attacker.IsPlayer() || attacker.IsNPC() then return end
	if (attacker:GetActiveWeapon():GetClass() == "destiny_thunderlord" && IsValid(attacker) ) then
		local weapon = attacker:GetActiveWeapon()
		weapon:SetClip1(math.Clamp( weapon:Clip1() + math.random(15, 20), 0, weapon:GetMaxClip1()))
	else return end
end)

local path = "weapons/"
local pref = "TFA_TH_FIRE"

TFA.AddFireSound(pref .. ".1", path .. "thunderlordfire3.ogg", false, ")")


local power = 11

SWEP.RecoilInstructions = {
	Interval = 2,
	Angle(-power, -power * 0.6),
	Angle(-power, -power * 0.48),
	Angle(-power, -power * 0.2),
	Angle(-power, power * 0.4),
	Angle(-power, power * 0.2),
	Angle(-power, power * 0.6),
	Angle(-power, power * 0.35),
	Angle(-power, power * 0.2),
	Angle(-power, -power * 0.2),
	Angle(-power, -power * 0.4),
}

SWEP.Ironsights = false