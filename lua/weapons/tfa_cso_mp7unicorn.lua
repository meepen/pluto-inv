SWEP.Base				= "weapon_ttt_mp7"
SWEP.Category				= "TFA CS:O" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author				= "Kamikaze" --Author Tooltip

SWEP.PrintName				= "MP7 Unicorn"
SWEP.Primary.Sound 			= Sound("Horsegun.Fire")

SWEP.ViewModel			= "models/weapons/tfa_cso/c_mp7unicorn.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 80		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= true		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true

SWEP.WorldModel			= "models/weapons/tfa_cso/w_mp7unicorn.mdl" -- Worldmodel path

SWEP.HoldType 				= "pistol"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
        Up = -5,
        Right = 1.2,
        Forward = 7,
	},
	Ang = {
        Up = -90,
        Right = 0,
        Forward = 178
	},
	Scale = 1.2
}

SWEP.ShowWorldModel = true

SWEP.Ironsights = {
	Pos = Vector(6.71, 0, 2.13),
	Angle = Vector(2.108, 0, 0),
	TimeTo = 0.2,
	TimeFrom = 0.15,
	SlowDown = 0.3,
	Zoom = 0.9,
}

SWEP.MuzzleAttachment = "0"
SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.PlutoSpawnable = false

DEFINE_BASECLASS(SWEP.Base)
function SWEP:Initialize()
	BaseClass.Initialize(self)
	hook.Add("Move", self, self.Move)
end

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetVar("CurrentCharge", "Float", 1)
end

SWEP.VelocityDisplace = 400

function SWEP:DrawHUD()
	BaseClass.DrawHUD(self)

	local w = 15
	local left = ScrW() / 2 - 50 - w / 2
	local h = 60
	local top = ScrH() / 2 - h / 2

	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(left, top, w, h)

	surface.SetDrawColor(10, 255, 20)

	local real_tall = math.Round((h - 2) * self:GetCurrentCharge())
	surface.DrawRect(left + 1, top + 1 + (h - 2) - real_tall, w - 2, real_tall)
end

function SWEP:Move(ply, mv)
	if (ply ~= self:GetOwner()) then
		return
	end

	local did = false

	if (mv:KeyDown(IN_JUMP) and self == self:GetOwner():GetActiveWeapon() and not ply:IsOnGround()) then
		local vel = mv:GetVelocity()
		local min = -60
		if (vel.z < min and self:GetCurrentCharge() > 0) then
			local diff = -vel.z - min
			vel.z = min
			self:SetCurrentCharge(math.max(0, self:GetCurrentCharge() - diff / self.VelocityDisplace * engine.TickInterval()))
			did = true
		end
		mv:SetVelocity(vel)
	end

	if (not did and ply:IsOnGround()) then
		self:SetCurrentCharge(1)
	end
end

SWEP.Ortho = {1.1, -1.3, angle = Angle(0, 180, -45)}
