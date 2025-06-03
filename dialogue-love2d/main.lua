local dialogue = {
    start = {
        text = "Ciao, come stai?",
        choices = {
            { text = "Bene, grazie.", next = "good" },
            { text = "Non tanto bene.", next = "bad" }
        }
    },
    good = {
        text = "Mi fa piacere!",
        next = "end"
    },
    bad = {
        text = "Mi dispiace sentirlo.",
        next = "end"
    },
    _end = {
        text = "Ci sentiamo presto.",
        choices = nil
    }
}

local currentNode = dialogue["start"]

function selectChoice(index)
    local choices = currentNode.choices
    if choices and choices[index] then
        local nextNode = dialogue[choices[index].next]
        if nextNode then
            currentNode = nextNode
        end
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(currentNode.text, 100, 100, 600)

    if currentNode.choices then
        for i, choice in ipairs(currentNode.choices) do
            love.graphics.printf(i .. ". " .. choice.text, 120, 150 + i * 30, 600)
        end
    end
end

function love.keypressed(key)
    local index = tonumber(key)
    if index then
        selectChoice(index)
    end
end