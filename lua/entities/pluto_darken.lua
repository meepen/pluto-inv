ENT.Type = "anim"

local DARKENED = 0

ENT.Distance = 1200
ENT.DistanceMin = 200

ENT.PrintName = "Wom Cube"

AddCSLuaFile()

function ENT:Initialize()
	if (CLIENT) then
		hook.Add("PreDrawEffects", self, self.RenderScreenspaceEffects)

		sound.PlayFile("sound/weapons/tfa_cso/darkknight/idle.ogg", "3d", function(snd)
			self.Sound = snd
			snd:SetPos(self:GetPos())

			snd:EnableLooping(true)
		end)
	end

	self.SpawnTime = CurTime()

	hook.Add("TTTUpdatePlayerSpeed", self, self.TTTUpdatePlayerSpeed)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:OnRemove()
	self:StopTheSound()
end

function ENT:StopTheSound()
	if (IsValid(self.Sound)) then
		self.Sound:Stop()
		self.Sound = nil
	end
end

function ENT:TTTUpdatePlayerSpeed(ply, data)
	local distance = self:GetPos():Distance(ply:GetPos())
	if (distance > self.Distance) then
		return
	end

	local alpha = 1

	if (distance > self.DistanceMin) then
		local frommin = distance - self.DistanceMin
		local max = self.Distance - self.DistanceMin
		alpha = (max - frommin) / max
	end

	data.DarkenOrb = math.min(data.DarkenOrb or 1, 1 - 0.25 * alpha)
end

function ENT:RenderScreenspaceEffects()
	if (self:IsDormant()) then
		self:StopTheSound()
		return
	end

	local distance = self:GetPos():Distance(LocalPlayer():GetPos())
	local alpha = 1

	if (distance > self.Distance) then
		return
	end

	if (distance > self.DistanceMin) then
		local frommin = distance - self.DistanceMin
		local max = self.Distance - self.DistanceMin
		alpha = (max - frommin) / max
	end

	DARKENED = math.max(DARKENED, alpha)
end


hook.Add("PreRender", "pluto_darken", function()
	DARKENED = 0
end)

hook.Add("RenderScreenspaceEffects", "pluto_darken", function()
	surface.SetDrawColor(0, 0, 0, DARKENED * 220)

	surface.DrawRect(0, 0, ScrW(), ScrH())
end)

function ENT:Think()
	if (SERVER and CurTime() > self.SpawnTime + 10) then
		self:Remove()
	end
end

local extent = Vector(10, 10, 10)
function ENT:Draw()
	if (self:IsDormant()) then
		return
	end

	render.SetColorMaterial()
	render.DrawBox(self:GetPos(), angle_zero, -extent, extent, Color(10, 10, 10))
end