pluto.currency = pluto.currency or {}
pluto.currency.byname = pluto.currency.byname or {}

local list = {
	{
		InternalName = "droplet",
		Name = "Magic Droplet",
		Icon = "pluto/currencies/droplet.png",
		Description = "Removes all modifiers and rolls new ones",
		SubDescription = "It's said this magic droplet was formed from one of Yaari's many former lovers",
		Color = Color(24, 125, 216),
		Crafted = {
			Chance = 1 / 4,
			Mod = "dropletted",
		},
		StardustRatio = 2,

		Category = "Modify",
		AllowMass = true,
	},
	{
		InternalName = "aciddrop",
		Name = "Acidic Droplet",
		Icon = "pluto/currencies/green_droplet.png",
		Description = "Rerolls prefix modifiers on an item",
		SubDescription = "What have Yaari done to you, my children?!",
		Color = Color(11, 84, 51),
		StardustRatio = 75,

		Category = "Modify",
		AllowMass = true,
	},
	{
		InternalName = "pdrop",
		Name = "Plutonic Droplet",
		Icon = "pluto/currencies/purple_droplet.png",
		Description = "Rerolls suffix modifiers on an item",
		SubDescription = "Back when these things first were created, the military bought them straight from the man himself... paid upwards to a million for a single liter. Nowadays they are shot straight up to the skies",
		Color = Color(117, 28, 178),
		StardustRatio = 100,

		Category = "Modify",
		AllowMass = true,
	},
	{
		InternalName = "hand",
		Name = "Yaari's Taking",
		Icon = "pluto/currencies/goldenhand.png",
		Description = "Removes a random modifier and enhances the tier of another",
		SubDescription = "One of the many hands of Yaari's victims",
		Color = Color(255, 208, 86),
		Crafted = {
			Chance = 1 / 4,
			Mod = "handed",
		},
		StardustRatio = 5,

		Category = "Modify",
	},
	{
		InternalName = "dice",
		Name = "Reflective Die",
		Icon = "pluto/currencies/dice.png",
		Description = "Randomizes all the rolls on modifiers",
		SubDescription = "Arizor lost this die in a bet with a farmer long ago. That farmer won a bet with Yaari later on and gave him the power to create these at will",
		Color = Color(255, 208, 86),
		Crafted = {
			Chance = 1 / 3,
			Mod = "diced",
		},
		StardustRatio = 4,

		Category = "Modify",
	},
	{
		InternalName = "tome",
		Name = "Arizor's Tome",
		Icon = "pluto/currencies/tome.png",
		Description = "Corrupts an item unpredictably",
		SubDescription = "Arizor hands these out to ruthless gunsmiths to augment their weapons and further themselves in life",
		Color = Color(142, 94, 166),
		Crafted = {
			Chance = 1 / 5,
			Mod = "tomed",
		},
		StardustRatio = 90,

		Category = "Modify",
	},
	{
		InternalName = "endround",
		Name = "End-round Crate",
		Icon = "pluto/currencies/crate0.png",
		Description = "Contains an item",
		SubDescription = "",
		NoTarget = true,
		Color = Color(133, 92, 58),
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Box", vgui.Create "pluto_box_open" :SetCurrency "endround")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,

		Category = "Item Boxes",
	},
	{
		InternalName = "crate0",
		Name = "Blue Egg",
		Icon = "pluto/currencies/crate0_new.png",
		Description = "Contains a model or a very rare weapon",
		SubDescription = "Who's there? It's been so long... please don't open me... I want to live...",
		NoTarget = true,
		Color = Color(71, 170, 222),
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Box", vgui.Create "pluto_box_open" :SetCurrency "crate0")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		Contents = {
			model_jacket = 400,
			model_sauron = 200,
			model_odst = 100,
			model_helga = 100,
			model_wonderw = 100,
			model_plague = 70,
			model_bigboss = 70,
			model_daedric = 40,
			model_chewie = 30,
			model_lilith = 25,
			model_a2lh = {
				Rare = true,
				Shares = 15,
			},
			model_a2 = {
				Rare = true,
				Shares = 15,
			},
			model_wick2 = {
				Rare = true,
				Shares = 3,
			},
			weapon_ttt_ak47_u = {
				Rare = true,
				Tier = "unique",
				Shares = 0.5,
			},
			weapon_ttt_deagle_u = {
				Rare = true,
				Tier = "unique",
				Shares = 0.5,
			},
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "crate2",
		Name = "Orange Egg",
		Icon = "pluto/currencies/crate2.png",
		Description = "Contains a model or a very rare weapon",
		SubDescription = "Hi! I missed you!! How have you been?!",
		NoTarget = true,
		Color = Color(242, 132, 57),
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Box", vgui.Create "pluto_box_open" :SetCurrency "crate2")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		Contents = {
			weapon_ttt_chargeup = {
				Rare = true,
				Shares = 1,
			},
			weapon_tfa_cso2_m3dragon = {
				Rare = true,
				Shares = 1
			},

			model_ciri = {
				Rare = true,
				Shares = 4
			},
			model_spacesuit = {
				Rare = true,
				Shares = 4
			},
			model_zer0 = {
				Rare = true,
				Shares = 4
			},
			model_deadpool = {
				Rare = true,
				Shares = 4,
			},

			model_tachanka = {
				Rare = true,
				Shares = 12,
			},
			model_noob_saibo = {
				Rare = true,
				Shares = 12,
			},
			model_raincoat = {
				Rare = true,
				Shares = 12,
			},
			model_psycho = {
				Rare = true,
				Shares = 12,
			},

			model_tron_anon = 30,

			model_wolffe = 50,
			model_bomb_squad = 50,
			model_lieutenant = 50,
			model_clone = 50,
			model_commander = 50,
			model_general = 50,
			model_sergeant = 50,
			model_captain = 50,
			model_brown_spar = 30,
			model_white_spar = 30,
			model_teal_spart = 30,
			model_red_sparta = 30,
			model_purple_spa = 30,
			model_olive_spar = 30,
			model_cyan_spart = 30,
			model_cobalt_spa = 30,
			model_crimson_sp = 30,
			model_sage_spart = 30,
			model_master_chi = 30,
			model_blue_spart = 30,
			model_tan_sparta = 30,
			model_steel_spar = 30,
			model_orange_spa = 30,
			model_green_spar = 30,
			model_pink_spart = 30,
			model_gold_spart = 30,
			model_violet_spa = 30,
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "crate1",
		Name = "Present (2019)",
		Icon = "pluto/currencies/crate1.png",
		Description = "Contains a 2019 Holiday Item",
		SubDescription = "Is that... it couldn't be... and what is he holding?",
		NoTarget = true,
		Color = Color(188, 2, 1),
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Present", vgui.Create "pluto_box_open" :SetCurrency "crate1")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		Contents = {
			model_osrsbob = 50,
			model_puggamax = 40,
			model_warmor = 100,
			model_nigt1 = 100,
			model_nigt2 = 100,

			model_metro_female_5 = crate1_fill,
			model_metro_female_4 = crate1_fill,
			model_metro_female_3 = crate1_fill,
			model_metro_female_2 = crate1_fill,
			model_metro_female_1 = crate1_fill,

			model_metro6 = crate1_fill,
			model_metro5 = crate1_fill,
			model_metro4 = crate1_fill,
			model_metro3 = crate1_fill,
			model_metro2 = crate1_fill,
			model_metro1 = crate1_fill,

			model_metro_male_9 = crate1_fill,
			model_metro_male_8 = crate1_fill,
			model_metro_male_7 = crate1_fill,
			model_metro_male_6 = crate1_fill,
			model_metro_male_5 = crate1_fill,
			model_metro_male_4 = crate1_fill,
			model_metro_male_3 = crate1_fill,
			model_metro_male_2 = crate1_fill,
			model_metro_male_1 = crate1_fill,

			model_cayde6 = {
				Rare = true,
				Shares = 20,
			},
			model_hansolo = {
				Rare = true,
				Shares = 30,
			},
			model_tomb = {
				Rare = true,
				Shares = 20,
			},
			model_zerosamus = {
				Rare = true,
				Shares = 2,
			},
			model_weebshit = {
				Rare = true,
				Shares = 1,
			},
			model_santa = {
				Rare = true,
				Shares = 5,
			},
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "xmas2020",
		Name = "Present",
		Icon = "pluto/currencies/xmas2020.png",
		Description = "Contains a 2020 Holiday Item",
		SubDescription = "Joy to the world!",
		NoTarget = true,
		Color = Color(17, 110, 191),
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Present", vgui.Create "pluto_box_open" :SetCurrency "xmas2020")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		Contents = {
			tfa_cso_m1887xmas = {
				Shares = 0.2,
				Tier = "unique",
				Rare = true,
			},
			model_tfacso2natalie01 = {
				Shares = 1,
				Rare = true
			},
			model_kleiaorgana = {
				Shares = 1,
				Rare = true
			},
			model_xmas_imp = {
				Shares = 1,
				Rare = true
			},
			model_ghilliewinter01 = {
				Shares = 1,
				Rare = true
			},
			model_xmas_spiderman = {
				Shares = 1,
				Rare = true
			},
			tfa_cso_m95_xmas = {
				Tier = "festive",
				Shares = 20,
			},

			model_elftrooper = xmas2020_fill,
			model_santatrooper = xmas2020_fill,
			model_treetrooper = xmas2020_fill,
			model_snowmantrooper = xmas2020_fill,
			model_hannukahtrooper = xmas2020_fill,
			model_reindeertrooper = xmas2020_fill,
			model_snow7 = xmas2020_fill,
			model_snow6 = xmas2020_fill,
			model_snow5 = xmas2020_fill,
			model_snow4 = xmas2020_fill,
			model_snow3 = xmas2020_fill,
			model_snow2 = xmas2020_fill,
			model_snow1 = xmas2020_fill,
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "heart",
		Name = "Mara's Heart",
		Icon = "pluto/currencies/heart.png",
		Description = "Adds a random modifier",
		SubDescription = "Mara gives her heart to people who have shown compassion in their time of need",
		Color = Color(204, 43, 75),
		Crafted = {
			Chance = 1 / 3,
			Mod = "hearted",
		},
		StardustRatio = 250,

		Category = "Modify",
	},
	{
		InternalName = "coin",
		Name = "Coin",
		Icon = "pluto/currencies/coin.png",
		Description = "Adds a storage tab",
		SubDescription = "$$$",
		Color = Color(254, 233, 105),
		NoTarget = true,
		Crafted = {
			Chance = 0.5,
			Mod = "new_coined",
		},
		StardustRatio = 6000,
	},
	{
		InternalName = "mirror",
		Name = "Mara's Mirror",
		Icon = "pluto/currencies/brokenmirror.png",
		Description = "Creates a mirror image of an item which is unmodifiable",
		SubDescription = "Mara threw this mirror out after seeing what she had become",
		Color = Color(177, 173, 205),

		Category = "Modify",
	},
	{
		InternalName = "quill",
		Name = "Glass Quill",
		Icon = "pluto/currencies/quill.png",
		Description = "Set an item's nickname",
		SubDescription = "This glass quill was used by the inscribers to write history before it was even made. What will you do with it?",
		Color = Color(23, 127, 105),
		StardustRatio = 9000,
		ClientsideUse = function(item)
			if (item.Nickname) then
				chat.AddText(white_text, "You must remove that item's name before naming it again!")
				return
			end

			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			local cat = vgui.Create "ttt_settings_category"
			local text = cat:AddTextEntry("What will this item's new name be?", true)
			local seent = cat:AddTextEntry("This will be seen as")
			local accept = cat:AddLabelButton "Rename!"
			cat:InvalidateLayout(true)
			cat:SizeToContents()

			function text:OnChange()
				seent:SetText('"' .. string.formatsafe(self:GetText(), item:GetDefaultName()) .. '"')
			end

			function text:AllowInput(c)
				if (self:GetText():len() + c:len() > 32) then
					return true
				end
			end

			function accept:DoClick()
				if (IsValid(pluto.opener)) then
					pluto.opener:Remove()
				end

				pluto.inv.message()
					:write("rename", item.ID, text:GetText())
					:send()
			end


			pluto.opener:AddTab("Rename!", cat)

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,

		Category = "Modify",
	},
	{
		InternalName = "tp",
		Name = "Refinium Vial",
		GroundData = {
			Icon = "pluto/currencies/refined_ingot.png",
			Amount = 25,
		},
		Icon = "pluto/currencies/plutonicvial.png",
		Description = "Valuable Black Market Currency",
		SubDescription = "Once the mission was complete, it was revealed what Yaari was truly after...",
		Color = Color(150, 50, 213),
	},
	{
		InternalName = "brainegg",
		Name = "Brain Egg",
		Icon = "pluto/currencies/brainegg.png",
		Description = "Contains a Halloween 2020 Item",
		SubDescription = "Brraaaaiiinsss...",
		Color = Color(0x92, 0xd4, 0x00),
		NoTarget = true,
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Brain Egg", vgui.Create "pluto_box_open" :SetCurrency "brainegg")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		Contents = {
			--model_ghostface = 1,
			tfa_cso_tbarrel = {
				Rare = true,
				Shares = 0.5,
			},
			tfa_cso_tomahawk = {
				Rare = true,
				Shares = 0.6,
			},
			tfa_cso_thanatos9 = {
				Rare = true,
				Shares = 0.7,
			},

			model_jason_unmask = {
				Rare = true,
				Shares = 1,
			},
			model_joker_2019 = {
				Rare = true,
				Shares = 1,
			},
			model_terminator = {
				Rare = true,
				Shares = 2,
			},

			model_richtofen        = {
				Rare = true,
				Shares = 5,
			},
			model_dempsey          = {
				Rare = true,
				Shares = 5,
			},
			model_nikolai          = {
				Rare = true,
				Shares = 5,
			},
			model_takeo            = {
				Rare = true,
				Shares = 5,
			},
			model_ghostfacereddevi = {
				Rare = true,
				Shares = 5,
			},

			model_darkwraith       = 6,
			model_jason            = 7,
			model_husk             = 7,
			model_scarecrow        = 8,
			model_ghostfacetheghos = 9,
			model_death            = 11,

			model_ghostfaceclassic = 12,
			model_blackmask        = 14,
			model_death_paint      = 15,
			model_ghost_rider      = 16,
			model_death_class      = 17,

			--[[
			model_markus_1 = 1,
			model_markus_3 = 1,
			model_markus_2 = 1,
			model_detr_connor = 1,]]
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "crate3",
		Name = "Consumed Pink Egg",
		Icon = "pluto/currencies/crate3.png",
		Description = "Contains a Easter Unique",
		SubDescription = "...they are torturing me in here",
		Color = Color(235, 70, 150, 255),
		NoTarget = true,
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Pink Egg", vgui.Create "pluto_box_open" :SetCurrency "crate3")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		DefaultTier = "easter_unique",
		Contents = {
			tfa_cso_serpent_blade = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_dreadnova = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_ruyi = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_mp7unicorn = {
				Rare = true,
				Shares = 1
			},
			tfa_cso_pchan = {
				Rare = true,
				Shares = 1
			}
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "crate3_n",
		Name = "Pink Egg",
		Icon = "pluto/currencies/crate3_norm.png",
		Description = "Contains an Easter Item",
		SubDescription = "hi! :)",
		Color = Color(235, 70, 150, 255),
		NoTarget = true,
		ClientsideUse = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Pink Egg", vgui.Create "pluto_box_open" :SetCurrency "crate3_n")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
		Contents = {
			-- consumed versions
			tfa_cso_serpent_blade = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_dreadnova = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_ruyi = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_mp7unicorn = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_pchan = {
				Tier = "easter_unique",
				Rare = true,
				Shares = 1
			},
			tfa_cso_ethereal = {
				Rare = true,
				Shares = 0--.1,
			},

			tfa_cso_m82 = {
				Tier = "unusual",
				Shares = 150
			},

			tfa_cso_charger5 = {
				Tier = "unusual",
				Shares = 150,
			},
			tfa_cso_m95 = {
				Tier = "unusual",
				Shares = 150,
			},
			tfa_cso_darkknight_v6 = {
				Rare = true,
				Tier = "easter_unique",
				Shares = 0.1,
			},
		},

		Category = "Item Boxes",
	},
	{
		InternalName = "eye",
		Name = "Eye",
		Icon = "pluto/currencies/eye.png",
		Description = "Spawns a Void boss",
		SubDescription = "I see the void envelop you, friend... embrace me.",
		Color = Color(107, 25, 14),
	},
	{
		InternalName = "stardust",
		Name = "Stardust",
		Icon = "pluto/currencies/stardust.png",
		Description = "Currency in the God's Market",
		SubDescription = "Dust from a star far away.",
		Color = Color(254, 233, 105),
		NoTarget = true,
		ClientsideUse = function()
		end,
	},
	{
		InternalName = "potato",
		Shares = 0,
		Name = "Developer Bag",
		Icon = "pluto/currencies/potatoes.png",
		Description = "Contains a developer-only model",
		SubDescription = "potato",
		Color = Color(254, 233, 105),
		ClientsideUse = function()
		end,
		Think = function(self)
			local speed = 4
			local col = HSVToColor(((CurTime() % speed) / speed) * 360, 1, 1)
			self.Color.r, self.Color.g, self.Color.b = col.r, col.g, col.b
		end,
		NoTarget = true,
		Category = "Item Boxes",
		Contents = {
			model_2b = 1,
			model_academy_ahri = 1,
			model_leet_low = 1,
			model_arctic_low = 1,
			model_guerilla_l = 1,
			model_maya = 1,
			model_kat_2 = 1,
			model_doomguy = 1,
			model_low_croft_lo_robe_anim = 1,
			model_lara_croft_lo_anim = 1,
		},
		Types = "None",
	},
	{
		InternalName = "_shootingstar",
		Name = "Shooting Star",
		Icon = "pluto/currencies/stardust.png",
		Color = Color(254, 233, 105),
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_lightsaber",
		Name = "FAKE: Lightsaber",
		Icon = "lightsaber/lightsaber_killicon.png",
		Color = color_white,
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_banna",
		Name = "Banna",
		Icon = "pluto/currencies/banna.png",
		Color = Color(204, 180, 0),
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_toy_blue",
		Name = "Blue Toy",
		Icon = "pluto/currencies/toy_blue.png",
		Color = Color(0, 0, 255),
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_toy_green",
		Name = "Green Toy",
		Icon = "pluto/currencies/toy_green.png",
		Color = Color(0, 255, 0),
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_toy_red",
		Name = "Red Toy",
		Icon = "pluto/currencies/toy_red.png",
		Color = Color(255, 0, 0),
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_toy_yellow",
		Name = "Yellow Toy",
		Icon = "pluto/currencies/toy_yellow.png",
		Color = Color(255, 255, 0),
		Fake = true,
		SkipNotify = true
	},
	{
		InternalName = "_chancedice",
		Name = "Chance Dice",
		Icon = "pluto/currencies/chancedice.png",
		Color = Color(255, 208, 86),
		Fake = true,
		SkipNotify = true
	},
	{
		Shares = 0,
		InternalName = "_emojibag",
		Name = "Random Emoji",
		Icon = "pluto/emoji/b1.png",
		Color = Color(192, 191, 190),
		SkipNotify = true,
		Fake = true,
		NoTarget = true,
		Category = "Item Boxes",
	},
}

hook.Add("Think", "pluto_currency_think", function()
	for _, cur in pairs(pluto.currency.byname) do
		if (cur.Think) then
			cur:Think()
		end
	end
end)

pluto.currency.list = {}
for _, mod in ipairs(list) do
	local old = pluto.currency.byname[mod.InternalName]
	if (old) then
		mod, old = old, mod
		table.Merge(mod, old)
	end

	table.insert(pluto.currency.list, mod)
end

pluto.currency_mt = pluto.currency_mt or {}
local CUR = pluto.currency_mt.__index or {}
pluto.currency_mt.__index = CUR
function pluto.currency_mt:__tostring()
	return self:GetPrintName()
end

CUR.Type = "Currency"

function CUR:GetMaterial()
	if (not self.Material) then
		self.Material = Material(self.Icon, "noclamp")
	end

	return self.Material
end

function CUR:AllowedUse(wpn)
	if (wpn and wpn.Locked) then
		return false
	end


	local type = wpn and wpn.Type or "None"
	if (isstring(self.Types)) then
		return self.Types == type
	end

	if (istable(self.Types) and table.HasValue(self.Types, type)) then
		return true
	end

	return false
end

function CUR:Use(ply, item)
	assert(SERVER)

	if (self:Run(item)) then
		return self:Save(ply, item)
	end

	return Promise(function(res, rej) return res() end)
end

function CUR:Save(ply, item, used)
	assert(SERVER)

	ply = pluto.db.steamid64(ply)
	return Promise(function(res, rej)
		item.LastUpdate = (item.LastUpdate or 0) + 1

		pluto.db.transact(function(db)
			pluto.weapons.update(db, item)
			if (pluto.inv.addcurrency(db, ply, self.InternalName, used and -used or -1)) then
				mysql_commit(db)
				res(item)
			else
				mysql_rollback(db)
				rej()
			end
		end)
	end)
end

function CUR:GetColor()
	if (self.Think) then
		self:Think()
	end

	return self.Color
end

function CUR:GetPrintName()
	return self.Name
end

function pluto.iscurrency(t)
	return debug.getmetatable(t) == pluto.currency_mt
end

pluto.currency_mt.__colorprint = function(self)
	return {self.Color, self.Name}
end

for _, item in pairs(pluto.currency.list) do
	if (SERVER) then
		resource.AddFile("materials/" .. item.Icon)
	end
	setmetatable(item, pluto.currency_mt)
	pluto.currency.byname[item.InternalName] = item
end

if (not CLIENT) then
	return
end

local PANEL = {}
function PANEL:SetCurrency(cur)
	self.Image:SetImage(pluto.currency.byname[cur].Icon)

	self.Currency = cur

	return self
end

function PANEL:Init()
	local main = self
	self:SetTall(310)
	self:Dock(TOP)
	self.Image = self:Add "DImage"

	function self.Image:PerformLayout(w, h)
		self:SetSize(self:GetParent():GetTall() - 20, self:GetParent():GetTall() - 20)
		self:Center()
	end

	self.Image.Start = RealTime()
	self.Image.Ends = RealTime() + (3 / GetConVar("pluto_open_speed"):GetFloat())

	local s = self
	function self.Image:Think()
		local x, y = self:GetParent():GetWide() / 2 - self:GetWide() / 2, self:GetParent():GetTall() / 2 - self:GetTall() / 2

		local pct = math.min(1, (RealTime() - self.Start) / (self.Ends - self.Start))

		self:SetPos(x + (math.random() - 0.5) * 40 * pct, y + (math.random() - 0.5) * 40 * pct)

		if (pct == 1 and not self.Sent) then
			self.Sent = true
			pluto.inv.message()
				:write("currencyuse", s.Currency)
				:send()
		end
	end

	hook.Add("CrateOpenResponse", self, function(self, id)
		for _, item in pairs(pluto.buffer) do
			if (item.ID == id) then
				self.Image:Remove()

				if (item.Type == "Model") then
					self.Image = self:Add "PlutoPlayerModel"

					self.Image:SetPlutoModel(item.Model)
				elseif (item.Type == "Weapon") then
					self.Image = self:Add "pluto_item"

					self.Image:SetItem(item)

					function self:GetScissor() return false end
				end
				
				sound.PlayFile("sound/garrysmod/balloon_pop_cute.wav", "mono", function(s)
					if (IsValid(s)) then
						s:Play()
					end
				end)
				function self.Image:PerformLayout(w, h)
					self:SetSize(self:GetParent():GetTall() - 20, self:GetParent():GetTall() - 20)
					self:Center()
				end
			end
		end
	end)
end

vgui.Register("pluto_box_open", PANEL, "EditablePanel")

function pluto.inv.writerename(itemid, name)
	net.WriteUInt(itemid, 32)
	net.WriteString(name)
end

function pluto.inv.writeunname(itemid)
	net.WriteUInt(itemid, 32)
end
