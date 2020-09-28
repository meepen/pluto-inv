-- local _R = debug.getregistry()
-- local meta = {}
-- _R.NPCFaction = meta
-- local methods = {}
-- meta.__index = methods
-- function meta:__tostring()
	-- local str = "NPCFaction [" .. tostring(self.m_name) .. "]"
	-- return str
-- end
-- function methods:AddClass(class)
	-- if(table.HasValue(self.m_tbClasses,class)) then return end
	-- table.insert(self.m_tbClasses,class)
-- end
-- function methods:AddClasses(...)
	-- for _,class in ipairs({...}) do self:AddClass(class) end
-- end
-- function methods:AddEnemyFaction(faction) self:SetFactionDisposition(faction,D_HT) end
-- function methods:AddAlliedFaction(faction) self:SetFactionDisposition(faction,D_LI) end
-- function methods:AddNeutralFaction(faction) self:SetFactionDisposition(faction,D_NU) end
-- function methods:AddFearsomeFaction(faction) self:SetFactionDisposition(faction,D_FR) end
-- function methods:SetFactionDisposition(faction,disp,bDontAdd)
	-- if(!self.m_tbRelationships[disp]) then return end
	-- if(type(faction) != "number") then faction = faction:GetID() end
	-- self.m_tbRelationships[disp][faction] = true
	-- faction = _R.NPCFaction.SLVGetFaction(faction)
	-- if(!bDontAdd) then faction:SetFactionDisposition(self:GetID(),disp,true) end
-- end
-- function methods:SLVGetFactionDisposition(faction)
	-- if(type(faction) != "number") then faction = faction:GetID() end
	-- if(faction == self:GetID()) then return D_LI end
	-- local rel = self.m_tbRelationships
	-- if(rel[D_LI][faction]) then return D_LI end
	-- if(rel[D_FR][faction]) then return D_FR end
	-- if(rel[D_NU][faction]) then return D_NU end
	-- if(rel[D_HT][faction]) then return D_HT end
	-- return self:GetDefaultDisposition()
-- end
-- function methods:Disposition(class)
	-- if(type(class) != "string") then
		-- local ent = class
		-- if(ent:IsPlayer()) then
			-- local faction
			-- if(ent.SLVGetFaction) then
				-- faction = ent:SLVGetFaction()
				-- if(faction != FACTION_NONE && !ent:IsWearingFactionArmor()) then faction = FACTION_NONE end
				-- return self:SLVGetFactionDisposition(GAMEMODE:PlayerFactionToNPCFaction(faction))
			-- end
			-- return self:SLVGetFactionDisposition(NPC_FACTION_PLAYER)
		-- end
		-- if(!ent.GetNPCFaction) then return self:GetDefaultDisposition() end
		-- return self:SLVGetFactionDisposition(ent:GetNPCFaction())
	-- end
	-- if(self:HasClass(class)) then return D_LI end
	-- for disp,factions in ipairs(self:GetRelationships()) do
		-- for faction,b in pairs(factions) do
			-- faction = _R.NPCFaction.SLVGetFaction(faction)
			-- if(faction:HasClass(class)) then return disp end
		-- end
	-- end
	-- return self:GetDefaultDisposition()
-- end
-- function methods:SetDefaultDisposition(disp) self.m_dispDefault = disp end
-- function methods:GetDefaultDisposition() return self.m_dispDefault end
-- function methods:GetClasses() return self.m_tbClasses end
-- function methods:HasClass(class) return table.HasValue(self:GetClasses(),class) end
-- function methods:GetID() return self.m_ID end
-- function methods:GetRelationships() return self.m_tbRelationships end
-- function methods:IsValid() return true end
-- function methods:GetName() return self.m_name end

-- // AFTERMATH
-- function methods:SetPlayerFactionDisposition(faction,disp)
	-- self.m_tbPlayerFactions[faction] = disp
