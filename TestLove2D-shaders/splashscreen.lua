-- splashscreen.lua
local splash = {}
local timer = 0
local duration = 3
local logo

function splash.load()
    logo = love.graphics.newImage("balatro.png")
end

function splash.update(dt)
    timer = timer + dt
    if timer >= duration then
        return "mainmenu" -- passaggio alla scena successiva
    end
end
function splash.draw()
    love.graphics.clear(0.1, 0.1, 0.1)
    local w, h = love.graphics.getDimensions()
    love.graphics.draw(logo, w/2 - logo:getWidth()/2, h/2 - logo:getHeight()/2)
end

return splash

