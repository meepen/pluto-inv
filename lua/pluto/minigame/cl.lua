local PANEL = {}

function PANEL:Paint(w, h)
	local boardsize = self.BoardSize
	local squaresize = math.floor(w / boardsize)
	local snakesize = squaresize * boardsize
	local xoff, yoff = (w - snakesize) / 2, (h - snakesize) / 2

	surface.SetDrawColor(255, 255, 255, 128)
	surface.DrawOutlinedRect(xoff, yoff, snakesize, snakesize)

	for x, yline in pairs(self.BoardInfo) do
		for y, info in pairs(yline) do
			surface.SetDrawColor(info.Color)
			local basex, basey = xoff + (x - 1) * squaresize, yoff + (y - 1) * squaresize 
			if (info.Type == "food") then
				for i = 0, 2 do
					surface.DrawOutlinedRect(basex + i, basey + i, squaresize - i * 2, squaresize - i * 2)
				end
			elseif (info.Type == "snake") then
				surface.DrawRect(basex + 4, basey + 4, squaresize - 8, squaresize - 8)
				if (info.Direction == "left" or info.From == "right") then
					surface.DrawRect(basex, basey + 4, 4, squaresize - 8)
				end
				if (info.Direction == "right" or info.From == "left") then
					surface.DrawRect(basex + squaresize - 4, basey + 4, 4, squaresize - 8)
				end
				
				if (info.Direction == "up" or info.From == "down") then
					surface.DrawRect(basex + 4, basey, squaresize - 8, 4)
				end
				if (info.Direction == "down" or info.From == "up") then
					surface.DrawRect(basex + 4, basey + squaresize - 4, squaresize - 8, 4)
				end
			end
		end
	end
end

function PANEL:KillSnake(snake)
	for _, pos in pairs(snake.History) do
		self.BoardInfo[pos.x][pos.y] = nil
	end
end

function PANEL:AddSnake()
	local snake = {
		Pos = Vector(1, 1),
		Color = HSVToColor(math.random() * 360, 1, 1),
		History = {Vector(1, 1)},
		Length = 3,
		Type = "snake",
		Direction = "right",
		LastDirection = "right",
	}
	self.BoardInfo[snake.Pos.x][snake.Pos.y] = {
		Type = "snake",
		Direction = "Head",
		Snake = snake,
		Color = snake.Color
	}
	return snake
end
function PANEL:AddFood()
	local food = {
		Type = "food",
		Color = HSVToColor(math.random() * 360, 1, 0.3)
	}

	local avail = {}
	for x = 1, self.BoardSize do
		for y = 1, self.BoardSize do
			if (not self.BoardInfo[x][y]) then
				table.insert(avail, Vector(x, y))
			end
		end
	end

	local selected = table.Random(avail)

	if (not selected) then
		return
	end

	food.Pos = selected

	self.BoardInfo[selected.x][selected.y] = food
end

function PANEL:Init()
	self.BoardSize = 21
	self.BoardInfo = {}

	for x = 1, self.BoardSize do
		self.BoardInfo[x] = {}
	end
	
	self.Snake = self:AddSnake()

	hook.Add("KeyPress", self, self.KeyPress)
	timer.Create("pluto_snake_game", 0.3, 0, function()
		if (not IsValid(self)) then
			return
		end

		self:Progress(self.Snake)

		if (math.random(5) == 1) then
			self:AddFood()
		end
	end)
end
function PANEL:OnRemove()
	timer.Remove "pluto_snake_game"
end

local modify = {
	up = function(pos)
		pos.y = pos.y - 1
	end,
	left = function(pos)
		pos.x = pos.x - 1
	end,
	right = function(pos)
		pos.x = pos.x + 1
	end,
	down = function(pos)
		pos.y = pos.y + 1
	end
}

