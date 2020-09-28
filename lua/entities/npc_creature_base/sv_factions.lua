local _R = debug.getregistry()
if(!GAMEMODE.Aftermath) then
	hook.Add("OnEntityCreated","slv_npcupdaterelationships_vanilla",function(ent)
		-- if ent:IsNPC() then
			-- util.SetRelationshipsThroughClass(CLASS_PLAYER_ALLY,ent:GetClass())
			-- util.SetRelationshipsThroughClass(CLASS_COMBINE,ent:GetClass())
			-- util.SetRelationshipsThroughClass(CLASS_HEADCRAB,ent:GetClass())
			-- util.SetRelationshipsThroughClass(CLASS_MILITARY,ent:GetClass())
			-- util.SetRelationshipsThroughClass(CLASS_ZOMBIE,ent:GetClass())
		-- end
		if ent:IsNPC() then
			if ent.IsSLVBaseNPC != nil then
				if ent:GetModel() == "models/error.mdl" then
					ent:SetModel(ent.sModel)
				end
			end
		end
	end)
	-- hook.Add("OnEntityCreated","slv_npcupdaterelationships",function(ent)
		-- if ent:IsValid() && ent:IsNPC() && !ent.bScripted then
			-- local enemy
			-- if ent.NPCFaction == nil then enemy = true end
			-- if ent.NPCFaction then print('weeah') end
		-- end
	-- end)
	-- hook.Add("OnEntityCreated","slv_npcupdaterelationships",function(ent) // Need to apply relationships manually for vanilla NPCs
		-- if(ent:IsValid() && ent:IsNPC() && !ent.bScripted) then
			-- timer.Simple(0,function() // Wait for it to initialize properly
				-- if(ent:IsValid()) then
					-- for _,entTgt in ipairs(ents.GetAll()) do
						-- if(entTgt:IsNPC() && entTgt != ent && entTgt.bScripted) then
							-- if entTgt:GetNPCFaction() != nil && entTgt:GetNPCFaction() == ent:GetNPCFaction() then
								-- ent:AddEntityRelationship(entTgt,D_LI,100)
							-- elseif entTgt:GetNPCFaction() != nil && entTgt:GetNPCFaction() != ent:GetNPCFaction() then
								-- ent:AddEntityRelationship(entTgt,D_HT,100)
							-- elseif entTgt:GetNPCFaction() == nil then
								-- ent:AddEntityRelationship(entTgt,D_HT,100)
							-- end
						-- end
					-- end
				-- end
			-- end)
		-- end
	-- end)
end

function ENT:GetNPCFaction()
	if self.NPCFaction == nil then
		return NPC_FACTION_NONE
	elseif self.NPCFaction != nil then
		return self.NPCFaction
	else
		return NPC_FACTION_NONE
	end
end

function ENT:SLVGetFactionDisposition(tgt)
	local faction = self:GetNPCFaction()
	local factionTgt
	if(type(tgt) == "number") then factionTgt = tgt
	elseif(type(tgt) == "string") then
		faction = _R.NPCFaction.SLVGetFaction(faction)
		return (self.m_tbFactionDisp && self.m_tbFactionDisp[faction:GetID()]) || faction:Disposition(tgt)
	elseif(type(tgt) != "table") then
		faction = _R.NPCFaction.SLVGetFaction(faction)
		return (self.m_tbFactionDisp && self.m_tbFactionDisp[faction:GetID()]) || faction:Disposition(tgt)
	else factionTgt = tgt end
	return (self.m_tbFactionDisp && self.m_tbFactionDisp[faction:GetID()]) || faction:SLVGetFactionDisposition(factionTgt)
end

function ENT:UpdateFactionRelationships()
	local faction = self:GetNPCFaction()
	faction = _R.NPCFaction.SLVGetFaction(faction)
	for _,ent in ipairs(ents.GetAll()) do
		if((ent:IsNPC() || ent:IsPlayer()) && ent != self) then
			local rel = gamemode.Call("SetupRelationship",self,ent)
			if(rel != true) then
				if(!self:ApplyCustomEntityDisposition(ent) && !self:ApplyCustomClassDisposition(ent) && !self:ApplyCustomFactionDisposition(ent)) then
					if(ent:IsPlayer() || ((!ent.ApplyCustomEntityDisposition || !ent:ApplyCustomEntityDisposition(self)) && (!ent.ApplyCustomClassDisposition || !ent:ApplyCustomClassDisposition(self)) && (!ent.ApplyCustomFactionDisposition || !ent:ApplyCustomFactionDisposition(self)))) then
						local disp
						if(ent:IsPlayer() && ent.SLVGetFaction) then
							local factionPl = ent:SLVGetFaction()
							if(!ent:IsWearingFactionArmor()) then factionPl = FACTION_NONE end
							disp = faction:GetPlayerFactionDisposition(factionPl)
						else disp = faction:Disposition(ent) end
						self:slvAddEntityRelationship(ent,disp,100)
						if(ent:IsNPC()) then ent:slvAddEntityRelationship(self,disp,100) end
					end
				end
			end
		end
	end
