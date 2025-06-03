function love.load()
    love.window.setTitle("Volumetric Lighting 2D (Love 11.5)")
    love.window.setMode(802, 600)

    lightCanvas = love.graphics.newCanvas(802, 600)
    volumeCanvas = love.graphics.newCanvas(802, 600)

    lightShader = love.graphics.newShader[[
        extern vec2 lightPos;
        extern number exposure;
        extern number decay;
        extern number density;
        extern number weight;

        const int SAMPLES = 512;

        vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 screen_coords)
        {
            vec2 delta = texcoord - lightPos;
            delta *= 1.0 / float(SAMPLES) * density;

            vec2 coord = texcoord;
            float illuminationDecay = 1.0;
            vec4 fragColor = vec4(0.0);

            for (int i = 0; i < SAMPLES; ++i) {
                coord -= delta;
                vec4 sample = Texel(tex, coord);
                sample *= illuminationDecay * weight;
                fragColor += sample;
                illuminationDecay *= decay;
            }

            return fragColor * exposure;
        }
    ]]

    -- Parametri iniziali shader
    lightShader:send("exposure", 0.3)
    lightShader:send("decay", 0.95)
    lightShader:send("density", 0.9)
    lightShader:send("weight", 0.4)
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    local nx, ny = mx / 800, my / 600
    lightShader:send("lightPos", {nx, ny})
end

function love.draw()
    -- 1. Disegniamo una semplice luce circolare
    love.graphics.setCanvas(lightCanvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    local mx, my = love.mouse.getPosition()
    love.graphics.circle("fill", mx, my, 100)
    love.graphics.setCanvas()

    -- 2. Applichiamo lo shader di volumetric lighting
    love.graphics.setCanvas(volumeCanvas)
    love.graphics.clear()
    love.graphics.setShader(lightShader)
    love.graphics.draw(lightCanvas)
    love.graphics.setShader()
    love.graphics.setCanvas()

    -- 3. Disegniamo la scena finale
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(volumeCanvas)

    -- Oggetto ostacolo (simulato)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 300, 250, 200, 100)
end