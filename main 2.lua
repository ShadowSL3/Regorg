-- Editor di Cutscene Mobile - Basato su UI musicale procedurale
-- Tutto in un unico main.lua - Compatibile con smartphone - Touch + SVG + VFX + Shader

-- Impostazioni schermo e colori
local screenWidth, screenHeight = love.graphics.getDimensions()
local uiScale = math.min(screenWidth / 800, screenHeight / 600)
local colors = {
    bg = {0.1, 0.1, 0.15, 1},
    button = {0.3, 0.3, 0.4},
    buttonHover = {0.5, 0.5, 0.6},
    text = {1, 1, 1},
    timeline = {0.8, 0.8, 0.2},
    vfx = {0.4, 0.8, 1}
}

-- Oggetti della scena
local objects = {}
local timeline = {}
local particles = {}
local currentTime = 0
local playing = false

-- Editor shader base
local shaderCode = [[
extern number time;
vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    float glow = 0.5 + 0.5 * sin(time + texCoord.x * 10.0);
    return vec4(glow, glow * 0.5, 1.0, 1.0) * Texel(tex, texCoord) * color;
}
]]
local shader

-- UI base
local buttons = {
    {text = "Play", x = 20, y = 20, width = 100, height = 30, action = function() playing = not playing end},
    {text = "Add Obj", x = 130, y = 20, width = 100, height = 30, action = function()
        table.insert(objects, {x = math.random(100, 500), y = math.random(100, 400)})
    end},
}

-- SVG-like icon rendering
function drawIcon(x, y, scale)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.scale(scale, scale)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 0, 0, 5)
    love.graphics.line(-10, 0, 10, 0)
    love.graphics.line(0, -10, 0, 10)
    love.graphics.pop()
end

function love.load()
    shader = love.graphics.newShader(shaderCode)
end

function love.update(dt)
    if playing then currentTime = currentTime + dt end
    shader:send("time", currentTime)
end

function love.draw()
    love.graphics.clear(colors.bg)
    love.graphics.scale(uiScale, uiScale)

    -- Draw objects with shader
    for _, obj in ipairs(objects) do
        love.graphics.setShader(shader)
        love.graphics.rectangle("fill", obj.x, obj.y, 40, 40)
        love.graphics.setShader()
    end

    -- UI buttons
    for _, b in ipairs(buttons) do
        love.graphics.setColor(colors.button)
        love.graphics.rectangle("fill", b.x, b.y, b.width, b.height, 6, 6)
        love.graphics.setColor(colors.text)
        love.graphics.print(b.text, b.x + 10, b.y + 7)
    end

    -- Timeline bar
    love.graphics.setColor(colors.timeline)
    love.graphics.rectangle("fill", 20, 70, 760, 10)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", 20 + (currentTime * 100) % 760, 75, 5)

    -- Icon test
    drawIcon(750, 30, 1.2)
end

function love.touchpressed(id, x, y)
    x = x / uiScale
    y = y / uiScale
    for _, b in ipairs(buttons) do
        if x > b.x and x < b.x + b.width and y > b.y and y < b.y + b.height then
            b.action()
        end
    end
end

function love.keypressed(k)
    if k == "space" then playing = not playing end
end
