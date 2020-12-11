
local soundData = {
	name		= "StarChaserSR.ClipOut" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/star_chaser_sr/clipout.ogg"
}
 
sound.Add(soundData)
 
local soundData = {
	name		= "StarChaserSR.ClipIn" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/star_chaser_sr/clipin.ogg"
}
 
sound.Add(soundData)

local soundData = {
	name		= "StarChaserSR.Idle" ,
	channel	 = CHAN_WEAPON,
	volume	  = 1,
	soundlevel  = 80,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/star_chaser_sr/idle.ogg"
}
 
sound.Add(soundData)
 
local soundData = {
	name		= "StarChaserSR.Fire" ,
	channel	 = CHAN_USER_BASE+11,
	volume	  = 1,
	level  = 100,
	pitchstart  = 100,
	pitchend	= 100,
	sound	   = "weapons/tfa_cso/star_chaser_sr/fire.ogg"
}

sound.Add(soundData)

SWEP.Base				= "weapon_tttbase"
SWEP.Category				= "TFA CS:O"
SWEP.Author				= "Anri"
SWEP.Spawnable				= false
SWEP.AdminSpawnable			= false
SWEP.PrintName				= "Star Hunter"
SWEP.Slot				= 2

SWEP.HuntTime = 1.5

SWEP.Primary.Sound 			= Sound("StarChaserSR.Fire")
SWEP.Primary.Damage		= 45
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 1.2

SWEP.Bullets = {
	HullSize = 0,
	Num = 1,
	DamageDropoffRange = 650,
	DamageDropoffRangeMax = 4200,
	DamageMinimumPercent = 0.1,
	Spread = Vector(0.01, 0.02),
	TracerName = "cso_ajax"
}

SWEP.ViewModel			= "models/weapons/tfa_cso/c_starchasersr.mdl"
SWEP.ViewModelFOV			= 90
SWEP.ViewModelFlip			= true
SWEP.UseHands = true
SWEP.NoPlayerModelHands = true

SWEP.HasScope = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_starchasersr.mdl"
SWEP.HoldType 				= "ar2"

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -4.5,
		Right = 1,
		Forward = 5,
	},
	Ang = {
		Up = -88,
		Right = 0,
		Forward = 165
	},
	Scale = 0.9
}

SWEP.Secondary.ScopeTable = {
	["ScopeMaterial"] =  Material("scope/starchaser/starchasersr_scope.png", "smooth"),
	["ScopeBorder"] = Color(0,0,0,190),
	["ScopeCrosshair"] = { ["r"] = 0, ["g"]  = 0, ["b"] = 0, ["a"] = 255, ["s"] = 0 }
}

SWEP.Ironsights = {
	Pos = Vector(10.397, -9.219, 1.873),
	Angle = Vector(-50),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.3,
	Zoom = 0.4,
}

SWEP.RecoilInstructions = {
	angle_zero
}

SWEP.MuzzleAttachment			= "1"
SWEP.ShellAttachment			= "2"

SWEP.DoMuzzleFlash = true
SWEP.CustomMuzzleFlash = true
SWEP.AutoDetectMuzzleAttachment = true
SWEP.MuzzleFlashEffect = "cso_muz_scsr"

SWEP.Tracer				= 0
SWEP.TracerName 		= "cso_tra_scsr"
SWEP.TracerCount 		= 1

SWEP.Primary.ClipSize      = 4
SWEP.Primary.DefaultClip   = 8

