SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" 
SWEP.Author				= "Anri" 
SWEP.Contact				= "" 
SWEP.Purpose				= "" 
SWEP.Instructions				= "" 
SWEP.Spawnable				= true 
SWEP.AdminSpawnable			= true 
SWEP.DrawCrosshair			= true		
SWEP.PrintName				= "Burning AUG"		
SWEP.Slot				= 2				
SWEP.SlotPos				= 73			
SWEP.DrawAmmo				= true		
SWEP.DrawWeaponInfoBox			= false		
SWEP.BounceWeaponIcon   		= 	false	
SWEP.AutoSwitchTo			= true		
SWEP.AutoSwitchFrom			= true		
SWEP.Weight				= 30			
SWEP.Revolver			= false			

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("BurningAUG.Fire")				
SWEP.Primary.Damage		= 39					
SWEP.DamageType = DMG_BULLET 
SWEP.Primary.NumShots	= 1 
SWEP.Primary.Automatic			= true					
SWEP.Primary.RPM				= 650					
SWEP.Primary.RPM_Semi				= 650					
SWEP.FiresUnderwater = true

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 8
SWEP.Secondary.Ammo = "smg1_grenade"
SWEP.Secondary.Ent = "burningaug_nade"

SWEP.Secondary.Model = "models/weapons/tfa_cso/w_shell_svdex.mdl" 
SWEP.Secondary.Damage = 240 
SWEP.Secondary.Velocity = 1400 
SWEP.Secondary.Delay = 2.75 
SWEP.Secondary.Sound = Sound("BurningAUG.FireNade") 
SWEP.Secondary.Recoil = Angle(-5,1,0) 

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Nathan Express"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	
SWEP.NZTotalBlackList	= false	


-- Selective Fire Stuff

SWEP.SelectiveFire		= false 
SWEP.DisableBurstFire	= true 
SWEP.OnlyBurstFire		= false 
SWEP.DefaultFireMode 	= "" 

--Ammo Related

SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 120				
SWEP.Primary.Ammo			= "ar2"					
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering = false 

--Recoil Related
SWEP.Primary.KickUp			= 0.225					
SWEP.Primary.KickDown			= 0.175					
SWEP.Primary.KickHorizontal			= 0.025				
SWEP.Primary.StaticRecoilFactor = 0.325 	

--Firing Cone Related

SWEP.Primary.Spread		= .016					
SWEP.Primary.IronAccuracy = .01125	

--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 2.5 
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

