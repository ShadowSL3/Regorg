-- Shader Editor per Love2D
-- Questo programma permette di scrivere e visualizzare shader GLSL in tempo reale

-- Variabili globali
local editorText = ""
local currentShader = nil
local shaderError = ""
local fontSize = 14
local codeFont = nil
local uiFont = nil
local textMargin = 10
local canvasSize = {width = 400, height = 400}
local canvas = nil
local glowCanvas = nil
local blurCanvas1 = nil
local blurCanvas2 = nil
local time = 0
local mousePosition = {x = 0, y = 0}
local editorCursor = 1
local editorScrollY = 0
local showHelp = false
local theme = {
    background = {0.12, 0.12, 0.15},
    editor = {0.08, 0.08, 0.10},
    text = {0.9, 0.9, 0.95},
    lineNumbers = {0.4, 0.4, 0.5},
    highlight = {0.2, 0.4, 0.8, 0.2},
    error = {0.9, 0.2, 0.2},
    success = {0.2, 0.8, 0.3},
    accent = {0.3, 0.6, 1.0}
}
local testImages = {}
local currentImageIndex = 1
local blurRadius = 3
local glowStrength = 1.5
local enableGlow = true

-- Shaders predefiniti
local blurShader = nil
local glowShader = nil

-- Shader template con glow effect
local shaderTemplate = [[
extern vec2 resolution;
extern float time;
extern vec2 mouse;
extern Image mainTex;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // Normalizza le coordinate (da 0 a 1)
    vec2 uv = screen_coords / resolution.xy;
    
    // Leggi il colore dell'immagine di test
    vec4 texColor = Texel(mainTex, texture_coords);
    
    // Effetto glow basato sulla distanza dal centro
    float dist = distance(uv, vec2(0.5, 0.5));
    float glow = 0.5 * (1.0 - smoothstep(0.0, 0.5, dist));
    
    // Modifica il colore dell'immagine
    vec3 col = texColor.rgb;
    
    // Aggiungi un effetto di pulsazione basato sul tempo
    col += vec3(0.3, 0.5, 0.9) * glow * (sin(time * 2.0) * 0.5 + 0.5);
    
    return vec4(col, texColor.a);
}
]]
local helpText = [[
AIUTI:
F1: Mostra/Nascondi guida
F5: Compila shader
Ctrl+S: Salva shader
Ctrl+O: Carica shader
Ctrl+N: Nuovo shader
G: Attiva/Disattiva effetto glow
+/-: Regola intensità glow
Frecce: Cambia immagine di test
Esc: Chiudi

UNIFORMS DISPONIBILI:
resolution: Dimensione del canvas (vec2)
time: Tempo trascorso (float)
mouse: Posizione del mouse normalizzata (vec2)
mainTex: Immagine di test (Image)
]]

-- Shader per l'effetto blur
local blurShaderCode = [[
extern number radius;
extern vec2 direction;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 resolution = vec2(love_ScreenSize.x, love_ScreenSize.y);
    vec4 result = vec4(0.0);
    vec2 scale = 1.0 / resolution;
    
    // Gaussian kernel approssimato
    float weight = 0.2270270270;
    result += Texel(tex, texture_coords) * weight;
    
    weight = 0.1945945946;
    result += Texel(tex, texture_coords + direction * scale * radius * 1.0) * weight;
    result += Texel(tex, texture_coords - direction * scale * radius * 1.0) * weight;
    
    weight = 0.1216216216;
    result += Texel(tex, texture_coords + direction * scale * radius * 2.0) * weight;
    result += Texel(tex, texture_coords - direction * scale * radius * 2.0) * weight;
    
    weight = 0.0540540541;
    result += Texel(tex, texture_coords + direction * scale * radius * 3.0) * weight;
    result += Texel(tex, texture_coords - direction * scale * radius * 3.0) * weight;
    
    weight = 0.0162162162;
    result += Texel(tex, texture_coords + direction * scale * radius * 4.0) * weight;
    result += Texel(tex, texture_coords - direction * scale * radius * 4.0) * weight;
    
    return result;
}
]]

