local PANEL = {}

function PANEL:Init()
	self.Snake = self:Add "pluto_minigame_snake"
	self.Snake:Dock(FILL)
end

vgui.Register("pluto_inventory_other_snake", PANEL, "EditablePanel")
