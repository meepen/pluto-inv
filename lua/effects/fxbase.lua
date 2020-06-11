-- based on nomad's tracer by Chad Barrett --

AddCSLuaFile()
if ( CLIENT ) then
TRACER_FLAG_USEATTACHMENT	= 0x0002
end
EFFECT.Speed	= 6500
EFFECT.Length	= 64

function EFFECT:GetTracerOrigin( data )
	if ( CLIENT ) then
		local start = data:GetStart()

		if( bit.band( data:GetFlags(), TRACER_FLAG_USEATTACHMENT ) == TRACER_FLAG_USEATTACHMENT ) then
			local entity = data:GetEntity()
			
			if( !IsValid( entity ) ) then 
				return start 
			end
			
			if( !game.SinglePlayer() && entity:IsEFlagSet( EFL_DORMANT ) ) then 
				return start 
			end
			
			if( entity:IsWeapon() && entity:IsCarriedByLocalPlayer() ) then
				local pl = entity:GetOwner()
				if( IsValid( pl ) ) then
					local vm = pl:GetViewModel()
					if( IsValid( vm ) and not LocalPlayer():ShouldDrawLocalPlayer() ) then
						entity = vm
					else 					
						if( entity.WorldModel ) then
							entity:SetModel( entity.WorldModel )
						end
					end
				end
			end

			local attachment = entity:GetAttachment( data:GetAttachment() )
			if( attachment ) then
				start = attachment.Pos
			end

		end
		
		return start
	end
end

function EFFECT:Init( data )

	self.StartPos = self:GetTracerOrigin( data )
	self.EndPos = data:GetOrigin()
	self.Parent = data:GetEntity()
	
--	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )

	local diff = ( self.EndPos - self.StartPos )
	
	self.Normal = diff:GetNormal()
	self.StartTime = 0
	
	if ( !self.LifeTime ) then
		self.LifeTime = ( diff:Length() + self.Length ) / self.Speed
	else
		self.LifeTime = CurTime() + self.LifeTime
	end
	
end

function EFFECT:Think()

	self.LifeTime = self.LifeTime - FrameTime()
	self.StartTime = self.StartTime + FrameTime()
	
	return self.LifeTime > 0

end

function EFFECT:Render()

	local endDistance = self.Speed * self.StartTime
	local startDistance = endDistance - self.Length
	
	startDistance = math.max( 0, startDistance )
	endDistance = math.max( 0, endDistance )

	local startPos = self.StartPos + self.Normal * startDistance
	local endPos = self.StartPos + self.Normal * endDistance
	
end