
sound.Add {
	name = "R301.Deploy",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 80,
	sound = "weapons/r301/gunother/r301_deploy.ogg"
}
sound.Add {
	name = "R301.MagOut",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 80,
	sound = "weapons/r301/gunother/r301_mag_pull.ogg"
}
sound.Add {
	name = "R301.MagGrab",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 80,
	sound = "weapons/r301/gunother/r301_mag_grab.ogg"
}
sound.Add {
	name = "R301.MagIn",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 80,
	sound = "weapons/r301/gunother/r301_mag_insert.ogg"
}
sound.Add {
	name = "R301.BoltBack",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 80,
	sound = "weapons/r301/gunother/r301_bolt_back.ogg"
}
sound.Add {
	name = "R301.BoltForward",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 80,
	sound = "weapons/r301/gunother/r301_bolt_forward.ogg"
}

-- Copyright (c) 2018-2019 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

SWEP.Base               = "weapon_tttbase"
SWEP.Author             = ""
SWEP.Contact                = ""
SWEP.Purpose                = ""
SWEP.Instructions               = ""
SWEP.AutoSpawnable         = true
SWEP.Spawnable             = true
SWEP.AdminSpawnable         = false
SWEP.DrawCrosshair          = true
SWEP.PrintName              = "R301"
SWEP.Slot               = 2
SWEP.SlotPos                = 73

SWEP.Ortho = {-7, 9}

SWEP.Primary.Sound = "weapons/r301/gunfire/r301_fire.ogg"
SWEP.Primary.Damage = 14
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.083

SWEP.HeadshotMultiplier = 1.5

SWEP.CanBeSilenced = false
SWEP.Silenced = false

SWEP.FireSoundAffectedByClipSize = true

SWEP.Primary.ClipSize = 28
SWEP.Primary.DefaultClip = 28 * 2
SWEP.Primary.Ammo = "pistol"
SWEP.AmmoEnt = "item_ammo_pistol_ttt"
SWEP.Primary.Recoil = 1

SWEP.ViewModel = "models/v_models/v_r301.mdl"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.NoPlayerModelHands = true

SWEP.WorldModel = "models/w_models/weapons/w_rifle_m16a2.mdl"

SWEP.HoldType = "ar2"

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.015, 0.015)
}

SWEP.Ironsights = {
	Pos = Vector(-3.23, 1.66, 0.85),
	Angle = Vector(1.18, 0, -6),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.3,
	Zoom = 0.9,
}

SWEP.Offset = {
	Pos = {
		Up = 0,
		Right = 0,
		Forward = 0
	},
	Ang = {
		Up = 0,
		Right = 0,
		Forward = 180
	},
	Scale = 1
}

SWEP.VElements = {
	["ironholo"] = { type = "Model", model = "models/hunter/plates/plate025.mdl", bone = "def_c_base", rel = "", pos = Vector(-0.06, -5.85, 20), angle = Angle(0, -30, 0), size = Vector(0.017, 0.017, 0.009), color = Color(255, 107, 0, 137), surpresslightning = false, material = "lights/white", skin = 0, bodygroup = {} },
	["ironholo+"] = { type = "Model", model = "models/hunter/plates/plate025.mdl", bone = "def_c_base", rel = "", pos = Vector(0.059, -5.85, 20), angle = Angle(0, 30, 0), size = Vector(0.017, 0.017, 0.009), color = Color(255, 107, 0, 137), surpresslightning = false, material = "lights/white", skin = 0, bodygroup = {} }
}

local pow = 0.6
SWEP.RecoilInstructions = {
	Interval = 1,
	pow * Angle(-6, -2),
	pow * Angle(-4, -1),
	pow * Angle(-2, 3),
	pow * Angle(-1, 0),
	pow * Angle(-1, 0),
	pow * Angle(-3, 2),
	pow * Angle(-3, 1),
	pow * Angle(-2, 0),
	pow * Angle(-3, -3),
}