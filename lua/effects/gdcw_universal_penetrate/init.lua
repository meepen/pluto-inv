
					//Sound,Impact

					// 1        2       3      4      5
					//Dirt, Concrete, Metal, Glass, Flesh

					// 1     2     3      4      5      6      7      8         9
					//Dust, Dirt, Sand, Metal, Smoke, Wood,  Glass, Blood, YellowBlood
local mats={				
	[MAT_ALIENFLESH]		={5,9},
	[MAT_ANTLION]			={5,9},
	[MAT_BLOODYFLESH]		={5,8},
	[45]				={5,8},	// Metrocop heads are a source glitch, they have no enumeration
	[88]				={5},	// Map boundary glitch is now accounted for!
	[MAT_CLIP]			={3,5},
	[MAT_COMPUTER]			={4,5},
	[MAT_FLESH]			={5,8},
	[MAT_GRATE]			={3,4},
	[MAT_METAL]			={3,4},
	[MAT_PLASTIC]			={2,5},
	[MAT_SLOSH]			={5,5},
	[MAT_VENT]			={3,4},
	[MAT_FOLIAGE]			={1,5},
	[MAT_TILE]			={2,5},
	[MAT_CONCRETE]			={2,1},
	[MAT_DIRT]			={1,2},
	[MAT_SAND]			={1,3},
	[MAT_WOOD]			={2,6},
	[MAT_GLASS]			={4,7},
}



function EFFECT:Init(data)
self.Pos 		= data:GetOrigin()		// Pos determines the global position of the effect			//
self.DirVec 		= data:GetNormal()		// DirVec determines the direction of impact for the effect		//
self.Scale 		= data:GetScale()		// Scale determines how large the effect is				//
self.Radius 		= data:GetRadius() or 1		// Radius determines what type of effect to create, default is Concrete	//
self.Emitter 		= ParticleEmitter( self.Pos )	// Emitter must be there so you don't get an error			//

	self.Mat=math.ceil(self.Radius)


 
	if     mats[self.Mat][2]==1 then	self:Dust()	
	elseif mats[self.Mat][2]==2 then	self:Dirt()
	elseif mats[self.Mat][2]==3 then	self:Sand()
	elseif mats[self.Mat][2]==4 then	self:Metal()
	elseif mats[self.Mat][2]==5 then	self:Smoke()
	elseif mats[self.Mat][2]==6 then	self:Wood()
	elseif mats[self.Mat][2]==7 then	self:Glass()
	elseif mats[self.Mat][2]==8 then	self:Blood()
	elseif mats[self.Mat][2]==9 then	self:YellowBlood()
	else 					self:Smoke()
	end

