AddCSLuaFile()
pluto.statuses = pluto.statuses or {}

ENT.Base = "pluto_flame"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.Speed = 0
	hook.Add("Tick", self, self.Tick)
end

function ENT:Tick()
	local p = self:GetParent()
	if (IsValid(p)) then
		self.Speed = self.Speed + p:GetVelocity():Length() * engine.TickInterval() / self:GetDelay()
	end
end

function ENT:PlayerRagdollCreated(ply, rag, atk)
end

function ENT:DoDamage(damages)
	local p = self:GetParent()

	local d = 2

	local dmg = DamageInfo()

	if (self.Speed > p:GetRunSpeed()) then
		d = d * 2
	elseif (self.Speed > 50) then
		d = d * 1.5
	end
	dmg:SetDamage(d)
	self.Speed = 0

	if (IsValid(damages.Owner)) then
		dmg:SetInflictor(IsValid(damages.Weapon) and damages.Weapon or damages.Owner)
		dmg:SetAttacker(damages.Owner)
	else
		dmg:SetAttacker(game.GetWorld())
	end
	dmg:SetDamageForce(vector_origin)
	dmg:SetDamageType(DMG_DIRECT)
	dmg:SetDamagePosition(p:GetPos())
	p:TakeDamageInfo(dmg)
end

function ENT:GetDelay()
	return 0.05
end

function pluto.statuses.bleed(ply, damage)
	local flame
	for _, e in pairs(ply:GetChildren()) do
		if (e:GetClass() == "pluto_bleed") then
			flame = e
			break
		end
	end

	if (not IsValid(flame)) then
		flame = ents.Create "pluto_bleed"
		flame:SetParent(ply)
		flame:Spawn()
	end

	damage.Left = math.ceil(damage.Damage / 2)
	damage.Damage = 2

	table.insert(flame.Damages, damage)
end
