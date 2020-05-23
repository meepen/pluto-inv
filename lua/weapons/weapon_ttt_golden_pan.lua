SWEP.Base = "weapon_ttt_crowbar"
SWEP.Slot = 0
SWEP.PrintName = "Golden Pan"

SWEP.WorldModel = "models/weapons/quentindylanp/c_crowbar_nohands.mdl"
SWEP.ViewModel  = "models/weapons/quentindylanp/c_crowbar_nohands.mdl"

SWEP.PlutoModel = "models/weapons/c_models/c_frying_pan/c_frying_pan.mdl"
SWEP.PlutoMaterial = "models/player/shared/gold_player"

SWEP.PlutoSpawnable = false
SWEP.AutoSpawnable = false

SWEP.Ortho = {-5, 3, angle = Angle(30, -90, 90)}

--SWEP.Primary.Sound = "weapons/bat_draw_swoosh1.ogg"


local mass = 12000

function MakeGold(what)
    if (not IsValid(what)) then
        return
	end

	for bone = 0, what:GetPhysicsObjectCount() - 1 do
		constraint.Weld(what, what, 0, bone, 0)

		local boneparent = what:GetBoneParent(what:TranslatePhysBoneToBone(bone))

		if (boneparent ~= -1) then
			constraint.Weld(what, what, what:TranslateBoneToPhysBone(boneparent), bone, 0)
		end

		local phys = what:GetPhysicsObjectNum(bone)

		phys:SetMass(mass / what:GetPhysicsObjectCount())
		phys:AddGameFlag(FVPHYSICS_NO_SELF_COLLISIONS)
		phys:AddGameFlag(FVPHYSICS_CONSTRAINT_STATIC)
		phys:SetMaterial "metal"
		phys:Sleep()
	end

	for bone = 0, what:GetPhysicsObjectCount() - 1 do
		what:GetPhysicsObjectNum(bone):RecheckCollisionFilter()
	end

	what:SetMateria(self.PlutoMaterial)

	what:SetPos(what:GetPos() + vector_up * 100)

	return what
end

DEFINE_BASECLASS "weapon_ttt_crowbar"

function SWEP:Initialize()
	BaseClass.Initialize(self)

	hook.Add("PlayerRagdollCreated", self, self.PlayerRagdollCreated)
end

function SWEP:PlayerRagdollCreated(ply, rag, atk, dmg)
	if (dmg and dmg:GetInflictor() == self) then
		MakeGold(rag)
		pluto.statuses.greed(atk, 50 * 39.37, 10)
	end
end

sound.Add {
	name = "bat_hit",
	channel = CHAN_VOICE,
	volume = 0.2,
	level = 70,
	sound = "weapons/gpan/hitsound.ogg"
}

function SWEP:DoHit(e, tr)
	BaseClass.DoHit(self, e, tr)

	if (IsValid(e) and e:IsPlayer()) then
		self:GetOwner():EmitSound "bat_hit"
	end
end

SWEP.VElements = {
	["pan"] = { type = "Model", model = "models/weapons/c_models/c_frying_pan/c_frying_pan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2, 2.00, -1.929), angle = Angle(180, 180, 0), size = Vector(0.806, 0.806, 0.806), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {} }
}

SWEP.WElements = {
	["pan"] = { type = "Model", model = "models/weapons/c_models/c_frying_pan/c_frying_pan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.693, 2.161, -1.436), angle = Angle(13.352, 0, 180), size = Vector(0.963, 0.963, 0.963), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 2, bodygroup = {} }
}
