AddCSLuaFile()

ENT.Base = "base_point"
ENT.Type = "point"

function ENT:Initialize()
	self.Modifiers = self.Modifiers or {}
	for i = 1, self:GetNumModifiers() do
		self:NetVar("String", "Modifier" .. i, self.Modifiers[i])
		self.Modifiers[i] = self["GetModifier" .. i](self)
	end

	self.Implicits = self.Implicits or {}
	for i = 1, self:GetNumImplicits() do
		self:NetVar("String", "Implicit" .. i, self.Modifiers[i])
		self.Implicits[i] = self["GetImplicit" .. i](self)
	end
end

function ENT:NetVar(type, name, default)
	self.NetVars = self.NetVars or {}
	self.NetVars[type] = self.NetVars[type] or 0

	self:NetworkVar(type, self.NetVars[type], name)

	if (default ~= nil) then
		self["Set" .. name](self, default)
	end

	self.NetVars[type] = self.NetVars[type] + 1
end

function ENT:SetupDataTables()
	self:NetVar("Int", "NumModifiers")
	self:NetVar("Int", "NumImplicits")
end

function ENT:InitializeModifiers(modifiers)
	self.Modifiers = modifiers
	self:SetNumModifiers(#modifiers)
end

function ENT:InitializeImplicits(implicits)
	self.Implicits = implicits
	self:SetNumImplicits(#implicits)
end

function ENT:GetModifierText(i)
	return self.Modifiers[i]
end

function ENT:GetModifiers()
	return self.Modifiers
end

function ENT:GetImplicitText(i)
	return self.Implicits[i]
end

function ENT:GetImplicits()
	return self.Implicits
end