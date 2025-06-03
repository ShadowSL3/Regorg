function love.load()
    love.window.setTitle("FPS Viewer")
    love.graphics.setFont(love.graphics.newFont(18))
end

function love.update(dt)
    -- FPS update handled automatically by love.timer.getFPS()
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.1)
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end
