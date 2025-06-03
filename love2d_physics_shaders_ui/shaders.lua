local fogShaderCode = [[
    vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
        vec4 pixel = Texel(tex, tex_coords);
        float fog = clamp(1.0 - (screen_coords.y / love_ScreenSize.y), 0.0, 1.0);
        return mix(vec4(0.2, 0.3, 0.4, 1.0), pixel, fog);
    }
]]

local godRayShaderCode = [[
    vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
        vec4 pixel = Texel(tex, tex_coords);
        float dist = length(screen_coords - love_ScreenSize.xy * 0.5);
        float light = clamp(1.0 - dist / 400.0, 0.0, 1.0);
        return pixel + vec4(1.0, 0.8, 0.5, 1.0) * light * 0.2;
    }
]]

local shaders = {
    fog = { active = false, shader = love.graphics.newShader(fogShaderCode) },
    godrays = { active = false, shader = love.graphics.newShader(godRayShaderCode) }
}

function setupShaders() end

function toggleShader(name)
    if shaders[name] then
        shaders[name].active = not shaders[name].active
    end
end

function drawFogShader(callback)
    if shaders["fog"].active or shaders["godrays"].active then
        love.graphics.setShader(nil)
        love.graphics.origin()
        love.graphics.push("all")
        local canvas = love.graphics.newCanvas()
        love.graphics.setCanvas(canvas)
        love.graphics.clear()
        callback()
        love.graphics.setCanvas()
        for name, data in pairs(shaders) do
            if data.active then
                love.graphics.setShader(data.shader)
            end
        end
        love.graphics.draw(canvas)
        love.graphics.setShader()
        love.graphics.pop()
    else
        callback()
    end
end
