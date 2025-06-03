
local tween = require "tween"

function love.load()
    love.window.setMode(720, 1280, {resizable = false})
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    money = 50
    transactionY = 0
    transactionText = ""
    cards = {
        {name = "Spada", x = 100, y = 400},
        {name = "Scudo", x = 100, y = 500}
    }

    cardImage = love.graphics.newImage("card.png")
    font = love.graphics.newFont(24)
    love.graphics.setFont(font)

    transactionTween = nil
end

function love.update(dt)
    if transactionTween then
        transactionTween:update(dt)
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("Soldi: " .. money, 20, 20)

    -- Disegna le carte
    for _, card in ipairs(cards) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(cardImage, card.x, card.y)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(card.name, card.x + 10, card.y + 10)
    end

    -- Transazione visiva
    if transactionText ~= "" then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print(transactionText, 20, 70 + transactionY)
    end
end

function love.touchpressed(id, x, y)
    -- Tocca una carta per comprarla
    for _, card in ipairs(cards) do
        if x >= card.x and x <= card.x + 100 and y >= card.y and y <= card.y + 150 then
            buyCard(card)
            break
        end
    end
end

function buyCard(card)
    if money >= 10 then
        money = money - 10
        transactionText = "-10"
        transactionY = 0
        transactionTween = tween.new(1, _G, {transactionY = -40}, "inOutQuad")
    end
end