SWEP.ReloadSpeed = 1.2

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Think()
	local owner = self:GetOwner()

	if (not self:GetIronsights()) then
		self.Hunted = nil
	end

	if (IsValid(owner) and self:GetIronsights() and (SERVER or LocalPlayer() == owner)) then
		-- hunting mode
		self.Hunted = self.Hunted or {}
		for _, data in pairs(self.Hunted) do
			data.Bad = true
		end
		local hull = Vector(100, 100, 100)
		util.TraceHull {
			ignoreworld = true,
			start = owner:GetShootPos(),
			endpos = owner:GetShootPos() + owner:GetAimVector() * 16000,
			filter = function(e)
				if ((SERVER or not e:IsDormant()) and e:IsPlayer() and e ~= owner) then
					local data = self.Hunted[e]
					if (data) then
						data.Bad = false
						if (SERVER and data.LastNotify < CurTime() - 0.3) then
							net.Start "tfa_cso_starchasersr"
							net.Send(e)
						end
					else
						data = {
							Start = CurTime(),
							Bad = false,
							LastNotify = CurTime()
						}
						if (SERVER) then
							net.Start "tfa_cso_starchasersr"
							net.Send(e)
						end
						self.Hunted[e] = data
					end
				end
			end,
			mins = -hull,
			maxs = hull
		}
		
		for ply, data in pairs(self.Hunted) do
			if (data.Bad) then
				self.Hunted[ply] = nil
			end
		end
	end

	return BaseClass.Think(self)
end

function SWEP:Initialize()
	if (CLIENT) then
		hook.Add("PostPlayerDraw", self, self.PostPlayerDraw)
	end
	return BaseClass.Initialize(self)
end

function SWEP:DrawHUD()
	BaseClass.DrawHUD(self)

	if (self:GetIronsights()) then
		draw.SimpleTextOutlined("Hunting...", "DermaDefault", ScrW() / 2, ScrH() / 3 * 2, white_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(12, 13, 14))
	end
end

function SWEP:FireBulletsCallback(tr, dmginfo, data)
	local hunt = (self.Hunted or {})[tr.Entity]
	if (hunt and hunt.Start < CurTime() - self.HuntTime) then
		dmginfo:ScaleDamage(2)
	end
	return BaseClass.FireBulletsCallback(self, tr, dmginfo, data)
end

local in_hook = false
function SWEP:PostPlayerDraw(ply)
	if (self:GetOwner() ~= LocalPlayer() or not self:GetIronsights()) then
		return
	end

	if (not self.Hunted or not self.Hunted[ply] or self.Hunted[ply].Start > CurTime() - self.HuntTime) then
		return
	end

	if (in_hook) then
		return
	end
	in_hook = true

	render.SetStencilEnable(true)
		render.SetStencilWriteMask(0xFF)
		render.SetStencilTestMask(0xFF)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
		render.SetStencilFailOperation(STENCIL_ZERO)
		render.SetStencilZFailOperation(STENCIL_REPLACE)
		render.ClearStencil()

		ply:DrawModel()

		render.SetStencilCompareFunction(STENCIL_EQUAL)
		render.SetStencilPassOperation(STENCIL_KEEP)
		render.SetStencilFailOperation(STENCIL_KEEP)
		render.SetStencilZFailOperation(STENCIL_KEEP)
		cam.IgnoreZ(true)

			render.SetColorMaterial()
			render.DrawScreenQuad()

		cam.IgnoreZ(false)
	render.SetStencilEnable(false)
	in_hook = false
end

function SWEP:Holster( ... )
	self:StopSound("StarChaserSR.Idle")
	return BaseClass.Holster(self,...)
end

if (CLIENT) then
	surface.CreateFont("tfa_cso_starchasersr", {
		font = 'Lato',
		size = 24,
		weight = 400
	})
	
	local hunted = false
	net.Receive("tfa_cso_starchasersr", function()
		timer.Create("tfa_cso_starchasersr_hunt", 2, 1, function()
			hunted = false
		end)
		hunted = true
	end)

	hook.Add("HUDPaint", "tfa_cso_starchasersr", function()
		if (not hunted) then
			return
		end

		local text = "You are being hunted. Run."

		surface.SetFont "tfa_cso_starchasersr"
		local w, h = surface.GetTextSize(text)
		hud.DrawTextOutlined(text, Color(255, 20, 20), color_black, ScrW() / 2 - w / 2, ScrH() / 4, 3)
	end)
end