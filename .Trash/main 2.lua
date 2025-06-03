local fpsGraph = {}
local maxGraphPoints = 120  -- numero di frame da tracciare (2 secondi a 60fps)

local function pushFPS(fps)
    table.insert(fpsGraph, fps)
    if #fpsGraph > maxGraphPoints then
        table.remove(fpsGraph, 1)
    end
end

function love.load()
    love.window.setTitle("FPS Viewer + Profiler")
    local width, height = 800, 480

    -- Supporto mobile (schermo adattivo)
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        width, height = love.graphics.getDimensions()
    else
        love.window.setMode(width, height, {resizable = true, minwidth = 400, minheight = 240})
    end

    font = love.graphics.newFont(18)
    love.graphics.setFont(font)
end

function love.update(dt)
    pushFPS(love.timer.getFPS())
end

function love.draw()
    local width, height = love.graphics.getDimensions()
    love.graphics.clear(0.08, 0.08, 0.1)
    
    -- Testo UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Frame Time: " .. string.format("%.2f ms", 1000 / love.timer.getFPS()), 10, 30)

    -- Grafico FPS
    local graphX, graphY = 10, 60
    local graphW, graphH = width - 20, 100
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", graphX, graphY, graphW, graphH)
    love.graphics.setColor(0, 1, 0)
    
    if #fpsGraph > 1 then
        for i = 2, #fpsGraph do
            local x1 = graphX + (i - 2) * (graphW / maxGraphPoints)
            local x2 = graphX + (i - 1) * (graphW / maxGraphPoints)
            local y1 = graphY + graphH - (fpsGraph[i - 1] / 120) * graphH
            local y2 = graphY + graphH - (fpsGraph[i] / 120) * graphH
            love.graphics.line(x1, y1, x2, y2)
        end
    end

    -- Target FPS line
    love.graphics.setColor(1, 0, 0, 0.4)
    local targetY = graphY + graphH - (60 / 120) * graphH
    love.graphics.line(graphX, targetY, graphX + graphW, targetY)
end
