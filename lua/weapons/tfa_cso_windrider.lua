SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze and WackoD" --Author Tooltip
SWEP.Contact				= "" --Contact Info Tooltip
SWEP.Purpose				= "" --Purpose Tooltip
SWEP.Instructions				= "" --Instructions Tooltip
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.PrintName				= "Dual Beretta Windrider"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter if enabled in the GUI.
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.Weight				= 30			-- This controls how "good" the weapon is for autopickup.
SWEP.Type	= "Unique Grade Akimbo Pistol"

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("Gunkata.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 90					-- Damage, in standard damage points.
SWEP.DamageType = DMG_BULLET --See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.
SWEP.Primary.NumShots	= 1 --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.RPM				= 700					-- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Semi				= 300					-- RPM for semi-automatic or burst fire.  This is in Rounds Per Minute / RPM
SWEP.FiresUnderwater = true

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Max Payne"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.

-- Selective Fire Stuff

SWEP.SelectiveFire		= false --Allow selecting your firemode?
SWEP.DisableBurstFire	= false --Only auto/single?
SWEP.OnlyBurstFire		= true --No auto, only burst/single?
SWEP.DefaultFireMode 	= "" --Default to auto or whatev
SWEP.Primary.BurstDelay = 0.25
SWEP.FireModes = {
	"3Burst",

}

--Ammo Related

SWEP.Primary.ClipSize			= 30					-- This is the size of a clip
SWEP.Primary.DefaultClip			= 330 			-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo			= "pistol"					-- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.  
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering = true --Disable round-in-the-chamber

--Recoil Related
SWEP.Primary.KickUp			= 0.05					-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= 0.02					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0					-- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.3 	--Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

--Firing Cone Related

SWEP.Primary.Spread		= .008					--This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .008	-- Ironsight accuracy, should be the same for shotguns

--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 1.5 --How far the spread can expand when you shoot.
SWEP.Primary.SpreadIncrement = 1/3.5 --What percentage of the modifier is added on, per shot.
SWEP.Primary.SpreadRecovery = 2 --How much the spread recovers, per second.

--Range Related
SWEP.Primary.Range = -1 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 0.8 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.


--Penetration Related

SWEP.MaxPenetrationCounter=2 --The maximum number of ricochets.  To prevent stack overflows.

--Misc
SWEP.IronRecoilMultiplier=0.5 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchRecoilMultiplier=0.65  --Multiply recoil by this factor when we're crouching.  This is proportional, not inversely.
SWEP.JumpRecoilMultiplier=1.3  --Multiply recoil by this factor when we're crouching.  This is proportional, not inversely.
SWEP.WallRecoilMultiplier=1.1  --Multiply recoil by this factor when we're changing state e.g. not completely ironsighted.  This is proportional, not inversely.
SWEP.ChangeStateRecoilMultiplier=1.3  --Multiply recoil by this factor when we're crouching.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier=0.5--Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate
SWEP.ChangeStateAccuracyMultiplier=1.5 --Less is more.  A change of state is when we're in the progress of doing something, like crouching or ironsighting.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.JumpAccuracyMultiplier=1--Less is more.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.WalkAccuracyMultiplier=1--Less is more.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.IronSightTime = 0.3 --The time to enter ironsights/exit it.
SWEP.NearWallTime = 0.25 --The time to pull up  your weapon or put it back down
SWEP.ToCrouchTime = 0.05 --The time it takes to enter crouching state
SWEP.WeaponLength = 50 --Almost 3 feet Feet.  This should be how far the weapon sticks out from the player.  This is used for calculating the nearwall trace.
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.SprintFOVOffset = 2 --Add this onto the FOV when we're sprinting.

--[[PROJECTILES]]--

SWEP.ProjectileEntity = nil --Entity to shoot
SWEP.ProjectileVelocity = 0 --Entity to shoot's velocity
SWEP.ProjectileModel = nil --Entity to shoot's model

--[[VIEWMODEL]]--

SWEP.ViewModel			= "models/weapons/tfa_cso/c_windrider.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 85		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position. 
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle. 

//SWEP.ViewModelBoneMods = {
//	["root"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) },
//	["spsmg"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.5, 0), angle = Angle(0, 0, 0) }
//}

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_windrider.mdl" -- Worldmodel path

SWEP.HoldType 				= "duel"		-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.WElements = {
	["otherpist"] = { type = "Model", model = "models/weapons/tfa_cso/w_windrider.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6.479, 1.812, 2.755), angle = Angle(0, 75.515, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -2.8,
		Right = 1.25,
		Forward = 5.5,
		},
		Ang = {
		Up = -100,
		Right = 0,
		Forward = 175
		},
		Scale = 1
}

SWEP.ThirdPersonReloadDisable=false --Disable third person reload?  True disables.

SWEP.ShowWorldModel = true

--[[SCOPES]]--

SWEP.BoltAction			= false  --Unscope/sight after you shoot?
SWEP.Scoped				= false  --Draw a scope overlay?

SWEP.ScopeOverlayThreshold = 0.875 --Percentage you have to be sighted in to see the scope.
SWEP.BoltTimerOffset = 0.25 --How long you stay sighted in after shooting, with a bolt action.

SWEP.ScopeScale = 0.5 --Scale of the scope overlay
SWEP.ReticleScale = 0.7 --Scale of the reticle overlay

--GDCW Overlay Options.  Only choose one.

SWEP.Secondary.UseACOG			= false	 --Overlay option
SWEP.Secondary.UseMilDot			= false			 --Overlay option
SWEP.Secondary.UseSVD			= false		 --Overlay option
SWEP.Secondary.UseParabolic		= false		 --Overlay option
SWEP.Secondary.UseElcan			= false	 --Overlay option
SWEP.Secondary.UseGreenDuplex		= true		 --Overlay option

--[[SHOTGUN CODE]]--

SWEP.Shotgun = false --Enable shotgun style reloading.

SWEP.ShellTime			= .35 -- For shotguns, how long it takes to insert a shell.

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(0, 0, 0)

--[[IRONSIGHTS]]--

SWEP.data 				= {}
SWEP.data.ironsights			= 0 --Enable Ironsights
SWEP.Secondary.IronFOV			= 75					-- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsPos = Vector(6.519, 0, -1.601)
SWEP.IronSightsAng = Vector(3.296, 0.289, -1.89)

--[[INSPECTION]]--

SWEP.InspectPos = nil --Replace with a vector, in style of ironsights position, to be used for inspection
SWEP.InspectAng = nil --Replace with a vector, in style of ironsights angle, to be used for inspection
SWEP.InspectionLoop = true --Setting false will cancel inspection once the animation is done.  CS:GO style.

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.ShootWhileDraw=false --Can you shoot while draw anim plays?
SWEP.AllowReloadWhileDraw=false --Can you reload while draw anim plays?
SWEP.SightWhileDraw=false --Can we sight in while the weapon is drawing / the draw anim plays?
SWEP.AllowReloadWhileHolster=true --Can we interrupt holstering for reloading?
SWEP.ShootWhileHolster=true --Cam we interrupt holstering for shooting?
SWEP.SightWhileHolster=false --Cancel out "iron"sights when we holster?
SWEP.UnSightOnReload=true --Cancel out ironsights for reloading.
SWEP.AllowReloadWhileSprinting=false --Can you reload when close to a wall and facing it?
SWEP.AllowReloadWhileNearWall=false --Can you reload when close to a wall and facing it?
SWEP.SprintBobMult=0 -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this > 1 probably for sprinting.
SWEP.IronBobMult=0  -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this < 1 for sighting, 0 to outright disable.
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS!!!!11111oneONEELEVEN

--[[HOLDTYPES]]--

SWEP.IronSightHoldTypeOverride=""  --This variable overrides the ironsights holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.
SWEP.SprintHoldTypeOverride=""  --This variable overrides the sprint holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.

--[[VIEWMODEL BLOWBACK]]--

SWEP.BlowbackEnabled = false --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-2,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = "RifleShellEject"

--[[ANIMATION]]--

SWEP.ForceDryFireOff = false --Disables dryfire.  Set to false to enable them.
SWEP.DisableIdleAnimations = false --Disables idle animations.  Set to false to enable them.
SWEP.ForceEmptyFireOff = false --Disables empty fire animations.  Set to false to enable them.

--If you really want, you can remove things from SWEP.actlist and manually enable animations and set their lengths.

SWEP.SequenceEnabled = {} --Self explanitory.  This can forcefully enable or disable a certain ACT_VM
SWEP.SequenceLength = {}  --This controls the length of a certain ACT_VM
//SWEP.SequenceLengthOverride={
//	[ACT_VM_PRIMARYATTACK] = 1,
//}
--[[EFFECTS]]--



--Muzzle Flash

SWEP.MuzzleAttachment			= "0" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models

SWEP.DoMuzzleFlash = true --Do a muzzle flash?
SWEP.CustomMuzzleFlash = true --Disable muzzle anim events and use our custom flashes?
SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = "muz_gunkata_wr" --Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.

--Tracer Stuff

SWEP.Tracer				= 0		--Bullet tracer.  TracerName overrides this.
SWEP.TracerName 		= nil 	--Change to a string of your tracer name.  Can be custom.
								--There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 0 	--0 disables, otherwise, 1 in X chance


SWEP.TracerLua 			= false --Use lua effect, TFA Muzzle syntax.  Currently obsolete.
SWEP.TracerDelay		= 0.01 --Delay for lua tracer effect

--[[EVENT TABLE]]--

SWEP.EventTable = {} --Event Table, used for custom events when an action is played.  This can even do stuff like playing a pump animation after shooting.

--example:
--SWEP.EventTable = {
--	[ACT_VM_RELOAD] = {
--		{ ['time'] = 0.1, ['type'] = "lua", ['value'] = examplefunction, ['client'] = true, ['server'] = false  },
--		{ ['time'] = 0.2, ['type'] = "sound", ['value'] = Sound("ExampleGun.Sound1", ['client'] = true, ['server'] = false ) }
--	}
--}


--[[RENDER TARGET]]--

SWEP.RTMaterialOverride = nil -- Take the material you want out of print(LocalPlayer():GetViewModel():GetMaterials()), subtract 1 from its index, and set it to this.

SWEP.RTOpaque = false -- Do you want your render target to be opaque?

SWEP.RTCode = nil


--[[AKIMBO]]--

SWEP.Akimbo = false --Akimbo gun?  Alternates between primary and secondary attacks.
SWEP.AnimCycle = 1 -- Start on the right
 
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
SWEP.CanHolsterAnimate=false
SWEP.CanHolsterAnimateEmpty=false
SWEP.CanIdleAnimate=false
SWEP.CanIdleAnimateEmpty=false
SWEP.CanIdleAnimateSilenced=false
SWEP.CanShootAnimate=false
SWEP.CanShootAnimateSilenced=false
SWEP.CanReloadAnimate=true
SWEP.CanReloadAnimateEmpty=false
SWEP.CanReloadAnimateSilenced=false
SWEP.CanDryFireAnimate=false
SWEP.CanDryFireAnimateSilenced=false
SWEP.CanSilencerAttachAnimate=false
SWEP.CanSilencerDetachAnimate=false

--Misc

SWEP.ShouldDrawAmmoHUD=false--THIS IS PROCEDURALLY CHANGED AND SHOULD NOT BE TWEAKED.  BASE DEPENDENT VALUE.  DO NOT CHANGE OR THINGS MAY BREAK.  NO USE TO YOU.
SWEP.DefaultFOV=90 --BASE DEPENDENT VALUE.  DO NOT CHANGE OR THINGS MAY BREAK.  NO USE TO YOU.

--Disable secondary crap

SWEP.Secondary.ClipSize			= 0					-- Size of a clip
SWEP.Secondary.DefaultClip			= 0					-- Default ammo to give...
SWEP.Secondary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none" -- Self explanitory, ammo type.

SWEP.idle = false
--Convar support

SWEP.ConDamageMultiplier = 1
SWEP.nextidle = 0
SWEP.Base				= "tfa_gun_base"
local fires = 6

DEFINE_BASECLASS("tfa_gun_base" )
function SWEP:PrimaryAttack()
--TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
if self:Clip1() <= 0 then return end
if self.rd-1 > CurTime() then return end

local VModel = self.Owner:GetViewModel()
local Seq = VModel:LookupSequence("shoot")
local Seq2 = VModel:LookupSequence("shoot2")
local Seq3 = VModel:LookupSequence("shoot_last")
local Seq4 = VModel:LookupSequence("shoot2_last")
if self:Clip1()%6 == 0 or self:Clip1()%6 == 5   then 
VModel:SendViewModelMatchingSequence( Seq )
self.MuzzleAttachment = "0"
end
if  self:Clip1()%6 == 4 then
VModel:SendViewModelMatchingSequence( Seq3)
self.MuzzleAttachment = "0"
self.Hand = 2
end
if  self:Clip1()%6 == 3 or self:Clip1()%6 == 2   then 
VModel:SendViewModelMatchingSequence( Seq2 )
self.MuzzleAttachment = "2"
end
if  self:Clip1()%6 == 1 then
VModel:SendViewModelMatchingSequence( Seq4)
self.MuzzleAttachment = "2"

self.Hand = 1
end
BaseClass.PrimaryAttack(self)
self.nextidle = CurTime() + 0.4
end
------
SWEP.rd = 0
function SWEP:Reload()

if self:Ammo1() <= 0 then return end
if self:Clip1() >= self.Primary.ClipSize then return end
if self.rd > CurTime() then return end


self.rd = CurTime() + 3
self.nextidle = CurTime() + 2
self:SetNextPrimaryFire(CurTime() + 2)
self:SetNextSecondaryFire(CurTime() + 2)

if SERVER then
local VModel = self.Owner:GetViewModel()
local Seq1 = VModel:LookupSequence("reload")
local Seq2 = VModel:LookupSequence("reload2")
if self.Hand == 1 then
VModel:SendViewModelMatchingSequence( Seq1 )
else
VModel:SendViewModelMatchingSequence( Seq2 )
end
end
timer.Simple(2,function() 
if self:IsValid() and  self.Owner:GetActiveWeapon():GetClass() ==  "tfa_cso_windrider" then
self:CompleteReload()
self.Hand = 1
end
end)
if SERVER then
self.Owner:SetAnimation(PLAYER_RELOAD )
end
end
function SWEP:Think()
BaseClass.Think(self)
local VModel = self.Owner:GetViewModel()
local Seq1 = VModel:LookupSequence("idle")
local Seq2 = VModel:LookupSequence("idle2")

if self.nextidle <= CurTime() and self.idle then


self.idle = false

end

if self.nextidle > CurTime()  then
self.idle = true
end

skill = 1
end
function SWEP:Deploy()
self.nextidle = CurTime() + 1
BaseClass.Deploy(self)
local VModel = self.Owner:GetViewModel()
local Seq1 = VModel:LookupSequence("draw")
local Seq2 = VModel:LookupSequence("draw2")
if self.Hand == 2 then

VModel:SendViewModelMatchingSequence( Seq2 )
    return true
else
VModel:SendViewModelMatchingSequence( Seq1 )
    return true
end
end
local function SetEntityStuff( ent1, ent2 ) -- Transfer most of the set things on entity 2 to entity 1
	if !IsValid( ent1 ) or !IsValid( ent2 ) then return false end
	ent1:SetModel("models/weapons/tfa_cso/ef_windrider_man.mdl" )
	
    local 	ang =  ent2:GetAngles()
    ang.x = 0
	ent1:SetAngles(ang )

	ent1:SetSkin( ent2:GetSkin() )
	ent1:SetRenderMode(2)
	ent1:SetColor( Color(255, 255, 255, 100) ) 
	
	

end

local skillt = 0
local skill = 0
local skilltime = 0
local skilltime1 = 0
function SWEP:SecondaryAttack()
self:SetNextPrimaryFire( CurTime() + 0.1)

if  self:Clip1()%6 == 4 then


self.Hand = 2
end

if  self:Clip1()%6 == 1 then

self.Hand = 1
end


if self:Clip1() <= 0 then return end
local VModel = self.Owner:GetViewModel()


if self:Clip1() > 1 then
self:SetNextSecondaryFire(CurTime() + 0.1)




self.Owner:AnimRestartGesture(0, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)


if skilltime < CurTime() then

skill = skill + 1
if skill > 5 then

skill = 1
end


local Seq = VModel:LookupSequence("skill_0"..skill)

VModel:SendViewModelMatchingSequence( Seq )
skilltime = CurTime() + 0.5






end


if skilltime1 < CurTime() then

skillt = skillt + 1
if skillt > 5 then

skillt = 0
end
--[[if CLIENT then
local rag = ClientsideModel(self.Owner:GetModel())

SetEntityStuff(rag,self.Owner)
if self.Owner:Crouching() then
rag:SetSequence(rag:LookupSequence("crouch_skill"..skillt))
rag:SetPos( self.Owner:GetPos() + self.Owner:GetUp()*25)
else
rag:SetSequence(rag:LookupSequence("skill"..skillt))
rag:SetPos( self.Owner:GetPos() + self.Owner:GetUp()*40)
end
timer.Simple(0.8,function() 

if rag:IsValid() then rag:Remove() end end)

end]]--
skilltime1 = CurTime() + 0.2

end













timer.Create( "gunkatadeploy",1, 1, function() 

if not self.Owner:KeyPressed(IN_ATTACK2) then
self:Deploy()

end


end )



if SERVER then
	for k,v in ipairs(ents.FindInSphere(self.Owner:GetPos(),190)) do
		if GetConVar( "sv_tfa_cso_dmg_gunslingers_player" ):GetInt() == 0 then
			if v != self.Owner and (v:IsNPC() or v:IsNextBot() or v:GetClass() == "func_prop" ) then
				if v:Health() > 0 then
					v:TakeDamage( GetConVar( "sv_tfa_cso_dmg_windrider_rb" ):GetInt() , self.Owner, self.Entity )
					v:EmitSound("Gunkata.Hit2")
				end
			end
		else
			if v != self.Owner and (v:IsNPC() or v:IsNextBot() or v:IsPlayer() or v:GetClass() == "func_prop" ) then
				if v:Health() > 0 then
					v:TakeDamage( GetConVar( "sv_tfa_cso_dmg_windrider_rb" ):GetInt() , self.Owner, self.Entity )
					v:EmitSound("Gunkata.Hit2")
				end
			end	
		end
	end
end
self:TakePrimaryAmmo(1)

elseif self:Clip1() <= 1 then
local Seq1 = VModel:LookupSequence("skill_last")
VModel:SendViewModelMatchingSequence( Seq1 )
self:TakePrimaryAmmo(1)
if SERVER then
timer.Simple(0.5,function()












self:EmitSound("weapons/tfa_cso/gunkata/skill_last_exp.wav")
local effectdata = EffectData()
        effectdata:SetEntity(self.Owner)
		effectdata:SetOrigin(self.Owner:GetPos())
		effectdata:SetAngles(Angle(0,0,0))

	util.Effect("exp_gunkata_wr", effectdata)








    local radius = 225
	local phys_force = 1500
	local push_force = 1024

	for k, target in ipairs( ents.FindInSphere( self.Owner:GetPos(), radius ) ) do

		if IsValid( target ) then
			local tpos = target:LocalToWorld( target:OBBCenter() )
			local dir = ( tpos - self.Owner:GetPos() ):GetNormal()
			local phys = target:GetPhysicsObject()

			if target != self.Owner and ( target:IsPlayer() && !target:IsFrozen() && ( !target.was_pushed || target.was_pushed.t != CurTime() ) or target:IsNPC() or target:IsNextBot() ) then

				dir.z = math.abs( dir.z ) + 1

				local push = dir * push_force

				local vel = target:GetVelocity() + push
				vel.z = math.min( vel.z, push_force / 3 )

				target:SetVelocity( vel )

				target.was_pushed = { att=self.Owner, t=CurTime(), wep="weapon_fraggrenade" }

			elseif IsValid( phys ) then
				phys:ApplyForceCenter( dir * -1 * phys_force )
			end
		end
	end


end)

timer.Simple(1,function() 
if self:IsValid() and  self.Owner:GetActiveWeapon():GetClass() ==  "tfa_cso_windrider" then
self:CompleteReload()
self.Hand = 1
self:Deploy()
end
end)

self.Owner:SetAnimation(PLAYER_RELOAD )
end
end
end
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_windrider")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end