AddCSLuaFile()

sound.Add {
	name = "CW_PPS_FIRE",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90-1.ogg"
}
sound.Add {
	name = "CW_PPS_MAGOUT",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_clipout.ogg"
}
sound.Add {
	name = "CW_PPS_MAGIN",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_clipin.ogg"
}
sound.Add {
	name = "CW_PPS_BOLTPULL",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_boltpull.ogg"
}
sound.Add {
	name = "CW_PPS_BOLTFORWARD",
	channel = CHAN_WEAPON,
	sound = "weapons/pps/p90_cliprelease.ogg"
}

SWEP.Offset = {
	Pos = {
		Up = -3,
		Right = 1,
		Forward = 0,
	},
	Ang = {
		Up = 0,
		Right = -10,
		Forward = 180,
	}
}

SWEP.DrawCrosshair = true
SWEP.PrintName = "PPSh"
SWEP.CSMuzzleFlashes = true

SWEP.AttachmentModelsVM = {
	["md_fas2_holo_aim"] = { type = "Model", model = "models/v_holo_sight_orig_hx.mdl", bone = "PPhS_41", rel = "", pos = Vector(-3, 0, -1.8), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_fas2_holo"] = { type = "Model", model = "models/v_holo_sight_kkrc.mdl", bone = "PPhS_41", rel = "", pos = Vector(-3, 0, -1.8), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_myfuckingbipod3"] = { type = "Model", model = "models/wystan/attachments/bipod.mdl", bone = "PPhS_41", rel = "", pos = Vector(11.947, 0, 0.569), angle = Angle(0, 90, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_kobra"] = { type = "Model", model = "models/cw2/attachments/kobra.mdl", bone = "PPhS_41", rel = "", pos = Vector(3, -0.51, -1.201), angle = Angle(0, -90, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_foregrip"] = { type = "Model", model = "models/wystan/attachments/foregrip1.mdl", bone = "PPhS_41", rel = "", pos = Vector(0.518, 0, -1), angle = Angle(0, 90, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_anpeq15"] = { type = "Model", model = "models/cw2/attachments/anpeq15.mdl", bone = "PPhS_41", rel = "", pos = Vector(1.557, -0.75, 1.557), angle = Angle(0, -180, 90), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_saker"] = { type = "Model", model = "models/cw2/attachments/556suppressor.mdl", bone = "PPhS_41", rel = "", pos = Vector(9, 0, 0.189), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_microt1"] = { type = "Model", model = "models/cw2/attachments/microt1.mdl", bone = "PPhS_41", rel = "", pos = Vector(1, 0, 2.596), angle = Angle(0, -90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_eotech"] = { type = "Model", model = "models/wystan/attachments/2otech557sight.mdl", bone = "PPhS_41", rel = "", pos = Vector(-9.87, -0.401, -8.4), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_aimpoint"] = { type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "PPhS_41", rel = "", pos = Vector(-4.676, 0.209, -2.58), angle = Angle(0, 90, 0), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["md_acog"] = { type = "Model", model = "models/wystan/attachments/2cog.mdl", bone = "PPhS_41", rel = "", pos = Vector(-2.597, 0.3, -2.597), angle = Angle(0, 90, 0), size = Vector(0.898, 0.898, 0.898), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

if CustomizableWeaponry_KK_HK416 then
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {700, -400}, atts = {"md_microt1", "md_eotech", "md_kobra", "md_aimpoint", "md_acog", "md_fas2_holo"}},
		[2] = {header = "Barrel", offset = {200, -400}, atts = {"md_saker"}},
		[3] = {header = "Handguard", offset = {-400, 0}, atts = {"md_foregrip", "md_myfuckingbipod3"}},
		[4] = {header = "Rail", offset = {-450, -450}, atts = {"md_anpeq15"}},
		["+reload"] = {header = "Ammo", offset = {700, 0}, atts = {"am_magnum", "am_matchgrade"}}
	}
else
	SWEP.Attachments = {
		[1] = {header = "Sight", offset = {700, -400}, atts = {"md_microt1", "md_eotech", "md_kobra", "md_aimpoint", "md_acog"}},
		[2] = {header = "Barrel", offset = {200, -400}, atts = {"md_saker"}},
		[3] = {header = "Handguard", offset = {-400, 0}, atts = {"md_foregrip", "md_myfuckingbipod3"}},
		[4] = {header = "Rail", offset = {-450, -450}, atts = {"md_anpeq15"}},
		["+reload"] = {header = "Ammo", offset = {700, 0}, atts = {"am_magnum", "am_matchgrade"}}
	}
end

SWEP.Ironsights = {
	Pos = Vector(6.3, -4, 2.1),
	Angle = Vector(1, 0, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.9,
}

SWEP.Sounds = {
	reload = {
		{time = 0.4, sound = "CW_PPS_MAGOUT"},
		{time = 2, sound = "CW_PPS_MAGIN"},
		{time = 3.05, sound = "CW_PPS_BOLTPULL"},
		{time = 3.3, sound = "CW_PPS_BOLTFORWARD"}
	}
}

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.Base = "weapon_tttbase"
SWEP.HoldType = "ar2"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= true
SWEP.ViewModel		= "models/weapons/pps/v_smg_pps.mdl"
SWEP.WorldModel		= "models/weapons/pps/w_smg_pps.mdl"

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 50
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo          = "smg1"
SWEP.AmmoEnt               = "item_ammo_smg1_ttt"

SWEP.Primary.Sound = "CW_PPS_FIRE"
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 60 / 1000
SWEP.Primary.Damage = 11.4
SWEP.ReloadSpeed = 1.3
SWEP.DeploySpeed = 1.4

SWEP.HeadshotMultiplier = 1.6

SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AdminSpawnable		= true

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 250,
	DamageDropoffRangeMax = 2200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.05, 0.045)
}