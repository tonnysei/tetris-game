require("states/grid")
require("objects/blocks")
require("states/menu")
require("music")

START = false
GameOver = false
PAUSE = false
PARAM = false
MUSIC = true
LEVELS = false

function love.load()
  Menu:load()
  Music:load()
  Blocks:load()
  Grid:load()

  WIDTH = love.graphics.getWidth()
end

function love.update(dt)
  Menu:update(dt)
  if PAUSE == false then
    Grid:update(dt)
    Music:update(dt)
    if START == true then
      Blocks:update(dt)
    end
  end
end

function love.draw()
  local x_offset = WIDTH / 2 - Grid.width * Grid.blockSize / 2
  local y_offset = 64

  if START == true then
    Grid:draw(x_offset, y_offset)
    Blocks:draw(x_offset, y_offset)
  else
    Menu:draw()
  end

  if PARAM == true then
    Music:draw()
  end

  if PAUSE == true and START == true then
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("GAME PAUSED", WIDTH / 2 - 170, 100)
  end
end