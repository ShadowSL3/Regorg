require('lib.Flipbook')
Pixelcam = require("lib.pixelcam")

function love.load(arg)
    local flipbookImg = love.graphics.newImage('assets/TEX_FB_Torch_8x8.png')
    local temp = require('lib.Flipbook')
    Quads = temp:constructFlipbook(flipbookImg, 8, 8)
    particleSystem = love.graphics.newParticleSystem(flipbookImg, 500)
    pixelfactor = 2
    cam = Pixelcam(pixelfactor)

    --PARTICLE SYSTEM CONFIGURATION
    particleSystem:setParticleLifetime(1, 2)
    particleSystem:setEmissionRate(8)
    particleSystem:setSizeVariation(1)
    particleSystem:setDirection(1.5*3.14)
    particleSystem:setSpeed(0, 200)
    particleSystem:setLinearDamping(0.33)
    particleSystem:setSpin(-0.25, 0.25)
    particleSystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    particleSystem:setQuads(Quads)
    particleSystem:setRotation(0, 2*3.14)
    particleSystem:setOffset(temp:getTileSize())
    particleSystem:setInsertMode('bottom')
end

function love.update(dt)
    particleSystem:update(dt)

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
end

function love.draw(dt)
  cam:startRecording()
    love.graphics.setBlendMode("additive")
    love.graphics.draw(particleSystem, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, 0.25, 0.25)
  cam:stopRecording()
  cam:draw()
  
  love.graphics.setColor(255, 127, 0)
  love.graphics.print("Pixelfactor: "..pixelfactor, 10, 10)
  love.graphics.print("Up/Down: change pixelfactor", 10, 20)
end

function love.keypressed(key)
  if key == "up" then
    pixelfactor = pixelfactor + 1
    cam = Pixelcam(pixelfactor)
  elseif key == "down" then
    pixelfactor = math.max(pixelfactor - 1, 1)
    cam = Pixelcam(pixelfactor)
  end
end