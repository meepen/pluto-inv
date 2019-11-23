pluto.currency = pluto.currency or {
	byname = {},
}

pluto.currency.list = {
	{
		InternalName = "dice",
		Name = "Reflective Die",
		Icon = "pluto/currencies/dice.png",
		Description = "Randomizes all the rolls on modifiers",
		SubDescription = "Arizor lost this die in a bet with a farmer long ago. That farmer won a bet with Yaari later, and gave him the power to create these at will",
		Color = Color(255, 208, 86),
	},
	{
		InternalName = "droplet",
		Name = "Magic Droplet",
		Icon = "pluto/currencies/droplet.png",
		Description = "Removes all modifiers and rolls new ones",
		SubDescription = "It's said this magic droplet was formed from one of Yaari's many former lovers",
		Color = Color(24, 125, 216),
	},
	{
		InternalName = "hand",
		Name = "Yaari's Taking",
		Icon = "pluto/currencies/goldenhand.png",
		Description = "Removes a random modifier and enhances the tier of another",
		SubDescription = "One of the many hands of Yaari's victims",
		Color = Color(255, 208, 86),
	},
	{
		InternalName = "tome",
		Name = "Arizor's Tome",
		Icon = "pluto/currencies/tome.png",
		Description = "Corrupts an item unpredictably",
		SubDescription = "Arizor hands these out to ruthless gunsmiths to augment their weapons and further themselves in life",
		Color = Color(142, 94, 166),
	},
	{
		InternalName = "mirror",
		Name = "Mara's Mirror",
		Icon = "pluto/currencies/brokenmirror.png",
		Description = "Creates a mirror image of an item (unmodifiable)",
		SubDescription = "Mara threw this mirror out after seeing what she had become",
		Color = Color(177, 173, 205),
	},
	{
		InternalName = "heart",
		Name = "Mara's Heart",
		Icon = "pluto/currencies/heart.png",
		Description = "Adds a random modifier",
		SubDescription = "Mara gives her heart to people who have shown compassion in their time of need",
		Color = Color(204, 43, 75),
	},
	{
		InternalName = "coin",
		Name = "Coin",
		Icon = "pluto/currencies/coin.png",
		Description = "Adds a storage tab",
		SubDescription = "$$$",
		Color = Color(254, 233, 105),
		NoTarget = true,
	},
	{
		InternalName = "crate0",
		Name = "Box",
		Icon = "pluto/currencies/crate0.png",
		Description = "Contains a model or a very rare weapon",
		SubDescription = "Who's there? It's been so long... please don't open me... I want to live...",
		NoTarget = true,
		Color = Color(240, 192, 71),
		Use = function()
			if (IsValid(pluto.opener)) then
				pluto.opener:Remove()
			end

			pluto.opener = vgui.Create "tttrw_base"

			pluto.opener:AddTab("Open Box", vgui.Create "pluto_box_open")

			pluto.opener:SetSize(640, 400)
			pluto.opener:Center()
			pluto.opener:MakePopup()
		end,
	},
}

for _, item in pairs(pluto.currency.list) do
	pluto.currency.byname[item.InternalName] = item
end

if (SERVER) then
	include "sv_currency.lua"
else
	local PANEL = {}
	function PANEL:Init()
		local main = self
		self:SetTall(310)
		self:Dock(TOP)
		self.Image = self:Add "DImage"

		self.Image:SetImage(pluto.currency.byname.crate0.Icon)

		function self.Image:PerformLayout(w, h)
			self:SetSize(self:GetParent():GetTall() - 20, self:GetParent():GetTall() - 20)
			self:Center()
		end

		self.Image.Start = RealTime()
		self.Image.Ends = RealTime() + 3

		function self.Image:Think()
			local x, y = self:GetParent():GetWide() / 2 - self:GetWide() / 2, self:GetParent():GetTall() / 2 - self:GetTall() / 2

			local pct = math.min(1, (RealTime() - self.Start) / (self.Ends - self.Start))

			self:SetPos(x + (math.random() - 0.5) * 40 * pct, y + (math.random() - 0.5) * 40 * pct)

			if (pct == 1 and not self.Sent) then
				self.Sent = true
				pluto.inv.message()
					:write("currencyuse", "crate0")
					:send()
			end
		end

		hook.Add("CrateOpenResponse", self, function(self, id)
			for _, item in pairs(pluto.buffer) do
				if (item.BufferID == id) then
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
end