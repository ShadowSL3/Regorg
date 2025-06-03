local ui = {}
ui.font = love.graphics.newFont(32)
ui.showSettings = false
ui.activeShaders = {
    Fog = false,
    VolumetricFog = false,
    GodRays = false,
    CRT = false
}

local function drawHamburger(x, y, size)
    love.graphics.setColor(1, 1, 1)
    local spacing = size / 4
    for i = 0, 2 do
        love.graphics.rectangle("fill", x, y + i * spacing, size, spacing / 2, 2, 2)
    end
end

function ui.drawCheckbox(label, x, y, w, h, state)
    love.graphics.setColor(state and {0.8, 0.4, 0.1} or {0.2, 0.2, 0.2})
    love.graphics.rectangle("fill", x, y, w, h, 4)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(ui.font)
    love.graphics.printf(label, x + w + 20, y, 300, "left")
end

function ui.checkInteraction(x, y, w, h, mx, my)
    return mx > x and mx < x + w and my > y and my < y + h
end

function ui.updateCheckboxes(mx, my)
    local W, H = love.graphics.getDimensions()
    local menuX, menuY, menuSize = W - 80, 30, 40

    if ui.checkInteraction(menuX, menuY, menuSize, menuSize, mx, my) then
        ui.showSettings = not ui.showSettings
        return
    end

    if ui.showSettings then
        local baseX = W * 0.1
        local baseY = H * 0.6
        local w, h = 40, 40
        local spacing = 60
        local index = 0

        for k in pairs(ui.activeShaders) do
            local x, y = baseX, baseY + index * spacing
            if ui.checkInteraction(x, y, w, h, mx, my) then
                ui.activeShaders[k] = not ui.activeShaders[k]
            end
            index = index + 1
        end
    end
end

function ui.drawShaderSettings()
    local W, H = love.graphics.getDimensions()
    local menuX, menuY, menuSize = W - 80, 30, 40
    drawHamburger(menuX, menuY, menuSize)

    if ui.showSettings then
        local baseX = W * 0.1
        local baseY = H * 0.6
        local w, h = 40, 40
        local spacing = 60
        local index = 0

        for k, v in pairs(ui.activeShaders) do
            local x, y = baseX, baseY + index * spacing
            ui.drawCheckbox(k, x, y, w, h, v)
            index = index + 1
        end
    end
end

return ui