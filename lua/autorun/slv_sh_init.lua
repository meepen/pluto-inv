if(!SLVBase_Fixed) then
	include("slvbase/slvbase.lua")
	if(!SLVBase_Fixed) then return end
end
local addon = "SLVBase"
if(SLVBase_Fixed.AddonInitialized(addon)) then return end
if(SERVER) then
	AddCSLuaFile("autorun/slv_sh_init.lua")
	AddCSLuaFile("autorun/slvbase/slvbase.lua")
end
SLVBase_Fixed.AddDerivedAddon(addon,{tag = "SLVBase"})
if(SERVER) then
	Add_NPC_Class("CLASS_XENIAN")
end

SLVBase_Fixed.AddNPC("SLVBase","Ichthyosaur (HL2)","npc_icky")