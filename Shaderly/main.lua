local editor = require("editor")
local shader_preview = require("shader_preview")
local menu = require("menu")

local font = love.graphics.newFont(14)
local screen_width, screen_height
local editor_width = 0.5

function love.load()
    love.graphics.setFont(font)
    screen_width, screen_height = love.graphics.getDimensions()
    editor.load()
    shader_preview.load()
    menu.load()
end

function love.update(dt)
    shader_preview.update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
    love.graphics.setColor(1, 1, 1)
    editor.draw(0, 50, screen_width * editor_width, screen_height - 50)
    shader_preview.draw(screen_width * editor_width, 50, screen_width * (1 - editor_width), screen_height - 50)
    menu.draw(0, 0, screen_width, 50)
end

function love.textinput(t)
    editor.textinput(t)
end

function love.keypressed(key)
    editor.keypressed(key)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    menu.touchpressed(id, x, y)
end

function love.resize(w, h)
    screen_width, screen_height = w, h
end