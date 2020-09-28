AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_NONE,CLASS_NONE)
end

ENT.HasMeleeAttack = false
ENT.MeleeAttack = ACT_MELEE_ATTACK1
ENT.fMeleeDistance = 40
ENT.fRangeDistance = 900
ENT.WeaponLists = {}
ENT.WeaponEquip = ACT_ARM
ENT.WeaponUnequip = ACT_DISARM
ENT.WeaponRun = ACT_RUN_AIM
ENT.WeaponWalk = ACT_WALK_AIM
ENT.WeaponMuzzle = "muzzle"
ENT.WeaponFire = "fire"
ENT.WeaponReload = "reload"

function ENT:OnInit()
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS,CAP_USE))
	self:slvSetHealth(GetConVarNumber("sk_" .. self.skName .. "_health"))
	self.moveSideways = 0
	self.nextAttackScream = 0
	self.nextAlertIdle = 0
	self.nextAlertToIdle = 0
	self.WeaponIsDrawn = false
	if self._init then self:_init() end
end

function ENT:_PossShouldFaceMoving(possessor)
	return false
end

-- function ENT:TranslateActivity(act)
	-- if(act == ACT_IDLE) then
		-- local state = self:GetState()
		-- if(state == NPC_STATE_ALERT || state == NPC_STATE_COMBAT) then return ACT_IDLE_ANGRY end
	-- end
	-- return act
-- end

-- function ENT:EventHandle(...)
	-- local event = select(1,...)
	-- if(event == "mattack") then
		-- local dist = self.fMeleeDistance
		-- local skDmg = GetConVarNumber("sk_" .. self.skName .. "_dmg_slash")
		-- local force = Vector(50,0,0)
		-- local ang = Angle(50,0,0)
		-- self:DealMeleeDamage(dist,skDmg,ang,force,DMG_SLASH,nil,true,nil,fcHit)
		-- return true
	-- end
	-- if(event == "rattack") then
		-- if self:GetActiveWeapon() != nil && IsValid(self:GetActiveWeapon()) then
			-- self:GetActiveWeapon():DoPrimaryAttack(ShootPos,ShootDir)
		-- end
		-- return true
	-- end
	-- if(event == "reload") then
		-- return true
	-- end
	-- if(event == "idlearmed") then
		-- return true
	-- end
	-- if(event == "disarm") then
		-- return true
	-- end
-- end

function ENT:OnStateChanged(old, new)
	if(self:KnockedDown()) then return end
	if old == NPC_STATE_IDLE then
		if new == NPC_STATE_COMBAT then self:slvPlaySound("NormalToCombat") end
	elseif old == NPC_STATE_COMBAT then
		if new == NPC_STATE_IDLE then self:slvPlaySound("CombatToNormal") end
	end
end

function ENT:GetMuzzlePos()
	return self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment(self.WeaponMuzzle)).Pos
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	self:MaintainPoseParameters()
	-- if IsValid(self:GetActiveWeapon()) then
		-- self:SetRunActivity(self.WeaponRun)
		-- self:SetWalkActivity(self.WeaponWalk)
	-- else
		-- self:SetRunActivity(ACT_RUN)
		-- self:SetWalkActivity(ACT_WALK)
	-- end
	local ang
	if(IsValid(self.entEnemy) && self.moveSideways && CurTime() < self.moveSideways) then
		local ang = self:GetAngles()
		local yawTgt = (self.entEnemy:GetPos() -self:GetPos()):Angle().y
		ang.y = math.ApproachAngle(ang.y,yawTgt,10)
		self:SetAngles(ang)
		self:NextThink(CurTime())
		return true
	end
end

function ENT:MaintainPoseParameters()
	local ent = self.entEnemy
	local yawTgt = 0
	local pitchTgt = 0
	if(IsValid(ent) && IsValid(self:GetActiveWeapon()) && self:GetActiveWeapon() != nil) then
		local posSrc = self:GetMuzzlePos()
		local posTgt = ent:GetHeadPos()
		local ang = self:GetAngles()
		local angTgt = (posTgt -posSrc):Angle()
		pitchTgt = math.AngleDifference(angTgt.p,ang.p)
		yawTgt = math.AngleDifference(angTgt.y,ang.y)
	end
	local ppYaw = self:GetPoseParameter("aim_yaw")
	self:SetPoseParameter("aim_yaw",math.ApproachAngle(ppYaw,yawTgt,15))
	
	local ppPitch = self:GetPoseParameter("aim_pitch")
	self:SetPoseParameter("aim_pitch",math.ApproachAngle(ppPitch,pitchTgt,15))
end

function ENT:AttackMelee(ent)
	if self.HasMeleeAttack == false then return end
	self:SetTarget(ent)
	self:SLVPlayActivity(self.MeleeAttack,2)
end

function ENT:_PossPrimaryAttack(entPossessor,fcDone)
	if self.WeaponIsDrawn == true then
		self:SLVPlayActivity(self.MeleeAttack,false,fcDone)
	else
		fcDone(true)
	end
end