function PANEL:Progress(snake)
	snake.LastDirection = snake.Direction
	modify[snake.Direction](snake.Pos)
	snake.Pos.x = (snake.Pos.x - 1) % self.BoardSize + 1
	snake.Pos.y = (snake.Pos.y - 1) % self.BoardSize + 1

	for i = 1, #snake.History - snake.Length do
		local rem = snake.History[1]
		table.remove(snake.History, 1)
		self.BoardInfo[rem.x][rem.y] = nil
	end

	local board = self.BoardInfo[snake.Pos.x][snake.Pos.y]
	if (board and board.Type == "food") then
		snake.Length = snake.Length + 1
	elseif (board and board.Type == "snake") then
		self:KillSnake(snake)
		self.Snake = self:AddSnake()
		return
	end

	local last = snake.History[#snake.History]
	if (last) then
		local info = self.BoardInfo[last.x][last.y]
		if (info) then
			info.Direction = snake.Direction
		end
	end
	table.insert(snake.History, snake.Pos * 1)
	self.BoardInfo[snake.Pos.x][snake.Pos.y] = {
		Type = "snake",
		Direction = "Head",
		From = snake.Direction,
		Snake = snake,
		Color = snake.Color
	}
end

function PANEL:KeyPress(_, key)
	if (not IsFirstTimePredicted()) then
		return
	end

	local snake = self.Snake

	if (key == IN_FORWARD) then
		if (snake.LastDirection ~= "down") then
			snake.Direction = "up"
		end
	elseif (key == IN_BACK) then
		if (snake.LastDirection ~= "up") then
			snake.Direction = "down"
		end
	elseif (key == IN_MOVELEFT) then
		if (snake.LastDirection ~= "right") then
			snake.Direction = "left"
		end
	elseif (key == IN_MOVERIGHT) then
		if (snake.LastDirection ~= "left") then
			snake.Direction = "right"
		end
	end
end

vgui.Register("pluto_minigame_snake_sp", PANEL, "EditablePanel")

local PANEL = {}

local directions = {
	[0] = "Head",
	"left",
	"right",
	"up",
	"down"
}
net.Receive("pluto_snake", function(len, cl)
	local game = {
		BoardSize = net.ReadUInt(8),
		BoardInfo = {},
	}
	for x = 1, game.BoardSize do
		game.BoardInfo[x] = {}
	end
	local max = game.BoardSize * game.BoardSize
	local x, y = net.ReadUInt(8), net.ReadUInt(8)
	while (x ~= 0) do
		local is_food = net.ReadBool()
		local obj
		if (is_food) then
			obj = {
				Type = "food",
				Color = HSVToColor((x + y * game.BoardSize) / max * 360, 1, 0.3)
			}
		else
			obj = {
				IsYou = net.ReadBool(),
				Type = "snake",
				Direction = "Head",
			}
			obj.Direction = directions[net.ReadUInt(3)]
			if (net.ReadBool()) then
				obj.From = directions[net.ReadUInt(2) + 1]
			end
			obj.Color = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
		end

		game.BoardInfo[x][y] = obj
		x, y = net.ReadUInt(8), net.ReadUInt(8)
	end
	if (IsValid(snake_mp)) then
		snake_mp.Board = game
	end
end)

function PANEL:Init()
	snake_mp = self
end

function PANEL:OnMousePressed()
	self.InputPanel = vgui.Create "EditablePanel"
	function self.InputPanel:Paint()
		if (not self.HasFocussed) then
			self:RequestFocus()
			self.HasFocussed = true
			return
		end
	end

	function self.InputPanel:OnKeyCodePressed(code)
		if (code == KEY_W) then
			net.Start "pluto_snake"
				net.WriteUInt(0, 3)
				net.WriteUInt(2, 3)
			net.SendToServer()
		elseif (code == KEY_S) then
			net.Start "pluto_snake"
				net.WriteUInt(0, 3)
				net.WriteUInt(3, 3)
			net.SendToServer()
		elseif (code == KEY_A) then
			net.Start "pluto_snake"
				net.WriteUInt(0, 3)
				net.WriteUInt(0, 3)
			net.SendToServer()
		elseif (code == KEY_D) then
			net.Start "pluto_snake"
				net.WriteUInt(0, 3)
				net.WriteUInt(1, 3)
			net.SendToServer()
		end
	end
 
	hook.Add("VGUIMousePressed", self.InputPanel, function(self, p)
		self:Remove()
	end)

	self.InputPanel:MakePopup()
	self.InputPanel:SetMouseInputEnabled(false)
end

function PANEL:Paint(w, h)
	local board = self.Board
	if (not board) then
		net.Start "pluto_snake"
			net.WriteUInt(1, 3) -- get lobbies
		net.SendToServer()
		return
	end

	local boardsize = board.BoardSize
	local squaresize = math.floor(w / boardsize)
	local snakesize = squaresize * boardsize
	local xoff, yoff = (w - snakesize) / 2, (h - snakesize) / 2

	surface.SetDrawColor(255, 255, 255, 128)
	surface.DrawOutlinedRect(xoff, yoff, snakesize, snakesize)

	for x = 1, boardsize do
		for y = 1, boardsize do
			local info = board.BoardInfo[x][y]
			if (not info) then
				continue
			end
			local basex, basey = xoff + (x - 1) * squaresize, yoff + (y - 1) * squaresize 
			if (info.Type == "food") then
				surface.SetDrawColor(info.Color)
				for i = 0, 2 do
					surface.DrawOutlinedRect(basex + i, basey + i, squaresize - i * 2, squaresize - i * 2)
				end
			elseif (info.Type == "snake") then
				if (info.IsYou) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.DrawRect(basex + 2, basey + 2, squaresize - 4, squaresize - 4)
					if (info.Direction == "left" or info.From == "right") then
						surface.DrawRect(basex, basey + 2, 2, squaresize - 4)
					end
					if (info.Direction == "right" or info.From == "left") then
						surface.DrawRect(basex + squaresize - 2, basey + 2, 2, squaresize - 4)
					end
					
					if (info.Direction == "up" or info.From == "down") then
						surface.DrawRect(basex + 2, basey, squaresize - 4, 2)
					end
					if (info.Direction == "down" or info.From == "up") then
						surface.DrawRect(basex + 2, basey + squaresize - 2, squaresize - 4, 2)
					end
				end

				surface.SetDrawColor(info.Color)
				surface.DrawRect(basex + 4, basey + 4, squaresize - 8, squaresize - 8)
				if (info.Direction == "left" or info.From == "right") then
					surface.DrawRect(basex, basey + 4, 4, squaresize - 8)
				end
				if (info.Direction == "right" or info.From == "left") then
					surface.DrawRect(basex + squaresize - 4, basey + 4, 4, squaresize - 8)
				end
				
				if (info.Direction == "up" or info.From == "down") then
					surface.DrawRect(basex + 4, basey, squaresize - 8, 4)
				end
				if (info.Direction == "down" or info.From == "up") then
					surface.DrawRect(basex + 4, basey + squaresize - 4, squaresize - 8, 4)
				end
			end
		end
	end

	if (not IsValid(self.InputPanel)) then
		surface.SetTextColor(white_text)
		surface.SetTextPos(2, 3)
		surface.SetFont "BudgetLabel"
		surface.DrawText "Click window to play!"
	end
end

function PANEL:OnRemove()
	if (IsValid(self.InputPanel)) then
		self.InputPanel:Remove()
	end
end

vgui.Register("pluto_minigame_snake", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:SetTab(tab)
end

function PANEL:Init()
	self:DockPadding(20, 16, 20, 10)
	self.Inner = self:Add "pluto_minigame_snake"
	self.Inner:Dock(FILL)
end

vgui.Register("pluto_minigame", PANEL, "pluto_inventory_base")