end
 
 function EFFECT:Dust()
	self.Emitter = ParticleEmitter( self.Pos )
		
	for i=0, 50*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(10,1000*self.Scale) + VectorRand():GetNormalized() * 350*self.Scale )
		Debris:SetDieTime( math.random( 0.5, 1.2) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(1,4*self.Scale) )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 30 ) 			 			
		Debris:SetColor( 100,100,100 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.2 )			
		end
	end

	for i=0, 15*self.Scale do
		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 30,500*self.Scale) )
		Smoke:SetDieTime( math.Rand( 0.3 , 0.8 )*self.Scale )
		Smoke:SetStartAlpha( 150 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 15*self.Scale )
		Smoke:SetEndSize( 40*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 300 ) 			 			
		Smoke:SetColor( 100,100,100 )
		end
	end
 end
 
 function EFFECT:Dirt()
	self.Emitter = ParticleEmitter( self.Pos )
		
	for i=0, 50*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(10,1000*self.Scale) + VectorRand():GetNormalized() * 350*self.Scale )
		Debris:SetDieTime( math.random( 0.5, 1.2) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(1,4*self.Scale) )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 30 ) 			 			
		Debris:SetColor( 90,83,68 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.2 )			
		end
	end

	for i=0, 15*self.Scale do
		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 30,500*self.Scale))
		Smoke:SetDieTime( math.Rand( 0.3 , 0.8 )*self.Scale )
		Smoke:SetStartAlpha( 150 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 15*self.Scale )
		Smoke:SetEndSize( 40*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 300 ) 			 			
		Smoke:SetColor( 90,83,68 )
		end
	end
 end

 function EFFECT:Sand()
	self.Emitter = ParticleEmitter( self.Pos )
		
	for i=0, 50*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(10,1000*self.Scale) + VectorRand():GetNormalized() * 350*self.Scale )
		Debris:SetDieTime( math.random( 0.5, 1.2) * self.Scale )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(1,4*self.Scale) )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 30 ) 			 			
		Debris:SetColor( 120,110,90 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.2 )			
		end
	end

	for i=0, 15*self.Scale do
		local Smoke = self.Emitter:Add( "particle/particle_composite", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 30,500*self.Scale) )
		Smoke:SetDieTime( math.Rand( 0.3 , 0.8 )*self.Scale )
		Smoke:SetStartAlpha( 150 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 15*self.Scale )
		Smoke:SetEndSize( 40*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 300 ) 			 			
		Smoke:SetColor( 120,110,90 )
		end
	end
 end

 function EFFECT:Metal()
	self.Emitter = ParticleEmitter( self.Pos )
		
	for i=0, 10*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 20,70*self.Scale) + VectorRand():GetNormalized()*150*self.Scale )
		Smoke:SetDieTime( math.Rand( 0.5 , 2 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 30, 40 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 25*self.Scale )
		Smoke:SetEndSize( 40*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 300 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) * self.Scale, math.Rand(0, -100) ) ) 			
		Smoke:SetColor( 100,100,100 )
		end
	end
	
		for i=0,3 do 
			local Flash = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos )
			if (Flash) then
			Flash:SetVelocity( self.DirVec*100 )
			Flash:SetAirResistance( 200 )
			Flash:SetDieTime( 0.1 )
			Flash:SetStartAlpha( 255 )
			Flash:SetEndAlpha( 0 )
			Flash:SetStartSize( math.Rand( 20, 30 )*self.Scale^2 )
			Flash:SetEndSize( 0 )
			Flash:SetRoll( math.Rand(180,480) )
			Flash:SetRollDelta( math.Rand(-1,1) )
			Flash:SetColor(255,255,255)	
			end
		end

 	 
 		for i=0, 20*self.Scale do 
 			local particle = self.Emitter:Add( "effects/spark", self.Pos ) 
 			if (particle) then 
 			particle:SetVelocity( ((self.DirVec*0.75)+VectorRand()) * math.Rand(50, 300)*self.Scale ) 
 			particle:SetDieTime( math.Rand(0.3, 0.5) ) 				 
 			particle:SetStartAlpha( 255 )  				 
 			particle:SetStartSize( math.Rand(4, 6)*self.Scale ) 
 			particle:SetEndSize( 0 ) 				 
 			particle:SetRoll( math.Rand(0, 360) ) 
 			particle:SetRollDelta( math.Rand(-5, 5) ) 				 
 			particle:SetAirResistance( 20 ) 
 			particle:SetGravity( Vector( 0, 0, -600 ) ) 
 			end 
			
		end 

