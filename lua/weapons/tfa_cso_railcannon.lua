SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Anri" --Author Tooltip
SWEP.Contact				= "" --Contact Info Tooltip
SWEP.Purpose				= "" --Purpose Tooltip
SWEP.Instructions				= "" --Instructions Tooltip
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.PrintName				= "Rail Cannon"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 3				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter if enabled in the GUI.
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.Weight				= 30			-- This controls how "good" the weapon is for autopickup.
SWEP.UseBallistics		= false			-- Enable Ballistics? If this gun uses special tracer effects, don't!

--[[WEAPON HANDLING]]--

--Firing related
SWEP.Primary.Sound 			= Sound("RailCannon.Fire")				-- This is the sound of the weapon, when you shoot.
SWEP.Primary.Damage		= 900 / 12 --effective damage
SWEP.Primary.DamageChargeTable = {
	[0] = 300 / 12,
	[1] = 300 / 12,
	[2] = 600 / 12,
	[3] = 900 / 12
}
SWEP.DamageType = DMG_BULLET --See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.
SWEP.Primary.NumShots	= 12 --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic			= true					-- Automatic/Semi Auto
SWEP.Primary.RPM				= 180					-- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Semi				= 180					-- RPM for semi-automatic or burst fire.  This is in Rounds Per Minute / RPM
SWEP.FiresUnderwater = false
SWEP.Primary.AmmoConsumption	= 1

-- nZombies Stuff
SWEP.NZWonderWeapon		= true	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName			= "Molecule Flex Constructor"	-- What name this weapon should use when Pack-a-Punched.
--SWEP.NZPaPReplacement 	= "nil"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually.

-- Selective Fire Stuff

SWEP.SelectiveFire		= false --Allow selecting your firemode?
SWEP.DisableBurstFire	= true --Only auto/single?
SWEP.OnlyBurstFire		= false --No auto, only burst/single?
SWEP.DefaultFireMode 	= "" --Default to auto or whatev

--Ammo Related

SWEP.Primary.ClipSize			= 24					-- This is the size of a clip
SWEP.Primary.DefaultClip			= 96				-- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo			= "buckshot"					-- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DisableChambering = true --Disable round-in-the-chamber

--Recoil Related
SWEP.Primary.KickUp			= 0.5				-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= 0.25					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.5					-- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.35 	--Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

--Firing Cone Related

SWEP.Primary.Spread		= .045					--This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .04	-- Ironsight accuracy, should be the same for shotguns

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
SWEP.JumpAccuracyMultiplier=2--Less is more.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.WalkAccuracyMultiplier=1.35--Less is more.  Accuracy * 2 = Half as accurate.  Accuracy * 5 = 1/5 as accurate
SWEP.IronSightTime = 0.3 --The time to enter ironsights/exit it.
SWEP.NearWallTime = 0.25 --The time to pull up  your weapon or put it back down
SWEP.ToCrouchTime = 0.05 --The time it takes to enter crouching state
SWEP.WeaponLength = 50 --Almost 3 feet Feet.  This should be how far the weapon sticks out from the player.  This is used for calculating the nearwall trace.
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.SprintFOVOffset = 3.75 --Add this onto the FOV when we're sprinting.

--[[PROJECTILES]]--

SWEP.ProjectileEntity = nil --Entity to shoot
SWEP.ProjectileVelocity = 0 --Entity to shoot's velocity
SWEP.ProjectileModel = nil --Entity to shoot's model

--[[VIEWMODEL]]--

SWEP.ViewModel			= "models/weapons/tfa_cso/c_railcannon.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.

--[[WORLDMODEL]]--

SWEP.WorldModel			= "models/weapons/tfa_cso/w_railcannon.mdl" -- Worldmodel path

SWEP.HoldType 				= "shotgun"		-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -4.5,
		Right = 0,
		Forward = 11,
		},
		Ang = {
		Up = 90,
		Right = 10,
		Forward = 195
		},
		Scale = 1.1
}

SWEP.ThirdPersonReloadDisable=false --Disable third person reload?  True disables.

SWEP.ShowWorldModel = true

--[[SCOPES]]--

SWEP.BoltAction			= false  --Unscope/sight after you shoot?
SWEP.Scoped				= false  --Draw a scope overlay?

SWEP.ScopeOverlayThreshold = 0.8 --Percentage you have to be sighted in to see the scope.
SWEP.BoltTimerOffset = 0.01 --How long you stay sighted in after shooting, with a bolt action.

SWEP.ScopeScale = 0.5 --Scale of the scope overlay
SWEP.ReticleScale = 0.7 --Scale of the reticle overlay

--GDCW Overlay Options.  Only choose one.

