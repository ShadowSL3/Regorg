local shader_preview = {}

local shader = nil
local time = 0
local error_msg = nil

function shader_preview.load()
    shader_preview.update_shader()
end

function shader_preview.update_shader()
    local code = require("editor").get_shader_code()
    local success, result = pcall(love.graphics.newShader, code)
    if success then
        shader = result
        error_msg = nil
    else
        shader = nil
        error_msg = result
    end
end

function shader_preview.update(dt)
    time = time + dt
    shader_preview.update_shader()
end

function shader_preview.draw(x, y, w, h)
    love.graphics.setColor(1, 1, 1)
    if shader then
        shader:send("time", time)
        shader:send("resolution", {w, h})
        love.graphics.setShader(shader)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setShader()
    else
        love.graphics.rectangle("line", x, y, w, h)
        if error_msg then
            love.graphics.print("Error: " .. error_msg, x + 5, y + 5)
        end
    end
end

return shader_preview