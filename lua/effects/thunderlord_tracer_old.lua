local Tracer = Material( "tracer/tl_tracer" )
local Width = 30

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.Dir = ( self.EndPos - self.StartPos ):GetNormalized()
	self.Dist = self.StartPos:Distance( self.EndPos )
	
	self.LifeTime = 0.2 * GetConVarNumber("bfx_lifetimemulti")/2
	self.DieTime = CurTime() + self.LifeTime

end

function EFFECT:Think()

	if ( CurTime() > self.DieTime ) then return false end
	return true

end

function EFFECT:Render()

	local r = GetConVarNumber("bfx_energycolor_r")
	local g = GetConVarNumber("bfx_energycolor_g")
	local b = GetConVarNumber("bfx_energycolor_b")
	
	
	local v = ( self.DieTime - CurTime() ) / self.LifeTime

	render.SetMaterial( Tracer )
	render.DrawBeam( self.StartPos, self.EndPos, (v * Width)*GetConVarNumber("bfx_widthmulti")/2, 0, (self.Dist/10)*math.Rand(-2,2), Color( 255, 255, 255, v * 70 ) )

end
