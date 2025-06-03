local timeline = {}

function timeline.draw()
    -- Draw the timeline grid and keyframes
    love.graphics.setColor(0.2, 0.6, 0.9)
    love.graphics.rectangle("line", 20, 60, 280, 120)
end

function timeline.update(dt)
    -- Update timeline state
end

return timeline