-- Shader per combinare la texture originale con l'effetto glow
local glowShaderCode = [[
extern Image originalTex;
extern Image glowTex;
extern number glowStrength;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 original = Texel(originalTex, texture_coords);
    vec4 glow = Texel(glowTex, texture_coords);
    
    // Mescola l'originale con il glow
    return original + glow * glowStrength;
}
]]

-- Inizializza Love2D
function love.load()
    love.keyboard.setKeyRepeat(true)
    codeFont = love.graphics.newFont(fontSize)
    uiFont = love.graphics.newFont(fontSize * 1.2)
    canvas = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    glowCanvas = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    blurCanvas1 = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    blurCanvas2 = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    
    -- Carica immagini di test
    createTestImages()
    
    -- Carica shader di effetto
    blurShader = love.graphics.newShader(blurShaderCode)
    glowShader = love.graphics.newShader(glowShaderCode)
    
    -- Imposta il shader iniziale
    editorText = shaderTemplate
    compileShader()
end

-- Crea immagini di test
function createTestImages()
    -- Immagine 1: Gradiente colorato
    local img1 = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    love.graphics.setCanvas(img1)
    love.graphics.clear()
    
    local mesh = love.graphics.newMesh({
        {0, 0, 0, 0, 1, 0, 0, 1},
        {canvasSize.width, 0, 1, 0, 0, 1, 0, 1},
        {canvasSize.width, canvasSize.height, 1, 1, 1, 1, 0, 1},
        {0, canvasSize.height, 0, 1, 0, 0, 1, 1}
    }, "fan", "static")
    
    love.graphics.draw(mesh)
    love.graphics.setCanvas()
    
    -- Immagine 2: Pattern a cerchi
    local img2 = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    love.graphics.setCanvas(img2)
    love.graphics.clear(0.1, 0.1, 0.1, 1)
    
    for i = 1, 10 do
        local radius = (11 - i) * 15
        love.graphics.setColor(i/10, 0.5, 1 - i/10, 1)
        love.graphics.circle("fill", canvasSize.width/2, canvasSize.height/2, radius)
    end
    
    love.graphics.setCanvas()
    
    -- Immagine 3: Pattern a griglia
    local img3 = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    love.graphics.setCanvas(img3)
    love.graphics.clear(0.15, 0.15, 0.15, 1)
    
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    local gridSize = 20
    for x = 0, canvasSize.width, gridSize do
        love.graphics.line(x, 0, x, canvasSize.height)
    end
    for y = 0, canvasSize.height, gridSize do
        love.graphics.line(0, y, canvasSize.width, y)
    end
    
    love.graphics.setCanvas()
    
    -- Immagine 4: Forme geometriche
    local img4 = love.graphics.newCanvas(canvasSize.width, canvasSize.height)
    love.graphics.setCanvas(img4)
    love.graphics.clear(0.05, 0.05, 0.05, 1)
    
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", 100, 100, 100, 100)
    
    love.graphics.setColor(0.3, 1, 0.3, 1)
    love.graphics.circle("fill", 250, 150, 80)
    
    love.graphics.setColor(0.3, 0.3, 1, 1)
    love.graphics.polygon("fill", 150, 250, 250, 300, 200, 350)
    
    love.graphics.setCanvas()
    
    -- Resetta il colore
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Aggiungi le immagini all'array
    table.insert(testImages, img1)
    table.insert(testImages, img2)
    table.insert(testImages, img3)
    table.insert(testImages, img4)
end

-- Compila lo shader dal testo dell'editor
function compileShader()
    shaderError = ""
    local success, result = pcall(function()
        return love.graphics.newShader(editorText)
    end)
    
    if success then
        currentShader = result
    else
        shaderError = tostring(result)
        return false
    end
    
    return true
end