SWEP.ViewModel			= "models/weapons/tfa_cso/c_burning_aug.mdl" 
SWEP.ViewModelFOV			= 82		
SWEP.ViewModelFlip			= true		
SWEP.UseHands = true 
SWEP.VMPos = Vector(2, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = false

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_burning_aug.mdl" 

SWEP.HoldType 				= "ar2"		
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { 
		Pos = {
		Up = -2.75,
		Right = 0,
		Forward = 2,
		},
		Ang = {
		Up = 92,
		Right = 0,
		Forward = 190
		},
		Scale = 1.15
}

SWEP.ThirdPersonReloadDisable=false 

--[[SCOPES]]--

SWEP.BoltAction			= false  
SWEP.Scoped				= true  

SWEP.ScopeOverlayThreshold = 0.875 
SWEP.BoltTimerOffset = 0 

SWEP.ScopeScale = 0.5 
SWEP.ReticleScale = 0.7 

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
SWEP.Secondary.IronFOV			= 40					

SWEP.IronSightsPos = Vector(11.939, -2.76, 1.518)
SWEP.IronSightsAng = Vector(0.456, 5.151, 0)

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

SWEP.BlowbackEnabled = false 
SWEP.BlowbackVector = Vector(-0.225,-1,0) 
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
//	[ACT_VM_RELOAD] = 2,
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

SWEP.EventTable = {} 

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

--[[TTT]]--

local gm = engine.ActiveGamemode()
if string.find(gm,"ttt") or string.find(gm,"terrorist") then
	SWEP.Kind = WEAPON_HEAVY
	SWEP.AutoSpawnable = false
	SWEP.AllowDrop = true
	SWEP.AmmoEnt = "item_ammo_smg1_ttt"
	SWEP.Base = "weapon_tttbase"
	DEFINE_BASECLASS("weapon_tttbase")
else
	SWEP.Base = "weapon_base"
	DEFINE_BASECLASS("weapon_base")
end



--[[MISC INFO FOR MODELERS]]--

--[[

Used Animations (for modelers):

ACT_VM_DRAW - Draw
ACT_VM_DRAW_EMPTY - Draw empty
ACT_VM_DRAW_SILENCED - Draw silenced, overrides empty

ACT_VM_IDLE - Idle
ACT_VM_IDLE_SILENCED - Idle empty, overwritten by silenced
ACT_VM_IDLE_SILENCED - Idle silenced

ACT_VM_PRIMARYATTACK - Shoot
ACT_VM_PRIMARYATTACK_EMPTY - Shoot last chambered bullet
ACT_VM_PRIMARYATTACK_SILENCED - Shoot silenced, overrides empty
ACT_VM_PRIMARYATTACK_1 - Shoot ironsights, overriden by everything besides normal shooting
ACT_VM_DRYFIRE - Dryfire

ACT_VM_RELOAD - Reload / Tactical Reload / Insert Shotgun Shell
ACT_SHOTGUN_RELOAD_START - Start shotgun reload, unless ACT_VM_RELOAD_EMPTY is there.
ACT_SHOTGUN_RELOAD_FINISH - End shotgun reload.
ACT_VM_RELOAD_EMPTY - Empty mag reload, chambers the new round.  Works for shotguns too, where applicable.
ACT_VM_RELOAD_SILENCED - Silenced reload, overwrites all


ACT_VM_HOLSTER - Holster
ACT_VM_HOLSTER_SILENCED - Holster empty, overwritten by silenced
ACT_VM_HOLSTER_SILENCED - Holster silenced

]]--

--[[Stuff you SHOULD NOT touch after this]]--

--Allowed VAnimations.  These are autodetected, so not really needed except as an extra precaution.  Do NOT change these, unless absolutely necessary.

SWEP.CanDrawAnimate=true
SWEP.CanDrawAnimateEmpty=true
SWEP.CanDrawAnimateSilenced=false
SWEP.CanHolsterAnimate=true
SWEP.CanHolsterAnimateEmpty=false
SWEP.CanIdleAnimate=true
SWEP.CanIdleAnimateEmpty=true
SWEP.CanIdleAnimateSilenced=false
SWEP.CanShootAnimate=true
SWEP.CanShootAnimateSilenced=false
SWEP.CanReloadAnimate=true
SWEP.CanReloadAnimateEmpty=false
SWEP.CanReloadAnimateSilenced=false
SWEP.CanDryFireAnimate=false
SWEP.CanDryFireAnimateSilenced=false
SWEP.CanSilencerAttachAnimate=false
SWEP.CanSilencerDetachAnimate=false

--Misc

SWEP.ShouldDrawAmmoHUD=false
SWEP.DefaultFOV=90 

SWEP.Base				= "tfa_gun_base"

function SWEP:AltAttack()
	--[[
	if CurTime() >  self:GetNextPrimaryFire() and TFA.Enum.ReadyStatus[ self:GetStatus() ] and not self:GetSprinting() and self:Ammo2() > 0 then
		self:TakeSecondaryAmmo( 1 )
		self:SendViewModelAnim( ACT_VM_SECONDARYATTACK )
		if SERVER then
			local ent = ents.Create( self.Secondary.Ent )
			ent:SetOwner( self.Owner )
			ent:SetPos( self.Owner:GetShootPos() )
			ent:SetAngles( self.Owner:EyeAngles() )
			ent:SetModel( self:GetStat("Secondary.Model") )
			ent:Spawn()
			ent:Activate()
			ent:GetPhysicsObject():SetVelocity( self.Owner:GetAimVector() * self.Secondary.Velocity )
			//SetVel( ent, self.Owner:GetAimVector() * self:GetStat("Secondary.Velocity") )
		end
		self:SetNextPrimaryFire( CurTime()  + self:GetStat("Secondary.Delay") )
		if IsFirstTimePredicted() then
			self:EmitSound( self:GetStat("Secondary.Sound") )
		end
		self.Owner:ViewPunch( self:GetStat("Secondary.Recoil") )
	end
	]]
end
