blood = {}

function blood.spawn(x, y, dir, power)
    local particles = {}
    for i = 1, power do
        local angle = dir + math.random() * 0.5 - 0.25
        table.insert(particles, {
            x = x, y = y,
            dx = math.cos(angle) * math.random(100, 300) / 100,
            dy = math.sin(angle) * math.random(100, 300) / 100,
            life = 1,
            size = math.random(2, 5)
        })
    end
    table.insert(blood, {particles = particles})
end

function blood.update(dt)
    for i, spray in ipairs(blood) do
        for j, p in ipairs(spray.particles) do
            p.x = p.x + p.dx * dt
            p.y = p.y + p.dy * dt
            p.life = p.life - dt
        end
    end
end

function blood.draw()
    for _, spray in ipairs(blood) do
        for _, p in ipairs(spray.particles) do
            if p.life > 0 then
                love.graphics.setColor(0.7, 0, 0, p.life)
                love.graphics.circle("fill", p.x, p.y, p.size)
            end
        end
    end
end