-- Applica effetto glow
function applyGlowEffect()
    -- Disegna la scena originale sul canvas principale
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    
    -- Applica lo shader dell'utente sul canvas con l'immagine di test corrente
    if currentShader then
        love.graphics.setShader(currentShader)
        
        -- Passa le uniform al shader
        if currentShader:hasUniform("resolution") then
            currentShader:send("resolution", {canvasSize.width, canvasSize.height})
        end
        if currentShader:hasUniform("time") then
            currentShader:send("time", time)
        end
        if currentShader:hasUniform("mouse") then
            currentShader:send("mouse", {mousePosition.x / love.graphics.getWidth(), mousePosition.y / love.graphics.getHeight()})
        end
        if currentShader:hasUniform("mainTex") then
            currentShader:send("mainTex", testImages[currentImageIndex])
        end
        
        love.graphics.draw(testImages[currentImageIndex])
        love.graphics.setShader()
    else
        -- Se non c'è shader, mostra l'immagine di test
        love.graphics.draw(testImages[currentImageIndex])
    end
    
    love.graphics.setCanvas()
    
    if enableGlow then
        -- Copia il canvas al glowCanvas
        love.graphics.setCanvas(glowCanvas)
        love.graphics.clear()
        love.graphics.draw(canvas)
        love.graphics.setCanvas()
        
        -- Applica blur orizzontale
        love.graphics.setCanvas(blurCanvas1)
        love.graphics.clear()
        love.graphics.setShader(blurShader)
        blurShader:send("direction", {1, 0})
        blurShader:send("radius", blurRadius)
        love.graphics.draw(glowCanvas)
        love.graphics.setCanvas()
        
        -- Applica blur verticale
        love.graphics.setCanvas(blurCanvas2)
        love.graphics.clear()
        love.graphics.setShader(blurShader)
        blurShader:send("direction", {0, 1})
        blurShader:send("radius", blurRadius)
        love.graphics.draw(blurCanvas1)
        love.graphics.setCanvas()
        love.graphics.setShader()
        
        -- Combina originale con glow
        love.graphics.setCanvas(glowCanvas)
        love.graphics.clear()
        love.graphics.setShader(glowShader)
        glowShader:send("originalTex", canvas)
        glowShader:send("glowTex", blurCanvas2)
        glowShader:send("glowStrength", glowStrength)
        love.graphics.draw(canvas)
        love.graphics.setCanvas()
        love.graphics.setShader()
    end
end

-- Aggiorna lo stato del gioco
function love.update(dt)
    time = time + dt
    mousePosition.x = love.mouse.getX()
    mousePosition.y = love.mouse.getY()
    
    -- Applica l'effetto glow in aggiornamento
    applyGlowEffect()
end

