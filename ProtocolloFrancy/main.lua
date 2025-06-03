function love.load()
    scene = require("scene")
    scene:load()
end

function love.draw()
    scene:draw()
end

function love.mousepressed(x, y)
    if scene.mousepressed then
        scene:mousepressed(x, y)
    end
end

function love.touchpressed(id, x, y)
    if scene.touchpressed then
        scene:touchpressed(x, y)
    else
        love.mousepressed(x * love.graphics.getWidth(), y * love.graphics.getHeight())
    end
end