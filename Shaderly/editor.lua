local editor = {}

local text = [[
#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 resolution;
void main() {
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    gl_FragColor = vec4(uv.x, uv.y, sin(time), 1.0);
}
]]
local cursor = #text
local lines = {}
local scroll = 0

function editor.load()
    lines = {}
    for line in text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
end

function editor.textinput(t)
    text = text:sub(1, cursor) .. t .. text:sub(cursor + 1)
    cursor = cursor + #t
    editor.load()
end

function editor.keypressed(key)
    if key == "backspace" then
        if cursor > 0 then
            text = text:sub(1, cursor - 1) .. text:sub(cursor + 1)
            cursor = cursor - 1
            editor.load()
        end
    elseif key == "return" then
        editor.textinput("\n")
    end
end

function editor.draw(x, y, w, h)
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1)
    local line_height = love.graphics.getFont():getHeight()
    for i, line in ipairs(lines) do
        local ly = y + (i - 1 - scroll) * line_height
        if ly >= y and ly < y + h then
            love.graphics.print(line, x + 5, ly)
        end
    end
end

function editor.get_shader_code()
    return text
end

return editor