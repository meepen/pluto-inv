SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "THANATOS-9"

SWEP.ViewModel = "models/weapons/tfa_cso/c_thanatos_9.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_thanatos_9.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Grim Reaper"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= false	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= false	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.
SWEP.Precision = 15


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -30,
		Right = 1,
		Forward = 5,
		},
		Ang = {
		Up = -90,
		Right = 0,
		Forward = 180
		},
		Scale = 1.35
}


sound.Add({
	['name'] = "THANATOS9.Draw",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/thanatos9/draw.ogg" },
	['pitch'] = {100,100}
})

sound.Add({
	['name'] = "THANATOS9.Swing1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/thanatos9/swing_1.ogg" },
	['pitch'] = {100,100}
})

sound.Add({
	['name'] = "THANATOS9.Swing2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/thanatos9/swing_1.ogg" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-150,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 400, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 1, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 2, --time before next attack
		['hull'] = 512, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 25
	}
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 130, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-140,-5,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 1, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.8, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 1,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 2, --time before next attack
		['hull'] = 512, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Weapon_Knife.Hit",
		['hitworld'] = "Weapon_Knife.HitWall",
		['maxhits'] = 1
	}
}

local minsVec = Vector(-8, -8, -8)
local maxsVec = Vector(8, 8, 8)
local upVec = Vector(0, 0, 1)

SWEP.EventTable = {
	[ACT_VM_SECONDARYATTACK] = {
		{
			["time"] = 0.85,
			["type"] = "lua",
			["value"] = function(wep, viewmodel)
				if not wep:OwnerIsValid() then return end
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(625)
				dmginfo:SetDamageType(bit.bor(DMG_SLASH, DMG_ALWAYSGIB))
				dmginfo:SetAttacker(wep:GetOwner())
				dmginfo:SetInflictor(wep)

				local tr = {
					["start"] = wep:GetOwner():GetShootPos(),
					["mask"] = MASK_SHOT,
					["mins"] = minsVec,
					["maxs"] = maxsVec,
					["filter"] = {wep:GetOwner(), wep}
				}

				local ea = wep:GetOwner():EyeAngles()

				for i = 1, 36 do
					ea:RotateAroundAxis(upVec, 10)
					tr.endpos = wep:GetOwner():GetShootPos() + ea:Forward() * 100
					local tres = util.TraceHull(tr)

					if IsValid(tres.Entity) and tres.Entity.TakeDamageInfo then
						dmginfo:SetDamagePosition(tres.HitPos)
						tres.Entity:TakeDamageInfo(dmginfo)
					end
				end
			end,
			["client"] = true,
			["server"] = true
		}
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_thanatos9")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