end

function ENT:UpdateFactionRelationship(ent)
	if(self:ApplyCustomEntityDisposition(ent) || self:ApplyCustomClassDisposition(ent) || self:ApplyCustomFactionDisposition(ent)) then return end
	local faction = self:GetNPCFaction()
	if(faction == NPC_FACTION_NONE) then return end
	faction = _R.NPCFaction.SLVGetFaction(faction)
	local disp = faction:Disposition(ent)
	self:slvAddEntityRelationship(ent,disp,100)
	if(ent:IsNPC()) then ent:slvAddEntityRelationship(self,disp,100) end
end

function ENT:SetNPCFaction(faction,class)
	self.NPCFaction = faction
	self.NPCFaction = faction
	self.NPCFaction = faction
	self.NPCFaction = faction
	self.NPCFaction = faction
	self.NPCFaction = faction
	self.NPCFaction = faction
	self.iClass = class
	self.iClass = class
	self.iClass = class
	self.iClass = class
	self.iClass = class
	self.iClass = class
	self.iClass = class
	self.iClass = class
	self.iClass = class
	-- if(!self.m_bInitialized) then return end
	-- self:UpdateFactionRelationships()
	self:SetUpEnemies(ent)
	-- local faction = self:GetNPCFaction()
	-- local otherfaction
	-- for _,ent in ipairs(ents.GetAll()) do
		-- if((ent:IsNPC() || ent:IsPlayer()) && ent != self) then
			-- if ent:IsNPC() then otherfaction = ent:GetNPCFaction() else otherfaction = FACTION_NONE end
			-- local rel = gamemode.Call("SetupRelationship",self,ent)
			-- if(rel != true) then
				-- self:AddEntityRelationship(ent,D_HT,100)
				-- if(ent:IsNPC()) then
					-- ent:AddEntityRelationship(self,D_HT,100)
				-- end
			-- end
		-- end
	-- end
end

function ENT:ApplyCustomFactionDisposition(ent)
	if(!self.m_tbFactionDisp) then return false end
	local faction
	if(ent:IsNPC()) then if(!ent.GetNPCFaction) then return false end; faction = ent:GetNPCFaction()
	elseif(!ent.SLVGetFaction) then return false
	else faction = GAMEMODE:PlayerFactionToNPCFaction(ent:SLVGetFaction()) end
	if(self.m_tbFactionDisp[faction]) then
		local disp = self.m_tbFactionDisp[faction]
		self:slvAddEntityRelationship(ent,disp,100)
		if(ent:IsNPC()) then ent:slvAddEntityRelationship(self,disp,100) end
		return true
	end
	return false
end

function ENT:ApplyCustomClassDisposition(ent)
	if(!self.m_tbFactionDisp) then return false end
	local class = ent:GetClass()
	if(!self.m_tbFactionDisp[class]) then return false end
	local disp = self.m_tbFactionDisp[class]
	self:slvAddEntityRelationship(ent,disp,100)
	if(ent:IsNPC()) then ent:slvAddEntityRelationship(self,disp,100) end
	return true
end

function ENT:ApplyCustomEntityDisposition(ent)
	if(!self.m_tbEntDisp || !self.m_tbEntDisp[ent]) then return false end
	local disp = self.m_tbEntDisp[class]
	self:slvAddEntityRelationship(ent,disp,100)
	if(ent:IsNPC()) then ent:slvAddEntityRelationship(self,disp,100) end
	return true
end

function ENT:AddFactionDisposition(faction,disp)
	self.m_tbFactionDisp = self.m_tbFactionDisp || {}
	self.m_tbFactionDisp[faction] = disp
end

function ENT:AddClassDisposition(class,disp)
	self.m_tbClassDisp = self.m_tbClassDisp || {}
	self.m_tbClassDisp[class] = disp
end

function ENT:AddEntityDisposition(ent,disp)
	self.m_tbEntDisp = self.m_tbEntDisp || {}
	self.m_tbEntDisp[ent] = disp
end