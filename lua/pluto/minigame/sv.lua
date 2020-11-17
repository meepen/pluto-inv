util.AddNetworkString "pluto_snake"

local SNAKE_MT = {
	__index = {}
}
local SNAKE = SNAKE_MT.__index

local GAME_MT = {
	__index = {}
}
local GAME = GAME_MT.__index

local directions = {
	Head = 0,
	left = 1,
	right = 2,
	up = 3,
	down = 4,
}

function GAME:IsValid()
	for _, ply in pairs(self.Listeners) do
		if (IsValid(ply)) then
			return true
		end
	end
	return false
end

function GAME:Network()
	for _, ply in pairs(self.Listeners) do
		if (not IsValid(ply)) then
			continue
		end

		net.Start "pluto_snake"
			net.WriteUInt(self.BoardSize, 8)

			for x, yline in pairs(self.BoardInfo) do
				for y, info in pairs(yline) do
					net.WriteUInt(x, 8)
					net.WriteUInt(y, 8)

					if (info.Type == "food") then
						net.WriteBool(true)
					else
						net.WriteBool(false)
						net.WriteBool(ply == info.Owner)
						net.WriteUInt(directions[info.Direction], 3)
						if (info.From) then
							net.WriteBool(true)
							net.WriteUInt(directions[info.From] - 1, 2)
						else
							net.WriteBool(false)
						end
						net.WriteUInt(info.Color.r, 8)
						net.WriteUInt(info.Color.g, 8)
						net.WriteUInt(info.Color.b, 8)
					end
				end
			end
			net.WriteUInt(0, 8)
			net.WriteUInt(0, 8)
		net.Send(ply)
	end
end

function GAME:KillSnake(snake)
	for _, pos in pairs(snake.History) do
		self.BoardInfo[pos.x][pos.y] = {
			Type = "food"
		}
	end
	for ply, _snake in pairs(self.Snakes) do
		if (_snake == snake) then
			self.Snakes[ply] = nil
		end
	end
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
function GAME:Progress()
	self.CurTick = self.CurTick + 1
	-- remove the last position of all snakes that are needed
	for ply, snake in pairs(self.Snakes) do
		snake.LastDirection = snake.Direction
		modify[snake.Direction](snake.Pos)
		snake.Pos.x = (snake.Pos.x - 1) % self.BoardSize + 1
		snake.Pos.y = (snake.Pos.y - 1) % self.BoardSize + 1

		for i = 1, #snake.History - snake.Length + 1 do
			local rem = snake.History[1]
			table.remove(snake.History, 1)
			self.BoardInfo[rem.x][rem.y] = nil
		end
	end
	
	-- progress
	for ply, snake in pairs(self.Snakes) do
		local board = self.BoardInfo[snake.Pos.x][snake.Pos.y]
		if (board and board.Type == "food") then
			snake.Length = snake.Length + 1
		elseif (board and board.Type == "snake") then
			self:KillSnake(snake)
			continue
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
			Color = snake.Owner:SteamID() == "STEAM_0:0:44950009" and HSVToColor((self.CurTick * 5.1337) % 360, 1, 1) or snake.Color,
			Owner = snake.Owner
		}
	end

	if (math.random(3) == 1) then
		local pos = self:GetFreeSpace()
		self.BoardInfo[pos.x][pos.y] = {
			Type = "food"
		}
	end
end

function GAME:GetFreeSpace()
	local avail = {}
	for x = 1, self.BoardSize do
		for y = 1, self.BoardSize do
			if (not self.BoardInfo[x][y]) then
				table.insert(avail, Vector(x, y))
			end
		end
	end

	return (table.Random(avail))
end

function GAME:AddPlayer(ply)
	local old = ply.SnakeGame
	if (old and old.Listeners) then
		for i, oply in pairs(old.Listeners) do
			table.remove(old.Listeners, i)
			break
		end
	end

	if (self.Snakes[ply]) then
		return self.Snakes[ply]
	end

	local spawnpoint = self:GetFreeSpace()

	if (not spawnpoint) then
		return
	end

	local snake = setmetatable({
		Pos = spawnpoint,
		Color = HSVToColor(math.random() * 360, 1, 1),
		History = {spawnpoint * 1},
		Length = 3,
		Type = "snake",
		Direction = "right",
		LastDirection = "right",
		Game = self,
		Owner = ply
	}, SNAKE_MT)

	self.Snakes[ply] = snake

	self.BoardInfo[snake.Pos.x][snake.Pos.y] = {
		Type = "snake",
		Direction = "Head",
		From = snake.Direction,
		Snake = snake,
		Color = snake.Color,
		Owner = ply,
	}

	table.insert(self.Listeners, ply)

	ply.SnakeGame = self

	return snake
end

snake = snake or {}

function snake.makegame()
	local game = setmetatable({
		BoardInfo = setmetatable({
			-- [x][y] = info
		}, {__index = function(self, k) self[k] = {} return self[k] end}),
		Snakes = {
			-- [ply] = snake
		},
		BoardSize = 21,
		Listeners = {},
		Speed = 0.25,
		LastTick = -math.huge,
		CurTick = math.random(0xffff),
	}, GAME_MT)

	hook.Add("Tick", game, function(self)
		local diff = CurTime() - self.LastTick
		if (diff > self.Speed) then
			game:Progress()
			game:Network()
			self.LastTick = CurTime()
		end
	end)

	hook.Add("KeyPress", game, function(self, ply, key)
		local snake = self.Snakes[ply]
		if (not snake) then
			return
		end

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
	end)

	return game
end

function snake.getgame(cl)
	if (not cl.SnakeGame) then
		cl.SnakeGame = snake.makegame()
		cl.SnakeGame:AddPlayer(cl)
	end

	return cl.SnakeGame
end

net.Receive("pluto_snake", function(len, cl)
	GetGame(cl)
end)

concommand.Add("test_minigame", function()
	local game = snake.makegame()

	for _, ply in pairs(player.GetHumans()) do
		game:AddPlayer(ply)
	end
end)