local settings = {
    maxGraphics = false,
    showBuffers = false,
    physicsCount = 100,
    slowEngine = false,
}

local menu = {
    selected = 1,
    sections = {
        {name = "Graphics", options = {"Max Graphics", "Show Buffers"}},
        {name = "Game", options = {"Physics Count", "Slower Engine"}},
    }
}

local balls = {}
local font

function love.load()
    font = love.graphics.newFont(16)
    love.graphics.setFont(font)
    createBalls(settings.physicsCount)
end

function createBalls(count)
    balls = {}
    for i = 1, count do
        table.insert(balls, {
            x = love.math.random(0, love.graphics.getWidth()),
            y = love.math.random(0, love.graphics.getHeight()/2),
            vy = 0
        })
    end
end

function love.update(dt)
    if settings.slowEngine then dt = dt * 0.3 end

    for _, ball in ipairs(balls) do
        ball.vy = ball.vy + 500 * dt
        ball.y = ball.y + ball.vy * dt
        if ball.y > love.graphics.getHeight() - 10 then
            ball.y = love.graphics.getHeight() - 10
            ball.vy = -ball.vy * 0.5
        end
    end
end

function drawMenu(x, y)
    local spacing = 28
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("SETTINGS", x, y)
    y = y + spacing
    for si, section in ipairs(menu.sections) do
        love.graphics.setColor(0.6, 1, 0.6)
        love.graphics.print(section.name, x + 10, y)
        y = y + spacing * 0.7
        for oi, option in ipairs(section.options) do
            local selected = (menu.selected == si * 10 + oi)
            local key = option:gsub(" ", ""):lower()
            local value = settings[key] or "?"

            local displayValue = type(value) == "boolean" and (value and "ON" or "OFF") or value
            love.graphics.setColor(selected and {1,0.8,0.2} or {1,1,1})
            love.graphics.print(option .. ": " .. tostring(displayValue), x + 20, y)
            y = y + spacing * 0.6
        end
        y = y + spacing * 0.5
    end
end

function love.keypressed(key)
    if key == "down" then menu.selected = menu.selected + 1 end
    if key == "up" then menu.selected = menu.selected - 1 end
    if key == "return" then
        for si, section in ipairs(menu.sections) do
            for oi, option in ipairs(section.options) do
                local idx = si * 10 + oi
                if menu.selected == idx then
                    local key = option:gsub(" ", ""):lower()
                    if type(settings[key]) == "boolean" then
                        settings[key] = not settings[key]
                    elseif key == "physicscount" then
                        settings.physicsCount = (settings.physicsCount == 100) and 300 or 100
                        createBalls(settings.physicsCount)
                    end
                end
            end
        end
    end
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.12)

    for _, ball in ipairs(balls) do
        love.graphics.setColor(0.9, 0.2, 0.3)
        love.graphics.circle("fill", ball.x, ball.y, 6)
    end

    drawMenu(20, 20)

    -- Placeholder shader FX feedback
    if settings.maxGraphics then
        love.graphics.setColor(0.2, 0.6, 1, 0.2)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end

    if settings.showBuffers then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("SHOW BUFFERS ENABLED", 20, love.graphics.getHeight() - 40)
    end
end