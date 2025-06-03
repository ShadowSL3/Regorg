local milk = {}
local milkX, milkY = 640, 360
local milkSpeed = 200
local milkImage

function love.load()
    love.window.setTitle("Latte Supremo")
    love.window.setMode(1280, 720)
    milkImage = love.graphics.newImage("milk.png")
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        milkX = milkX - milkSpeed * dt
    elseif love.keyboard.isDown("right") then
        milkX = milkX + milkSpeed * dt
    end

    if love.keyboard.isDown("up") then
        milkY = milkY - milkSpeed * dt
    elseif love.keyboard.isDown("down") then
        milkY = milkY + milkSpeed * dt
    end
end

function love.draw()
    love.graphics.clear(0.9, 0.95, 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(milkImage, milkX, milkY, 0, 0.5, 0.5, milkImage:getWidth()/2, milkImage:getHeight()/2)
    love.graphics.setColor(0, 0, 0.2)
    love.graphics.print("Muovi il Latte con le frecce", 10, 10)
end