SWEP.Base				= "tfa_cso_crow_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Kamikaze" 
SWEP.Contact				= "" 
SWEP.Purpose				= "" 
SWEP.Instructions				= "" 
SWEP.Spawnable				= true 
SWEP.AdminSpawnable			= true 
SWEP.DrawCrosshair			= true		
SWEP.PrintName				= "CROW-5"		
SWEP.Slot				= 2				
SWEP.SlotPos				= 73			
SWEP.DrawAmmo				= true		
SWEP.DrawWeaponInfoBox			= false		
SWEP.BounceWeaponIcon   		= 	false	
SWEP.AutoSwitchTo			= true		
SWEP.AutoSwitchFrom			= true		
SWEP.Weight				= 30			

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("CROW5.Fire")				
SWEP.Primary.Damage		= 40					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 750					
SWEP.Primary.RPM_Semi				= 750					
SWEP.FiresUnderwater = false

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName			= "SCAVENGER-10"	
--SWEP.NZPaPReplacement 	= "nil"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	

-- Selective Fire Stuff

SWEP.SelectiveFire		= false 
SWEP.DisableBurstFire	= true 
SWEP.OnlyBurstFire		= false 
SWEP.DefaultFireMode 	= "" 

--Ammo Related

SWEP.Primary.ClipSize			= 50					
SWEP.Primary.DefaultClip			= 250				
SWEP.Primary.Ammo			= "ar2"					
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering = false 

--Recoil Related
SWEP.Primary.KickUp			= 0.12					
SWEP.Primary.KickDown			= 0					
SWEP.Primary.KickHorizontal			= 0.175					
SWEP.Primary.StaticRecoilFactor = 0.4 	

--Firing Cone Related

SWEP.Primary.Spread		= .025					
SWEP.Primary.IronAccuracy = .012	

--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 1.5 
SWEP.Primary.SpreadIncrement = 1/3.5 
SWEP.Primary.SpreadRecovery = 2 

--Range Related
SWEP.Primary.Range = -1 
SWEP.Primary.RangeFalloff = 0.8 


--Penetration Related

SWEP.MaxPenetrationCounter=2 

--Misc
SWEP.IronRecoilMultiplier=0.5 
SWEP.CrouchRecoilMultiplier=0.65  
SWEP.JumpRecoilMultiplier=1.3  
SWEP.WallRecoilMultiplier=1.1  
SWEP.ChangeStateRecoilMultiplier=1.3  
SWEP.CrouchAccuracyMultiplier=0.5
SWEP.ChangeStateAccuracyMultiplier=1.5 
SWEP.JumpAccuracyMultiplier=2
SWEP.WalkAccuracyMultiplier=1.35
SWEP.IronSightTime = 0.3 
SWEP.NearWallTime = 0.25 
SWEP.ToCrouchTime = 0.05 
SWEP.WeaponLength = 50 
SWEP.MoveSpeed = 1 
SWEP.IronSightsMoveSpeed = 0.8 
SWEP.SprintFOVOffset = 3.75 

--[[PROJECTILES]]--

SWEP.ProjectileEntity = nil 
SWEP.ProjectileVelocity = 0 
SWEP.ProjectileModel = nil 

--[[VIEWMODEL]]--

SWEP.ViewModel			= "models/weapons/tfa_cso/c_crow5.mdl" 
SWEP.ViewModelFOV			= 80		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true 
SWEP.VMPos = Vector(0,0,0) 
SWEP.VMAng = Vector(0,0,0) 

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_crow5.mdl" 

SWEP.HoldType 				= "ar2"		
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { 
		Pos = {
		Up = -3,
		Right = 1,
		Forward = 2,
		},
		Ang = {
		Up = -90,
		Right = 0,
		Forward = 170
		},
		Scale = 1.2
}

SWEP.ThirdPersonReloadDisable=false 

SWEP.ShowWorldModel = true

--[[SCOPES]]--

SWEP.BoltAction			= false  
SWEP.Scoped				= true  

SWEP.ScopeOverlayThreshold = 0.875 
SWEP.BoltTimerOffset = 0.25 

SWEP.ScopeScale = 1 
SWEP.ReticleScale = 0.6 

--GDCW Overlay Options.  Only choose one.

SWEP.Secondary.UseACOG			= true	 
SWEP.Secondary.UseMilDot			= false			 
SWEP.Secondary.UseSVD			= false		 
SWEP.Secondary.UseParabolic		= false		 
SWEP.Secondary.UseElcan			= false	 
SWEP.Secondary.UseGreenDuplex		= false		 

--[[SHOTGUN CODE]]--

