local blood = {}
local tweens = {}
local function tween(duration, subject, target)
    local t = { time = 0, duration = duration, subject = subject, target = target }
    table.insert(tweens, t)
end

function spawnBlood(x, y)
    for i = 1, 30 do
        local angle = math.random() * 2 * math.pi
        local speed = math.random(100, 300)
        local dx, dy = math.cos(angle) * speed, math.sin(angle) * speed
        local particle = {
            x = x, y = y, dx = dx, dy = dy,
            life = 1.5, alpha = 1.0,
            r = 0.7, g = 0.1, b = 0.1
        }
        tween(1.5, particle, {alpha = 0.0, r = 0.4, g = 0.2, b = 0.2})
        table.insert(blood, particle)
    end
    sound:play()
end

function love.load()
    bloodShader = love.graphics.newShader("shaders/bloodsplash.glsl")
    gun = { x = 100, y = 300 }
    handL = { x = 80, y = 400 }
    handR = { x = 120, y = 400 }
    local snd = require("sounds.bloodsquirt")
    sound = snd.createSound()
end

function love.update(dt)
    for _, b in ipairs(blood) do
        b.x = b.x + b.dx * dt
        b.y = b.y + b.dy * dt
        b.life = b.life - dt
    end
    for i=#tweens,1,-1 do
        local t = tweens[i]
        t.time = t.time + dt
        local ratio = math.min(t.time / t.duration, 1)
        for k,v in pairs(t.target) do
            t.subject[k] = t.subject[k] + (v - t.subject[k]) * ratio
        end
        if ratio >= 1 then table.remove(tweens, i) end
    end
end

function love.draw()
    love.graphics.setShader(bloodShader)
    for _, b in ipairs(blood) do
        if b.life > 0 then
            bloodShader:send("alpha", b.alpha)
            love.graphics.setColor(b.r, b.g, b.b, b.alpha)
            love.graphics.circle("fill", b.x, b.y, 3)
        end
    end
    love.graphics.setShader()

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", gun.x, gun.y, 30, 10)
    love.graphics.rectangle("fill", handL.x, handL.y, 10, 20)
    love.graphics.rectangle("fill", handR.x, handR.y, 10, 20)
end

function love.mousepressed(x, y, button)
    if button == 1 then
        spawnBlood(x, y)
    end
end
