SWEP.Base = "weapon_ttt_shotgun"
SWEP.Category = "TFA CS:O" 

SWEP.Author = "Anri" 
SWEP.Editor = "add___123" -- Changed basically everything

SWEP.PrintName = "Chronobreaker"
SWEP.Slot = 2

SWEP.Primary.Sound = "Batista.Fire"				
SWEP.Primary.Damage = 7

SWEP.Secondary.Sound = Sound("AlyxEMP.Charge")

SWEP.Bullets = {
	HullSize = 0,
	Num = 11,
	DamageDropoffRange = 450,
	DamageDropoffRangeMax = 1200,
	DamageMinimumPercent = 0.15,
	Spread = Vector(0.09, 0.09),
	TracerName = "tfa_tracer_incendiary"
}

SWEP.Primary.Delay = 1.1
SWEP.Primary.Automatic = true

SWEP.RewindCounts = 40
SWEP.RewindBaseLength = 0.01

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

sound.Add({
	name 		= "Batista.Fire" ,
	channel 	= CHAN_USER_BASE+11,
	volume 		= 1,
	soundlevel 	= 80,
	pitchstart 	= 100,
	pitchend 	= 100,
	sound 		= "weapons/tfa_cso/batista/fire.ogg"
})

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	if (SERVER) then
		self.Times = {}

		timer.Create(tostring(self) .. "Times", 0.1, 0, function() -- Timer tracks player info multiple times a second
			local ply = self:GetOwner()
			if (not IsValid(ply) or timer.Exists(tostring(self) .. "Rewind") or self:GetRewinding()) then
				return -- Skips if there's no owner or if they're currently rewinding
			end

			table.insert(self.Times, {
				Pos = ply:GetPos(),
				EyeAngles = ply:EyeAngles(),
				Health = ply:Health(),
				Armor = ply:Armor(),
				Velocity = ply:GetVelocity(),
				Clip1 = self:Clip1() or 0,
				Ammo = ply:GetAmmoCount(self:GetPrimaryAmmoType()),
				Crouched = ply:Crouching(),
			})
		end)

		hook.Add("PlayerDeath", self, function(self, vic, inf, att) -- Adds a charge if the owner gets a kill
			if (IsValid(self) and IsValid(inf) and self == inf) then
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

		if (IsValid(self:GetOwner())) then
			net.Start "batista_duck"
				net.WriteBool(false)
			net.Send(self:GetOwner())
		end
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

function SWEP:DoReload(act)
	local speed = self:GetReloadAnimationSpeed() / 1.65

	self:SendWeaponAnim(act)
	self:SetPlaybackRate(speed)
	if (IsValid(self:GetOwner())) then
		self:GetOwner():GetViewModel():SetPlaybackRate(speed)
		self:GetOwner():DoCustomAnimEvent(PLAYERANIMEVENT_RELOAD, 0)
	end

	local endtime = CurTime() + self:GetReloadDuration(speed)

	self.LastSound = nil
	self:SetReloadStartTime(CurTime())
	self:SetReloadEndTime(endtime)
	self:SetNextPrimaryFire(endtime)
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

local function RagdollDissolveEffect(ply) -- Creates the dissolving after-image ragdoll
    if (not IsValid(BLINK_DISSOLVER)) then
        BLINK_DISSOLVER = ents.Create "env_entity_dissolver"
        BLINK_DISSOLVER:SetKeyValue("dissolvetype", 3)
        BLINK_DISSOLVER:Spawn()
    end

	if (not IsValid(ply)) then
		return	
	end

	local rgd = ents.Create "prop_ragdoll"
	if (not IsValid(rgd)) then
		return
	end

	rgd:SetPos(ply:GetPos())
	rgd:SetModel(ply:GetModel())
	rgd:SetAngles(ply:GetAngles())
	rgd:Spawn()
	rgd:Activate()
	rgd:SetGravity(0)
	rgd:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	rgd:SetMaxHealth(100)
	rgd:SetHealth(100)
	rgd.Owner = ply
	rgd:SetOwner(ply)
	rgd:SetColor(Color(255, 255, 255, 100))

	if IsValid(rgd) then
		for i = 0, rgd:GetPhysicsObjectCount() - 1 do
			local phys = rgd:GetPhysicsObjectNum(i)
			phys:Wake()

			if IsValid(phys) then
				local pos, ang = ply:GetBonePosition(rgd:TranslatePhysBoneToBone(i))
				phys:EnableGravity(false)

				if pos and ang then
					phys:SetPos(pos)
					phys:SetAngles(ang)
				end
			end

			phys:EnableMotion(false)

			timer.Simple(0.1, function()
				if IsValid(phys) then
					phys:Sleep()
				end
			end)
		end
	end

	rgd.IsSafeToRemove = true
	rgd:SetName("DissolveID" .. rgd:EntIndex())
	BLINK_DISSOLVER:Fire("Dissolve", "DissolveID" .. rgd:EntIndex(), 0.01)
end

function SWEP:SecondaryAttack() -- Rewinds the player if able
	if (timer.Exists(tostring(self) .. "Rewind") or self:GetRewinding()) then
		return
	end

	if (SERVER and #self.Times > 1 and self:GetCharge() > 0) then
		self:SetCharge(self:GetCharge() - 1)
		self:SetRewinding(true)

		timer.Simple(0, function()
			self:EmitSound(self.Secondary.Sound)
		end)

		local ply = self:GetOwner()

		if (not IsValid(ply)) then
			return
		end

		self:SetPlaybackRate(-1)
		ply:GetViewModel():SetPlaybackRate(-1)
		self:SetReloadEndTime(math.huge)

		for _, e in pairs(ply:GetChildren()) do -- Removes health-related status effects
			local eclass = e:GetClass()
			if (eclass == "pluto_bleed" or eclass == "pluto_flame" or eclass == "pluto_poison" or eclass == "pluto_heal") then
				e:Remove()
			end
		end

		local iteration = 0 -- Counts the number of rewind attempts
		local count = 0 -- Counts the number of successful rewinds
		timer.Create(tostring(self) .. "Rewind", self.RewindBaseLength, 0, function()
			iteration = iteration + 1

			if (iteration <= 40 and iteration % 5 ~= 0) then -- Skips 75% of the time for 8 counts
				return
			elseif (iteration <= 56 and iteration % 2 ~= 0) then -- Skips 50% of the time for 8 counts
				return
			end -- After that, rewinds for the rest of the counts

			local info = table.remove(self.Times)

			if (not info or not IsValid(ply) or not ply:Alive() or count >= self.RewindCounts) then -- Ends the rewind
				timer.Remove(tostring(self) .. "Rewind")
				self:SetRewinding(false)
				self:SetNextPrimaryFire(CurTime() + 0.1)
				if (IsValid(ply)) then
					net.Start "batista_duck"
						net.WriteBool(false)
					net.Send(ply)
				end
				return
			end

			if (iteration % 10 == 0) then -- Creates the dissolving after-image every 10th iteration
				RagdollDissolveEffect(ply)
			end

			ply:SetPos(info.Pos)
			ply:SetEyeAngles(info.EyeAngles)
			ply:SetHealth(info.Health)
			ply:SetArmor(info.Armor)

			if (info.Crouched and not ply:Crouching() and (count > math.floor(self.RewindCounts / 2) or #self.Times < 5)) then -- Makes the player crouch if needed
				net.Start "batista_duck"
					net.WriteBool(true)
				net.Send(ply)
			end

			if (count >= self.RewindCounts - 1 or #self.Times == 0) then -- Resets player velocity at the end
				ply:SetVelocity(-1 * ply:GetVelocity() + info.Velocity / 1.2)
			else -- Removes player velocity during the rewind
				ply:SetVelocity(-1 * ply:GetVelocity())
			end
			self:SetClip1(info.Clip1)
			ply:SetAmmo(info.Ammo, self:GetPrimaryAmmoType())

			count = count + 1
		end)
	end
end

if (SERVER) then
	util.AddNetworkString "batista_duck"
else
	surface.CreateFont("pluto_chronobreaker", {
        font = "Roboto",
        size = 24,
    })

	local text_color = Color(255, 0, 0)
	local outline_color = Color(0, 0, 0, 255)

	function SWEP:DrawHUD()
		draw.SimpleTextOutlined("CHARGE: " .. tostring(self:GetCharge()), "pluto_chronobreaker", ScrW() / 2, ScrH() / 2 + 80, text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline_color)
	end

	net.Receive("batista_duck", function()
		if (net.ReadBool()) then
			RunConsoleCommand "+duck"
		else
			RunConsoleCommand "-duck"
		end
	end)
end