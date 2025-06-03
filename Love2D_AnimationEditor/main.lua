local lume = require "lume"
local anim8 = require "anim8"
local ui = require "ui"

function love.load()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    ui.load()
end

function love.update(dt)
    ui.update(dt)
end

function love.draw()
    ui.draw()
end

function love.mousepressed(x, y, button)
    ui.mousepressed(x, y, button)
end

function love.keypressed(key)
    ui.keypressed(key)
end