-- Disegna l'interfaccia
function love.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    
    -- Area dell'editor (a sinistra)
    love.graphics.setColor(theme.editor)
    love.graphics.rectangle("fill", 0, 0, windowWidth/2, windowHeight)
    
    -- Disegna il testo dell'editor
    love.graphics.setColor(theme.text)
    love.graphics.setFont(codeFont)
    
    -- Calcola le linee visibili
    local visibleLines = {}
    local lineHeight = codeFont:getHeight() + 2
    local lines = splitLines(editorText)
    local startLine = math.floor(editorScrollY / lineHeight) + 1
    local endLine = math.min(#lines, startLine + math.floor(windowHeight / lineHeight))
    
    -- Disegna sfondo evidenziato per la riga corrente
    local currentPos = 1
    local currentLine = 1
    for i, line in ipairs(lines) do
        if currentPos + #line >= editorCursor then
            currentLine = i
            break
        end
        currentPos = currentPos + #line + 1
    end
    
    if currentLine >= startLine and currentLine <= endLine then
        love.graphics.setColor(theme.highlight)
        local y = (currentLine - 1) * lineHeight - editorScrollY + textMargin - 2
        love.graphics.rectangle("fill", 0, y, windowWidth/2, lineHeight)
    end
    
    -- Disegna i numeri di riga
    love.graphics.setColor(theme.lineNumbers)
    for i = startLine, endLine do
        local y = (i - 1) * lineHeight - editorScrollY + textMargin
        love.graphics.print(i, 5, y)
    end
    
    -- Disegna il testo
    love.graphics.setColor(theme.text)
    for i = startLine, endLine do
        local y = (i - 1) * lineHeight - editorScrollY + textMargin
        love.graphics.print(lines[i], 40, y)
    end
    
    -- Area di visualizzazione dello shader (a destra)
    love.graphics.setColor(theme.background)
    love.graphics.rectangle("fill", windowWidth/2, 0, windowWidth/2, windowHeight)
    
    -- Disegna il canvas con lo shader e il glow
    love.graphics.setColor(1, 1, 1)
    if enableGlow then
        love.graphics.draw(glowCanvas, windowWidth/2, 0)
    else
        love.graphics.draw(canvas, windowWidth/2, 0)
    end
    
    -- Mostra eventuali errori
    if shaderError ~= "" then
        love.graphics.setColor(theme.error)
        love.graphics.setFont(uiFont)
        love.graphics.printf("Errore Shader: " .. shaderError, windowWidth/2 + 10, canvasSize.height + 10, windowWidth/2 - 20, "left")
    end
    
    -- Mostra info su immagine e glow
    love.graphics.setColor(theme.accent)
    love.graphics.setFont(uiFont)
    love.graphics.printf(
        "Immagine: " .. currentImageIndex .. "/4  |  " ..
        "Glow: " .. (enableGlow and "ON" or "OFF") .. "  |  " ..
        "Intensità: " .. string.format("%.1f", glowStrength),
        windowWidth/2 + 10, canvasSize.height + 50, windowWidth/2 - 20, "left"
    )
    
    -- Mostra la guida se attiva
    if showHelp then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", windowWidth/2, canvasSize.height + 80, windowWidth/2, windowHeight - canvasSize.height - 80)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(uiFont)
        love.graphics.printf(helpText, windowWidth/2 + 10, canvasSize.height + 90, windowWidth/2 - 20, "left")
    end
    
    -- Disegna barra di stato
    love.graphics.setColor(theme.background)
    love.graphics.rectangle("fill", 0, windowHeight - 40, windowWidth, 40)
    
    love.graphics.setColor(theme.text)
    love.graphics.setFont(uiFont)
    love.graphics.print("Premi F1 per aiuto | F5 per compilare | G: toggle glow | Frecce: cambia immagine", 10, windowHeight - 30)
end

-- Gestisci l'input della tastiera
function love.keypressed(key, scancode, isrepeat)
    -- Scorciatoie da tastiera
    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        if key == "s" then
            saveShader()
            return
        elseif key == "o" then
            loadShader()
            return
        elseif key == "n" then
            editorText = shaderTemplate
            compileShader()
            return
        end
    end
    
    if key == "f1" then
        showHelp = not showHelp
    elseif key == "f5" then
        compileShader()
    elseif key == "escape" then
        love.event.quit()
    elseif key == "backspace" then
        if #editorText > 0 and editorCursor > 1 then
            editorText = string.sub(editorText, 1, editorCursor - 2) .. string.sub(editorText, editorCursor)
            editorCursor = math.max(1, editorCursor - 1)
        end
    elseif key == "delete" then
        if editorCursor <= #editorText then
            editorText = string.sub(editorText, 1, editorCursor - 1) .. string.sub(editorText, editorCursor + 1)
        end
    elseif key == "return" or key == "kpenter" then
        editorText = string.sub(editorText, 1, editorCursor - 1) .. "\n" .. string.sub(editorText, editorCursor)
        editorCursor = editorCursor + 1
    elseif key == "tab" then
        editorText = string.sub(editorText, 1, editorCursor - 1) .. "    " .. string.sub(editorText, editorCursor)
        editorCursor = editorCursor + 4
    elseif key == "left" then
        editorCursor = math.max(1, editorCursor - 1)
    elseif key == "right" then
        editorCursor = math.min(#editorText + 1, editorCursor + 1)
    elseif key == "up" or key == "down" then
        -- Navigazione più complessa tra le righe, semplificata per questo esempio
        local lines = splitLines(editorText)
        local currentPos = 1
        local currentLine = 1
        local columnInLine = 0
        
        -- Trova riga e colonna correnti
        for i, line in ipairs(lines) do
            if currentPos + #line >= editorCursor then
                currentLine = i
                columnInLine = editorCursor - currentPos
                break
            end
            currentPos = currentPos + #line + 1  -- +1 per il carattere newline
        end
        
        if key == "up" and currentLine > 1 then
            currentLine = currentLine - 1
        elseif key == "down" and currentLine < #lines then
            currentLine = currentLine + 1
        end
        
        -- Calcola la nuova posizione
        local newPos = 1
        for i = 1, currentLine - 1 do
            newPos = newPos + #lines[i] + 1
        end
        editorCursor = math.min(newPos + math.min(columnInLine, #lines[currentLine]), newPos + #lines[currentLine])
    end
    
    -- Aggiorna lo scroll per mantenere visibile il cursore
    updateScroll()
end

-- Gestisce l'input dei caratteri
function love.textinput(text)
    editorText = string.sub(editorText, 1, editorCursor - 1) .. text .. string.sub(editorText, editorCursor)
    editorCursor = editorCursor + #text
    updateScroll()
end

-- Gestisce lo scroll con la rotella del mouse
function love.wheelmoved(x, y)
    editorScrollY = math.max(0, editorScrollY - y * 20)
end

-- Aggiorna la posizione di scroll per tenere il cursore visibile
function updateScroll()
    local lines = splitLines(editorText)
    local lineHeight = codeFont:getHeight() + 2
    local windowHeight = love.graphics.getHeight()
    
    -- Calcola la riga corrente
    local currentPos = 1
    local currentLine = 1
    
    for i, line in ipairs(lines) do
        if currentPos + #line >= editorCursor then
            currentLine = i
            break
        end
        currentPos = currentPos + #line + 1
    end
    
    -- Calcola la posizione Y del cursore
    local cursorY = (currentLine - 1) * lineHeight
    
    -- Assicurati che il cursore sia visibile
    if cursorY < editorScrollY then
        editorScrollY = cursorY
    elseif cursorY > editorScrollY + windowHeight - 2 * lineHeight then
        editorScrollY = cursorY - windowHeight + 2 * lineHeight
    end
    
    editorScrollY = math.max(0, editorScrollY)
end

-- Divide il testo in righe
function splitLines(text)
    local lines = {}
    local line = ""
    
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "\n" then
            table.insert(lines, line)
            line = ""
        else
            line = line .. char
        end
    end
    
    table.insert(lines, line)
    return lines
end

-- Salva lo shader su file
function saveShader()
    local fileName = "shader-" .. os.time() .. ".glsl"
    
    -- Apre una finestra di dialogo per il salvataggio del file (versione semplificata)
    local success, message = love.filesystem.write(fileName, editorText)
    
    if success then
        print("Shader salvato come: " .. fileName)
    else
        print("Errore durante il salvataggio: " .. tostring(message))
    end
end

-- Carica uno shader da file
function loadShader()
    -- In una vera applicazione, qui ci sarebbe una finestra di dialogo
    -- Per semplicità, carica il primo file .glsl trovato
    local files = love.filesystem.getDirectoryItems("")
    
    for _, file in ipairs(files) do
        if file:match("%.glsl$") then
            local content, error = love.filesystem.read(file)
            if content then
                editorText = content
                editorCursor = 1
                compileShader()
                print("Caricato shader: " .. file)
                return
            else
                print("Errore nel caricamento: " .. tostring(error))
            end
        end
    end
    
    print("Nessun file shader trovato.")
end