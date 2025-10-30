

Grid = {}

function Grid:load()
  self.blockSize = 50
  self.width = 10
  self.height = 12
  self.currentScore = 0
  self.highScore = 0
  self.counter = 0

  self:generate()

  if love.filesystem.getInfo("highscore.txt") then
    local contents = love.filesystem.read("highscore.txt")
    self.highScore = tonumber(contents) or 0
  else
    self.highScore = 0
  end
end

function Grid:generate()
  love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

  for y = 1, self.height do
    self[y] = {}
    for x = 1, self.width do
      self[y][x] = 0
    end
  end

  Blocks:spawn()
end

function Grid:update(dt)
  if START == false then
    self:generate()
  end

  if Blocks.isFalling == false then
    for y = 1,
     #Blocks.current.shape
     do
      for x = 1,
       #Blocks.current.shape[y]
       do
        if  Blocks.current.shape[y][x] == 1 then
          self[Blocks.current.y + y - 1][Blocks.current.x + x - 1] = 1
        end
      end
    end
  end

  self:score()

  if Blocks.fallCounter == 0 and Blocks.isFalling == false then
    START = false
    GameOver = true
    if self.currentScore > self.highScore then
      self.highScore = self.currentScore
      love.filesystem.write("highscore.txt", tostring(self.highScore))
    end
  end
end

function Grid:score()
  for y = 1, self.height do
    if self:sum(self[y]) == self.width then
      table.remove(self, y)
      table.insert(self, 1, self:emptyRow())
      if MUSIC == true then
        Music.effect:play()
      end

      self.counter = self.counter + 1
    end
  end
end

function Grid:sum(t)
  local sum = 0
  for k,v in pairs(t) do
      sum = sum + v
  end

  return sum
end

function Grid:emptyRow()
  local t = {}
  for x = 1, self.width do
    t[x] = 0
  end

  return t
end

function Grid:draw(x_offset, y_offset)
  self.font = love.graphics.newFont(4)
  for y = 1, self.height do
    for x = 1, self.width do
        if self[y][x] == 0 then
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("line",
            (x - 1) * self.blockSize + x_offset,
            (y - 1) * self.blockSize + y_offset,
            self.blockSize, self.blockSize)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill",
            (x - 1) * self.blockSize + x_offset,
            (y - 1) * self.blockSize + y_offset,
            self.blockSize, self.blockSize)

            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("line",
            (x - 1) * self.blockSize + x_offset,
            (y - 1) * self.blockSize + y_offset,
            self.blockSize, self.blockSize)
        end
        -- local num = y .. "," .. x
        -- love.graphics.print(num,
        -- (x - 1) * self.blockSize + x_offset,
        -- (y - 1) * self.blockSize + y_offset)
    end
  end

  love.graphics.setColor(1, 1, 1)

  local tw = self.font:getWidth("High Score")
  love.graphics.print("High Score", 50 + tw/2, 150)
  love.graphics.print(self.highScore, 80 + tw, 220)

  tw = self.font:getWidth("Score")
  love.graphics.print("Score", 70 + tw/2, 350)
  love.graphics.print(Grid.currentScore, 100 + tw, 420)

  love.graphics.print("Level: " .. Menu.lvl, WIDTH - 280, 200)

end