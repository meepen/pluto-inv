--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
AddCSLuaFile()
pluto.statuses = pluto.statuses or {}

ENT.Base = "pluto_flame"

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.Speed = 0
end

function ENT:DoTick()
	local p = self:GetParent()
	if (IsValid(p)) then
		self.Speed = self.Speed + p:GetVelocity():Length() * engine.TickInterval() / self:GetDelay()
	end
end

function ENT:PlayerRagdollCreated(ply, rag, atk)
end

function ENT:DoDamage(damages)
	local p = self:GetParent()

	local d = 1

	local dmg = DamageInfo()

	if (self.Speed > p:GetRunSpeed() * 2) then
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
	dmg:SetDamageType(DMG_DIRECT + DMG_SONIC)
	dmg:SetDamagePosition(p:GetPos())
	p:TakeDamageInfo(dmg)
end

function ENT:GetDelay()
	return 0.025
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

	damage.Left = damage.Damage
	damage.Damage = 1

	table.insert(flame.Damages, damage)
end
