require("src.core.init")()

function love.draw()
    ui.draw()
    timeline.draw()
end

function love.update(dt)
    ui.update(dt)
    timeline.update(dt)
end
