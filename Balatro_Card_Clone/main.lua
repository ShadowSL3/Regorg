
local lume = require("lib.lume")
local lurker = require("lib.lurker")

local fireShader, dissolveShader
local cards = {}
local selectedIndex = nil
local time = 0
local multiplier = 5

function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("Balatro Card Clone")
    fireShader = love.graphics.newShader("shaders/fire.glsl")
    dissolveShader = love.graphics.newShader("shaders/dissolve.glsl")

    for i = 1, 5 do
        table.insert(cards, {
            x = 120 * i, y = 250, w = 100, h = 140,
            selected = false,
            shader = i == 3 and fireShader or nil
        })
    end
end

function love.update(dt)
    time = time + dt
    fireShader:send("time", time)
    dissolveShader:send("time", time)
end

function love.draw()
    -- Moltiplicatore a sinistra
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(32))
    love.graphics.print("x" .. multiplier, 30, 260)

    for i, card in ipairs(cards) do
        if card.shader then
            love.graphics.setShader(card.shader)
        end
        love.graphics.setColor(1, 1, 1, card.selected and 1 or 0.8)
        love.graphics.rectangle("fill", card.x, card.y, card.w, card.h, 8, 8)
        love.graphics.setShader()
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf("Card " .. i, card.x, card.y + card.h/2 - 8, card.w, "center")
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for i, card in ipairs(cards) do
            if x > card.x and x < card.x + card.w and y > card.y and y < card.y + card.h then
                card.selected = not card.selected
            end
        end
    end
end
