
local ui = require("src.ui")
local shaderManager = require("src.shader_manager")
local editor = require("src.editor")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    shaderManager.init()
    editor.init()
    ui.init()
end

function love.update(dt)
    ui.update(dt)
    editor.update(dt)
end

function love.draw()
    editor.draw()
    ui.draw()
end
