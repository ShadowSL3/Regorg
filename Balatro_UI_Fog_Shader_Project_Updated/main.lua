local ui = require("ui")
local startTime = 0

function love.load()
    love.window.setMode(720, 1280, {resizable = true})
end

function love.update(dt)
    startTime = startTime + dt
end

function love.mousepressed(x, y, b, istouch)
    if b == 1 or istouch then
        ui.updateCheckboxes(x, y)
    end
end

function love.draw()
    ui.drawShaderSettings()
end