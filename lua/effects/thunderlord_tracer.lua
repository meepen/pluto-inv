AddCSLuaFile()
AddCSLuaFile( "effects/fxbase.lua" )
include( "effects/fxbase.lua" )

EFFECT.ParticleCast = false
EFFECT.Time = nil

EFFECT.Speed = 12000
function EFFECT:Think()

	if ( !self.ParticleCast ) then
		util.ParticleTracerEx( 
			"aquamarine_tracer", 	--particle system
			self.StartPos, 	--startpos
			self.EndPos, 	--endpos
			false, 			--do whiz effect
			-1, 			--entity index
			-1  			--attachment
		)
		
		self.ParticleCast = true
	end
	
	if ( !self.Time ) then	
		self.Time = self.LifeTime + CurTime()
	end
	
	local Fraction = math.max( 0, ( self.Time - CurTime() ) / self.LifeTime )
	
	local difforigin = self.EndPos - self.StartPos
	local lightorigin = self.StartPos + ( difforigin * ( 1 - Fraction ) ) 

	local mLight = DynamicLight( -1 )
	if ( mLight ) then
		mLight.pos = lightorigin
		mLight.r = 0
		mLight.g = 40
		mLight.b = 255
		mLight.brightness = 3 * Fraction
		mLight.Size = 180 + 200 * Fraction
		mLight.Decay = 1024
		mLight.Style = 1
		mLight.DieTime = CurTime() + 1
	end
	
	return ( self.Time > CurTime() ) 
	
end