-- end
-- function methods:GetPlayerFactionDisposition(faction) return self.m_tbPlayerFactions[faction] || self:Disposition("player") end
-- hook.Add("OnFactionArmorChanged","plchangedfactionarmor",function(pl,old,new)
	-- for _,ent in ipairs(ents.GetAll()) do
		-- if(ent:IsNPC()) then
			-- ent:UpdateFactionRelationship(pl)
		-- end
	-- end
-- end)
-- //

-- local ID = -1
-- local tbFactions = {}
-- function _R.NPCFaction.Create(...)
	-- local name = ...
	-- if(_G[name]) then
		-- local ID = _G[name]
		-- for _,faction in ipairs(tbFactions) do
			-- if(faction:GetID() == ID) then
				-- faction:AddClasses(select(2,...))
				-- return faction
			-- end
		-- end
		-- MsgN("WARNING: _R.NPCFaction.Create: Tried to overwrite global var '" .. name .. "' (" .. tostring(ID) .. ")")
		-- return NULL
	-- end
	-- local t = {}
	-- t.m_ID = ID
	-- t.m_name = name
	-- t.m_tbClasses = {select(2,...)} || {}
	-- t.m_tbRelationships = {
		-- [D_LI] = {},
		-- [D_FR] = {},
		-- [D_NU] = {},
		-- [D_HT] = {}
	-- }
	-- t.m_tbPlayerFactions = {}
	-- _G[name] = ID
	-- setmetatable(t,meta)
	-- t:SetDefaultDisposition(D_HT)
	-- ID = ID +1
	-- table.insert(tbFactions,t)
	-- return t
-- end

-- function _R.NPCFaction.AddClass(faction,class)
	-- faction = _R.NPCFaction.SLVGetFaction(faction)
	-- if(!faction) then return end
	-- faction:AddClass(class)
-- end

-- function _R.NPCFaction.SLVGetFactions()
	-- return tbFactions
-- end

-- function _R.NPCFaction.SLVGetFaction(ID)
	-- for _,faction in ipairs(tbFactions) do
		-- if(faction:GetID() == ID) then return faction end
	-- end
-- end

-- function _R.NPCFaction.PrintFactions()
	-- for _,faction in ipairs(tbFactions) do
		-- MsgN(faction:GetName())
		-- for _,class in ipairs(faction:GetClasses()) do
			-- MsgN("\t" .. class)
		-- end
	-- end
-- end

-- local f = _R.NPCFaction.Create("NPC_FACTION_NONE")
-- f:SetDefaultDisposition(D_HT)
-- _R.NPCFaction.Create("NPC_FACTION_PLAYER","player")

-- local _R = debug.getregistry()
-- local meta = {}
-- _R.NPCFaction = meta
local methods = FindMetaTable("NPC")
-- meta.__index = methods
-- function meta:__tostring()
	-- local str = "NPCFaction [" .. tostring(self.m_name) .. "]"
	-- return str
-- end
function methods:AddClass(class)
	if(table.HasValue(self.m_tbClasses,class)) then return end
	table.insert(self.m_tbClasses,class)
end
function methods:AddClasses(...)
	for _,class in ipairs({...}) do self:AddClass(class) end
end
function methods:AddEnemyFaction(faction) self:SetFactionDisposition(faction,D_HT) end
function methods:AddAlliedFaction(faction) self:SetFactionDisposition(faction,D_LI) end
function methods:AddNeutralFaction(faction) self:SetFactionDisposition(faction,D_NU) end
function methods:AddFearsomeFaction(faction) self:SetFactionDisposition(faction,D_FR) end
function methods:SetFactionDisposition(faction,disp,bDontAdd)
	if(!self.m_tbRelationships[disp]) then return end
	if(type(faction) != "number") then faction = faction:GetID() end
	self.m_tbRelationships[disp][faction] = true
	faction = _R.NPCFaction.SLVGetFaction(faction)
	if(!bDontAdd) then faction:SetFactionDisposition(self:GetID(),disp,true) end
end
function methods:SLVGetFactionDisposition(faction)
	-- if(type(faction) != "number") then faction = faction:GetID() end
	-- if(faction == self:GetID()) then return D_LI end
	-- local rel = self.m_tbRelationships
	-- if(rel[D_LI][faction]) then return D_LI end
	-- if(rel[D_FR][faction]) then return D_FR end
	-- if(rel[D_NU][faction]) then return D_NU end
	-- if(rel[D_HT][faction]) then return D_HT end
	-- if self:GetNPCFaction()
	return self:GetDefaultDisposition()
