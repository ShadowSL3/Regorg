local card = {}
local cards = {}

function card:new(x, y)
    return {x = x, y = y, selected = false, angle = 0}
end

function cards.load()
    table.insert(cards, card:new(300, 400))
end

function cards.update(dt)
    for _, c in ipairs(cards) do
        if c.selected then
            c.angle = c.angle + dt * 2
        end
    end
end

function cards.draw()
    for _, c in ipairs(cards) do
        love.graphics.push()
        love.graphics.translate(c.x, c.y)
        love.graphics.rotate(c.angle)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", -50, -70, 100, 140)
        love.graphics.pop()
    end
end

return cards