if(!SLVBase_Fixed) then
	include("slvbase/slvbase.lua")
	if(!SLVBase_Fixed) then return end
end
local addon = "Skyrim"
if(SLVBase_Fixed.AddonInitialized(addon)) then return end
if(SERVER) then
	AddCSLuaFile("autorun/sky_sh_init.lua")
	AddCSLuaFile("autorun/slvbase/slvbase.lua")
	AddCSLuaFile("items/meta_inventory.lua")
	AddCSLuaFile("items/meta_item.lua")
end
include("items/meta_inventory.lua")
local items = {
	["000302CA"] = {
		value = 45,
		weight = 12,
		dmg = 8,
		name = "Ancient Nord Bow",
		class = "ai_weapon_bow_draugr",
		model = "models/skyrim/weapons/draugr/w_draugrbowskinned.mdl",
		holdType = "bow",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponbow"
	},
	["000139AD"] = {
		value = 1440,
		weight = 16,
		dmg = 17,
		name = "Ebony Bow",
		class = "ai_weapon_bow_ebony",
		model = "models/skyrim/weapons/w_ebonybowskinned.mdl",
		holdType = "bow",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponbow"
	},
	["000139A5"] = {
		value = 820,
		weight = 14,
		dmg = 15,
		name = "Glass Bow",
		class = "ai_weapon_bow_glass",
		model = "models/skyrim/weapons/w_glassbowskinned.mdl",
		holdType = "bow",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponbow"
	},
	["00038340"] = {
		value = 135,
		weight = 15,
		dmg = 12,
		name = "Falmer Bow",
		class = "ai_weapon_bow_falmer",
		model = "models/skyrim/weapons/w_falmerbow.mdl",
		holdType = "bow",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponbow"
	},
	["0001CB64"] = {
		value = 28,
		weight = 22,
		dmg = 18,
		name = "Ancient Nord Battle Axe",
		class = "ai_weapon_axe_battle_draugr",
		model = "models/skyrim/weapons/draugr/w_draugrbattleaxe.mdl",
		holdType = "2hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponback"
	},
	["0002C672"] = {
		value = 15,
		weight = 14,
		dmg = 9,
		name = "Ancient Nord War Axe",
		class = "ai_weapon_axe_war_draugr",
		model = "models/skyrim/weapons/draugr/w_draugrhandaxe.mdl",
		holdType = "1hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponaxe"
	},
	["000139AB"] = {
		value = 865,
		weight = 17,
		dmg = 15,
		name = "Ebony War Axe",
		class = "ai_weapon_axe_war_ebony",
		model = "models/skyrim/weapons/w_ebonywaraxe.mdl",
		holdType = "1hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponaxe"
	},
	["000302CD"] = {
		value = 82,
		weight = 21,
		dmg = 11,
		name = "Falmer War Axe",
		class = "ai_weapon_axe_war_falmer",
		model = "models/skyrim/weapons/w_falmerwaraxe.mdl",
		holdType = "1hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponaxe"
	},
	["0002C66F"] = {
		value = 13,
		weight = 12,
		dmg = 8,
		name = "Ancient Nord Sword",
		class = "ai_weapon_sword_draugr",
		model = "models/skyrim/weapons/draugr/w_draugrsword.mdl",
		holdType = "1hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponsword"
	},
	["000139B1"] = {
		value = 720,
		weight = 15,
		dmg = 13,
		name = "Ebony Sword",
		class = "ai_weapon_sword_ebony",
		model = "models/skyrim/weapons/w_ebonysword.mdl",
		holdType = "1hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponsword"
	},
	["0002E6D1"] = {
		value = 67,
		weight = 18,
		dmg = 10,
		name = "Falmer Sword",
		class = "ai_weapon_sword_falmer",
		model = "models/skyrim/weapons/w_falmersword.mdl",
		holdType = "1hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponsword"
	},
	["000236A5"] = {
		value = 35,
		weight = 18,
		dmg = 17,
		name = "Ancient Nord Greatsword",
		class = "ai_weapon_sword_great_draugr",
		model = "models/skyrim/weapons/draugr/w_draugrgreatsword.mdl",
		holdType = "2gs",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponback"
	},
	["000139AF"] = {
		value = 1440,
		weight = 22,
		dmg = 22,
		name = "Ebony Greatsword",
		class = "ai_weapon_sword_great_ebony",
		model = "models/skyrim/weapons/w_ebonygreatsword.mdl",
		holdType = "2gs",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponback"
	},
	["000139B2"] = {
		value = 1725,
		weight = 30,
		dmg = 25,
		name = "Ebony Warhammer",
		class = "ai_weapon_warhammer_ebony",
		model = "models/skyrim/weapons/w_ebonywarhammer.mdl",
		holdType = "2hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponback"
	},
	["000139AC"] = {
		value = 1585,
		weight = 26,
		dmg = 23,
		name = "Ebony Battleaxe",
		class = "ai_weapon_axe_battle_ebony",
		model = "models/skyrim/weapons/w_ebonybattleaxe.mdl",
		holdType = "2hm",
		itemType = ITEM_TYPE_WEAPON,
		holster = "weaponback"
	},
	["00013964"] = {
		value = 750,
		weight = 14,
		name = "Ebony Shield",
		model = "models/skyrim/armor/ebony/shield.mdl",
		shield = "heavy",
		itemType = ITEM_TYPE_SHIELD,
		armor = 32
	},
	["00012EB6"] = {
		value = 60,
		weight = 12,
		name = "Iron Shield",
		model = "models/skyrim/armor/iron/shield.mdl",
		shield = "light",
		itemType = ITEM_TYPE_SHIELD,
		armor = 20
	},
	["0001393C"] = {
		value = 450,
		weight = 6,
		name = "Glass Shield",
		model = "models/skyrim/armor/glass/shield.mdl",
		shield = "heavy",
		itemType = ITEM_TYPE_SHIELD,
		armor = 27
	},
	["0005C06C"] = {
		value = 10,
		weight = 15,
		name = "Falmer Shield",
		model = "models/skyrim/armor/falmer/shield.mdl",
		shield = "light",
		itemType = ITEM_TYPE_SHIELD,
		armor = 29
	},
	["00034182"] = {
		value = 1,
		weight = 0,
		name = "Ancient Nord Arrow",
		model = "models/skyrim/weapons/draugrarrow.mdl",
		quiver = "models/skyrim/draugrquiver.mdl",
		arrows = 7,
		itemType = ITEM_TYPE_ARROW,
		dmg = 10
	},
	["000139BB"] = {
		value = 3,
		weight = 0,
		name = "Orcish Arrow",
		model = "models/skyrim/weapons/orcisharrow.mdl",
		quiver = "models/skyrim/orcishquiver.mdl",
		arrows = 6,
		itemType = ITEM_TYPE_ARROW,
		dmg = 12
	},
	["000139BF"] = {
		value = 7,
		weight = 0,
		name = "Ebony Arrow",
		model = "models/skyrim/weapons/ebonyarrow.mdl",
		quiver = "models/skyrim/ebonyquiver.mdl",
		arrows = 7,
		itemType = ITEM_TYPE_ARROW,
		dmg = 20
	},
	["000139BE"] = {
		value = 6,
		weight = 0,
		name = "Glass Arrow",
		model = "models/skyrim/weapons/glassarrow.mdl",
		quiver = "models/skyrim/glassquiver.mdl",
		arrows = 7,
		itemType = ITEM_TYPE_ARROW,
		dmg = 18
	},
	["00038341"] = {
		value = 1,
		weight = 0,
		name = "Falmer Arrow",
		model = "models/skyrim/weapons/falmerarrow.mdl",
		quiver = "models/skyrim/falmerquiver.mdl",
		arrows = 6,
		itemType = ITEM_TYPE_ARROW,
		dmg = 7
	}
}
SLVBase_Fixed.AddDerivedAddon(addon,{tag = "Skyrim",GetItems = function() return items end})
if(SERVER) then
	Add_NPC_Class("CLASS_MUDCRAB")
	Add_NPC_Class("CLASS_ATRONACH")
	Add_NPC_Class("CLASS_DRAGON")
	Add_NPC_Class("CLASS_SPIDER_FROSTBITE")
	Add_NPC_Class("CLASS_CHAURUS")
	Add_NPC_Class("CLASS_DWARVEN")
	Add_NPC_Class("CLASS_DRAUGR")
	Add_NPC_Class("CLASS_FALMER")
	Add_NPC_Class("CLASS_GARGOYLE")
	Add_NPC_Class("CLASS_SCRIB")