SWEP.Shotgun = false 

SWEP.ShellTime			= .35 

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(-5.788, -1.009, 0)
SWEP.RunSightsAng = Vector(-16.223, -35.562, 0)

--[[IRONSIGHTS]]--

SWEP.data 				= {}
SWEP.data.ironsights			= 1 
SWEP.Secondary.IronFOV			= 60					

SWEP.IronSightsPos = Vector(6.71, -11.898, 0.234)
SWEP.IronSightsAng = Vector(0.944, 6.243, -3.751)

--[[INSPECTION]]--

SWEP.InspectPos = nil 
SWEP.InspectAng = nil 
SWEP.InspectionLoop = true 

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.ShootWhileDraw=false 
SWEP.AllowReloadWhileDraw=false 
SWEP.SightWhileDraw=false 
SWEP.AllowReloadWhileHolster=true 
SWEP.ShootWhileHolster=true 
SWEP.SightWhileHolster=false 
SWEP.UnSightOnReload=true 
SWEP.AllowReloadWhileSprinting=false 
SWEP.AllowReloadWhileNearWall=false 
SWEP.SprintBobMult=1.5 
SWEP.IronBobMult=0  
SWEP.AllowViewAttachment = true 

--[[HOLDTYPES]]--

SWEP.IronSightHoldTypeOverride=""  
SWEP.SprintHoldTypeOverride=""  

--[[VIEWMODEL BLOWBACK]]--

SWEP.BlowbackEnabled = true 
SWEP.BlowbackVector = Vector(0,0,-0.1) 
SWEP.BlowbackCurrentRoot = 0 
SWEP.BlowbackCurrent = 0 
SWEP.Blowback_Only_Iron = true 
SWEP.Blowback_PistolMode = false 
SWEP.Blowback_Shell_Enabled = false
SWEP.Blowback_Shell_Effect = "RifleShellEject"

--[[ANIMATION]]--

SWEP.ForceDryFireOff = true 
SWEP.DisableIdleAnimations = false 
SWEP.ForceEmptyFireOff = true 

--If you really want, you can remove things from SWEP.actlist and manually enable animations and set their lengths.

SWEP.SequenceEnabled = {} 
SWEP.SequenceLength = {}  
SWEP.SequenceLengthOverride={
//	[ACT_VM_RELOAD] = 2.7,
}
--[[EFFECTS]]--



--Muzzle Flash

SWEP.MuzzleAttachment			= "1" 		
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		

SWEP.DoMuzzleFlash = true 
SWEP.CustomMuzzleFlash = true 
SWEP.AutoDetectMuzzleAttachment = true 
SWEP.MuzzleFlashEffect = nil 

--Tracer Stuff

SWEP.Tracer				= 0		
SWEP.TracerName 		= nil 	
								
SWEP.TracerCount 		= 1 	


SWEP.TracerLua 			= false 
SWEP.TracerDelay		= 0.01 

--[[EVENT TABLE]]--

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ time = 0, type = "lua", value = function(wep) wep:CrowReset() end},
		{ time = 22 / 30, type = "lua", value = function(wep) wep:CrowEnableCheck() end},
		{ time = 30 / 30, type = "lua", value = function(wep) wep:CrowChooseReloadAnim() end},
	},
	[ACT_VM_RELOAD_END] = {
		{ time = 16 / 30, type = "lua", value = function(wep) wep:CrowCompleteReload() end},
	},
	[ACT_VM_RELOAD_END_EMPTY] = {
		{ time = 20 / 30, type = "lua", value = function(wep) wep:CrowCompleteReload() end},
	},
} 

SWEP.StatusLengthOverride = {
	[ACT_VM_RELOAD] = math.huge,
}

--example:
--SWEP.EventTable = {
--	[ACT_VM_RELOAD] = {
--		{ ['time'] = 0.1, ['type'] = "lua", ['value'] = examplefunction, ['client'] = true, ['server'] = false  },
--		{ ['time'] = 0.2, ['type'] = "sound", ['value'] = Sound("ExampleGun.Sound1", ['client'] = true, ['server'] = false ) }
--	}
--}


--[[RENDER TARGET]]--

SWEP.RTMaterialOverride = nil 

SWEP.RTOpaque = false 

SWEP.RTCode = nil

--[[AKIMBO]]--

SWEP.Akimbo = false 
SWEP.AnimCycle = 0 

--Disable secondary crap

SWEP.Secondary.ClipSize			= 0					
SWEP.Secondary.DefaultClip			= 0					
SWEP.Secondary.Automatic			= false					
SWEP.Secondary.Ammo			= "none" 
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_crow5")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