end
function methods:slvDisposition(class)
	if(type(class) != "string") then
		local ent = class
		if(ent:IsPlayer()) then
			local faction
			if(ent.SLVGetFaction) then
				faction = ent:SLVGetFaction()
				if(faction != FACTION_NONE && !ent:IsWearingFactionArmor()) then faction = FACTION_NONE end
				return self:SLVGetFactionDisposition(GAMEMODE:PlayerFactionToNPCFaction(faction))
			end
			return self:SLVGetFactionDisposition(NPC_FACTION_PLAYER)
		end
		if(!ent.GetNPCFaction) then return self:GetDefaultDisposition() end
		return self:SLVGetFactionDisposition(ent:GetNPCFaction())
	end
	if(self:HasClass(class)) then return D_LI end
	for disp,factions in ipairs(self:GetRelationships()) do
		for faction,b in pairs(factions) do
			faction = _R.NPCFaction.SLVGetFaction(faction)
			if(faction:HasClass(class)) then return disp end
		end
	end
	return self:GetDefaultDisposition()
end
function methods:SetDefaultDisposition(disp) self.m_dispDefault = disp end
function methods:GetDefaultDisposition() return self.m_dispDefault end
function methods:GetClasses() return self.m_tbClasses end
function methods:HasClass(class) return table.HasValue(self:GetClasses(),class) end
function methods:slvGetID() return self.m_ID end
function methods:GetRelationships() return self.m_tbRelationships end
function methods:slvIsValid() return true end
function methods:slvGetName() return self.m_name end

// AFTERMATH
function methods:SetPlayerFactionDisposition(faction,disp)
	self.m_tbPlayerFactions[faction] = disp
end
function methods:GetPlayerFactionDisposition(faction) return self.m_tbPlayerFactions[faction] || self:Disposition("player") end
hook.Add("OnFactionArmorChanged","plchangedfactionarmor",function(pl,old,new)
	for _,ent in ipairs(ents.GetAll()) do
		if(ent:IsNPC()) then
			ent:UpdateFactionRelationship(pl)
		end
	end
end)
//

local ID = -1
local tbFactions = {}
function methods:NPCFactionCreate(...)
	local name = ...
	if(_G[name]) then
		local ID = _G[name]
		for _,faction in ipairs(tbFactions) do
			if(faction:GetID() == ID) then
				faction:AddClasses(select(2,...))
				return faction
			end
		end
		MsgN("WARNING: _R.NPCFaction.Create: Tried to overwrite global var '" .. name .. "' (" .. tostring(ID) .. ")")
		return NULL
	end
	local t = {}
	t.m_ID = ID
	t.m_name = name
	t.m_tbClasses = {select(2,...)} || {}
	t.m_tbRelationships = {
		[D_LI] = {},
		[D_FR] = {},
		[D_NU] = {},
		[D_HT] = {}
	}
	t.m_tbPlayerFactions = {}
	_G[name] = ID
	setmetatable(t,meta)
	t:SetDefaultDisposition(D_HT)
	ID = ID +1
	table.insert(tbFactions,t)
	return t
end

function methods:NPCFactionAddClass(faction,class)
	faction = _R.NPCFaction.SLVGetFaction(faction)
	if(!faction) then return end
	faction:AddClass(class)
end

function methods:NPCFactionSLVGetFactions()
	return tbFactions
end

function methods:NPCFactionSLVGetFaction(ID)
	for _,faction in ipairs(tbFactions) do
		if(faction:GetID() == ID) then return faction end
	end
end

function methods:NPCFactionPrintFactions()
	for _,faction in ipairs(tbFactions) do
		MsgN(faction:GetName())
		for _,class in ipairs(faction:GetClasses()) do
			MsgN("\t" .. class)
		end
	end
end

-- methods:NPCFactionCreate("NPC_FACTION_PLAYER","player")