end

game.AddParticles("particles/dragonflames.pcf")
game.AddParticles("particles/dragonfrost.pcf")
game.AddParticles("particles/dragonshout.pcf")
game.AddParticles("particles/frostatronach.pcf")
game.AddParticles("particles/magic01.pcf")
for _, particle in pairs({
		"dragonshout",
		"dragonshout_icestorm",
		"dragonshout_fireball",
		"dragon_fire",
		"dragon_frost"
	}) do
	PrecacheParticleSystem(particle)
end

SLVBase_Fixed.InitLua("sky_init")

local Category = "Skyrim"
SLVBase_Fixed.AddNPC(Category,"Mud Crab","npc_mudcrab")
SLVBase_Fixed.AddNPC(Category,"Legendary Mud Crab","npc_mudcrab_legendary")
SLVBase_Fixed.AddNPC(Category,"Flame Atronach","npc_atronach_flame")
SLVBase_Fixed.AddNPC(Category,"Frost Atronach","npc_atronach_frost")
SLVBase_Fixed.AddNPC(Category,"Chaurus Reaper","npc_chaurus")
SLVBase_Fixed.AddNPC(Category,"Chaurus Hunter","npc_chaurus_flyer")

SLVBase_Fixed.AddNPC(Category,"Dragon","npc_dragon")
SLVBase_Fixed.AddNPC(Category,"Alduin","npc_dragon_alduin")
SLVBase_Fixed.AddNPC(Category,"Revered Dragon 1","npc_dragon_revered",{type = 0})
SLVBase_Fixed.AddNPC(Category,"Revered Dragon 2","npc_dragon_revered",{type = 1})
SLVBase_Fixed.AddNPC(Category,"Paarthurnax","npc_dragon_paarthurnax")
SLVBase_Fixed.AddNPC(Category,"Blood Dragon","npc_dragon_blood")
SLVBase_Fixed.AddNPC(Category,"Odahviing","npc_dragon_odahviing")
SLVBase_Fixed.AddNPC(Category,"Skeletal Dragon","npc_dragon_skeleton")
SLVBase_Fixed.AddNPC(Category,"Frost Dragon","npc_dragon_frost")
SLVBase_Fixed.AddNPC(Category,"Elder Dragon","npc_dragon_elder")
SLVBase_Fixed.AddNPC(Category,"Ancient Dragon","npc_dragon_ancient")
SLVBase_Fixed.AddNPC(Category,"Large Frostbite Spider","npc_frostbitespider")
SLVBase_Fixed.AddNPC(Category,"Frostbite Spider","npc_frostbitespider_med")
SLVBase_Fixed.AddNPC(Category,"Small Frostbite Spider","npc_frostbitespider_small")

