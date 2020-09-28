AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_VAMPIRE,CLASS_GARGOYLE)
end
ENT.sModel = "models/skyrim/gargoyle.mdl"
ENT.fMeleeDistance	= 90
ENT.bFlinchOnDamage = true
ENT.m_bKnockDownable = false
ENT.BoneRagdollMain = "NPC COM [COM ]"
ENT.skName = "gargoyle"
ENT.CollisionBounds = Vector(28,28,89)

ENT.iBloodType = BLOOD_COLOR_RED
ENT.sSoundDir = "npc/gargoyle/"

ENT.tblFlinchActivities = {
	[HITBOX_GENERIC] = ACT_FLINCH_CHEST
}

ENT.m_tbAttacks = {
	[1] = "attackl",
	[2] = "attackr",
	[3] = "attack_standingpower",
	[4] = "attack_standingpowerl",
	[5] = "attack_standingpowerr",
	-- [6] = "attack_forwardpowerdash",
	-- [7] = "forwardpowerattack"
}

ENT.m_tbAttacksGestures = {
	[1] = "gesture_attackl",
	[2] = "gesture_attackr",
	[3] = "gesture_attack_standingpower",
	[4] = "gesture_attack_standingpowerl",
	[5] = "gesture_attack_standingpowerr"
}

ENT.m_tbSounds = {
	["Attack"] = "mudcrab_attack0[1-3].mp3",
	["AttackCombo"] = "mudcrab_attackcombo0[1-2].mp3",
	["AttackJump"] = "mudcrab_attackforwardjump01.mp3",
	["Death"] = "mudcrab_death0[1-2].mp3",
	["DigIn"] = "mudcrab_dig_in01.mp3",
	["DigOut"] = "mudcrab_dig_out01.mp3",
	["Idle"] = "mudcrab_idle0[1-2].mp3",
	["Pain"] = "mudcrab_injured0[1-2].mp3",
	["FootLeft"] = "foot/mudcrab_foot_l0[1-3].mp3",
	["FootRight"] = "foot/mudcrab_foot_r0[1-3].mp3"
}

function ENT:OnInit()
	self:SetHullType(HULL_LARGE)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:slvCapabilitiesAdd(bit.bor(CAP_MOVE_GROUND,CAP_OPEN_DOORS))
	self:slvSetHealth(700)
	self.nextMoveSideways = 0

	local cspLoop = CreateSound(self,self.sSoundDir .. "dlc01_npc_gargoyle_conscious_lp.wav")
	cspLoop:SetSoundLevel(75)
	cspLoop:Play()
	self.cspBreathe = cspLoop
	self:StopSoundOnDeath(cspLoop)
	self:SetGargoyleType("normal")
	self:SubInit()
end

function ENT:SetGargoyleType(skin)
	if skin == "goliath" then
		self:SetSkin(0)
	elseif skin == "normal" then
		self:SetSkin(1)
	elseif skin == "brute" then
		self:SetSkin(1)
	elseif skin == "sentinel" then
		self:SetSkin(3)
	elseif skin == "albino" then
		self:SetSkin(4)
	elseif skin == "hell" then
		self:SetSkin(2)
	end
end

-- function ENT:_PossShouldFaceMoving(possessor)
	-- return false
-- end

function ENT:Flinch(hitgroup)
	local act = self.tblFlinchActivities[hitgroup] || self.tblFlinchActivities[HITGROUP_GENERIC] || self.tblFlinchActivities[HITBOX_GENERIC]
	if !act then return end
	if math.random(1,2) == 1 then
		self:SLVPlayActivity(self:GetSequenceActivity(self:LookupSequence("staggersmall")))
	else
		self:SLVPlayActivity(self:GetSequenceActivity(self:LookupSequence("staggermedium")))
	end
end

function ENT:SubInit()
end

