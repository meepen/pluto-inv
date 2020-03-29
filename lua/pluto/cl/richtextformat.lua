local PANEL = {}

function PANEL:SetFont(f)
	self.Font = f
end

function PANEL:SetText(...)
	self.Text = {n = select("#", ...), ...}
end

function PANEL:AddText(...)
	local x = 1
	local n = select("#", ...)
	for i = self.Text.n, self.Text.n + n do
		self.Text[i] = select(x, ...)
		x = x + 1
	end
	self.Text.n = self.Text.n + n
end

function PANEL:AddClickableTextStart(func)
	self.ClickableFunction = func
	-- insert structure for clicking that is shared to panels
end
function PANEL:FinishClickableText()
	self.ClickableFunction = nil
end


function PANEL:AddFormatText(text, replacer, ...)
	local data = table.formatsplit(text, replacer)

	for _, info in ipairs(data) do
		print(info)
	end
end

vgui.Register("PlutoRichText", PANEL, "EditablePanel")

