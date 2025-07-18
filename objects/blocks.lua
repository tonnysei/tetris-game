

Blocks = {}

function Blocks:load()
  self.tetrominoes = {
    {  -- T shape
      { {1, 1, 1}, {0, 1, 0} },
      { {1, 0}, {1, 1}, {1, 0} },
      { {0, 1, 0}, {1, 1, 1} },
      { {0, 1}, {1, 1}, {0, 1} }
    },

     {  -- I shape
       { {1, 1, 1, 1} },
       { {1}, {1}, {1}, {1} }
     },

    {  -- O shape
      { {1, 1}, {1, 1} }
    },

    {  -- S shape 
      { {1, 1, 0}, {0, 1, 1} },
      { {0, 1}, {1, 1}, {1, 0} }
    },

    {  -- Z shape 
      { {0, 1, 1}, {1, 1, 0} },
      { {1, 0}, {1, 1}, {0, 1} }
    },

    {  -- L shape
      { {1, 1, 1}, {1, 0, 0} },
      { {1, 1}, {0, 1}, {0, 1} },
      { {0, 0, 1}, {1, 1, 1} },
      { {1, 0}, {1, 0}, {1, 1} }
    },

    {  -- J shape
      { {1, 1, 1}, {0, 0, 1} },
      { {0, 1}, {0, 1}, {1, 1} },
      { {1, 0, 0}, {1, 1, 1} },
      { {1, 1}, {1, 0}, {1, 0} }
    }
  }

  self.colors = {
    {0.5, 0, 0.5}, -- Purple (T piece)
    {0, 1, 1}, -- Cyan (I piece)
    {1, 1, 0}, -- Yellow (O piece)
    {0, 1, 0}, -- Green (S piece)
    {1, 0, 0}, -- Red (Z piece)
    {1, 0.5, 0}, -- Orange (L piece)
    {0, 0, 1} -- Blue (J piece)
  }
  self.current = { shape = nil, x = 5, y = 1, index = nil , rotation = nil }
  self.timer = {}
  self.timer.fall = 0
  self.timer.lock = 0
  self.delay = {}
  self.delay.fall = 0.5
  self.delay.lock = 0.2
  self.isFalling = false
  self.right = false
  self.left = false
  self.down = false
  self.fallCounter = 0

  math.randomseed(os.time())
end

function Blocks:update(dt)
  if self.isFalling == false and START == true then
    self:spawn()
  end

  self.delay.fall = 0.55 - Menu.lvl * 0.025

  self:fall(dt)
  self:checkBoundaries()
end

