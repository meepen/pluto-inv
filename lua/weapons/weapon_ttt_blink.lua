DEFINE_BASECLASS "weapon_tttbase"

SWEP.Base = "weapon_tttbase"

SWEP.PrintName = "Blink"

SWEP.Primary.Automatic = true

SWEP.Speed = 4000
SWEP.Distance = 1600
SWEP.Blinks = 2.4
SWEP.RechargeRate = 0.2 / SWEP.Blinks

SWEP.UseHands = true

SWEP.ViewModel             = "models/weapons/c_slam.mdl"
SWEP.WorldModel            = "models/weapons/w_slam.mdl"

SWEP.Slot = 6
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1

SWEP.Equipment = {
	Name		   = "Blink",
	Desc 		   = "In a blink of an eye, they were gone.",
	CanBuy	       = { traitor = true, Detective = true },
	Cost 	   	   = 1,
	Limit	       = 1,
	Icon           = "materials/weapons/blink.png"
}

SWEP.DeploySpeed = 4

local none = Vector(math.huge)

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	self:NetVar("Blinking", "Bool", false)
	self:NetVar("ToPos", "Vector", none)
	self:NetVar("Charge", "Float", 1)
	self:NetVar("LastBlink", "Float", -math.huge)
end

function SWEP:GetCurrentCharge()
	return math.Clamp(self:GetCharge() + (CurTime() - self:GetLastBlink()) * self.RechargeRate, 0, 1)
end

function SWEP:Initialize()
	hook.Add("Move", self, self.Move)
	hook.Add("PostDrawTranslucentRenderables", self, self.PostDrawTranslucentRenderables)
	hook.Add("RenderScreenspaceEffects", self, self.RenderScreenspaceEffects)
end


local function RagdollDissolveEffect(ply)
    if (not IsValid(BLINK_DISSOLVER)) then
        BLINK_DISSOLVER = ents.Create "env_entity_dissolver"
        BLINK_DISSOLVER:SetKeyValue("dissolvetype", 3)
        BLINK_DISSOLVER:Spawn()
    end

	if (not SERVER or not IsValid(ply)) then
		return	
	end

	local rgd = ents.Create "prop_ragdoll"
	if (not IsValid(rgd)) then
		return
	end

	rgd:SetPos(ply:GetPos())
	rgd:SetModel(ply:GetModel())
	rgd:SetAngles(ply:GetAngles())
	rgd:Spawn()
	rgd:Activate()
	rgd:SetGravity(0)
	rgd:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	rgd:SetMaxHealth(100)
	rgd:SetHealth(100)
	rgd.Owner = ply
	rgd:SetOwner(ply)
	rgd:SetColor(Color(255, 255, 255, 100))

	if IsValid(rgd) then
		for i = 0, rgd:GetPhysicsObjectCount() - 1 do
			local phys = rgd:GetPhysicsObjectNum(i)
			phys:Wake()

			if IsValid(phys) then
				local pos, ang = ply:GetBonePosition(rgd:TranslatePhysBoneToBone(i))
				phys:EnableGravity(false)

				if pos and ang then
					phys:SetPos(pos)
					phys:SetAngles(ang)
				end
			end

			phys:EnableMotion(false)

			timer.Simple(0.1, function()
				phys:Sleep()
			end)
		end
	end

	rgd.IsSafeToRemove = true
	rgd:SetName("DissolveID" .. rgd:EntIndex())
	BLINK_DISSOLVER:Fire("Dissolve", "DissolveID" .. rgd:EntIndex(), 0.01)
end

function SWEP:DrawHUD()
	local w = 15
	local left = ScrW() / 2 - 50 - w / 2
	local h = 60
	local top = ScrH() / 2 - h / 2

	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(left, top, w, h)

	if (self:GetCurrentCharge() >= 1 / self.Blinks) then
		surface.SetDrawColor(0, 255, 0)
	else
		surface.SetDrawColor(255, 0, 0)
	end
	local real_tall = math.Round((h - 2) * self:GetCurrentCharge())
	surface.DrawRect(left + 1, top + 1 + (h - 2) - real_tall, w - 2, real_tall)
end

function SWEP:Think()
	if (self:GetBlinking()) then
		local own = self:GetOwner()
		if (not own:KeyDown(IN_ATTACK)) then
			self:SetBlinking(false)
			
			local pos = self:Trace()

			if (pos) then
				self:EmitSound("vadim_blink/teleport" .. math.random(2) .. ".ogg")
				self:SetToPos(pos)
				self:SetCharge(math.max(0, self:GetCurrentCharge() - 1 / self.Blinks))
				self:SetLastBlink(CurTime())
				if (SERVER) then
					RagdollDissolveEffect(self:GetOwner())
				end
			end
		end
	end

	BaseClass.Think(self)
