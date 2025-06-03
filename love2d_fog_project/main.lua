local player = { x = 400, y = 300 }
local fogCanvas
local mask
local fogShader

function love.load()
    love.graphics.setDefaultFilter("linear", "linear")
    mask = love.graphics.newImage("assets/mask.png")
    fogCanvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())

    fogShader = love.graphics.newShader[[
        extern vec2 playerPos;
        extern Image mask;

        vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
            vec2 maskCoord = (screenCoord - playerPos + vec2(128.0)) / 256.0;
            float maskValue = Texel(mask, maskCoord).r;
            vec4 base = Texel(tex, texCoord);
            return mix(base, vec4(0, 0, 0, 1), maskValue);
        }
    ]]
end

function love.update(dt)
    if love.keyboard.isDown("w") then player.y = player.y - 200 * dt end
    if love.keyboard.isDown("s") then player.y = player.y + 200 * dt end
    if love.keyboard.isDown("a") then player.x = player.x - 200 * dt end
    if love.keyboard.isDown("d") then player.x = player.x + 200 * dt end
end

function love.draw()
    love.graphics.setCanvas()
    love.graphics.clear(0.1, 0.1, 0.1)
    love.graphics.setColor(1,1,1)
    love.graphics.circle("fill", player.x, player.y, 10)
    love.graphics.print("Mondo", 20, 20)

    love.graphics.setCanvas(fogCanvas)
    love.graphics.clear(0, 0, 0, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, fogCanvas:getWidth(), fogCanvas:getHeight())

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("subtract", "premultiplied")
    love.graphics.draw(mask, player.x - 128, player.y - 128)

    love.graphics.setCanvas()

    fogShader:send("playerPos", { player.x, player.y })
    fogShader:send("mask", mask)
    love.graphics.setShader(fogShader)
    love.graphics.draw(fogCanvas)
    love.graphics.setShader()
end
