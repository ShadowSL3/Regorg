local gfx = {}

gfx.color = {
    background = {0, 0, 0}, 
    highlight = {1, 1, 1},
    white = {1, 1, 1},
    black = {0, 0, 0},
}
gfx.settings = {
    msaa = false, 
    msaaType = { 
        msaa = "4"
    }
}

function gfx.draw()

end

function gfx.rect(x, y, width, height, color, border)
    love.graphics.setColor(color or gfx.color.white)
    love.graphics.rectangle("fill", x, y, width, height)

    if border then
        love.graphics.setColor(border)
        love.graphics.rectangle("line", x, y, width, height)
    end
end
function gfx.update(dt)
end

-- function gfx.setBGColor(color)
--     gfx.color.background = color or gfx.color.black
--     love.graphics.setBackgroundColor(gfx.color.background)
-- end
function gfx.newShader(shaderCode)
    local shader = love.graphics.newShader(shaderCode)
    love.graphics.setShader(shader)
    return shader
end
return gfx