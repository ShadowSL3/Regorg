-- Variabili per lo shader CRT e il tempo
local crtShader
local time = 0

function love.load()
    -- Impostare il titolo della finestra
    love.window.setTitle("Effetto CRT sul Background")

    -- Carica lo shader CRT
    crtShader = love.graphics.newShader([[
        extern number time;  -- Variabile per il tempo (animazione)
        
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
        {
            vec2 uv = texture_coords;

            -- Distorsioni orizzontali per l'effetto CRT (simula la distorsione delle scanlines)
            uv.x = uv.x + sin(uv.y * 10.0 + time) * 0.05;

            -- Distorsione verticale per simulare il disturbo delle scanlines
            uv.y = uv.y + sin(uv.x * 10.0 + time) * 0.05;

            -- Distorci leggermente per ottenere l'effetto retrò
            vec4 texColor = Texel(texture, uv);

            -- Aggiungi un po' di rumore per emulare il "disturbo" CRT
            texColor.rgb = texColor.rgb + vec3(sin(time * 5.0) * 0.1, sin(time * 2.0) * 0.1, sin(time * 1.5) * 0.1);

            return texColor;
        }
    ]])
end

function love.update(dt)
    -- Aggiorna il tempo per animare l'effetto
    time = time + dt
end

function love.draw()
    -- Applica lo shader CRT
    love.graphics.setShader(crtShader)
    
    -- Crea un background gradiente (ad esempio, un gradiente che simula un cielo)
    -- Puoi cambiare questo con un altro metodo per creare il tuo background
    love.graphics.setColor(0.1, 0.2, 0.5)  -- Colore blu scuro
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    -- Rimuove lo shader per gli altri disegni
    love.graphics.setShader()

    -- Mostra un semplice testo sopra il background
    love.graphics.setColor(1, 1, 1)  -- Colore bianco per il testo
    love.graphics.setFont(love.graphics.newFont(30))
    love.graphics.print("Effetto CRT sul Background", 50, 50)
end