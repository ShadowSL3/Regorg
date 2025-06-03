function love.load()
    love.window.setTitle("Volumetric Clouds and Fog")
    love.window.setMode(800, 600)
    width, height = love.graphics.getDimensions()

    time = 0

    -- Shader per nuvole volumetriche
    cloudShader = love.graphics.newShader([[
        extern number time;
        extern vec2 resolution;

        // Funzione di rumore semplice
        float rand(vec2 n) {
            return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
        }

        float noise(vec2 p){
            vec2 i = floor(p);
            vec2 f = fract(p);
            f = f*f*(3.0-2.0*f);
            float a = rand(i);
            float b = rand(i + vec2(1.0, 0.0));
            float c = rand(i + vec2(0.0, 1.0));
            float d = rand(i + vec2(1.0, 1.0));
            return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
        }

        vec3 skyGradient(float y) {
            return mix(vec3(0.4, 0.7, 1.0), vec3(1.0, 1.0, 1.0), y);
        }

        vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords)
        {
            vec2 uv = screenCoords / resolution;
            float n = noise(uv * 10.0 + vec2(time * 0.02, time * 0.01));
            float cloud = smoothstep(0.5, 0.7, n);

            // Nebbia volumetrica
            float fogLayer = noise(uv * vec2(20.0, 8.0) + vec2(time * 0.05));
            float fogAmount = smoothstep(0.4, 0.8, fogLayer) * (1.0 - uv.y);

            // Colori
            vec3 sky = skyGradient(uv.y);
            vec3 finalColor = mix(sky, vec3(1.0), cloud * 0.5);
            finalColor = mix(finalColor, vec3(0.8, 0.8, 0.8), fogAmount * 0.7);

            return vec4(finalColor, 1.0);
        }
    ]])

    cloudShader:send("resolution", {width, height})
end

function love.update(dt)
    time = time + dt
    cloudShader:send("time", time)
end

function love.draw()
    love.graphics.setShader(cloudShader)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setShader()
end