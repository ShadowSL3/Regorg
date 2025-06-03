function love.load()
    shader = love.graphics.newShader([[
        extern number time;

        vec4 effect(vec4 color, Image tex, vec2 uv, vec2 px)
        {
            // Calcolo la distanza dal centro
            vec2 center = vec2(0.5, 0.5);
            float dist = distance(uv, center);

            // Intensità glow decrescente con la distanza
            float glow = 1.0 - smoothstep(0.0, 0.5, dist);

            // Oscillazione di apparizione/scomparsa con sinusoide
            float pulse = 0.5 + 0.5 * sin(time * 3.0);

            // Colore della fiamma (arancio-rosso)
            vec3 flameColor = mix(vec3(1.0, 0.5, 0.0), vec3(1.0, 0.0, 0.0), dist * 2.0);

            // Output finale
            return vec4(flameColor * glow * pulse, glow * pulse);
        }
    ]])
end

function love.update(dt)
    shader:send("time", love.timer.getTime())
end

function love.draw()
    love.graphics.setShader(shader)
    love.graphics.rectangle("fill", 200, 100, 400, 400)
    love.graphics.setShader()
end