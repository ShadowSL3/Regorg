local shaderCode = love.filesystem.read("flash.glsl")
local shader = love.graphics.newShader(shaderCode)

local flashSound
local flashPos = { x = 0.5, y = 0.5 }
local flashAlpha = 0
local flashDuration = 0.2
local flashTimer = 0

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    flashSound = love.audio.newSource("flash.wav", "static")
end

function triggerFlash(x, y)
    flashPos.x = x / love.graphics.getWidth()
    flashPos.y = y / love.graphics.getHeight()
    flashAlpha = 1
    flashTimer = flashDuration
    flashSound:stop()
    flashSound:play()
end

function love.mousepressed(x, y)
    triggerFlash(x, y)
end

function love.touchpressed(id, x, y)
    triggerFlash(x, y)
end

function love.update(dt)
    if flashTimer > 0 then
        flashTimer = flashTimer - dt
        flashAlpha = flashTimer / flashDuration
    end
end

function love.draw()
    shader:send("flashPos", { flashPos.x, flashPos.y })
    shader:send("alpha", flashAlpha)

    love.graphics.setBlendMode("add")
    love.graphics.setShader(shader)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()
    love.graphics.setBlendMode("alpha")
end