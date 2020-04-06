AddCSLuaFile()
pluto.statuses = pluto.statuses or {}

ENT.Base = "pluto_status"

ENT.Icon = "tttrw/tbutton.png"
ENT.PrintName = "Fire"

function ENT:Initialize()
	hook.Add("DoPlayerDeath", self, self.DoPlayerDeath)
	hook.Add("Tick", self, self.Tick)
end

function ENT:SetupDataTables()
	self.Damages = {}
end


function ENT:DoPlayerDeath(ply)
	if (ply == self:GetParent()) then
		self:Remove()
	end
end

function ENT:Tick()
	if (not SERVER or (self.Next and self.Next > CurTime())) then
		return
	end

	local p = self:GetParent()

	local damages = self.Damages[1]

	if (not damages) then
		self:Remove()
		return
	end

	self:DoDamage(damages)

	damages.Left = damages.Left - 1

	if (damages.Left == 0) then
		table.remove(self.Damages, 1)
		if (#self.Damages == 0) then
			self:Remove()
			return
		end
		damages = damages[1]
	end

	self.Next = CurTime() + self:GetDelay()

	self:DoTick()
	return true
end

function ENT:DoTick()
end

function ENT:GetDelay()
	return 0.05
end

function ENT:DoDamage(damages)
	local p = self:GetParent()

	local outside = util.TraceLine {
		start = p:GetPos(),
		endpos = p:GetPos() + vector_up * 20000,
		filter = function() return false end,
	}.MatType == MAT_DEFAULT and 2.5 or 1

	local dmg = DamageInfo()
	dmg:SetDamage(damages.Damage * outside)
	if (IsValid(damages.Owner)) then
		dmg:SetInflictor(IsValid(damages.Weapon) and damages.Weapon or damages.Owner)
		dmg:SetAttacker(damages.Owner)
	else
		dmg:SetAttacker(game.GetWorld())
	end
	dmg:SetDamageForce(vector_origin)
	dmg:SetDamageType(DMG_SLOWBURN + DMG_DIRECT)
	dmg:SetDamagePosition(p:GetPos())
	p:TakeDamageInfo(dmg)
	--p:EmitSound "General.BurningFlesh"
end

function pluto.statuses.fire(ply, damage)
	local flame
	for _, e in pairs(ply:GetChildren()) do
		if (e:GetClass() == "pluto_flame") then
			flame = e
			break
		end
	end

	if (not IsValid(flame)) then
		flame = ents.Create "pluto_flame"
		flame:SetParent(ply)
		flame:Spawn()
	end

	damage.Damage = damage.Damage / 4
	damage.Left = 4

	table.insert(flame.Damages, damage)
end
