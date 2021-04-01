SWEP.Base = "weapon_ttt_shotgun"
SWEP.Category = "TFA CS:O" 

SWEP.Author = "Anri" 
SWEP.Editor = "add___123" -- Changed basically everything

SWEP.PrintName = "Chronobreaker"
SWEP.Slot = 2

SWEP.Primary.Sound = Sound("tfa_cso2_m3dragon.1")				
SWEP.Primary.Damage = 5

SWEP.Secondary.Sound = Sound("AlyxEMP.Charge")

SWEP.Bullets = {
	HullSize = 0,
	Num = 12,
	DamageDropoffRange = 900,
	DamageDropoffRangeMax = 4000,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.1, 0.1),
	TracerName = "tfa_tracer_incendiary"
}

SWEP.Primary.Delay = 1.25
SWEP.Primary.Automatic = true

SWEP.Primary.ClipSize = 2		
SWEP.Primary.DefaultClip = 24

SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = true
SWEP.UseHands = true
SWEP.HoldType = "ar2"
SWEP.Offset = { 
	Pos = {
		Up = -6,
		Right = 1.5,
		Forward = 12,
	},
	Ang = {
		Up = 90,
		Right = 0,
		Forward = 190
	},
	Scale = 1.15
}

SWEP.Ortho = {-3, 3, angle = Angle(10, 20, -30)}

SWEP.Ironsights = false

SWEP.Spawnable = false
SWEP.AutoSpawnable = false
SWEP.PlutoSpawnable = false
SWEP.AdminSpawnable = false

SWEP.WorldModel = "models/weapons/tfa_cso/w_batista.mdl"
SWEP.ViewModel = "models/weapons/tfa_cso/c_batista.mdl"

SWEP.DrawCrosshair = true

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	if (SERVER) then
		timer.Create(tostring(self) .. "Times", 0.1, 0, function()
			local ply = self:GetOwner()
			if (not IsValid(ply)) then
				return
			end

			self.Times = self.Times or {}

			table.insert(self.Times, {
				Pos = ply:GetPos(),
				EyeAngles = ply:EyeAngles(),
				Health = ply:Health(),
				Armor = ply:Armor(),
				Velocity = ply:GetVelocity(),
				Clip1 = self:Clip1() or 0,
				Ammo = ply:GetAmmoCount(self:GetPrimaryAmmoType()),
			})
		end)

		hook.Add("DoPlayerDeath", self, function(ply, att, dmg)
			if (IsValid(self) and IsValid(self:GetOwner()) and IsValid(att) and self:GetOwner() == att) then
				self:SetCharge(self:GetCharge() + 1)
			end
		end)
	end
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("Charge", "Int", 1)
	self:NetVar("Rewinding", "Bool", false)
end

function SWEP:OnRemove()
	if (SERVER) then
		timer.Remove(tostring(self) .. "Times")
		timer.Remove(tostring(self) .. "Rewind")
	end
end

function SWEP:Reload()
	if (self:GetReloadEndTime() ~= math.huge or self:Clip1() == self:GetMaxClip1() or self:GetReserveAmmo() <= 0) then
		return
	end
	if (CLIENT) then
		self:CalcFOV()
	end
	self:DoReload(ACT_VM_RELOAD)
end

function SWEP:CanPrimaryAttack()
	if (self:Clip1() > 0) then
		return true
	end
	return false
end

function SWEP:Think()
	BaseClass.Think(self)

	local reloadtime = self:GetReloadEndTime()
	if (reloadtime ~= math.huge) then
		if (reloadtime > CurTime()) then
			local time = (CurTime() - self:GetReloadStartTime())
			return
		end

		local ammocount = self:GetReserveAmmo()
		local needed = self:GetMaxClip1() - self:Clip1()

		local added = math.min(needed, ammocount)

		self:GetOwner():SetAmmo(ammocount - added, self:GetPrimaryAmmoType())

		self:SetClip1(self:Clip1() + added)
		self:SetReloadEndTime(math.huge)
	end
end

function SWEP:SecondaryAttack()
	if (timer.Exists(tostring(self) .. "Rewind") or self:GetRewinding()) then
		return
	end

	if (SERVER and self.Times and #self.Times > 1 and self:GetCharge() > 0) then
		self:SetCharge(self:GetCharge() - 1)
		self:SetRewinding(true)

		local count = 0

		timer.Simple(0, function()
			self:EmitSound(self.Secondary.Sound)
		end)

		timer.Create(tostring(self) .. "Rewind", 0.01, 0, function()
			local info = table.remove(self.Times)
			local ply = self:GetOwner()

			if (not info or not IsValid(ply) or not ply:Alive() or count >= 50) then
				timer.Remove(tostring(self) .. "Rewind")
				self:SetRewinding(false)
				return
			end

			ply:SetPos(info.Pos)
			ply:SetEyeAngles(info.EyeAngles)
			ply:SetHealth(info.Health)
			ply:SetArmor(info.Armor)
			ply:SetVelocity(-1 * ply:GetVelocity() + info.Velocity)
			self:SetClip1(info.Clip1)
			ply:SetAmmo(info.Ammo, self:GetPrimaryAmmoType())

			count = count + 1
		end)
	end
end

if (CLIENT) then
	surface.CreateFont("pluto_chronobreaker", {
        font = "Roboto",
        size = 24,
    })

	local text_color = Color(255, 0, 25)
	local outline_color = Color(0, 0, 0, 200)

	function SWEP:DrawHUD()
		draw.SimpleTextOutlined("CHARGE: " .. tostring(self:GetCharge()), "pluto_chronobreaker", ScrW() / 2, ScrH() / 2 + 100, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_color)
	end
end