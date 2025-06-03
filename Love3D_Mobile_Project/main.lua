
function love.load()
    OS = getOS()
    require("engine.init") -- carica il motore 3D base
    scene = engine.newScene()
    scene:addCube({x=0, y=0, z=0}, {r=1, g=0.5, b=0.2})
end

function love.update(dt)
    scene:update(dt)
end

function love.draw()
    scene:render()
    love.graphics.print("OS: " .. OS, 10, 10)
end

function getOS()
    local os = love.system.getOS()
    if os == "Android" or os == "iOS" then return "Mobile" else return os end
end
