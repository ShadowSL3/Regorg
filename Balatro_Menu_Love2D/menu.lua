local menu = {}
local buttons = {}
local font
local shader

function menu.load()
    font = love.graphics.newFont("assets/m6x11plus.ttf", 24)
    love.graphics.setFont(font)

    shader = love.graphics.newShader("assets/shaders/crt.frag")

    local w, h = love.graphics.getDimensions()
    local labels = {"Nuova partita", "Impostazioni", "Esci"}
    for i, label in ipairs(labels) do
        table.insert(buttons, {
            label = label,
            x = w/2 - 100,
            y = 250 + i * 50,
            w = 200,
            h = 40,
            hover = false
        })
    end
end

function menu.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, btn in ipairs(buttons) do
        btn.hover = mx >= btn.x and mx <= btn.x + btn.w and my >= btn.y and my <= btn.y + btn.h
    end
end

function menu.draw()
    love.graphics.setShader(shader)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setShader()

    love.graphics.setColor(1, 1, 0.6, 1)
    love.graphics.printf("BALATRO", 0, 100, love.graphics.getWidth(), "center")

    for _, btn in ipairs(buttons) do
        if btn.hover then
            love.graphics.setColor(1, 0.5, 0.2, 1)
        else
            love.graphics.setColor(0.9, 0.9, 0.9, 1)
        end
        love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 8, 8)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(btn.label, btn.x, btn.y + 10, btn.w, "center")
    end
end

function menu.mousepressed(x, y, button)
    if button == 1 then
        for _, btn in ipairs(buttons) do
            if btn.hover then
                print("Clicked:", btn.label)
                -- Add logic for each button
            end
        end
    end
end

return menu
