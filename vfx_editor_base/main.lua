
function love.load()
    love.window.setMode(720, 1280, {resizable=false})
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    touches = {}
    particles = {}

    particleImage = love.graphics.newImage("spark.png")
    local ps = love.graphics.newParticleSystem(particleImage, 100)
    ps:setParticleLifetime(0.5, 1)
    ps:setEmissionRate(20)
    ps:setSizeVariation(1)
    ps:setLinearAcceleration(-20, -20, 20, 20)
    ps:setColors(1, 1, 0.5, 1, 1, 0.5, 0, 0)
    ps:setSpeed(100, 200)
    particleSystem = ps
end

function love.update(dt)
    particleSystem:update(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("VFX Preview", 10, 10)
    love.graphics.draw(particleSystem, 360, 300)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    touches[id] = {x=x, y=y}
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    touches[id] = nil
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    touches[id] = {x=x, y=y}
end
