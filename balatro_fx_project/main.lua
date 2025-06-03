local smoot_dt = 1/100
local accumulator = 0
local cards = require("cards")
local fx = require("fx")

function love.load()
    cards.load()
    fx.load()
end

function love.update(dt)
    accumulator = accumulator + dt
    while accumulator >= smoot_dt do
        cards.update(smoot_dt)
        fx.update(smoot_dt)
        accumulator = accumulator - smoot_dt
    end
end

function love.draw()
    fx.apply(function()
        cards.draw()
    end)
end