end

function SWEP:Trace()
	local own = self:GetOwner()
	local first = {
		start = own:GetShootPos(),
		endpos = own:GetShootPos() + own:GetAimVector() * self.Distance,
		mins = Vector(-1, -1, -1),
		maxs = Vector(1, 1, 1),
		filter = own,
		mask = MASK_PLAYERSOLID,
		collisiongroup = own:GetCollisionGroup()
	}
	local tr = util.TraceHull(first)

	local test = {
		mins = own:OBBMins(),
		maxs = own:OBBMaxs(),
		filter = own,
		mask = MASK_PLAYERSOLID,
		collisiongroup = own:GetCollisionGroup()
	}

	for curdist = tr.HitPos:Distance(own:GetPos()), 0, -4 do
		local curpos = own:GetShootPos() + own:GetAimVector() * curdist
		test.start = curpos
		test.endpos = curpos
		tr = util.TraceHull(test)

		if (not tr.StartSolid and not tr.Hit) then
			first.endpos = tr.HitPos
			tr = util.TraceLine(first)
			if (not tr.StartSolid and not tr.Hit) then
				return tr.HitPos
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if (self:GetBlinking() or self:GetToPos() ~= none or self:GetCurrentCharge() < 1 / self.Blinks) then
		return
	end
	local own = self:GetOwner()
	if (not IsValid(own) or own:KeyDown(IN_ATTACK2)) then
		self:SetNextPrimaryFire(CurTime() + 0.5)
		return
	end
	self:SetBlinking(true)
	hook.Run("PlutoMovementAbility", own, self)

	self:EmitSound("vadim_blink/aim" .. math.random(2) .. ".ogg")
end

function SWEP:SecondaryAttack()
	self:SetBlinking(false)
end

function SWEP:PostDrawTranslucentRenderables(depth, skybox)
	if (skybox or depth) then
		return
	end

	local targ = ttt.GetHUDTarget()
	if (targ ~= self:GetOwner()) then
		return
	end

	if (self:GetBlinking()) then
		local pos = self:Trace()
		if (not pos) then
			return
		end

		render.SetColorMaterial()
		render.DrawBeam(pos, pos + vector_up * 40, 4, 0, 1, color_white)
	end
end

local tab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.2,
	["$pp_colour_contrast"] = 0.5,
	["$pp_colour_colour"] = 5,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}
local mat = Material "models/effects/comball_tape"

function SWEP:RenderScreenspaceEffects()
	local targ = ttt.GetHUDTarget()
	if (targ ~= self:GetOwner() or targ:GetActiveWeapon() ~= self) then
		return
	end

	if (self:GetBlinking()) then
		DrawColorModify(tab) --Draws Color Modify effect
	end
end

function SWEP:Holster()
	if (self:GetBlinking() or self:GetToPos() ~= none) then
		return false
	end

	return BaseClass.Holster(self)
end

function SWEP:OnDrop()
	self:SetToPos(none)
	self:SetBlinking(false)
	BaseClass.OnDrop(self)
end

function SWEP:Move(ply, mv)
	if (self:GetToPos() == none or self:GetOwner() ~= ply) then
		return
	end

	local topos = self:GetToPos()
	local now = mv:GetOrigin()

	if (now:Distance(topos) < self.Speed * engine.TickInterval()) then
		mv:SetOrigin(topos)
		mv:SetVelocity(vector_origin)
		self:SetBlinking(false)
		self:SetToPos(none)
		local ply = self:GetOwner()
		self:PreventFallDamage(ply)
		timer.Simple(0, function()
			if (IsValid(ply)) then
				ply:SetMoveType(MOVETYPE_WALK)
			end
		end)
	else
		local ang = (topos - now)
		ang:Normalize()

		mv:SetOrigin(now + ang * self.Speed * engine.TickInterval())
	end

	return true
end

function SWEP:PreventFallDamage(own)
	hook.Add("GetFallDamage", {
		ply = own,
		time = CurTime(),
		IsValid = function(self)
			return IsValid(self.ply) and self.ply:Alive() and self.time + 1.5 > CurTime()
		end
	}, function(_, p, d)
		if (p ~= own) then
			return
		end

		return 0
	end)
end

function SWEP:DrawWorldModel()
	if (IsValid(self:GetOwner())) then
		return
	else
		self:DrawModel()
	end
end
