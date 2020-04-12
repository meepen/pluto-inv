-- Variables that are used on both client and server
SWEP.Category				= "TFA CS:O"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Chain Grenade"		
SWEP.Slot				= 4				
SWEP.SlotPos				= 40			
SWEP.DrawAmmo				= true		
SWEP.DrawWeaponInfoBox			= false		
SWEP.BounceWeaponIcon   		= 	false	
SWEP.DrawCrosshair			= true		
SWEP.Weight				= 2			
SWEP.AutoSwitchTo			= true		
SWEP.AutoSwitchFrom			= true		
SWEP.HoldType 				= "grenade"		
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and ar2 make for good sniper rifles

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName			= "Chain-Chain Grenade"	
--SWEP.NZPaPReplacement 	= "nil"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= true	
SWEP.NZTotalBlackList	= true	

SWEP.ViewModelFOV			= 80
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/tfa_cso/c_chain_grenade.mdl"	
SWEP.WorldModel				= "models/weapons/tfa_cso/w_chain_grenade.mdl"	
SWEP.ShowWorldModel			= true
SWEP.Base				= "tfa_nade_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true

SWEP.Primary.RPM				= 30		
SWEP.Primary.ClipSize			= 1		
SWEP.Primary.DefaultClip		= 6		
SWEP.Primary.Automatic			= false		
SWEP.Primary.Ammo			= "grenade"
-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a metal peircing shotgun slug

SWEP.Primary.Round 			= ("chaingrenade_thrown")	

SWEP.Velocity = 800 
SWEP.Velocity_Underhand = 450 

SWEP.Offset = { 
		Pos = {
		Up = -1.5,
		Right = 1,
		Forward = 3,
		},
		Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
		},
		Scale = 1.2
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_chaingrenade")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Deploy( ... )
    BaseClass.Deploy( self, ... )
	self:CleanParticles()
	return true
end

function SWEP:Holster( ... )
	self:CleanParticles()
	return BaseClass.Holster( self, ... )
end

function SWEP:OnRemove( ... )
	self:CleanParticles()
	return BaseClass.OnRemove( self, ... )
end