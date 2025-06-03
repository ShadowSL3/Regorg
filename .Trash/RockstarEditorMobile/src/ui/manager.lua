local ui = {}

function ui.draw()
    -- Draw UI buttons and timeline
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Rockstar Editor UI", 10, 10)
end

function ui.update(dt)
    -- Update UI logic (touch input)
end

return ui
