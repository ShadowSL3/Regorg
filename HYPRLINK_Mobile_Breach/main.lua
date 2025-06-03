local ui = require("src.ui")
local game = require("src.game")

function love.load()
    ui.load()
    game.load()
end

function love.update(dt)
    ui.update(dt)
    game.update(dt)
end

function love.draw()
    game.draw()
    ui.draw()
end

function love.resize(w, h)
    ui.resize(w, h)
end