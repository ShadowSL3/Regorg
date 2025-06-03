local tween = {}
local ball = { x = -200, y = 400, size = 30, animTime = 0, mode = "shoot-in" }
local dropdown = { x = 280, y = 20, w = 90, h = 30, expanded = false, options = { "shoot-in", "shoot-out", "shoot-in-out" }, selected = 1 }

function love.load()
    love.window.setMode(390, 844)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
end

function shootIn(t)  -- velocità che rallenta verso il centro
    return 1 - math.pow(2, -10 * t)
end

function shootOut(t) -- velocità che accelera subito
    return math.pow(t, 3)
end

function shootInOut(t)
    if t < 0.5 then
        return 0.5 * shootIn(t * 2)
    else
        return 0.5 + 0.5 * shootOut((t - 0.5) * 2)
    end
end

function updateBall(dt)
    ball.animTime = ball.animTime + dt
    local t = ball.animTime
    if t > 1 then
        ball.animTime = 0
        return
    end

    local interp
    if ball.mode == "shoot-in" then
        interp = shootIn(t)
    elseif ball.mode == "shoot-out" then
        interp = shootOut(t)
    elseif ball.mode == "shoot-in-out" then
        interp = shootInOut(t)
    end

    ball.x = 40 + interp * (310)
end

function love.update(dt)
    updateBall(dt)
end

function love.draw()
    -- Dropdown menu
    love.graphics.setColor(0.2, 0.2, 0.25)
    love.graphics.rectangle("fill", dropdown.x, dropdown.y, dropdown.w, dropdown.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(dropdown.options[dropdown.selected], dropdown.x + 5, dropdown.y + 8)

    if dropdown.expanded then
        for i, opt in ipairs(dropdown.options) do
            love.graphics.setColor(0.25, 0.25, 0.3)
            love.graphics.rectangle("fill", dropdown.x, dropdown.y + i * dropdown.h, dropdown.w, dropdown.h)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(opt, dropdown.x + 5, dropdown.y + i * dropdown.h + 8)
        end
    end

    -- Ball
    love.graphics.setColor(1, 0.6, 0.4)
    love.graphics.circle("fill", ball.x, ball.y, ball.size)
end

function love.mousepressed(x, y)
    -- Dropdown click
    if x > dropdown.x and x < dropdown.x + dropdown.w then
        if y > dropdown.y and y < dropdown.y + dropdown.h then
            dropdown.expanded = not dropdown.expanded
            return
        end
        if dropdown.expanded then
            for i = 1, #dropdown.options do
                local oy = dropdown.y + i * dropdown.h
                if y > oy and y < oy + dropdown.h then
                    dropdown.selected = i
                    dropdown.expanded = false
                    ball.mode = dropdown.options[i]
                    ball.animTime = 0
                    return
                end
            end
        end
    end
end