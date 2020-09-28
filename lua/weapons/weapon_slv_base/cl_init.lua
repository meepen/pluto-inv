include('shared.lua')

SWEP.PrintName			= ""
SWEP.Slot				= 0
SWEP.SlotPos			= 10
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon   = true
SWEP.SwayScale			= 1.0
SWEP.BobScale			= 1.0

SWEP.RenderGroup 		= RENDERGROUP_OPAQUE

SWEP.WepSelectIcon		= surface.GetTextureID("weapons/swep")
SWEP.SpeechBubbleLid	= surface.GetTextureID("gui/speech_lid")

function SWEP:CustomAmmoDisplay()
	if self.Weapon.Primary.Ammo == "none" then return end
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self.Weapon:GetClip1()
	if !self.Primary.SingleClip then
		self.AmmoDisplay.PrimaryAmmo = self:GetAmmoPrimary()
	else
		self.AmmoDisplay.PrimaryAmmo = -1
	end
	//self.AmmoDisplay.PrimaryClip 	= -1
	//self.AmmoDisplay.PrimaryAmmo 	= -1
	self.AmmoDisplay.SecondaryClip = self.Weapon:GetClip2()
	self.AmmoDisplay.SecondaryAmmo = self:GetAmmoSecondary()
	return self.AmmoDisplay
end

function SWEP:PlayThirdPersonAnim(anim)
	anim = anim || PLAYER_ATTACK1
	if !game.SinglePlayer() || self.Owner:IsNPC() then self.Owner:SetAnimation(anim); return end
	GAMEMODE:DoAnimationEvent(self.Owner, PLAYERANIMEVENT_ATTACK_PRIMARY)
end

function SWEP:GetPrintName()
	return self.PrintName
end

function SWEP:DrawHUD()
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetTexture( self.WepSelectIcon )
	
	y = y + 10
	x = x + 10
	wide = wide - 20
	
	surface.DrawTexturedRect(x, y, wide, wide /2)
	
	self:PrintWeaponInfo(x +wide +20, y +tall *0.95, alpha)
end


function SWEP:PrintWeaponInfo( x, y, alpha )
end

function SWEP:FreezeMovement()
	return false
end

function SWEP:ViewModelDrawn()
	if self.CModel then
		local bValid = IsValid(self.clMdl)
		if !bValid then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self.clMdl = ClientsideModel(self.CModel)
				self.clMdl:SetPos(vm:GetPos())
				self.clMdl:SetAngles(vm:GetAngles())
				self.clMdl:AddEffects(EF_BONEMERGE)
				self.clMdl:SetNoDraw(true)
				self.clMdl:SetParent(vm)
				bValid = true
			end
		end
		if bValid then self.clMdl:DrawModel() end
	end
end

function SWEP:OnRestore()
end

function SWEP:OnRemove()
end

function SWEP:TranslateFOV(current_fov)
	return current_fov
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:DrawWorldModelTranslucent()
	self:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	return nil
end

usermessage.Hook("HLR_HUDItemPickedUp", function(um)
	if LocalPlayer() == NULL || !LocalPlayer():Alive() then return end
	um = string.Explode(",", um:ReadString())
	local itemname = um[1]
	local amount = um[2]
	if GAMEMODE.PickupHistory then
		for k, v in pairs(GAMEMODE.PickupHistory) do
			if v.name == itemname then
				v.amount = tostring(tonumber(v.amount) +amount)
				v.time = CurTime() -v.fadein
				return
			end
		end
	end
	
	local pickup = {}
	pickup.time 		= CurTime()
	pickup.name 		= itemname;
	pickup.holdtime 	= 5
	pickup.font 		= "DermaDefaultBold"
	pickup.fadein		= 0.04
	pickup.fadeout		= 0.3
	pickup.color		= Color( 180, 200, 255, 255 )
	pickup.amount		= tostring(amount)
	
	surface.SetFont(pickup.font)
	local w, h = surface.GetTextSize(pickup.name)
	pickup.height		= h
	pickup.width		= w
	
	local w, h = surface.GetTextSize(pickup.amount)
	pickup.xwidth	= w
	pickup.width = pickup.width +w +16

	if GAMEMODE.PickupHistoryLast >= pickup.time then
		pickup.time = GAMEMODE.PickupHistoryLast +0.05
	end
	
	table.insert(GAMEMODE.PickupHistory, pickup)
	GAMEMODE.PickupHistoryLast = pickup.time
end)

usermessage.Hook("HLR_SWEPDoReload", function(um)
	local wep = um:ReadEntity()
	if !IsValid(wep) || LocalPlayer():GetActiveWeapon() != wep then return end
	wep.Weapon:Reload()
end)

usermessage.Hook("slv_tpanim", function(um)
	local ent = LocalPlayer():GetActiveWeapon()
	if !IsValid(ent) || !IsValid(ent.Owner) then return end
	local anim = um:ReadShort()
	if !anim then return end
	GAMEMODE:DoAnimationEvent(ent.Owner, anim == PLAYER_RELOAD && PLAYERANIMEVENT_RELOAD || PLAYERANIMEVENT_ATTACK_PRIMARY)
end)
