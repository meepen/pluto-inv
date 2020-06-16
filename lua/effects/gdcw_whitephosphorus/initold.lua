

EFFECT.Mat = Material( "effects/select_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
local vOffset = data:GetOrigin() 
	 
 	local emitter = ParticleEmitter( vOffset ) 

 	 	WorldSound( "ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", vOffset, 100, 100 )
		WorldSound( "Explosion.Boom", vOffset)


 			for i=1, 200 do 
			local particle2 = emitter:Add( "particle/particle_smokegrenade", vOffset ) 
 			if (particle2) then 
 				 
 				particle2:SetVelocity( VectorRand():GetNormalized() * math.Rand(1200, 2000) ) 
 				particle2:SetDieTime( math.Rand(10, 20) )  				 
 				particle2:SetStartAlpha( 120 ) 
 				particle2:SetEndAlpha( 0 )  				 
 				particle2:SetStartSize( math.Rand(60, 70) ) 
 				particle2:SetEndSize( math.Rand(120, 170) ) 				 
 				particle2:SetRoll( math.Rand(0, 360) ) 
 				particle2:SetRollDelta( math.Rand(-0.5, 0.5) ) 				 
 				particle2:SetAirResistance( 300 ) 
 				particle2:SetColor(255,255,255) 
 				particle2:SetGravity( Vector( math.Rand(-200, 200), math.Rand(-200, 200), 0) ) 
				particle2:SetCollide( true )
				particle2:SetBounce( 1 )
			end
		end

 			for i=1,10 do 
			local Flash = emitter:Add( "effects/muzzleflash"..math.random(1,4), vOffset )
			if (Flash) then
				Flash:SetVelocity( VectorRand() )
				Flash:SetAirResistance( 200 )
				Flash:SetDieTime( 0.2 )
				Flash:SetStartAlpha( 255 )
				Flash:SetEndAlpha( 0 )
				Flash:SetStartSize( 0 )
				Flash:SetEndSize( 1000 )
				Flash:SetRoll( math.Rand(180,480) )
				Flash:SetRollDelta( math.Rand(-1,1) )
				Flash:SetColor(255,255,255)	
			end
		end

			for i=1,1 do 
			local Shockwave = emitter:Add( "sprites/heatwave", vOffset )
			if (Shockwave) then
				Shockwave:SetVelocity( VectorRand() )
				Shockwave:SetAirResistance( 200 )
				Shockwave:SetDieTime( 0.2 )
				Shockwave:SetStartAlpha( 255 )
				Shockwave:SetEndAlpha( 0 )
				Shockwave:SetStartSize( 10 )
				Shockwave:SetEndSize( 1000 )
				Shockwave:SetRoll( math.Rand(180,480) )
				Shockwave:SetRollDelta( math.Rand(-1,1) )
				Shockwave:SetColor(255,255,255)	
			end
		end
 			 
	 
 emitter:Finish() 
	
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end
