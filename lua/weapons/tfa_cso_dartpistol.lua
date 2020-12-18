SWEP.Base = "tfa_gun_base"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Dart Pistol"
SWEP.Slot = 1

SWEP.Primary.Sound = Sound("Dartpistol.Fire")

SWEP.Primary.Delay = 60 / 70
SWEP.Primary.Damage = 33

SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Ammo = "pistol"

SWEP.ViewModel = "models/weapons/tfa_cso/c_dartpistol.mdl"
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.UseHands = true

SWEP.WorldModel = "models/weapons/tfa_cso/w_dartpistol.mdl"

SWEP.HoldType = "revolver"

SWEP.Offset = {
	Pos = {
        Up = -4.5,
        Right = 1,
        Forward = 7,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 170
	},
	Scale = 1.2
}

SWEP.Ironsights = {
	Pos = Vector(7.403, -3.84, 0.791),
	Angle = Vector(-1.152, 5.633, -2.722),
	TimeTo = 0.23,
	TimeFrom = 0.22,
	SlowDown = 0.8,
	Zoom = 0.9,
}

DEFINE_BASECLASS(SWEP.Base)

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("DoPlayerDeath", self, self.DoPlayerDeath)
end

function SWEP:DoPlayerDeath(ply, atk, dmg)
	if (dmg and dmg:GetInflictor() == self and IsValid(atk)) then
		self.OldModel = atk:GetModel()
		self.CurrentModel = pluto.models[(math.random() > 0.5 and "fe" or "") .. "male_child"].Model

		atk:SetModel(self.CurrentModel)
		atk:SetupHands()
		atk:ChatPrint(white_text, "You burst alight with a child-like energy!")

		net.Start "dart_speed"
			net.WriteBool(true)
		net.Send(atk)

		hook.Add("TTTUpdatePlayerSpeed", "pluto_dart_" .. atk:Nick(), function(ply, data)
			if (atk == ply) then
				data.dart = 1.1
			end
		end)

		timer.Create("dartpistol" .. atk:Nick(), 6, 1, function()
			if (IsValid(atk) and atk:Alive()) then
				atk:ChatPrint(white_text, " The power of the dart gun fades...")

				net.Start "dart_speed"
					net.WriteBool(false)
				net.Send(atk)

				hook.Remove("TTTUpdatePlayerSpeed", "pluto_dart_" .. atk:Nick())

				if (atk:GetModel() == self.CurrentModel) then
					atk:SetModel(self.OldModel)
					atk:SetupHands()
				end
			end
		end)
	end
end

if (SERVER) then
	util.AddNetworkString "dart_speed"
else
	net.Receive("dart_speed", function()
		if (net.ReadBool()) then
			hook.Add("TTTUpdatePlayerSpeed", "pluto_dart", function(ply, data)
				if (ply == LocalPlayer()) then
					data.dart = 1.1
				end
			end)
		else
			hook.Remove("TTTUpdatePlayerSpeed", "pluto_dart")
		end
	end)
end