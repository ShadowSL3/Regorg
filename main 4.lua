
local font, profilerFont
local settings = {
    maxGraphics = false,
    showBuffers = false,
    physicsCount = 150,
    slowEngine = false,
}

local ui = {
    activeSlider = nil,
    sliders = {
        physicsCount = {value = 150, min = 50, max = 300, label = "Physics Count"},
    }
}

local menuOpen = true
local balls = {}
local profiler = {}
local shaders = {}

function love.load()
    font = love.graphics.newFont(16)
    profilerFont = love.graphics.newFont(12)
    love.graphics.setFont(font)
    createBalls(ui.sliders.physicsCount.value)
    shaders.glow = love.graphics.newShader[[
        vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
            vec4 pixel = Texel(tex, tex_coords);
            return vec4(pixel.rgb * 1.2, pixel.a);
        }
    ]]
    shaders.blur = love.graphics.newShader[[
        vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
            vec4 pixel = Texel(tex, tex_coords);
            float blur = sin(tex_coords.y * 50.0) * 0.01;
            return vec4(pixel.r + blur, pixel.g + blur, pixel.b + blur, pixel.a);
        }
    ]]
end

function createBalls(count)
    balls = {}
    for i = 1, count do
        table.insert(balls, {
            x = love.math.random(0, love.graphics.getWidth()),
            y = love.math.random(0, love.graphics.getHeight()/2),
            vy = 0
        })
    end
end

function love.update(dt)
    if settings.slowEngine then dt = dt * 0.3 end

    for _, ball in ipairs(balls) do
        ball.vy = ball.vy + 500 * dt
        ball.y = ball.y + ball.vy * dt
        if ball.y > love.graphics.getHeight() - 10 then
            ball.y = love.graphics.getHeight() - 10
            ball.vy = -ball.vy * 0.5
        end
    end

    if not profiler.fps then profiler.fps = {} end
    table.insert(profiler.fps, 1 / dt)
    if #profiler.fps > 100 then table.remove(profiler.fps) end
end

function drawProfiler(x, y)
    love.graphics.setFont(profilerFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), x, y)
    love.graphics.setColor(0.2, 0.8, 1)
    for i, fps in ipairs(profiler.fps) do
        love.graphics.line(x + i, y + 40, x + i, y + 40 - (fps / 2))
    end
end

function drawUI()
    local spacing = 30
    local x, y = 20, 20
    love.graphics.setColor(1,1,1)
    love.graphics.print("SETTINGS", x, y)
    y = y + spacing

    for key, slider in pairs(ui.sliders) do
        love.graphics.setColor(0.6, 1, 0.6)
        love.graphics.print(slider.label, x, y)
        y = y + 20
        love.graphics.setColor(1, 0.7, 0.3)
        love.graphics.rectangle("fill", x, y, 200, 8)
        love.graphics.setColor(1, 1, 1)
        local sx = x + ((slider.value - slider.min) / (slider.max - slider.min)) * 200
        love.graphics.rectangle("fill", sx - 5, y - 4, 10, 16)
        y = y + spacing
    end

    local toggles = { "maxGraphics", "showBuffers", "slowEngine" }
    for _, key in ipairs(toggles) do
        love.graphics.setColor(0.6, 1, 0.6)
        love.graphics.print(key, x, y)
        love.graphics.setColor(settings[key] and {0.2, 1, 0.2} or {1, 0.2, 0.2})
        love.graphics.rectangle("fill", x + 150, y, 20, 20)
        y = y + spacing
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for key, slider in pairs(ui.sliders) do
            local sx, sy = 20, 50 + 30
            if y > sy and y < sy + 8 and x > sx and x < sx + 200 then
                ui.activeSlider = key
            end
        end
    end
end

function love.mousereleased(x, y, button)
    ui.activeSlider = nil
end

function love.mousemoved(x, y, dx, dy)
    if ui.activeSlider then
        local slider = ui.sliders[ui.activeSlider]
        local rel = math.max(0, math.min(1, (x - 20) / 200))
        slider.value = math.floor(slider.min + rel * (slider.max - slider.min))
        if ui.activeSlider == "physicsCount" then
            createBalls(slider.value)
        end
    end
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.12)

    if settings.maxGraphics then
        love.graphics.setShader(shaders.glow)
    elseif settings.showBuffers then
        love.graphics.setShader(shaders.blur)
    end

    for _, ball in ipairs(balls) do
        love.graphics.setColor(0.9, 0.2, 0.3)
        love.graphics.circle("fill", ball.x, ball.y, 6)
    end

    love.graphics.setShader()

    drawUI()
    drawProfiler(10, love.graphics.getHeight() - 60)
end
