AddCSLuaFile()
pluto.statuses = pluto.statuses or {}

ENT.Base = "pluto_flame"

function ENT:DoDamage()
	local p = self:GetParent()
	if (not IsValid(p) or not p:IsPlayer() or not p:Alive()) then
		self:Remove()
		return
	end
	
	p:SetHealth(math.min(p:GetMaxHealth(), p:Health() + 1))
end

function ENT:GetDelay()
	return self.Delay
end

function pluto.statuses.heal(ply, amt, time)
	local flame = ents.Create "pluto_heal"
	flame:SetParent(ply)
	flame:Spawn()

	amt = math.Round(amt)

	flame.Delay = time / amt

	table.insert(flame.Damages, {
		Left = amt,
		Damage = 1,
	})
end
