AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:SetupSLVFactions()
	self:SetNPCFaction(NPC_FACTION_DRAGON,CLASS_DRAGON)
end
ENT.sModel = "models/skyrim/dragonalduin.mdl"
ENT.skName = "alduin"
ENT.m_shouts = bit.bor(1,2,4,8,16,32,64)
ENT.ScaleExp = 12
ENT.ScaleLootChance = 0.01

ENT.m_tbSounds = {
	["Attack"] = "dragon_attack0[1-4].mp3",
	["AttackBite"] = "dragon_attackbite0[1-2].mp3",
	["Alert"] = "alduin/spot[1-3].wav",
	["IdleAlert"] = "alduin/alert[1-11].wav",
	["Death"] = "dragon_death0[1-2].mp3",
	["DeathAlduinA"] = "dragon_alduin_death_a.mp3",
	["DeathAlduinB"] = "dragon_alduin_death_b.mp3",
	["DeathAlduinC"] = "dragon_alduin_death_c.mp3",
	["DeathAlduinD"] = "dragon_alduin_death_d.mp3",
	["DeathAlduinE"] = "dragon_alduin_death_e.mp3",
	["Pain"] = "alduin/pain[1-3].wav",
	["PainFlight"] = "alduin/growl.wav",
	["Land"] = "dragon_land0[1-2].mp3",
	["WingFlap"] = "dragon_wingflap0[1-4].mp3",
	["FootLeft"] = "foot/dragon_foot_walkl0[1-2].mp3",
	["FootRight"] = "foot/dragon_foot_walkr0[1-2].mp3",
	["Shout1a"] = "shouts/dragonshout_alduin01_a_fus.mp3",
	["Shout1b"] = "shouts/dragonshout_alduin01_b_rodah.mp3",
	["Shout2a"] = "shouts/dragonshout_alduin02_a_faas.mp3",
	["Shout2b"] = "shouts/dragonshout_alduin02_b_rumaar.mp3",
	["Shout4a"] = "shouts/dragonshout_alduin03_a_iiz.mp3",
	["Shout4b"] = "shouts/dragonshout_alduin03_b_slennus.mp3",
	["Shout8a"] = "shouts/dragonshout_alduin04_a_zun.mp3",
	["Shout8b"] = "shouts/dragonshout_alduin04_b_haalvik.mp3",
	["Shout16a"] = "shouts/dragonshout_alduin05_a_yol.mp3",
	["Shout16b"] = "shouts/dragonshout_alduin05_b_torshul.mp3"
}

-- local tbShouts = {
	-- ["Shout1a"] = "shouts/dragonshout_alduin01_a_fus.mp3",
	-- ["Shout1b"] = "shouts/dragonshout_alduin01_b_rodah.mp3",
	-- ["Shout2a"] = "shouts/dragonshout_alduin02_a_faas.mp3",
	-- ["Shout2b"] = "shouts/dragonshout_alduin02_b_rumaar.mp3",
	-- ["Shout4a"] = "shouts/dragonshout_alduin03_a_iiz.mp3",
	-- ["Shout4b"] = "shouts/dragonshout_alduin03_b_slennus.mp3",
	-- ["Shout8a"] = "shouts/dragonshout_alduin04_a_zun.mp3",
	-- ["Shout8b"] = "shouts/dragonshout_alduin04_b_haalvik.mp3",
	-- ["Shout16a"] = "shouts/dragonshout_alduin05_a_yol.mp3",
	-- ["Shout16b"] = "shouts/dragonshout_alduin05_b_torshul.mp3"
-- }

ENT.fSoundVolume = 105

function ENT:PlayIdle()
	self:slvPlaySound((!self:GetSoundEvents()["IdleAlert"] || self:GetState() == NPC_STATE_IDLE) && "Idle" || "IdleAlert")
end

function ENT:SelectDeathActivity() return ACT_DIEVIOLENT end
-- function ENT:SubInit()
	-- table.Merge(self.m_tbSounds,tbShouts)
-- end