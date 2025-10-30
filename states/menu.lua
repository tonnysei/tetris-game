---@diagnostic disable: deprecated


Menu = {}

Menu.buttons = {}
Menu.font = nil
Menu.params = {}
Menu.levels = {}
Menu.lvl = 1

function Menu:newButton(text, fn)
  return {
    text = text,
    fn = fn,

    now = false,
    last = false
  }
end

function Menu:load()
  self.font = love.graphics.newFont(32)
  self.font_gameover = love.graphics.newFont(48)

  table.insert(self.buttons, self:newButton("Start Game", function ()
    START = true
    Grid.currentScore = 0
  end))


  table.insert(self.buttons, self:newButton("Level: 1", function ()
    LEVELS = true
  end))

  table.insert(self.buttons, self:newButton("Settings", function ()
    PARAM = true
  end))

  table.insert(self.buttons, self:newButton("About me", function()
    love.system.openURL("file://" .. love.filesystem.getSourceBaseDirectory() .. "/TETRIS GAME/assets/cs50x-final-project.png")
  end))

  table.insert(self.buttons, self:newButton("Exit", function ()
    love.event.quit()
  end))

  table.insert(self.params, self:newButton("Music: on", function ()
    MUSIC = not MUSIC
  end))

  table.insert(self.params, self:newButton("Back", function ()
    PARAM = false
  end))

  for i=1, 15 do
    local txt = "Level " .. i
    table.insert(self.levels, self:newButton(txt, function ()
      self.lvl = i
      LEVELS = false
    end))
  end

    table.insert(self.levels, self:newButton("Back", function ()
    LEVELS = false
  end))
end

function Menu:update(dt)
  self.buttons[2].text = "Level: " .. Menu.lvl
end

function Menu:draw()
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()

  local button_width = ww / 3
  local button_height = 64

  local margin = 16
  local y_offset = 0
  local total_height = (button_height + margin) * #self.buttons

  if PARAM then
    self.buttons.last = self.buttons.now
    self.buttons.now = love.mouse.isDown(1)

    for i, param in ipairs(self.params) do
      local bx = ww/2 - button_width/2
      local by = wh/2 - total_height/2 + y_offset + 80


      local mx, my = love.mouse.getPosition()
      local hot = mx > bx and mx < bx + button_width and
      my > by and my < by + button_height


      local color = {0.4, 0.4, 0.4}
      if MUSIC == true and param.text == "Music: on" then
        color = {0, 0.4, 0}
      elseif param.text == "Music: off" then
        color = {0.4, 0, 0}
      end

      if hot then
        color = {0.8, 0.8, 0.9}
      end

      if self.buttons.now and not self.buttons.last and hot then
        param.fn()
        if param.text == "Music: off" then
          param.text = "Music: on"
        elseif param.text == "Music: on" then
          param.text = "Music: off"
        end
      end

      love.graphics.setColor(unpack(color))
      love.graphics.rectangle("fill",
      bx, by, button_width, button_height)

      local tw = self.font:getWidth(param.text)
      local th = self.font:getHeight(param.text)

      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(self.font)
      love.graphics.print(param.text,
      ww/2 - tw/2,
      by + th/2 - 5)

      y_offset = y_offset + button_height + margin
    end

  elseif LEVELS then
    self.buttons.last = self.buttons.now
    self.buttons.now = love.mouse.isDown(1)

    for i, level in ipairs(self.levels) do
      local bx = ww/2 - button_width/2
      if i % 2 == 0 then
        bx = ww/3 + button_width/2
      else
        bx = ww/3 - button_width/2 + 30
      end
      local by = wh/3 - total_height/2 + y_offset


      local mx, my = love.mouse.getPosition()
      local hot = mx > bx and mx < bx + 2*button_width / 3 and
      my > by and my < by + button_height


      local color = {0.4, 0.4, 0.4}


      if hot then
        color = {0.8, 0.8, 0.9}
      end

      if self.buttons.now and not self.buttons.last and hot then
        level.fn()
      end

      love.graphics.setColor(unpack(color))
      love.graphics.rectangle("fill",
      bx, by, 2*button_width / 3, button_height)

      local th = self.font:getHeight(level.text)

      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(self.font)

      local tempBX
      if i % 2 == 0 then
        tempBX = 3*bx /2 - button_width/2 - 30
      else
        tempBX = 3*bx /2 - 45
      end

      love.graphics.print(level.text,
      tempBX,
      by + th/2 - 5)

      if i % 2 == 0 then
        y_offset = y_offset + button_height + margin
      end
    end

  else
    self.buttons.last = self.buttons.now
    self.buttons.now = love.mouse.isDown(1)

    for i, button in ipairs(self.buttons) do
      local bx = ww/2 - button_width/2
      local by = wh/2 - total_height/2 + y_offset


      local mx, my = love.mouse.getPosition()
      local hot = mx > bx and mx < bx + button_width and
      my > by and my < by + button_height

      local color = {0.4, 0.4, 0.5}

      if hot then
        color = {0.8, 0.8, 0.9}
      end

      if self.buttons.now and not self.buttons.last and hot then
        button.fn()
      end


      love.graphics.setColor(unpack(color))
      love.graphics.rectangle("fill",
      bx, by, button_width, button_height)

      local tw = self.font:getWidth(button.text)
      local th = self.font:getHeight(button.text)

      love.graphics.setColor(0, 0, 0)
      love.graphics.setFont(self.font)
      love.graphics.print(button.text,
      ww/2 - tw/2,
      by + th/2 - 5)

      y_offset = y_offset + button_height + margin
    end
  end

  local text = "GAME OVER !!"

  love.graphics.setColor(1, 0, 0)
  love.graphics.setFont(self.font_gameover)
  local tw = self.font_gameover:getWidth(text)

  if GameOver == true and PARAM == false and LEVELS == false then
    love.graphics.print(text, ww / 2  - tw/2, wh / 8)
  end
end