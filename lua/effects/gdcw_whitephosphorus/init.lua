
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
	
	self.Origin 		= data:GetOrigin()
	self.Pos 		= data:GetOrigin()
	self.DirVec 		= data:GetNormal()
	self.Scale 		= data:GetScale()
	self.Radius 		= data:GetRadius()
	self.Particles 		= data:GetMagnitude()
	self.Angle 		= self.DirVec:Angle()
	self.DebrizzlemyNizzle 	= 10+data:GetScale()
	self.Size 		= 5*self.Scale
	self.Emitter 		= ParticleEmitter( self.Origin )


	sound.Play( "Explosion.Boom", self.Origin)
	sound.Play( "ambient/explosions/explode_" .. math.random(1, 4) .. ".wav", self.Origin, 100, 100 )
		

		for i=0, 20*self.Scale do
		local Smoke = self.Emitter:Add( "particles/smokey", self.Origin )
		if (Smoke) then
		Smoke:SetVelocity( self.DirVec * math.random( 200,700*self.Scale) + VectorRand():GetNormalized()*250*self.Scale )
		Smoke:SetDieTime( math.Rand( 13 , 20 ) )
		Smoke:SetStartAlpha( math.Rand( 60, 80 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 50*self.Scale )
		Smoke:SetEndSize( 90*self.Scale )
		Smoke:SetRoll( math.Rand(0, 360) )
		Smoke:SetRollDelta( math.Rand(-1, 1) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( (Vector(math.Rand(-300,300),math.Rand(-300,300),0):GetNormalized()*math.Rand(50, 300)) + Vector(0,0,math.Rand(-100, -200)) ) 			
		Smoke:SetColor( 255,255,255 )
		end
		end
	
		local Distort = self.Emitter:Add( "sprites/heatwave", self.Origin )
		if (Distort) then
		Distort:SetVelocity( self.DirVec )
		Distort:SetAirResistance( 200 )
		Distort:SetDieTime( 0.15 )
		Distort:SetStartAlpha( 255 )
		Distort:SetEndAlpha( 0 )
		Distort:SetStartSize( 700 *self.Scale )
		Distort:SetEndSize( 0 )
		Distort:SetRoll( math.Rand(180,480) )
		Distort:SetRollDelta( math.Rand(-1,1) )
		Distort:SetColor(255,255,255)	
		end


		local Density = 20*self.Radius
		local Angle = self.DirVec:Angle()	
		for i=0, Density do	
			
		Angle:RotateAroundAxis(Angle:Forward(), (360/Density))
		local ShootVector = Angle:Up()
		local Smoke = self.Emitter:Add( "particles/smokey", self.Origin+self.DirVec*100 )	//"particle/smokestack"

		if (Smoke) then
		Smoke:SetVelocity( ShootVector * math.Rand(10,500*self.Radius) )
		Smoke:SetDieTime( math.Rand( 10 , 20 ) )
		Smoke:SetStartAlpha( math.Rand( 60, 80 ) )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 40*self.Scale )
		Smoke:SetEndSize( 70*self.Radius )
		Smoke:SetRoll( math.Rand(0, 360) )
		Smoke:SetRollDelta( math.Rand(-1, 1) )			
		Smoke:SetAirResistance( 200 ) 			 
		Smoke:SetGravity( Vector(math.Rand(-300,300),math.Rand(-300,300),0):GetNormalized() * math.Rand(50, 300) )			
		Smoke:SetColor( 255,255,255 )
		end	
		end

		local Angle = self.DirVec:Angle()
		for i = 1, self.DebrizzlemyNizzle do
		Angle:RotateAroundAxis(Angle:Forward(), (360/self.DebrizzlemyNizzle))
		local DustRing = Angle:Up()
		local RanVec = self.DirVec*math.Rand(1, 3) + (DustRing*math.Rand(2, 5))

		for k = 3, self.Particles do
		local particle1 = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Pos )				
		particle1:SetVelocity((VectorRand():GetNormalized()*math.Rand(1, 2) * self.Size) + (RanVec*self.Size*k*3.5))	
		particle1:SetDieTime( math.Rand( 0.5, 4 )*self.Scale )	
		particle1:SetStartAlpha( math.Rand( 90, 100 ) )			
		particle1:SetEndAlpha(0)	
		particle1:SetGravity((VectorRand():GetNormalized()*math.Rand(5, 10)* self.Size) + Vector(0,0,-50))
		particle1:SetAirResistance( 200+self.Scale*20 ) 		
		particle1:SetStartSize( (5*self.Size)-((k/self.Particles)*self.Size*3) )	
		particle1:SetEndSize( (20*self.Size)-((k/self.Particles)*self.Size) )
		particle1:SetRoll( math.random( -500, 500 )/100 )	
		particle1:SetRollDelta( math.random( -0.5, 0.5 ) )	
		particle1:SetColor( 255,255,255 )
		end
		end

 end 
   
   
/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think()
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end

 