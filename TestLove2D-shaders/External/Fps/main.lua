local gameSpeed = 1
local minSpeed = 0.1
local maxSpeed = 5

-- Posizione centrale
local x = 100
local y = 100
local arrowSize = 20

function love.draw()
    -- Disegna le frecce e il valore
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.printf("◄", x, y, arrowSize, "center")
    love.graphics.printf(tostring(gameSpeed), x + arrowSize, y, 50, "center")
    love.graphics.printf("►", x + arrowSize + 50, y, arrowSize, "center")
end

function love.mousepressed(mx, my, button)
    if button == 1 then
        if mx > x and mx < x + arrowSize and my > y and my < y + 30 then
            -- Click su ◄
            gameSpeed = math.max(minSpeed, gameSpeed - 0.1)
        elseif mx > x + arrowSize + 50 and mx < x + arrowSize*2 + 50 and my > y and my < y + 30 then
            -- Click su ►
            gameSpeed = math.min(maxSpeed, gameSpeed + 0.1)
        end
    end
end