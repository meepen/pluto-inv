SWEP.Base = "weapon_tttbase_old"
DEFINE_BASECLASS "weapon_tttbase_old"

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetVar("DamageMod", "Float", 1)
end

function SWEP:Initialize()
	BaseClass.Initialize(self)
	self.GetDamage_Old = self.GetDamage
	self.GetDamage = self.GetDamageOverride
end

function SWEP:GetDamageOverride()
	return self:GetDamageMod() * self:GetDamage_Old()
end