end


 function EFFECT:Smoke()
	self.Emitter = ParticleEmitter( self.Pos )
		
	for i=0, 5*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokestack", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 20,70*self.Scale) + VectorRand():GetNormalized()*150*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 5 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 50, 70 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20*self.Scale )
		Smoke:SetEndSize( 50*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) ) ) 			
		Smoke:SetColor( 100,100,100 )
		end
	end

	for i=0, 10*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 20,70*self.Scale) + VectorRand():GetNormalized()*150*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 4 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 50, 60 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20*self.Scale )
		Smoke:SetEndSize( 50*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) ) ) 			
		Smoke:SetColor( 100,100,100 )
		end
	end

	for i=0, 15*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_tile"..math.random(1,2), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(50,200*self.Scale) + VectorRand():GetNormalized() * 300*self.Scale )
		Debris:SetDieTime( math.random( 0.75, 1) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(1,4*self.Scale) )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 50 ) 			 			
		Debris:SetColor( 90,85,75 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 1 )			
		end
	end

 end

 function EFFECT:Wood()
	self.Emitter = ParticleEmitter( self.Pos )
		
	for i=0, 7*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 20,70*self.Scale) + VectorRand():GetNormalized()*150*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 3 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 30, 50 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 25*self.Scale )
		Smoke:SetEndSize( 50*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) ) ) 			
		Smoke:SetColor( 100,100,100 )
		end
	end

	for i=0, 13*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 20,70*self.Scale) + VectorRand():GetNormalized()*130*self.Scale )
		Smoke:SetDieTime( math.Rand( 1 , 3 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 40, 60 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20*self.Scale )
		Smoke:SetEndSize( 50*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) ) ) 			
		Smoke:SetColor( 90,85,75 )
		end
	end

	for i=0, 15*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_wood"..math.random(1,2), self.Pos+self.DirVec )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(50,400*self.Scale) + VectorRand():GetNormalized() * 300*self.Scale )
		Debris:SetDieTime( math.random( 0.75, 1) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(3,6*self.Scale) )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-5, 5) )			
		Debris:SetAirResistance( 50 ) 			 			
		Debris:SetColor( 90,85,75 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 
		Debris:SetCollide( true )
		Debris:SetBounce( 0.5 )			
		end
	end

 end

 function EFFECT:Glass()
	self.Emitter = ParticleEmitter( self.Pos )

	for i=0, 10*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 20,70*self.Scale) + VectorRand():GetNormalized()*150*self.Scale )
		Smoke:SetDieTime( math.Rand( 3 , 7 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 30, 50 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20*self.Scale )
		Smoke:SetEndSize( 50*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-2, 2) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) * self.Scale, math.Rand(-70, 70) ) ) 			
		Smoke:SetColor( 100,100,100 )
		end
	end
	
	for i=0, 20*self.Scale do
		local Debris = self.Emitter:Add( "effects/fleck_glass"..math.random(1,3), self.Pos )
		if (Debris) then
		Debris:SetVelocity ( self.DirVec * math.random(30,400)*self.Scale + VectorRand():GetNormalized() * 100*self.Scale )
		Debris:SetDieTime( math.random( 1, 1.5) )
		Debris:SetStartAlpha( 255 )
		Debris:SetEndAlpha( 0 )
		Debris:SetStartSize( math.random(2,4)*self.Scale )
		Debris:SetRoll( math.Rand(0, 360) )
		Debris:SetRollDelta( math.Rand(-15, 15) )			
		Debris:SetAirResistance( 50 ) 			 			
		Debris:SetColor( 200,200,200 )
		Debris:SetGravity( Vector( 0, 0, -600) ) 		
		end
	end
 end

 function EFFECT:Blood()
	self.Emitter = ParticleEmitter( self.Pos )

		// Some chunks of spleen or whatever
	for i=0, (30)*self.Scale do
		local Chunks = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Chunks) then
		Chunks:SetVelocity ( (self.DirVec*self.Scale*math.Rand(30, 400)) + (VectorRand():GetNormalized()*80*self.Scale) )
		Chunks:SetDieTime( math.random( 0.3, 0.9) )
		Chunks:SetStartAlpha( 255 )
		Chunks:SetEndAlpha( 0 )
		Chunks:SetStartSize( 4*self.Scale )
		Chunks:SetEndSize( 3*self.Scale )
		Chunks:SetRoll( math.Rand(0, 360) )
		Chunks:SetRollDelta( math.Rand(-5, 5) )			
		Chunks:SetAirResistance( 30 ) 			 			
		Chunks:SetColor( 70,35,35 )
		Chunks:SetGravity( Vector( 0, 0, -600) ) 
		Chunks:SetCollide( true )
		Chunks:SetBounce( 0.01 )			
		end
	end

 end

 function EFFECT:YellowBlood()
	self.Emitter = ParticleEmitter( self.Pos )

		// Some chunks of spleen or whatever
	for i=0, (25)*self.Scale do
		local Chunks = self.Emitter:Add( "effects/fleck_cement"..math.random(1,2), self.Pos )
		if (Chunks) then
		Chunks:SetVelocity ( (self.DirVec*self.Scale*math.Rand(-100, 300)) + (VectorRand():GetNormalized()*50*self.Scale) )
		Chunks:SetDieTime( math.random( 0.3, 0.8) )
		Chunks:SetStartAlpha( 255 )
		Chunks:SetEndAlpha( 0 )
		Chunks:SetStartSize( 3*self.Scale )
		Chunks:SetEndSize( 3*self.Scale )
		Chunks:SetRoll( math.Rand(0, 360) )
		Chunks:SetRollDelta( math.Rand(-5, 5) )			
		Chunks:SetAirResistance( 30 ) 			 			
		Chunks:SetColor( 120,120,0 )
		Chunks:SetGravity( Vector( 0, 0, -600) ) 
		Chunks:SetCollide( true )
		Chunks:SetBounce( 0.01 )			
		end
	end

		// Some dust kickup like in the movies
	for i=0, 8*self.Scale do
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec*math.random( 10,30*self.Scale) + VectorRand():GetNormalized()*120*self.Scale )
		Smoke:SetDieTime( math.Rand( 0.5 , 3 )*self.Scale )
		Smoke:SetStartAlpha( math.Rand( 40, 50 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20*self.Scale )
		Smoke:SetEndSize( 30*self.Scale )
		Smoke:SetRoll( math.Rand(150, 360) )
		Smoke:SetRollDelta( math.Rand(-1, 1) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetColor( 120,120,0 )
		end
	end
end
 

function EFFECT:Think( )
return false
end

function EFFECT:Render()
end