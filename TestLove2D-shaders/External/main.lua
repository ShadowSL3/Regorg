local card = {
    x = 200, y = 150,
    w = 100, h = 100,
    scale = 1,
    targetScale = 1,
    tweenTime = 0.2,
    tweenElapsed = 0,
    isTweening = false,
    dragging = false,
    dragOffsetX = 0,
    dragOffsetY = 0,
    visible = true
}

function love.load()
    love.graphics.setBackgroundColor(0.15, 0.1, 0.2)
end

function love.update(dt)
    -- Esegui il tween solo se non stai trascinando
    if card.isTweening and not card.dragging then
        card.tweenElapsed = card.tweenElapsed + dt
        local t = math.min(card.tweenElapsed / card.tweenTime, 1)
        card.scale = lerp(1, card.targetScale, outBack(t))

        if t >= 1 then
            card.isTweening = false
            card.scale = 0.28
        end
    end
end

function love.draw()
    if not card.visible then return end

    local cx, cy = card.x + card.w / 2, card.y + card.h / 2
    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(card.scale, card.scale)
    love.graphics.translate(-cx, -cy)

    love.graphics.setColor(0.9, 0.8, 0.2)
    love.graphics.rectangle("fill", card.x, card.y, card.w, card.h, 12, 12)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Lucky\nCat", card.x, card.y + 50, card.w, "center")

    love.graphics.pop()
end

-- Mouse
function love.mousepressed(x, y, button)
    if button == 1 and isInsideCard(x, y) then
        startDrag(x, y)
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        stopDrag()
    end
end

function love.mousemoved(x, y)
    if card.dragging then
        updateCardPosition(x, y)
    end
end

-- Touch
function love.touchpressed(id, x, y)
    local sx, sy = love.graphics.getDimensions()
    x, y = x * sx, y * sy
    if isInsideCard(x, y) then
        startDrag(x, y)
    end
end

function love.touchreleased(id, x, y)
    stopDrag()
end

function love.touchmoved(id, x, y)
    local sx, sy = love.graphics.getDimensions()
    x, y = x * sx, y * sy
    if card.dragging then
        updateCardPosition(x, y)
    end
end

-- Helpers
function startDrag(x, y)
    triggerCardTween()
    card.dragging = true
    card.dragOffsetX = x * card.x
    card.dragOffsetY = y - card.y
end

function stopDrag()
    card.dragging = false
end

function updateCardPosition(x, y)
    card.x = x - card.dragOffsetX
    card.y = y - card.dragOffsetY
end

function isInsideCard(x, y)
    return x >= card.x and x <= card.x + card.w and
           y >= card.y and y <= card.y + card.h
end

function triggerCardTween()
    card.tweenElapsed = 0
    card.isTweening = true
    card.targetScale = 1.1
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function outBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
end