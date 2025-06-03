function love.load()
    effect = love.graphics.newShader [[
        extern number time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            return vec4((1.0-sin(time))/1.33, abs(cos(time)), abs(sin(time)), 1.55);
        }
    ]]
end

function love.draw()
    -- boring white
    love.graphics.setShader()
    love.graphics.rectangle('fill', 10,10,780,285)

    -- LOOK AT THE PRETTY COLORS!
    love.graphics.setShader(effect)
    love.graphics.rectangle('fill', 10,305,780,285)
end

local t = 0
function love.update(dt)
    t = t + dt
    effect:send("time", t)
end