local timer = 60
local maxTime = 60

function love.update(dt)
    timer = math.max(0, timer - dt)
end

function love.draw()
    local w = 300
    local h = 20
    local x = 50
    local y = love.graphics.getHeight() - 50

    local percent = timer / maxTime

    -- Colore dinamico
    if percent > 0.5 then
        love.graphics.setColor(0, 1, 0) -- verde
    elseif percent > 0.2 then
        love.graphics.setColor(1, 1, 0) -- giallo
    else
        love.graphics.setColor(1, 0, 0) -- rosso
    end

    -- Barra
    love.graphics.rectangle("fill", x, y, w * percent, h)

    -- Timer testo
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("Time: %.1f", timer), x, y - 25)
end