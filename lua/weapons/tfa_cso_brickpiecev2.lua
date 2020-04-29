SWEP.Base				= "weapon_ttt_m4a1"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Anri"
SWEP.PrintName				= "Lego M4A1"
SWEP.Slot				= 2

SWEP.Primary.Sound 			= "BrickPieceV2.Fire"

SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.PlutoSpawnable = false

SWEP.ViewModel			= "models/weapons/tfa_cso/c_brick_piece_v2.mdl"
SWEP.ViewModelFOV			= 90
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.WorldModel			= "models/weapons/tfa_cso/w_brick_piece_v2.mdl"
SWEP.HoldType 				= "ar2"
SWEP.Offset = {
	Pos = {
		Up = -2.6,
		Right = 1,
		Forward = 17.25,
	},
	Ang = {
		Up = 94,
		Right = 0,
		Forward = 190
	},
	Scale = 1.15
}


SWEP.Ironsights = {
	Pos = Vector(6.73, -3, 0.23),
	Angle = Vector(3.186, -0.141, 0),
	TimeTo = 0.25,
	TimeFrom = 0.15,
	SlowDown = 0.35,
	Zoom = 0.6,
}

SWEP.MuzzleAttachment			= "1"

DEFINE_BASECLASS(SWEP.Base)

SWEP.DamageSounds = {
	default = {
		"imhurt01",
		"imhurt02",
		"moan01",
		"moan02",
		"moan03",
		"moan04",
		"moan05",
	},
	leg = {
		"myleg01",
		"myleg02",
	},
	chest = {
		"mygut01",
		"mygut02",
	}
}

function SWEP:FireBulletsCallback(tr, dmginfo, data)
	local r = BaseClass.FireBulletsCallback(self, tr, dmginfo, data)

	if (SERVER and IsValid(hit) and hit:IsPlayer() and dmginfo:GetDamage() > 0 and math.random() > 0.5) then
		local hg = tr.HitGroup
		local hit = tr.Entity

		local fmt = "vo/npc/female01/%s.wav"

		if (pluto.models.gendered[hit:GetModel()] == "Male") then
			fmt = "vo/npc/male01/%s.wav"
		end

		local type = "default"

		if (math.random() > 0.75) then
			if (hg == HITGROUP_LEFTLEG or hg == HITGROUP_RIGHTLEG) then
				type = "leg"
			elseif (hg == HITGROUP_CHEST or hg == HITGROUP_STOMACH or hg == HITGROUP_GEAR) then
				type = "chest"
			end
		end

		local voiceline = table.Random(self.DamageSounds[type])

		hit:EmitSound(string.format(fmt, voiceline), 75, 100, 1, CHAN_USER_BASE + 6)
	end
	
	return r
end
