-- 'Borrowed' from Zombie Survival's explosion_fusordisc effect
-- https://github.com/JetBoom/zombiesurvival/blob/master/gamemodes/zombiesurvival/entities/effects/explosion_fusordisc.lua

local mat = Material "sprites/sent_ball"
function EFFECT:Init(data)
	self.EndPos = data:GetOrigin()
	self.StartPos = self:GetTracerShootPos(data:GetStart(), data:GetEntity(), data:GetAttachment())
	self.StartTime = CurTime()
	self.Duration = self.EndPos:Distance(self.StartPos) / 3000
	self.Normal = (self.EndPos - self.StartPos):GetNormalized()
	self.Entity = data:GetEntity()
end

local size = 0.075
local min = 0.05
function EFFECT:Think()
	if (CurTime() < self.StartTime + self.Duration) then
		return true
	end
	local tr = util.TraceLine {
		start = self.EndPos - self.Normal,
		endpos = self.EndPos + self.Normal
	}

	util.DecalEx(Material(util.DecalMaterial "PaintSplatBlue"), IsValid(tr.Entity) and tr.Entity or game.GetWorld(), self.EndPos, tr.HitNormal, Color(255, 255, 255, 255), min + math.random() * size, min + math.random() * size)
	return false
end

function EFFECT:Render()
	local pct = (CurTime() - self.StartTime) / self.Duration * 0.6 + 0.4
	local pos = LerpVector((CurTime() - self.StartTime) / self.Duration, self.StartPos, self.EndPos)

	render.SetMaterial(mat)
	render.DrawSprite(pos, pct * 3, pct * 3, white_text)
end
