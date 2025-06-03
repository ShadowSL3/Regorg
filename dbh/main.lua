function love.load()
    player = {x = 300, y = 300}
    rayLength = 66

    -- Ostacolo rettangolare
    wall = {x = 400, y = 250, w = 100, h = 100}
end

function love.update(dt)
    -- Aggiorna direzione raggio verso il mouse
    mouseX, mouseY = love.mouse.getPosition()
    dx = mouseX - player.x
    dy = mouseY - player.y
    dist = math.sqrt(dx*dx + dy*dy)
    dirX = dx / dist
    dirY = dy / dist
end

function love.draw()
    -- Disegna il giocatore
    love.graphics.circle("fill", player.x, player.y, 5)

    -- Disegna il muro
    love.graphics.rectangle("line", wall.x, wall.y, wall.w, wall.h)

    -- Calcola punto finale del raggio
    local endX = player.x + dirX * rayLength
    local endY = player.y + dirY * rayLength

    -- Controlla collisione con il muro (bounding box semplificata)
    if endX > wall.x and endX < wall.x + wall.w and
       endY > wall.y and endY < wall.y + wall.h then
        love.graphics.setColor(1, 0, 0) -- rosso se colpisce
    else
        love.graphics.setColor(0, 1, 0) -- verde se libero
    end

    -- Disegna il raggio
    love.graphics.line(player.x, player.y, endX, endY)
    love.graphics.setColor(1, 1, 1)
end 