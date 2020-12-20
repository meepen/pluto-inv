pluto.currency = pluto.currency or {
	byname = {},
}

pluto.currency.list = {
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
	},
	{
		InternalName = "aciddrop",
		Name = "Acidic Droplet",
		Icon = "pluto/currencies/green_droplet.png",
		Description = "Rerolls prefix modifiers on an item",
		SubDescription = "What have Yaari done to you, my children?!",
		Color = Color(11, 84, 51),
		StardustRatio = 75,
	},
	{
		InternalName = "pdrop",
		Name = "Plutonic Droplet",
		Icon = "pluto/currencies/purple_droplet.png",
		Description = "Rerolls suffix modifiers on an item",
		SubDescription = "Back when these things first were created, the military bought them straight from the man himself... paid upwards to a million for a single liter. Nowadays they are shot straight up to the skies",
		Color = Color(117, 28, 178),
		StardustRatio = 100,
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
			Mod = "coined",
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
		end
	},
	{
		InternalName = "tp",
		Name = "Refined Plutonium",
		Icon = "pluto/currencies/refined_ingot.png",
		Description = "Valuable Black Market Currency",
		SubDescription = "Once the mission was complete, it was revealed what Yaari was truly after...",
		Color = Color(0, 213, 183),
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
}

pluto.currency_mt = pluto.currency_mt or {}

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
