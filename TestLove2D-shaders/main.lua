local number_clouds = 1 
local maxClouds = 22
local SmokeImage 
local smokeSystem
local startTime = love.timer.getTime()    
local lurker = require("lurker")
local canvas 
local crt
local crt_r

local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local cards = 1
local cardSound = love.audio.newSource("sounds/card1.ogg", "static")
local time = love.timer.getTime()

function love.load()
crt = love.graphics.newShader("crt.glsl")
sounds =  {}

smokeImage = love.graphics.newImage("smoke.png")
--crt_r = love.graphics.newShader("shaders/CRT.fs")
canvas = love.graphics.newCanvas(screenWidth, screenHeight, {type = "2d", readable = true})
-- smokeSystem:setColors(3, 3, 2, 3, 1, 1, 1, 0) -- da opaco a trasparente
sounds.mission_complete = love.audio.newSource("missionCompleted.wav", "static")

sounds.coin = love.audio.newSource("sounds/coin1.ogg", "static")
sounds.lobby_music = love.audio.newSource("sounds/music4.ogg", "stream")
jokers = love.graphics.newImage("Jokers.png")
font = love.graphics.newFont(20)
sounds.lobby_music:setPitch(0.77) 
sounds.lobby_music:setVolume(0.66)
end
local t = 0.25
local increased = false
function love.update(dt)
    lurker.update()
    sounds.lobby_music:play()
    sounds.lobby_music:setEffect("lowpass", { type = "lowpass", highgain = 0.5, volume = 1.0 })
    --sounds.lobby_music:setPitch(0.99)
    --if not increased then
    --     t = t + dt
        --if t >= 1 then
            --sounds.lobby_music:setPitch(0.36)
            --increased = true
--end
    -- smokeSystem:update(dt)

end
function love.draw()
    love.graphics.setCanvas(canvas)
    -- Set the view direction to point towards the camera
    love.graphics.draw(jokers, 25, 0)
    love.graphics.setFont(font)
    love.graphics.setCanvas()
    love.graphics.setColor({ 1, 1, 1 })
    crt:send('millis', love.timer.getTime() - startTime)
     love.graphics.print(love.timer.getFPS(), 0, 10)
     love.graphics.setShader(crt)
    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()
end

function love.touchpressed(id, x, y, dx, dy, pressure)
sounds.coin:play()
sounds.coin:setVolume(1.5)
sounds.lobby_music:setVolume(0)
love.graphics.print("Pressure", pressure, 0,0)
local touches = love.touch.getTouches()
for i, id in ipairs(touches) do
    local x, y = love.touch.getPosition(id)
    local pressure = love.touch.getPressure(id)
    -- usa x, y, pressure come ti serve
end
end