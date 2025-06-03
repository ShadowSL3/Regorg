function love.load()
    -- Crea un'immagine bianca 8x8 per il sistema particellare
    local canvas = love.image.newImageData(8, 8)
    canvas:mapPixel(function() return 1, 1, 1, 1 end)
    local particleImage = love.graphics.newImage(canvas)

    -- Sistema particellare: scia dello shuriken
    trail = love.graphics.newParticleSystem(particleImage, 128)
    trail:setParticleLifetime(0.2, 0.5)
    trail:setSpeed(30, 60)
    trail:setSizes(1.01, 0.5, 0.2)
    trail:setSpread(math.rad(30))
    trail:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    trail:setDirection(0)
    trail:setLinearDamping(2)

    -- Parametri dello shuriken
    shuriken = {
        x = 200,
        y = 200,
        angle = 0,
        speed = 100,
        radius = 0.2
    }
end

function love.update(dt)
    -- Movimento circolare dello shuriken
    shuriken.angle = shuriken.angle + dt * 9
    shuriken.x = shuriken.x + math.cos(shuriken.angle) * shuriken.speed * dt
    shuriken.y = shuriken.y + math.sin(shuriken.angle) * shuriken.speed * dt

    -- Aggiorna la posizione del sistema particellare
    trail:setDirection(shuriken.angle + math.pi) -- scia opposta alla direzione
    trail:setPosition(shuriken.x, shuriken.y)
    trail:emit(3)

    trail:update(dt)
end

function love.draw()
    -- Disegna la scia
    love.graphics.draw(trail)

    -- Disegna lo shuriken (simbolo stilizzato)
    love.graphics.push()
    love.graphics.translate(shuriken.x, shuriken.y)
    love.graphics.rotate(shuriken.angle)
    love.graphics.setColor(1, 1, 1)
    for i = 0, 3 do
        love.graphics.rotate(math.pi / 2)
        love.graphics.polygon("fill", 0, -shuriken.radius, shuriken.radius / 2, 0, 0, shuriken.radius)
    end
    love.graphics.pop()
end