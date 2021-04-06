SWEP.Base = "weapon_ttt_crowbar"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Chimp Stick"
SWEP.Author = "Kamikaze"

SWEP.ViewModel = "models/weapons/tfa_cso/c_monkeywpnset3.mdl"
SWEP.WorldModel = "models/weapons/tfa_cso/w_monkeywpnset3.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 85
SWEP.UseHands = true

SWEP.Primary.Range           = 100
SWEP.Primary.Delay           = 0.5
SWEP.Primary.Damage          = 35

SWEP.Offset = {
	Pos = {
		Up = -7.5,
		Right = 1.25,
		Forward = 3.5,
	},
	Ang = {
		Up = 270,
		Right = 180,
		Forward = 0
	},
	Scale = 1
}

sound.Add({
	['name'] = "Ruyi.Idle",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/idle.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.Draw",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/draw.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.Slash1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/slash1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.Slash2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/slash2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/stab.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.HitFleshSlash1",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/hit1.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.HitFleshSlash2",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/hit2.ogg"},
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ruyi.HitWall",
	['channel'] = CHAN_WEAPON,
	['sound'] = { "weapons/tfa_cso/monkeywpset3/wall.ogg" },
	['pitch'] = {100,100}
})

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 25*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-120,0,-100), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 450, --Nope!! Not overpowered!!
		['dmgtype'] = DMG_CLUB, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.4, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "TFABaseMelee.Null", -- Sound ID
		['snd_delay'] = 0.2,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.2, --time before next attack
		['hull'] = 64, --Hullsize
		['direction'] = "F", --Swing dir
		['hitflesh'] = "Ruyi.HitFleshSlash2",
		['hitworld'] = "Ruyi.HitWall",
		['maxhits'] = 25
	}
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("Kills", "Int", 0)
end

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("DoPlayerDeath", self, self.DoPlayerDeath)
end

function SWEP:DoPlayerDeath(ply, atk, dmg)
	if (dmg and dmg:GetInflictor() == self) then
		ply:SetModel(pluto.models["chimp"].Model)
		
		self:SetKills(self:GetKills() + 1)

		if (IsValid(atk) and self:GetKills() == 2) then
			atk:SetModel(pluto.models["chimp"].Model)
			atk:SetupHands()
			atk:ChatPrint(white_text, "For get 2", ttt.roles.Monke.Color, " monke", white_text, " smash, you now", ttt.roles.Monke.Color, " monke!", white_text, " OOK OOK!")
		end
	end
end

function SWEP:PrimaryAttack()
	BaseClass.PrimaryAttack(self)
	self:SetBulletsShot(self:GetBulletsShot() + 1)
end

function SWEP:MeleeAnimation(tr_main)
	local num = self:GetBulletsShot() % 2
	local stuff = {
		[0] = ACT_VM_HITRIGHT,
		ACT_VM_HITLEFT
	}
	self:SendWeaponAnim(stuff[num])
end

function SWEP:Holster(...)
	self:StopSound "Hellfire.Idle"
	return BaseClass.Holster(self, ...)
end

function SWEP:OnRemove()
	hook.Remove("DoPlayerDeath", self)
end

SWEP.Ortho = {0, 0, angle = Angle(0, 180, 20), size = 0.9}