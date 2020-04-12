EFFECT.g_sModelIndexSmoke = Material("cs16/steam1")

function EFFECT:Init(data)
	self.Pos = data:GetOrigin()
	self.Frame = 0
	self.SmokeZ = 0
	self.Scale = 0.55 * (350 + math.Rand(0, 10) * 10)
end

function EFFECT:Think()
	self.Frame = self.Frame + FrameTime()

	return self.Frame < 3
end

function EFFECT:Render()
	if !self.SmokeNextChange or CurTime() >= self.SmokeNextChange then	
		self.SmokeZ = self.SmokeZ + 30
		self.SmokeNextChange = CurTime() + 1
	end

	render.SetMaterial(self.g_sModelIndexSmoke)
	self.g_sModelIndexSmoke:SetInt("$frame", math.Clamp(math.floor(self.Frame * 5), 0, 15))
	render.DrawSprite(self.Pos + Vector(0, 0, 70), self.Scale * 0.5, self.Scale, Color(0, 0, 0, 255))
end