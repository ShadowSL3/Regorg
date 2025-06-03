function love.conf(t)
    t.window.title = "Rockstar Editor Mobile"
    t.window.msaa = 8
    t.window.highdpi = true
end

local scenes = {}
local camera = { x = 0, y = 0, zoom = 1 }
local buttons = {}
local font

function love.load()
    font = love.graphics.newFont(18)
    love.graphics.setFont(font)
    table.insert(buttons, {label="Options", x=10, y=10, w=120, h=40, onClick=function()
        print("Options button pressed")
    end})
    -- Preload scene data
    table.insert(scenes, { name = "Intro", duration = 3, effect = "fadein" })
    table.insert(scenes, { name = "Action", duration = 5, effect = "shake" })
end

function love.update(dt)
    -- Scene logic (placeholder)
    camera.x = camera.x + math.sin(love.timer.getTime()) * 0.2
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-camera.x, -camera.y)
    love.graphics.scale(camera.zoom)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Rockstar Editor - Scene View", 200, 100)

    -- Draw camera viewport placeholder
    love.graphics.rectangle("line", 150, 90, 300, 180)

    love.graphics.pop()

    drawUI()
end

function drawUI()
    love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
    for _, b in ipairs(buttons) do
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h, 6)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(b.label, b.x + 10, b.y + 10)
        love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
    end
end

function love.touchpressed(id, x, y)
    handleButtonPress(x * love.graphics.getWidth(), y * love.graphics.getHeight())
end

function love.mousepressed(x, y, button)
    if button == 1 then
        handleButtonPress(x, y)
    end
end

function handleButtonPress(x, y)
    for _, b in ipairs(buttons) do
        if x > b.x and x < b.x + b.w and y > b.y and y < b.y + b.h then
            if b.onClick then b.onClick() end
        end
    end
end
