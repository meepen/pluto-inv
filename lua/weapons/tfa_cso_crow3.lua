SWEP.Base				= "tfa_cso_crow_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Kamikaze" 
SWEP.Contact				= "" 
SWEP.Purpose				= "" 
SWEP.Instructions				= "" 
SWEP.Spawnable				= true 
SWEP.AdminSpawnable			= true 
SWEP.DrawCrosshair			= true		
SWEP.PrintName				= "CROW-3"		
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
SWEP.Primary.Sound 			= Sound("CROW3.Fire")				
SWEP.Primary.Damage		= 30					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 800					
SWEP.Primary.RPM_Semi				= 800					
SWEP.FiresUnderwater = true

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Zombie Scarer"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	


-- Selective Fire Stuff

SWEP.SelectiveFire		= true 
SWEP.DisableBurstFire	= false 
SWEP.OnlyBurstFire		= false 
SWEP.DefaultFireMode 	= "Auto" 
SWEP.FireModes = {"Auto"}

--Ammo Related

SWEP.Primary.ClipSize			= 64					
SWEP.Primary.DefaultClip			= 384				
SWEP.Primary.Ammo			= "smg1"					
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering = false 

--Recoil Related
SWEP.Primary.KickUp			= 0.12				
SWEP.Primary.KickDown			= 0.08					
SWEP.Primary.KickHorizontal			= 0.16					
SWEP.Primary.StaticRecoilFactor = 0.3 	

--Firing Cone Related

SWEP.Primary.Spread		= .020					
SWEP.Primary.IronAccuracy = .004	

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

SWEP.ViewModel			= "models/weapons/tfa_cso/c_crow3.mdl" 
SWEP.ViewModelFOV			= 80		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true 
SWEP.VMPos = Vector(0,0,0) 
SWEP.VMAng = Vector(0,0,0) 

//SWEP.ViewModelBoneMods = {
//	["root"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) },
//	["spsmg"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) }
//}

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_crow3.mdl" 

SWEP.HoldType 				= "ar2"		
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { 
        Pos = {
        Up = -3.5,
        Right = 0.8,
        Forward = 8,
        },
        Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
        },
		Scale = 1
}

SWEP.ThirdPersonReloadDisable=false 

SWEP.ShowWorldModel = true

--[[SCOPES]]--

SWEP.BoltAction			= false  
SWEP.Scoped				= false  

SWEP.ScopeOverlayThreshold = 0.875 
SWEP.BoltTimerOffset = 0.25 

SWEP.ScopeScale = 0.5 
SWEP.ReticleScale = 0.7 

--GDCW Overlay Options.  Only choose one.

SWEP.Secondary.UseACOG			= false	 
SWEP.Secondary.UseMilDot			= false			 
SWEP.Secondary.UseSVD			= false		 
SWEP.Secondary.UseParabolic		= false		 
SWEP.Secondary.UseElcan			= false	 
SWEP.Secondary.UseGreenDuplex		= true		 

--[[SHOTGUN CODE]]--

SWEP.Shotgun = false 

SWEP.ShellTime			= .4 

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(-5.788, -1.009, 0)
SWEP.RunSightsAng = Vector(-16.223, -35.562, 0)

--[[IRONSIGHTS]]--

SWEP.data 				= {}
SWEP.data.ironsights			= 0 
SWEP.Secondary.IronFOV			= 75					

SWEP.IronSightsPos = Vector(6.71, 0, 2.13)
SWEP.IronSightsAng = Vector(2.108, 0, 0)

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
SWEP.BlowbackVector = Vector(0,-2,0) 
SWEP.BlowbackCurrentRoot = 0 
SWEP.BlowbackCurrent = 0 
SWEP.Blowback_Only_Iron = true 
SWEP.Blowback_PistolMode = false 
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "9mmShellEject"
SWEP.BlowbackBoneMods = {
    ["bone02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -2.5), angle = Angle(0, 0, 0) },
}

--[[ANIMATION]]--

SWEP.ForceDryFireOff = true 
SWEP.DisableIdleAnimations = false 
SWEP.ForceEmptyFireOff = true 

--If you really want, you can remove things from SWEP.actlist and manually enable animations and set their lengths.

SWEP.SequenceEnabled = {} 
SWEP.SequenceLength = {}  
//SWEP.SequenceLengthOverride={
//	[ACT_VM_PRIMARYATTACK] = 1,
//}
--[[EFFECTS]]--

--Muzzle Flash

SWEP.MuzzleAttachment			= "0" 		
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
		{ time = 29 / 30, type = "lua", value = function(wep) wep:CrowChooseReloadAnim() end},
	},
	[ACT_VM_RELOAD_END] = {
		{ time = 12 / 30, type = "lua", value = function(wep) wep:CrowCompleteReload() end},
	},
	[ACT_VM_RELOAD_END_EMPTY] = {
		{ time = 26 / 30, type = "lua", value = function(wep) wep:CrowCompleteReload() end},
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
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_crow3")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