SWEP.Secondary.UseACOG			= true	 --Overlay option
SWEP.Secondary.UseMilDot			= false			 --Overlay option
SWEP.Secondary.UseSVD			= false		 --Overlay option
SWEP.Secondary.UseParabolic		= false		 --Overlay option
SWEP.Secondary.UseElcan			= false	 --Overlay option
SWEP.Secondary.UseGreenDuplex		= false		 --Overlay option

--[[SHOTGUN CODE]]--

SWEP.Shotgun = false --Enable shotgun style reloading.

SWEP.ShellTime			= .5 -- For shotguns, how long it takes to insert a shell.

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(-5.788, -1.009, 0)
SWEP.RunSightsAng = Vector(-16.223, -35.562, 0)

--[[IRONSIGHTS]]--

SWEP.data 				= {}
SWEP.data.ironsights			= 0 --Enable Ironsights
SWEP.Secondary.IronFOV			= 75					-- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsPos = Vector(6.143, 0, 1.692)
SWEP.IronSightsAng = Vector(0, 0, 0)

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
SWEP.SprintBobMult=1.5 -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this > 1 probably for sprinting.
SWEP.IronBobMult=0  -- More is more bobbing, proportionally.  This is multiplication, not addition.  You want to make this < 1 for sighting, 0 to outright disable.
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS!!!!11111oneONEELEVEN

--[[HOLDTYPES]]--

SWEP.IronSightHoldTypeOverride=""  --This variable overrides the ironsights holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.
SWEP.SprintHoldTypeOverride=""  --This variable overrides the sprint holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.

--[[VIEWMODEL BLOWBACK]]--

SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-2,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = false
SWEP.Blowback_Shell_Effect = "9mmShellEject"

--[[ANIMATION]]--

SWEP.ForceDryFireOff = true --Disables dryfire.  Set to false to enable them.
SWEP.DisableIdleAnimations = false --Disables idle animations.  Set to false to enable them.
SWEP.ForceEmptyFireOff = true --Disables empty fire animations.  Set to false to enable them.

--If you really want, you can remove things from SWEP.actlist and manually enable animations and set their lengths.

SWEP.SequenceEnabled = {} --Self explanitory.  This can forcefully enable or disable a certain ACT_VM
SWEP.SequenceLength = {}  --This controls the length of a certain ACT_VM
//SWEP.SequenceLengthOverride={
//	[ACT_VM_PRIMARYATTACK] = 1,
//}
--[[EFFECTS]]--



--Muzzle Flash

SWEP.MuzzleAttachment			= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
--SWEP.MuzzleAttachmentRaw = 1 --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models

SWEP.DoMuzzleFlash = true --Do a muzzle flash?
SWEP.CustomMuzzleFlash = true --Disable muzzle anim events and use our custom flashes?
SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = "cso_muz_railcan" --Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.

--Tracer Stuff

SWEP.Tracer				= 0		--Bullet tracer.  TracerName overrides this.
SWEP.TracerName 		= "cso_tra_railcan" 	--Change to a string of your tracer name.  Can be custom.
								--There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 1 	--0 disables, otherwise, 1 in X chance


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
SWEP.AnimCycle = 0 -- Start on the right

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

SWEP.ShouldDrawAmmoHUD=false--THIS IS PROCEDURALLY CHANGED AND SHOULD NOT BE TWEAKED.  BASE DEPENDENT VALUE.  DO NOT CHANGE OR THINGS MAY BREAK.  NO USE TO YOU.
SWEP.DefaultFOV=90 --BASE DEPENDENT VALUE.  DO NOT CHANGE OR THINGS MAY BREAK.  NO USE TO YOU.

--Disable secondary crap

SWEP.Secondary.ClipSize			= 0					-- Size of a clip
SWEP.Secondary.DefaultClip			= 0					-- Default ammo to give...
SWEP.Secondary.Automatic			= false					-- Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none" -- Self explanitory, ammo type.

--Convar support

SWEP.ConDamageMultiplier = 1

SWEP.Base				= "tfa_gun_base"

DEFINE_BASECLASS( SWEP.Base )

SWEP.VElements = {
	["stage1_sprite"] = {
		type = "Sprite",
		sprite = "sprites/yellowflare",
		bone = "railcannon_root",
		rel = "",
		pos = Vector(-2.743, 14.612, 0.856),
		size = {
			x = 1.92,
			y = 1.92
		},
		color = Color(255, 255, 0, 255),
		nocull = true,
		additive = true,
		vertexalpha = true,
		vertexcolor = true,
		ignorez = true,
		active = false
	},
	["stage2_sprite"] = {
		type = "Sprite",
		sprite = "sprites/yellowflare",
		bone = "railcannon_root",
		rel = "",
		pos = Vector(-2.743, 13.024, 0.856),
		size = {
			x = 1.92,
			y = 1.92
		},
		color = Color(255, 192, 0, 255),
		nocull = true,
		additive = true,
		vertexalpha = true,
		vertexcolor = true,
		ignorez = true,
		active = false
	},
	["stage3_sprite"] = {
		type = "Sprite",
		sprite = "sprites/yellowflare",
		bone = "railcannon_root",
		rel = "",
		pos = Vector(-2.743, 11.307, 0.856),
		size = {
			x = 1.92,
			y = 1.92
		},
		color = Color(255, 128, 0, 255),
		nocull = true,
		additive = true,
		vertexalpha = true,
		vertexcolor = true,
		ignorez = true,
		active = false
	}
}

