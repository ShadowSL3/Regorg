function love.load()
    -- Imposta larghezza e altezza del rettangolo
    rectWidth = love.graphics.getWidth()
    rectHeight = love.graphics.getHeight()
end

function love.draw()
    -- Divido l'altezza in bande
    local bands = 100
    
    for i = 0, bands - 1 do
        -- Calcolo la percentuale della banda corrente
        local t = i / (bands - 1)
        
        -- Genero il colore arcobaleno (HSV → RGB)
        local r, g, b = hsvToRgb(t * 360, 1, 1)
        
        -- Applico il colore
        love.graphics.setColor(r, g, b)
        
        -- Disegno una striscia orizzontale
        love.graphics.rectangle("fill", 0, i * (rectHeight / bands), rectWidth, rectHeight / bands)
    end
end

-- Funzione per convertire HSV in RGB
function hsvToRgb(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b

    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end

    return r + m, g + m, b + m
end