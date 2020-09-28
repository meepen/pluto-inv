SWEP.Base = "weapon_tttbase"

SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.PlutoSpawnable = false

SWEP.Slot = 8
SWEP.HoldType = "pistol"

function SWEP:PrimaryAttack()
	if (not SERVER) then
		return
	end
	local npc = ents.Create "npc_atronach_frost"
	npc:SetPos(self:GetOwner():GetPos())
	local ang = self:GetOwner():GetAngles()
	npc:SetAngles(Angle(0, ang.y))
	npc:Spawn()

	local entPossession = ents.Create "obj_possession_manager"
	entPossession:SetPossessor(self:GetOwner())
	entPossession:SetTarget(npc)
	entPossession:Spawn()
	entPossession:StartPossession()

	self:Remove()
end