require("menu")

function love.load()
    menu.load()
end

function love.update(dt)
    menu.update(dt)
end

function love.draw()
    menu.draw()
end

function love.mousepressed(x, y, button)
    menu.mousepressed(x, y, button)
end
