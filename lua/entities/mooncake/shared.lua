ENT.Type = "anim"
ENT.PrintName			= "explosive Grenade"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions			= ""
ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 60 then
		self.Entity:EmitSound(Sound("physics/flesh/flesh_squishy_impact_hard" .. math.random(1, 3) .. ".wav"))
	
		local impulse = (data.OurOldVelocity - 2 * data.OurOldVelocity:Dot(data.HitNormal) * data.HitNormal)*0.25
		phys:ApplyForceCenter(impulse)
	end
	
end
