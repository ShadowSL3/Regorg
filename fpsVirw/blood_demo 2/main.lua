local blood = {}
local isShooting = false
local shootTimer = 0
local shootDelay = 0.1
local tweens = {}
local settings = { quality = "high" }

local function tween(duration, subject, target)
    local t = { time = 0, duration = duration, subject = subject, target = target }
    table.insert(tweens, t)
end

function spawnBlood(x, y)
    for i = 1, (settings.quality == "high" and 40 or 20) do
        local angle = math.random() * 2 * math.pi
        local speed = math.random(100, 300)
        local dx, dy = math.cos(angle) * speed, math.sin(angle) * speed
        local particle = {
            x = x, y = y, dx = dx, dy = dy,
            alpha = 1.0, size = math.random(2, 4),
            r = 0.7, g = 0.1, b = 0.1, glow = 1.0
        }
        table.insert(blood, particle)
        tween(0.5, particle, {glow = 0.0}) -- glow fade only
    end
    sound:stop(); sound:play()
end

function love.load()
    bloodShader = love.graphics.newShader("shaders/bloodsplash.glsl")
    gun = { x = 100, y = 300 }
    handL = { x = 80, y = 400 }
    handR = { x = 120, y = 400 }
    local snd = require("sounds.bloodsquirt")
    sound = snd.createSound()
    font = love.graphics.newFont(14)
end

function love.update(dt)
    if isShooting then
        shootTimer = shootTimer + dt
        if shootTimer >= shootDelay then
            spawnBlood(love.mouse.getX(), love.mouse.getY())
            shootTimer = 0
        end
    end

    for _, b in ipairs(blood) do
        b.x = b.x + b.dx * dt
        b.y = b.y + b.dy * dt
        b.dx = b.dx * 0.97
        b.dy = b.dy * 0.97
    end

    for i = #tweens, 1, -1 do
        local t = tweens[i]
        t.time = t.time + dt
        local ratio = math.min(t.time / t.duration, 1)
        for k, v in pairs(t.target) do
            t.subject[k] = t.subject[k] + (v - t.subject[k]) * ratio
        end
        if ratio >= 1 then table.remove(tweens, i) end
    end
end

function love.draw()
    love.graphics.setFont(font)
    love.graphics.print("Settings: Quality [" .. settings.quality .. "]", 10, 10)
    love.graphics.print("Hold Left Click to shoot blood", 10, 30)

    love.graphics.setShader(bloodShader)
    for _, b in ipairs(blood) do
        bloodShader:send("alpha", b.alpha)
        bloodShader:send("glow", b.glow)
        love.graphics.setColor(b.r, b.g, b.b, b.alpha)
        love.graphics.circle("fill", b.x, b.y, b.size)
    end
    love.graphics.setShader()

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", gun.x, gun.y, 30, 10)
    love.graphics.rectangle("fill", handL.x, handL.y, 10, 20)
    love.graphics.rectangle("fill", handR.x, handR.y, 10, 20)
end

function love.mousepressed(x, y, button)
    if button == 1 then isShooting = true end
end

function love.mousereleased(x, y, button)
    if button == 1 then isShooting = false end
end

function love.keypressed(key)
    if key == "q" then
        settings.quality = (settings.quality == "high") and "low" or "high"
    end
end
