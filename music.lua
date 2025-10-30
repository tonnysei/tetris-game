local ww = love.graphics.getWidth()
local wh = love.graphics.getHeight()


local slider = {
    x = ww/3,
    y = wh * 0.25,
    width = ww/3,
    height = 24,
    knob_radius = 10,
    dragging = false
}

local volume = 0.5

Music = {}

function Music:load()
    -- Load the audio file as a Source
    Music.loop = love.audio.newSource("assets/tetris-loop.mp3", "stream")
    Music.effect = love.audio.newSource("assets/tetris-sound-effect.mp3", "static")

    -- Set to loop indefinitely
    Music.loop:setLooping(true)

    -- Set music volume
    Music.loop:setVolume(volume/2)

    -- Start playing the music
    love.audio.play(Music.loop)
end

function Music:update(dt)
  if  MUSIC == true then
    Music.loop:play()
  else
    Music.loop:pause()
  end

  if slider.dragging then
      local mouseX = love.mouse.getX()
      local knobX = math.max(slider.x, math.min(mouseX, slider.x + slider.width))
      volume = (knobX - slider.x) / slider.width
      Music.loop:setVolume(volume/2)
  end
end


function love.mousepressed(x, y, button)
    if button == 1 then
        local knobX = slider.x + volume * slider.width
        local dx = x - knobX
        local dy = y - slider.y - slider.height / 2
        if dx * dx + dy * dy <= slider.knob_radius^2 then
            slider.dragging = true
        end
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        slider.dragging = false
    end
end

function Music:draw()
    -- Slider bar
    love.graphics.setColor(0.6, 0.6, 0.6)
    love.graphics.rectangle("fill", slider.x, slider.y, slider.width, slider.height)

    -- Knob
    local knobX = slider.x + volume * slider.width
    local knobY = slider.y + slider.height / 2
    love.graphics.setColor(0.2, 0.2, 0.8)
    love.graphics.circle("fill", knobX, knobY, slider.knob_radius)

    -- Text
    love.graphics.setColor(1, 1, 1)
    self.font = love.graphics.newFont(42)
    love.graphics.setFont(self.font)

    love.graphics.print("Master Volume: " .. math.floor(volume * 100) .. "%", ww/3, slider.y - 80)
end