--[[ * This Source Code Form is subject to the terms of the Mozilla Public
     * License, v. 2.0. If a copy of the MPL was not distributed with this
     * file, You can obtain one at https://mozilla.org/MPL/2.0/. ]]
local PANEL = {}
AccessorFunc(PANEL, "TextColor", "TextColor")
function PANEL:Init()
	self.Image = self:Add "DImage"
	self.Loading = self.Image:Add "pluto_inventory_loading"
	self.Loading:Dock(FILL)
	self.Loading:SetVisible(true)
	self:SetCursor "beam"
end

function PANEL:SetMaterial(mat)
	if (not mat) then
		return
	end
	self.Image:SetMaterial(mat)
	self.Loading:SetVisible(false)
end

local urls = {}
file.CreateDir "pluto"
file.CreateDir "pluto/emojis"

local flags = "mips smooth"

local function GetURLMaterial(url)
	return Promise(function(res, rej)
		if (urls[url]) then
			return res(urls[url])
		end

		local fname = "pluto/emojis/" .. url:GetFileFromFilename() .. ".png"
		if (file.Exists(fname, "DATA")) then
			local mat = Material("../data/" .. fname, flags)
			urls[url] = mat
			return res(mat)
		end

	
		http.Fetch(url, function(body)
			file.Write(fname, body)
			local mat = Material("../data/" .. fname, flags)
			urls[url] = mat
			return res(mat)
		end, rej)
	end)
end

function PANEL:SetFromURL(url)
	GetURLMaterial(url):next(function(mat)
		if (not IsValid(self)) then
			return
		end

		self.Image:SetMaterial(mat)
		self.Loading:SetVisible(false)
	end):catch(function(err)
		ErrorNoHalt(err)
		self.Image:SetImage("icon16/image_link.png")
		self.Loading:SetVisible(false)
	end)
end

function PANEL:SetImageSize(w, h)
	self:SetWide(w)
	self.Image:SetWide(w)
	self.Image:SetTall(h)
end

function PANEL:PerformLayout()
	self.Image:Center()
	self.Loading:Center()
end

function PANEL:SetClickable(clickable)
	self.Clickable = clickable

	if (clickable) then
		self:SetMouseInputEnabled(true)
		if (clickable.Cursor) then
			self:SetCursor(clickable.Cursor)
		end
	end
end

function PANEL:OnMousePressed(m)
	if (m == MOUSE_LEFT) then
		self:DoClick()
	end
end

function PANEL:DoClick()
	local click = self.Clickable
	if (click and click.Run) then
		click.Run()
	end
end

function PANEL:Paint(w, h)
	if (self:GetFadeLength() ~= -1 and self:GetFadeSustain() ~= -1 and self.Creation + self:GetFadeSustain() < CurTime()) then
		self.Image:SetAlpha(255 * (1 - math.min(1, (CurTime() - self.Creation - self:GetFadeSustain()) / self:GetFadeLength())))
	else
		self.Image:SetAlpha(255)
	end
	if (self.Clickable) then
		local col = self:GetTextColor()
		if (self:GetFadeLength() ~= -1 and self:GetFadeSustain() ~= -1 and self.Creation + self:GetFadeSustain() < CurTime()) then
			col = ColorAlpha(col, col.a * (1 - math.min(1, (CurTime() - self.Creation - self:GetFadeSustain()) / self:GetFadeLength())))
		end

		surface.SetDrawColor(col)
		surface.DrawLine(0, h - 1, w - 1, h - 1)
	end
end

function PANEL:GetText()
	return ""
end

function PANEL:SetFade(sustain, length, reset)
	self.Fade = {
		Sustain = sustain,
		Length = length
	}
	if (reset) then
		self:ResetFade()
	end
end

function PANEL:GetFadeLength()
	return self.Fade and self.Fade.Length or -1
end

function PANEL:GetFadeSustain()
	return self.Fade and self.Fade.Sustain or -1
end

function PANEL:ResetFade()
	self.Creation = CurTime()
end

vgui.Register("pluto_image", PANEL, "EditablePanel")