balls = {}
gravity = 800

function setupPhysics()
    for i = 1, 20 do
        table.insert(balls, {
            x = math.random(50, 750),
            y = math.random(0, 200),
            radius = 10 + math.random() * 10,
            vy = 0
        })
    end
end

function updatePhysics(dt)
    for _, ball in ipairs(balls) do
        ball.vy = ball.vy + gravity * dt
        ball.y = ball.y + ball.vy * dt
        if ball.y + ball.radius > love.graphics.getHeight() then
            ball.y = love.graphics.getHeight() - ball.radius
            ball.vy = -ball.vy * 0.7
        end
    end
end

function drawPhysics()
    love.graphics.setColor(1, 0.8, 0.2)
    for _, ball in ipairs(balls) do
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    end
end