function Blocks:spawn()
  -- choose a random block and load it 
  self.current.index = math.random(#self.tetrominoes)
  self.current.rotation = 1
  self.current.shape = self.tetrominoes[self.current.index][self.current.rotation]
  self.current.x = math.floor(Grid.width / 2) - 1
  self.current.y = 1
  self.fallCounter = 0
  self.isFalling = true

  if Grid.counter > 0 then
    Grid.currentScore = Grid.currentScore + (Grid.counter * 200 - 100) * Menu.lvl / 2
    Grid.counter = 0
  end
end

function Blocks:rotate()
  local nextRotation = self.current.rotation + 1
  if nextRotation > #self.tetrominoes[self.current.index] then
      nextRotation = 1
  end

  local newShape = self.tetrominoes[self.current.index][nextRotation]

  -- Test rotation at current position
  local canRotate = true
  for y = 1, #newShape do
      for x = 1, #newShape[1] do
          if newShape[y][x] == 1 then
              local newX = self.current.x + x - 1
              local newY = self.current.y + y - 1
              if newX < 1 or newX > Grid.width or newY > Grid.height or  Grid[newY][newX] == 1 then
                  canRotate = false
                  break
              end
          end
      end
  end

  -- If no collision, apply rotation
  if canRotate then
      self.current.rotation = nextRotation
      self.current.shape = newShape
  end
end

function Blocks:fall(dt)
  self.timer.fall = self.timer.fall  + dt
  self.down = self:checkFall()
  if self.timer.fall  > self.delay.fall and self.isFalling then
      if not self.down then
          self.current.y = self.current.y + 1
          self.fallCounter = self.fallCounter + 1
      else
          if self.timer.lock >= self.delay.lock then
              self.isFalling = false
              self.timer.lock = 0
          end
      end
      self.timer.fall = 0  -- Reset fall timer
  end

  -- Start lock delay
  if self.down then
    self.timer.lock = self.timer.lock + dt
  else
    self.timer.lock = 0;
  end
end

function love.keypressed(key)
  -- check for right movement
  if key == "right" and not Blocks.right and PAUSE == false then
    Blocks.current.x = Blocks.current.x + 1
  end
  -- check for left movement
  if key == "left" and not Blocks.left and PAUSE == false then
    Blocks.current.x = Blocks.current.x - 1
  end
  -- -- check for downward movement
  if key == "down" and not Blocks.down and PAUSE == false then
    Blocks.current.y = Blocks.current.y + 1
  end

  if key == "r" and PAUSE == false then
    Blocks:rotate()
  end

  if key == "space" and START == true then
    PAUSE = not PAUSE
  end

  if key == "escape" and START == true then
    START = false
    GameOver = true
    if Grid.currentScore > Grid.highScore then
      Grid.highScore = Grid.currentScore
      love.filesystem.write("highscore.txt", tostring(Grid.highScore))
    end
  end
end

function Blocks:checkBoundaries()
  local w = #self.current.shape[1] -- get width of the block
  local h = #self.current.shape -- get height of the block

  -- check collision with left wall
  if self.current.x < 1 then
    self.current.x = 1
  end

  -- check collision with right wall
  if self.current.x > Grid.width  - w + 1  then
    self.current.x = Grid.width  - w + 1
  end

  -- check collision with another block
  self.left = self:checkLeft()
  self.right = self:checkRight()
  --print(self.left, self.right, self.current)
end

function Blocks:checkFall()
  local w = #self.current.shape[1] -- get width of the block
  local h = #self.current.shape -- get height of the block

    -- check collision with the floor
    if self.current.y >= Grid.height - h + 1 then
      self.current.y = Grid.height - h + 1
      return true
    end

  for y = 1, h do
    for x = 1, w do
      -- check collision below the block  
      if self.current.shape[y][x] == 1 and
      Grid[self.current.y + y][self.current.x + x - 1] == 1 then
        return true -- disable falling
      end
    end
  end

  return false
end

function Blocks:checkRight()
  local w = #self.current.shape[1] -- get width of the block
  local h = #self.current.shape -- get height of the block

  for y = 1, h do
    for x = 1, w do
      -- check collision right of the block
      if self.current.shape[y][x] == 1 and
      Grid[self.current.y + y - 1][self.current.x + x] == 1 then
        return true -- disable right movement       
      end
    end
  end

  return false -- enable right movement
end

function Blocks:checkLeft()
  local w = #self.current.shape[1] -- get width of the block
  local h = #self.current.shape -- get height of the block

  for y = 1, h do
    for x = 1, w do
      -- check collision left of the block 
      if self.current.shape[y][x] == 1 and
      Grid[self.current.y + y - 1][self.current.x + x - 2] == 1 then
        return true -- disable left movement
      end
    end
  end

  return false -- enable left movement
end



function Blocks:draw(x_offset, y_offset)
  -- draw tetris block
  local color = self.colors[self.current.index]
  for y = 1, #self.current.shape do
      for x = 1, #self.current.shape[y] do
          if self.current.shape[y][x] == 1 then
            love.graphics.setColor(color[1], color[2], color[3])
              love.graphics.rectangle("fill",
                  (self.current.x + x - 2) * Grid.blockSize + x_offset,
                  (self.current.y + y - 2) * Grid.blockSize + y_offset,
                  Grid.blockSize, Grid.blockSize
              )
            love.graphics.setColor(color[1]*0.2, color[2]*0.2, color[3]*0.2)
              love.graphics.rectangle("line",
                (self.current.x + x - 2) * Grid.blockSize + x_offset,
                (self.current.y + y - 2) * Grid.blockSize + y_offset,
                Grid.blockSize, Grid.blockSize
              )
          end
          -- local num = y .. "," .. x
          -- love.graphics.print(num,
          -- (self.current.x + x - 2) * Grid.blockSize + x_offset,
          -- (self.current.y + y - 2) * Grid.blockSize + y_offset)
      end
  end
end
