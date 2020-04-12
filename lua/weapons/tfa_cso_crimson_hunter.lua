SWEP.Base				= "tfa_gun_base"
SWEP.Author				= "Anri" 

SWEP.PrintName				= "Desert Eagle Crimson Hunter"		
SWEP.Slot				= 1				
SWEP.AutoSwitchTo			= true		
SWEP.AutoSwitchFrom			= true		

SWEP.Primary.Sound 			= "CrimsonHunter.Fire"				
SWEP.Primary.Damage		= 90					
SWEP.Primary.Automatic			= false					

SWEP.Secondary.Ent = "crimson_hunter_nade"
SWEP.Secondary.Velocity = 850
SWEP.Secondary.Ammo = "smg1_grenade"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 20
SWEP.Secondary.Delay = 1.5
SWEP.Secondary.Sound = "CrimsonHunter.Throw"


SWEP.Primary.ClipSize			= 30					
SWEP.Primary.DefaultClip			= 300				
SWEP.Primary.Ammo			= "357"					

SWEP.ViewModel			= "models/weapons/tfa_cso/c_crimson_hunter.mdl" 
SWEP.ViewModelFOV			= 80		
SWEP.ViewModelFlip			= false		
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_crimson_hunter.mdl" 

SWEP.HoldType 				= "pistol"		
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { 
	Pos = {
		Up = -1.5,
		Right = 0.8,
		Forward = 8.2,
	},
	Ang = {
		Up = 90,
		Right = 180,
		Forward = 0
	},
	Scale = 1
}


SWEP.WElements = {
	["nade"] = { type = "Model", model = "models/weapons/tfa_cso/w_crimsonhunter_nade.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.591, 1.781, 0.626), angle = Angle(-4.645, 38.619, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Tracer				= 0		
SWEP.TracerName 		= "cso_tra_crm_hnt" 	


SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_smg1_ttt"
SWEP.Base = "weapon_tttbase"
