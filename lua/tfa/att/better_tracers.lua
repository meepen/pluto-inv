if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Better Tracers"
ATTACHMENT.ShortName = "Tracer" --Abbreviation, 5 chars or less please
ATTACHMENT.Description = {TFA.Attachments.Colors["+"], "Better looking tracers", TFA.Attachments.Colors["-"], "CAN CAUSE LAG ON LOWER END PC" }
ATTACHMENT.Icon = "entities/better_tracers.png" --Revers to label, please give it an icon though!  This should be the path to a png, like "entities/tfa_ammo_match.png"
ATTACHMENT.WeaponTable = {
	["TracerName"] = "Thunderlord_Tracer"
		
} --put replacements for your SWEP talbe in here e.g. ["Primary"] = {}

function ATTACHMENT:CanAttach(wep)
	return true --can be overridden per-attachment
end

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end