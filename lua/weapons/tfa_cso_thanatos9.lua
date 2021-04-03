SWEP.Base = "weapon_ttt_crowbar"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Demon Slayer"

SWEP.ViewModel = "models/weapons/tfa_cso/c_thanatos_9.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_thanatos_9.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee2"
SWEP.Slot = 0

SWEP.Primary.Range           = 130
SWEP.Primary.Extents = Vector(2, 20, 4)
SWEP.Secondary.Delay = 2.5
SWEP.Secondary.Damage = 69

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
		['dmgtype'] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
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

function SWEP:GetCurrentAnimation(what)
	local t = self[what or "Primary"].Attacks
	return t[(self:GetBulletsShot() % #t) + 1]
end

function SWEP:SoundEffect(tr_main)
	if (IsValid(tr_main.Entity) and tr_main.Entity:IsPlayer()) then
		self:EmitSound(self:GetCurrentAnimation().hitflesh)
	elseif (IsValid(tr_main.Entity) or tr_main.HitWorld) then
		self:EmitSound(self:GetCurrentAnimation().hitworld)
	elseif (SERVER) then
		self:EmitSound(self:GetCurrentAnimation().snd)
	end
end

function SWEP:PrimaryAttack()
	if (self:GetNextPrimaryFire() > CurTime()) then
		return
	end

	local owner = self:GetOwner()
	timer.Simple(self.Secondary.Attacks[1].delay - 0.1, function()
		if (IsValid(owner) and owner:GetActiveWeapon() == self) then
			owner:SetAnimation(PLAYER_ATTACK1)
		end
	end)

	self:SetBulletsShot(self:GetBulletsShot() + 1)

	self:SendWeaponAnim(self:GetCurrentAnimation "Secondary".act)
	self:SetSecondary(CurTime() + 0.95)

	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
end

SWEP.Ortho = {0, -9, angle = Angle(0, 180, 5), size = 1}
