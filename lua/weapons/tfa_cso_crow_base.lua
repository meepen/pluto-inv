SWEP.Base = "tfa_gun_base"

SWEP.Author = "YuRaNnNzZZ"

SWEP.BaseAnimations = {
	["reload_fast"] = {
		
		["value"] = ACT_VM_RELOAD_END,
	},
	["reload_slow"] = {
		
		["value"] = ACT_VM_RELOAD_END_EMPTY,
	}
}

DEFINE_BASECLASS( SWEP.Base )

function SWEP:SetupDataTables(...)
	BaseClass.SetupDataTables(self, ...)

	self:NetworkVar("Bool", 29, "CrowActive")
	self:NetworkVar("Bool", 30, "CrowCheck")
	self:NetworkVar("Bool", 31, "CrowFail")
end

local sp = game.SinglePlayer()

function SWEP:Reload(bReleased, ...)
	if (CLIENT or sp) and not IsFirstTimePredicted() then return end

	if bReleased then
		if self:GetCrowCheck() then
			self:SetCrowCheck(false)
			self:SetCrowActive(true)

			return
		elseif TFA.Enum.ReloadStatus[self:GetStatus()] and not self:GetCrowFail() then
			self:SetCrowFail(true)
		end
	end

	BaseClass.Reload(self, bReleased, ...)
end

function SWEP:CrowReset()
	self:SetCrowActive(false)
	self:SetCrowCheck(false)
	self:SetCrowFail(false)
end

function SWEP:CrowEnableCheck()
	if self:GetCrowFail() then return end

	self:SetCrowCheck(true)
end

function SWEP:CrowChooseReloadAnim()
	local ct = CurTime()
	self:SetStatusEnd(ct + math.huge)

	self:PlayAnimation(self.Animations[self:GetCrowActive() and "reload_fast" or "reload_slow"])
	local endTime = CurTime() + self:GetActivityLength()

	self:SetStatus(TFA.GetStatus("reloading"))

	self:SetStatusEnd(endTime)
	self:SetNextPrimaryFire(endTime)
end

function SWEP:CrowCompleteReload()
	self:CompleteReload()
	self:SetStatus(TFA.GetStatus("reloading_wait"))
end