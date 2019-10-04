AddCSLuaFile()
pluto.statuses = pluto.statuses or {}

ENT.Base = "pluto_flame"

function ENT:DoDamage(damages)
	local p = self:GetParent()

	local dmg = DamageInfo()
	dmg:SetDamage(1)
	if (IsValid(damages.Owner)) then
		dmg:SetInflictor(IsValid(damages.Weapon) and damages.Weapon or damages.Owner)
		dmg:SetAttacker(damages.Owner)
	else
		dmg:SetAttacker(game.GetWorld())
	end
	dmg:SetDamageForce(vector_origin)
	dmg:SetDamageType(DMG_ACID + DMG_DIRECT)
	dmg:SetDamagePosition(p:GetPos())
	p:TakeDamageInfo(dmg)
end

function ENT:GetDelay()
	return 0.06
end

function pluto.statuses.poison(ply, damage)
	local flame
	for _, e in pairs(ply:GetChildren()) do
		if (e:GetClass() == "pluto_poison") then
			flame = e
			break
		end
	end

	if (not IsValid(flame)) then
		flame = ents.Create "pluto_poison"
		flame:SetParent(ply)
		flame:Spawn()
	end

	damage.Left = damage.Damage
	damage.Damage = 1

	table.insert(flame.Damages, damage)
end