function ENT:_PossSecondaryAttack(entPossessor,fcDone)
	if self.WeaponIsDrawn == true then
		-- self:RestartGesture(ACT_RANGE_ATTACK1)
		self:PlayLayeredGesture(self.WeaponFire,2,1)
		fcDone(true)
	else
		fcDone(true)
	end
end

function ENT:_PossReload(entPossessor,fcDone)
	reload = 0
	if self.WeaponIsDrawn == true && CurTime() > reload && self:GetActiveWeapon().PrimaryClip < 15 then
		-- self:RestartGesture(ACT_RELOAD)
		self:PlayLayeredGesture(self.WeaponReload,2,1)
		fcDone(true)
		reload = CurTime() +1
		self:GetActiveWeapon():DoReload()
	else
		fcDone(true)
	end
end

function ENT:_PossJump(entPossessor,fcDone)
	switch = 0
	if self.WeaponIsDrawn == true && CurTime() > switch then
		self:DisarmWeapon()
		timer.Simple(0.8,function() if IsValid(self) then
			fcDone(true)
		end end)
		switch = CurTime() +1
	elseif self.WeaponIsDrawn == false && CurTime() > switch then
		self:ArmWeapon()
		timer.Simple(0.8,function() if IsValid(self) then
			fcDone(true)
		end end)
		switch = CurTime() +1
	end
end

function ENT:GunTraceBlocked()
	local tracedata = {}
	tracedata.start = self:GetMuzzlePos()
	tracedata.endpos = self.entEnemy:GetHeadPos()
	tracedata.filter = self
	local tr = util.TraceLine(tracedata)
	return tr.Entity:IsValid() && tr.Entity != self.entEnemy
end

function ENT:SelectWeaponMethods(enemy,dist,distPred,disp)
	if dist < self.fRangeDistance && !self:GunTraceBlocked() && self:GetActiveWeapon().PrimaryClip >= 0 && dist > 40 then
		-- self:RestartGesture(ACT_RANGE_ATTACK1)
		if(CurTime() < self:GetActiveWeapon():GetNextPrimaryFire()) then return end
		self:PlayLayeredGesture(self.WeaponFire,2,1)
	end
end

function ENT:OnFoundEnemy(iEnemies)
	self:ArmWeapon()
	self:SelectSchedule()
end

function ENT:ArmWeapon()
	self:Give(self.WeaponLists[math.random(1,#self.WeaponLists)])
	self.WeaponIsDrawn = true
	if type(self.WeaponEquip) == "number" then
		self:SLVPlayActivity(self.WeaponEquip,true)
	else
		self:PlayLayeredGesture(self.WeaponEquip,2,1)
	end
end

function ENT:OnAreaCleared()
	self:slvPlaySound("AreaClear")
	self:DisarmWeapon()
end

function ENT:DisarmWeapon()
	if self:GetActiveWeapon() != nil && self:GetActiveWeapon():IsValid() && self:GetActiveWeapon().PrimaryClip != nil && self:GetActiveWeapon().PrimaryClip < 15 then
		self:GetActiveWeapon():DoReload()
		if type(self.WeaponUnequip) == "number" then
			self:SLVPlayActivity(self.WeaponUnequip,false)
		else
			self:PlayLayeredGesture(self.WeaponUnequip,2,1)
		end
		self.WeaponIsDrawn = false
		self:GetActiveWeapon():Remove()
	end
end

ENT.m_bGunWalk = false
ENT.NextRunT = 0
local choose
function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			self:SelectWeaponMethods(enemy,dist,distPred,disp)
			if dist < 200 && CurTime() > self.NextRunT then
				self:Interrupt()
				self:MoveToPos(self:GetPos() +self:GetForward() *-500,false)
				self.NextRunT = CurTime() +math.random(1,2)
			end
			if(self.moveSideways) then
				if(CurTime() > self.moveSideways || dist > 120 || dist <= 40) then
					self.moveSideways = nil
					self.nextMoveSideways = CurTime() +math.random(2,5)
				else
					if math.random(1,2) == 1 then
						choose = false
					else
						choose = true
					end
					self:MoveToPosDirect(self:GetPos() +self:GetRight() *(self.moveDir == 0 && 1 || -1) *150,choose,true)
					return
				end
			elseif(dist <= 350 && dist > 40) then
				if(CurTime() >= self.nextMoveSideways) then
					if(math.random(1,1) == 1) then
						if math.random(1,2) == 1 then
							choose = false
						else
							choose = true
						end
						self.moveSideways = CurTime() +math.Rand(2,3)
						self.moveDir = math.random(0,1)
						self:MoveToPosDirect(self:GetPos() +self:GetRight() *(self.moveDir == 0 && 1 || -1) *150,choose,true)
						return
					else self.nextMoveSideways = CurTime() +math.random(3,5) end
				end
			end
			if(self.HasMeleeAttack == true && dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				self:SLVPlayActivity(self.MeleeAttack,true)
				return
			end
		end
		if(dist > self.fRangeDistance) then self.m_bGunWalk = false; self:ChaseEnemy(); return else self:SLVFaceEnemy() end
		if(dist > 1000) then
			self.m_bGunWalk = true
			self:ChaseEnemy()
		end
	elseif(disp == D_FR) then
		self:Hide()
	end
end