function SWEP:SetupDataTables(...)
	self:NetworkVar("Int",31,"Charge")
	return BaseClass.SetupDataTables(self, ...)
end

function SWEP:Deploy(...)
	self:SetCharge(0)
	return BaseClass.Deploy(self, ...)
end

local AnimTable = {
	[1] = {
		--["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "v_idle_chage1"
	},
	[2] = {
		--["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "v_idle_chage2"
	},
	[3] = {
		--["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "v_idle_chage3"
	},
	["shoot"] = {
		--["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "shoot2"
	}
}

function SWEP:ChooseIdleAnim(...)
	local c = self:GetCharge()
	if AnimTable[c] then
		local typev, tanim = AnimTable[c].type, AnimTable[c].value
		if typev ~= TFA.Enum.ANIMATION_SEQ then
			return self:SendViewModelAnim(tanim)
		else
			return self:SendViewModelSeq(tanim)
		end
	end
	return BaseClass.ChooseIdleAnim(self, ...)
end

function SWEP:ChooseShootAnim(...)
	local c = self:GetCharge()
	if c > 1 then
		local typev, tanim = AnimTable["shoot"].type, AnimTable["shoot"].value
		if typev ~= TFA.Enum.ANIMATION_SEQ then
			return self:SendViewModelAnim(tanim)
		else
			return self:SendViewModelSeq(tanim)
		end
	end
	return BaseClass.ChooseShootAnim(self, ...)
end

--local chargeStat = TFA.GetStatus("charging")
local chargeMax = 3
local oldc = -1
SWEP.Primary.ChargeTime = 0.75

function SWEP:ChargedAttack()
	self:SetStatus(TFA.GetStatus("idle"))
	self:PrimaryAttack()
	self:SetCharge(0)
end

function SWEP:Think2(...)
	local stat = self:GetStatus()

	if TFA.Enum.ReadyStatus[stat] then
		if self:GetOwner():KeyDown(IN_ATTACK2) and not self:GetSprinting() and self:Clip1() >= 1 then
			self:SetCharge(1)
			self:SetStatus(chargeStat)
			self:SetStatusEnd(CurTime() + self:GetStat("Primary.ChargeTime"))
			self:SetNextPrimaryFire(self:GetStatusEnd())
			self:ChooseIdleAnim()
		end
	elseif stat == chargeStat then
		if self:GetSprinting() then
			self:SetCharge(0)
			self:ChooseIdleAnim()
		elseif not self:GetOwner():KeyDown(IN_ATTACK2) and CurTime() > self:GetNextPrimaryFire() then
			if self:GetCharge() ~= 0 then
				self:ChargedAttack()
			else
				self:SetStatusEnd(CurTime() - 1)
			end
		elseif self:GetCharge() < chargeMax and CurTime() > self:GetStatusEnd() then
			self:SetCharge(self:GetCharge() + 1)
			self:SetStatusEnd(CurTime() + self:GetStat("Primary.ChargeTime"))
			self:ChooseIdleAnim()
		elseif CurTime() > self:GetStatusEnd() then
			self:SetStatusEnd(CurTime() + 1)
		end
	elseif self:GetCharge() ~= 0 then
		self:SetCharge(0)
	end

	local c = self:GetCharge()
	self.Primary.Damage = self.Primary.DamageChargeTable[math.Clamp(c, 0, 3)]

	if c ~= oldc then
		oldc = c
		self:ClearStatCache()
	end

	if CLIENT then
		if c >= 3 then
			self.VElements["stage3_sprite"].active = true
		else
			self.VElements["stage3_sprite"].active = false
		end

		if c >= 2 then
			self.VElements["stage2_sprite"].active = true
		else
			self.VElements["stage2_sprite"].active = false
		end

		if c >= 1 then
			self.VElements["stage1_sprite"].active = true
		else
			self.VElements["stage1_sprite"].active = false
		end
	end

	return BaseClass.Think2(self, ...)
end

SWEP.EventTable = {
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 5 / 35, ["type"] = "lua", ["value"] = function(wep,vm)
			if wep then
				wep:StopSound("RailCannon.Charge.Stage1_Start")
				wep:StopSound("RailCannon.Charge.Stage3_Loop")
			end
		end, ["client"] = true, ["server"] = true }
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_railcannon")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
