function love.load()
    love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
    ghost = {x = 400, y = 300, visible = true}
    luigi = {x = 100, y = 300, speed = 200}
    flashlight_on = false
    touches = {}

    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
end

function love.update(dt)
    local moveLeft, moveRight, torch = false, false, false

    -- Keyboard control
    if love.keyboard.isDown("right") then moveRight = true end
    if love.keyboard.isDown("left") then moveLeft = true end
    if love.keyboard.isDown("x") then torch = true end

    -- Touch control
    for id, t in pairs(touches) do
        if t.x < screen_width * 0.3 then moveLeft = true end
        if t.x > screen_width * 0.7 then moveRight = true end
        if t.x >= screen_width * 0.3 and t.x <= screen_width * 0.7 then torch = true end
    end

    if moveRight then luigi.x = luigi.x + luigi.speed * dt end
    if moveLeft then luigi.x = luigi.x - luigi.speed * dt end

    flashlight_on = torch

    if flashlight_on and math.abs(luigi.x - ghost.x) < 100 then
        ghost.visible = false
    end
end

function love.draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", luigi.x, luigi.y, 30, 60)

    if ghost.visible then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.circle("fill", ghost.x, ghost.y, 30)
    end

    if flashlight_on then
        love.graphics.setColor(1, 1, 0.2, 0.3)
        love.graphics.rectangle("fill", luigi.x + 30, luigi.y, 120, 60)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("← Muovi | → Muovi | Centro: Torcia (Touch OK)", 10, 10)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    touches[id] = {x = x * screen_width, y = y * screen_height}
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    touches[id] = nil
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    touches[id] = {x = x * screen_width, y = y * screen_height}
end