SLVBase_Fixed.AddNPC(Category,"Horse","npc_horse")
SLVBase_Fixed.AddNPC(Category,"Arvak","npc_horse_arvak")

SLVBase_Fixed.AddNPC(Category,"Dwarven Spider","npc_dwarven_spider")
SLVBase_Fixed.AddNPC(Category,"Dwarven Centurion","npc_dwarven_centurion")
SLVBase_Fixed.AddNPC(Category,"Dwarven Sphere","npc_dwarven_sphere")

SLVBase_Fixed.AddNPC(Category,"Ash Hopper","npc_scrib")

-- SLVBase_Fixed.AddNPC(Category,"Gargoyle","npc_gargoyle") // Uses my old, shitty model

// Disabled untit I change the animation code to use normal animations instead of broken gestures
-- SLVBase_Fixed.AddNPC(Category,"Draugr","npc_draugr")
-- SLVBase_Fixed.AddNPC(Category,"Restless Draugr","npc_draugr_restless")
-- SLVBase_Fixed.AddNPC(Category,"Draugr Wight","npc_draugr_wight")
-- SLVBase_Fixed.AddNPC(Category,"Draugr Scourge","npc_draugr_scourge")
-- SLVBase_Fixed.AddNPC(Category,"Draugr Overlord","npc_draugr_overlord")
-- SLVBase_Fixed.AddNPC(Category,"Draugr Deathlord","npc_draugr_deathlord")

-- SLVBase_Fixed.AddNPC(Category,"Falmer","npc_falmer")
-- SLVBase_Fixed.AddNPC(Category,"Falmer Skulker","npc_falmer_skulker")
-- SLVBase_Fixed.AddNPC(Category,"Falmer Gloomlurker","npc_falmer_gloomlurker")
-- SLVBase_Fixed.AddNPC(Category,"Falmer Nightprowler","npc_falmer_nightprowler")
-- SLVBase_Fixed.AddNPC(Category,"Falmer Shadowmaster","npc_falmer_shadowmaster")