function ENT:SelectGetUpActivity()
	local _, ang = self.ragdoll:GetBonePosition(self:GetMainRagdollBone())
	return ang.p >= 0 && ACT_ROLL_LEFT || ACT_ROLL_RIGHT
end

function ENT:_PossPrimaryAttack(entPossessor, fcDone)
	-- self:SLVPlayActivity(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacks[math.random(1,#self.m_tbAttacks)])),false,fcDone)
	-- self:RestartGesture(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacksGestures[math.random(1,#self.m_tbAttacksGestures)])))
	if self:IsMoving() then
		self:PlayGestureActivity(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacksGestures[math.random(1,#self.m_tbAttacksGestures)])))
		fcDone(true)
	else
		self:SLVPlayActivity(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacks[math.random(1,#self.m_tbAttacks)])),true,fcDone)
	end
end

function ENT:OnThink()
	self:UpdateLastEnemyPositions()
	-- if(IsValid(self.entEnemy) && self.moveSideways && CurTime() < self.moveSideways) then
		-- local ang = self:GetAngles()
		-- local yawTgt = (self.entEnemy:GetPos() -self:GetPos()):Angle().y
		-- ang.y = math.ApproachAngle(ang.y,yawTgt,10)
		-- self:SetAngles(ang)
		-- self:NextThink(CurTime())
		-- return true
	-- end
end

function ENT:EventHandle(...)
	local event = select(1,...)
	if(event == "mattack") then
		local dist = self.fMeleeDistance
		local dmg
		local ang
		local atk = select(2,...)
		if(atk == "right") then
			ang = Angle(5,-15,2)
			dmg = 29
		elseif(atk == "left") then
			ang = Angle(5,15,-2)
			dmg = 29
		elseif(atk == "rightpower") then
			ang = Angle(5,-15,2)
			dmg = 46
		elseif(atk == "leftpower") then 
			ang = Angle(16,15,-2)
			dmg = 46
		else
			ang = Angle(16,15,-2)
			dmg = 29
		end
		self:DealMeleeDamage(dist,dmg,ang)
		return true
	end
	if(event == "dig") then
		return true
	end
end

function ENT:SelectScheduleHandle(enemy,dist,distPred,disp)
	if(disp == D_HT) then
		if(self:CanSee(self.entEnemy)) then
			-- if(self.moveSideways) then
				-- if(CurTime() > self.moveSideways || dist > 120 || dist <= 40) then
					-- self:SetRunActivity(ACT_RUN)
					-- self.moveSideways = nil
					-- self.nextMoveSideways = CurTime() +4
				-- else
					-- self:MoveToPosDirect(self:GetPos() +self:GetRight() *(self.moveDir == 0 && 1 || -1) *80,true,true)
					-- return
				-- end
			-- elseif(dist <= 100 && dist > 40) then
				-- if(CurTime() >= self.nextMoveSideways) then
					-- if(math.random(1,3) == 1) then
						-- self.moveSideways = CurTime() +math.Rand(2,4)
						-- self.moveDir = math.random(0,1)
						-- self:SetRunActivity(self:GetWalkActivity())
						-- self:MoveToPosDirect(self:GetPos() +self:GetRight() *(self.moveDir == 0 && 1 || -1) *80,true,true)
						-- return
					-- else self.nextMoveSideways = CurTime() +4 end
				-- end
			-- end
			if(dist <= self.fMeleeDistance || distPred <= self.fMeleeDistance) then
				-- self:RestartGesture(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacksGestures[math.random(1,#self.m_tbAttacksGestures)])))
				if self:IsMoving() then
					self:PlayGestureActivity(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacksGestures[math.random(1,#self.m_tbAttacksGestures)])))
				else
					self:SLVPlayActivity(self:GetSequenceActivity(self:LookupSequence(self.m_tbAttacks[math.random(1,#self.m_tbAttacks)])))
				end
				return
			end
		end
		self:ChaseEnemy()
	elseif(disp == D_FR) then
		self:Hide()
	end
end
