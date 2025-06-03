
local menu = require("menu")
local buttons = {}
local font
local shader
local time = 0
local cardArea = { x = 0, y = 0, w = 0, h = 0 }
local tween = { scale = 0, target = 1, speed = 3 }

function menu.load()
    font = love.graphics.newFont("assets/m6x11plus.ttf", 24)
    love.graphics.setFont(font)

    shader = love.graphics.newShader("assets/shaders/intro.glsl")

    local w, h = love.graphics.getDimensions()
    local labels = {"Nuova partita", "Impostazioni", "Esci"}
    for i, label in ipairs(labels) do
        table.insert(buttons, {
            label = label,
            x = w/2 - 100,
            y = h * 0.5 + i * 60,
            w = 200,
            h = 45,
            hover = false
        })
    end

    cardArea.w = w * 0.9
    cardArea.h = h * 0.25
    cardArea.x = (w - cardArea.w) / 2
    cardArea.y = h - cardArea.h - 20
end

function menu.update(dt)
    time = time + dt
    if tween.scale < tween.target then
        tween.scale = tween.scale + tween.speed * dt
        if tween.scale > tween.target then tween.scale = tween.target end
    end

    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(buttons) do
        btn.hover = mx >= btn.x and mx <= btn.x + btn.w and my >= btn.y and my <= btn.y + btn.h
    end

    shader:send("time", time)
end

function menu.draw()
    love.graphics.setShader(shader)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    -- Titolo con animazione
    love.graphics.setColor(1, 1, 0.6, 1)
    local s = 1 + 0.05 * math.sin(time * 2)
    love.graphics.printf("BALATRO", 0, 80, love.graphics.getWidth(), "center", 0, s, s, 0, 0)

    -- Pulsanti
    for _, btn in ipairs(buttons) do
        if btn.hover then
            love.graphics.setColor(1, 0.5, 0.2, 1)
        else
            love.graphics.setColor(0.9, 0.9, 0.9, 1)
        end
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 8, 8)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(btn.label, btn.x, btn.y + 12, btn.w, "center")
    end

    -- CardArea UI
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", cardArea.x, cardArea.y, cardArea.w, cardArea.h, 10, 10)
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", cardArea.x, cardArea.y, cardArea.w, cardArea.h, 10, 10)
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        for _, btn in ipairs(buttons) do
            if btn.hover then
                print("Clicked:", btn.label)
                -- Aggiungi azioni qui
            end
        end
    end
end

return menu
