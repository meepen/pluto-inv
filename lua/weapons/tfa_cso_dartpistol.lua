SWEP.Base = "weapon_tttbase"
SWEP.Category = "TFA CS:O"
SWEP.Author = "Kamikaze"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = true
SWEP.PrintName = "Dart Pistol"
SWEP.Slot = 1

SWEP.Primary.Sound = Sound("Dartpistol.Fire")

SWEP.Primary.Delay = 60 / 90
SWEP.Primary.Damage = 40
SWEP.Primary.Recoil = 1
SWEP.Primary.RecoilTiming  = 0.2

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
		self.OldModel = self.OldModel or atk:GetModel()
		self.CurrentModel = pluto.models[(math.random() > 0.5 and "fe" or "") .. "male_child"].Model

		atk:SetModel(self.CurrentModel)
		atk:ChatPrint(white_text, "You are filled with a child-like energy!")

		net.Start "dart_speed"
			net.WriteBool(true)
		net.Send(atk)

		hook.Add("TTTUpdatePlayerSpeed", "pluto_dart_" .. atk:Nick(), function(ply, data)
			if (atk == ply) then
				data.dart = 1.5
			end
		end)

		timer.Create("dartpistol" .. atk:Nick(), 8, 1, function()
			if (IsValid(atk)) then
				atk:ChatPrint(white_text, " The power of the dart gun fades...")

				net.Start "dart_speed"
					net.WriteBool(false)
				net.Send(atk)

				hook.Remove("TTTUpdatePlayerSpeed", "pluto_dart_" .. atk:Nick())

				if (atk:Alive() and atk:GetModel() == self.CurrentModel) then
					atk:SetModel(self.OldModel)
				end
				
				self.OldModel = nil
				self.CurrentModel = nil
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
					data.dart = 1.5
				end
			end)
		else
			hook.Remove("TTTUpdatePlayerSpeed", "pluto_dart")
		end
	end)
end

SWEP.RecoilInstructions = {
	Interval = 1,
	Angle(-10),
}