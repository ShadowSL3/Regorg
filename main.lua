<<<<<<< HEAD
<<<<<<< HEAD
=======
lurker = require("libraries.lurker")
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
local screenWidth, screenHeight = 800, 600
local backgroundColor = {0.1, 0.1, 0.15, 1}
local notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
local octaves = {3, 4, 5}
local grid = {}
<<<<<<< HEAD
local gridWidth = 16  -- Numero di beat
local gridHeight = #notes * #octaves  -- Numero di note totali
local cellSize = 30
local gridOffsetX, gridOffsetY = 100, 50
=======
local gridWidth = 16  -- Number of beats
local gridHeight = #notes * #octaves  -- Total number of notes
local cellSize = 40
local gridOffsetX, gridOffsetY = 60, 92
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
local currentBeat = 1
local isPlaying = false
local bpm = 120
local beatTimer = 0
local soundSources = {}
local selectedWaveform = "sine"  -- sine, square, triangle, sawtooth
local volume = 0.5
local sustain = 0.5  -- Duration Of Note in milleseconds 

-- Colors
local colors = {
    grid = {0.3, 0.3, 0.3},
    cell = {0.2, 0.2, 0.25},
    active = {0.2, 0.6, 0.9},
    playing = {0.9, 0.3, 0.3},
    text = {0.9, 0.9, 0.9},
    button = {0.4, 0.4, 0.4},
    buttonHover = {0.5, 0.5, 0.5},
    buttonText = {1, 1, 1}
}

-- Buttons of interface
local buttons = {
    {
        text = "Play/Pause",
<<<<<<< HEAD
        x = 20,
        y = 20,
=======
        x = 10*2,
        y = 5*3,
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
        width = 100,
        height = 30,
        action = function() isPlaying = not isPlaying end
    },
    {
        text = "Sine",
<<<<<<< HEAD
        x = 20,
        y = 60,
        width = 80,
        height = 25,
=======
        x = 120*7.35,
        y = 20*3,
        width = 20*4,
        height = 5*5,
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
        action = function() selectedWaveform = "sine" end
    },
    {
        text = "Square",
<<<<<<< HEAD
        x = 110,
        y = 60,
        width = 80,
        height = 25,
=======
        x = 234,
        y = 20*3,
        width = 20*4,
        height = 5*5,
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
        action = function() selectedWaveform = "square" end
    },
    {
        text = "Triangle",
<<<<<<< HEAD
        x = 200,
        y = 60,
        width = 80,
        height = 25,
=======
        x = 21*15.11,
        y = 20*3,
        width = 40*2,
        height = 5*5,
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
        action = function() selectedWaveform = "triangle" end
    },
    {
        text = "Sawtooth",
<<<<<<< HEAD
        x = 290,
        y = 60,
        width = 80,
        height = 25,
=======
        x = 40*10,
        y = 20*3,
        width = 20*4,
        height = 5*5,
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
        action = function() selectedWaveform = "sawtooth" end
    },
    {
        text = "Clear All",
<<<<<<< HEAD
        x = 390,
        y = 20,
        width = 80,
        height = 30,
=======
        x = 40*14,
        y = 3*5,
        width = 40*2,
        height = 15*2,
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
        action = function() grid = {} end
    }
}

<<<<<<< HEAD
-- Slider for controls
local sliders = {
    {
        name = "BPM",
        x = 140,
        y = 20,
        width = 200,
        height = 20,
        min = 60,
        max = 200,
        value = bpm,
        onChange = function(value) bpm = value end
    },
    {
        name = "Volume",
        x = 390,
        y = 60,
        width = 200,
        height = 20,
        min = 0,
        max = 1.24,
        value = volume,
        onChange = function(value) volume = value end
    }
}
=======
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461

-- Initizialization
function love.load()
    love.window.setMode(screenWidth, screenHeight)
<<<<<<< HEAD
    love.window.setTitle("Editor Musicale Procedurale")
=======
    love.window.setTitle("Notifu Editor")
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
    love.keyboard.setKeyRepeat(true)
    
    -- Inizializza la griglia vuota
    for i = 1, gridWidth do
        grid[i] = {}
    end
    
    -- Imposta il font
    font = love.graphics.newFont(12)
    love.graphics.setFont(font)
end

-- Generate a frequency for a specific note and octave
function getNoteFrequency(note, octave)
    local baseFreq = 440.0  -- A4 = 440Hz
    local noteIndex = 0
    
    for i, n in ipairs(notes) do
        if n == note then
            noteIndex = i - 10  -- A is the 10ª note in our scale
            break
        end
    end
    
    local semitones = (octave - 4) * 12 + noteIndex
    return baseFreq * math.pow(2, semitones / 12)
end

-- Generates a sine wave
function generateSineWave(frequency, amplitude, time)
    return amplitude * math.sin(2 * math.pi * frequency * time)
end

-- Generate a square wave
function generateSquareWave(frequency, amplitude, time)
    local sine = math.sin(2 * math.pi * frequency * time)
    if sine >= 0 then
        return amplitude
    else
        return -amplitude
    end
end

-- Generates a triangular wave
function generateTriangleWave(frequency, amplitude, time)
    local period = 1.0 / frequency
    local t = (time % period) / period
    if t < 0.25 then
        return amplitude * (4 * t)
    elseif t < 0.75 then
        return amplitude * (1 - 4 * (t - 0.25))
    else
        return amplitude * (-1 + 4 * (t - 0.75))
    end
end

-- Generates a sawtooth wave
function generateSawtoothWave(frequency, amplitude, time)
    local period = 1.0 / frequency
    local t = (time % period) / period
    return amplitude * (2 * t - 1)
end

-- Genera un suono procedurale
function generateSound(frequency)
    local sampleRate = 44100
    local duration = sustain
    local amplitude = volume
    local samples = {}
    
    local buffer = love.sound.newSoundData(math.floor(sampleRate * duration), sampleRate, 16, 1)
    
    for i = 0, buffer:getSampleCount() - 1 do
        local time = i / sampleRate
        local value = 0
        
        -- Apply simplified ADSR envelope (only attack and release)
        local envelope = 1.0
        local attackTime = 0.05
        local releaseTime = 0.2
        
        if time < attackTime then
            envelope = time / attackTime
        elseif time > duration - releaseTime then
            envelope = (duration - time) / releaseTime
        end
        
        -- Select the type of wave
        if selectedWaveform == "sine" then
            value = generateSineWave(frequency, amplitude * envelope, time)
        elseif selectedWaveform == "square" then
            value = generateSquareWave(frequency, amplitude * envelope, time)
        elseif selectedWaveform == "triangle" then
            value = generateTriangleWave(frequency, amplitude * envelope, time)
        elseif selectedWaveform == "sawtooth" then
            value = generateSawtoothWave(frequency, amplitude * envelope, time)
        end
        
        -- Limit the values between -1 and 1
        value = math.max(-1, math.min(1, value))
        buffer:setSample(i, value)
    end
    
    return buffer
end

-- Play a note
function playNote(note, octave)
    local frequency = getNoteFrequency(note, octave)
    local soundData = generateSound(frequency)
    local source = love.audio.newSource(soundData)
    source:setVolume(volume)
    source:play()
    table.insert(soundSources, source)
    
    -- Limit the number of active audio sources
    if #soundSources > 64 then
        table.remove(soundSources, 1)
    end
end

-- Controlla se il mouse è sopra un pulsante
function isMouseOverButton(button)
    local mx, my = love.mouse.getPosition()
    return mx >= button.x and mx <= button.x + button.width and
           my >= button.y and my <= button.y + button.height
end

-- Check if the mouse is over a slider
function isMouseOverSlider(slider)
    local mx, my = love.mouse.getPosition()
    return mx >= slider.x and mx <= slider.x + slider.width and
           my >= slider.y - 10 and my <= slider.y + slider.height + 10
end

-- Gets the value of the slider based on the position of the mouse
function getSliderValue(slider, mx)
    local progress = (mx - slider.x) / slider.width
    progress = math.max(0, math.min(1, progress))
    return slider.min + progress * (slider.max - slider.min)
end

-- Update the game status
function love.update(dt)
<<<<<<< HEAD
=======
    lurker.update()
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
    -- Cleaning of completed audio sources
    for i = #soundSources, 1, -1 do
        if not soundSources[i]:isPlaying() then
            table.remove(soundSources, i)
        end
    end
<<<<<<< HEAD
    
=======
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
    -- Update the playback
    if isPlaying then
        beatTimer = beatTimer + dt
        local beatDuration = 60 / bpm
        
        if beatTimer >= beatDuration then
            beatTimer = beatTimer - beatDuration
            
            -- Play the notes for the current beat
            if grid[currentBeat] then
                for noteIdx, active in pairs(grid[currentBeat]) do
                    if active then
                        local octaveIndex = math.ceil(noteIdx / #notes)
                        local noteIndex = ((noteIdx - 1) % #notes) + 1
                        playNote(notes[noteIndex], octaves[octaveIndex])
                    end
                end
            end
            
            -- Advance to the next beat
            currentBeat = currentBeat % gridWidth + 1
        end
    end
end

-- Draw the interface
function love.draw()
    -- Sfondo
    love.graphics.setBackgroundColor(backgroundColor)
    
    -- Draw the grid
    love.graphics.setColor(colors.grid)
    for i = 0, gridWidth do
        local x = gridOffsetX + i * cellSize
        love.graphics.line(x, gridOffsetY, x, gridOffsetY + gridHeight * cellSize)
    end
    
    for i = 0, gridHeight do
        local y = gridOffsetY + i * cellSize
        love.graphics.line(gridOffsetX, y, gridOffsetX + gridWidth * cellSize, y)
    end
<<<<<<< HEAD
    
=======
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
    -- Draw the active notes and the cells
    for x = 1, gridWidth do
        for y = 1, gridHeight do
            local cellX = gridOffsetX + (x - 1) * cellSize
            local cellY = gridOffsetY + (y - 1) * cellSize
            
            -- Draw the background of the cell
            love.graphics.setColor(colors.cell)
            love.graphics.rectangle("fill", cellX + 1, cellY + 1, cellSize - 1, cellSize - 1)
            
            -- Disegna la nota attiva
            if grid[x] and grid[x][y] then
                love.graphics.setColor(colors.active)
                love.graphics.rectangle("fill", cellX + 1, cellY + 1, cellSize - 1, cellSize - 1)
            end
            
            -- Evidenzia il beat corrente
            if x == currentBeat and isPlaying then
                love.graphics.setColor(colors.playing)
                love.graphics.rectangle("line", cellX + 1, cellY + 1, cellSize - 1, cellSize - 1)
            end
        end
    end
    
    -- Draw the names of the notes
    love.graphics.setColor(colors.text)
    for i = 1, #octaves do
        for j = 1, #notes do
            local noteIdx = (i - 1) * #notes + j
            local y = gridOffsetY + (noteIdx - 0.5) * cellSize
            love.graphics.print(notes[j] .. octaves[i], gridOffsetX - 40, y - 6)
        end
    end
    
    -- Draw the buttons
    for _, button in ipairs(buttons) do
        if isMouseOverButton(button) then
            love.graphics.setColor(colors.buttonHover)
        else
            love.graphics.setColor(colors.button)
        end
        
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height, 5, 5)
        love.graphics.setColor(colors.buttonText)
        love.graphics.print(button.text, button.x + 10, button.y + button.height/2 - 6)
        
        -- Highlight the selected waveform button
        if button.text:lower() == selectedWaveform then
            love.graphics.setColor(colors.active)
            love.graphics.rectangle("line", button.x, button.y, button.width, button.height, 5, 5)
        end
    end
    
    -- Draw the sliders
    for _, slider in ipairs(sliders) do
        -- Barra dello slider
        love.graphics.setColor(colors.button)
        love.graphics.rectangle("fill", slider.x, slider.y, slider.width, slider.height, 3, 3)
        
        -- Current position
        local progress = (slider.value - slider.min) / (slider.max - slider.min)
        love.graphics.setColor(colors.active)
        love.graphics.rectangle("fill", slider.x, slider.y, slider.width * progress, slider.height, 3, 3)
        
        -- Slider text
        love.graphics.setColor(colors.text)
        love.graphics.print(slider.name .. ": " .. math.floor(slider.value * 100) / 100, 
                           slider.x, slider.y - 15)
    end
<<<<<<< HEAD
    
    -- Additional information
    love.graphics.setColor(colors.text)
    love.graphics.print("Waveform: " .. selectedWaveform, 20, 100)
    love.graphics.print("Beat: " .. currentBeat .. "/" .. gridWidth, 20, 120)
    
    -- Help info
    love.graphics.print("Click sulle celle per aggiungere/rimuovere note", 20, screenHeight - 60)
    love.graphics.print("Spazio per play/pause", 20, screenHeight - 40)
    love.graphics.print("C per pulire la griglia", 20, screenHeight - 20)
=======
    -- Additional information
    love.graphics.setColor(colors.text)
    love.graphics.print("Waveform: " .. selectedWaveform, 707, 101)
    love.graphics.print("Beat: " .. currentBeat .. "/" .. gridWidth, 707, 120)
>>>>>>> 9b185bb42f41e850321442f6262a24354757f461
end

-- Mouse input management
function love.mousepressed(x, y, button)
    if button == 1 then  -- Click sinistro
        -- Controlla i pulsanti
        for _, btn in ipairs(buttons) do
            if isMouseOverButton(btn) then
                btn.action()
                return
            end
        end
        
        -- Controlla gli slider
        for _, slider in ipairs(sliders) do
            if isMouseOverSlider(slider) then
                slider.value = getSliderValue(slider, x)
                slider.onChange(slider.value)
                return
            end
        end
        
        -- Check the grid
        if x >= gridOffsetX and x < gridOffsetX + gridWidth * cellSize and
           y >= gridOffsetY and y < gridOffsetY + gridHeight * cellSize then
            local gridX = math.floor((x - gridOffsetX) / cellSize) + 1
            local gridY = math.floor((y - gridOffsetY) / cellSize) + 1
            
            -- Create the line if it doesn't exist
            if not grid[gridX] then
                grid[gridX] = {}
            end
            
            -- Activate/deactivate the cell
            grid[gridX][gridY] = not grid[gridX][gridY]
            
            -- If the cell is now active, play the note
            if grid[gridX][gridY] then
                local octaveIndex = math.ceil(gridY / #notes)
                local noteIndex = ((gridY - 1) % #notes) + 1
                playNote(notes[noteIndex], octaves[octaveIndex])
            end
        end
    end
end

-- Mouse drag management for sliders
function love.mousemoved(x, y, dx, dy, istouch)
    if love.mouse.isDown(1) then  -- Se il mouse è premuto
        for _, slider in ipairs(sliders) do
            if isMouseOverSlider(slider) then
                slider.value = getSliderValue(slider, x)
                slider.onChange(slider.value)
            end
        end
    end
end

-- Keyboard input management
function love.keypressed(key)
    if key == "space" then
        isPlaying = not isPlaying
    elseif key == "c" then
        grid = {}  -- Clean the grill
    elseif key == "escape" then
        love.event.quit()
    end
=======
local gfx = require("graphics.graphics")
local gp3 = require "audio.gp3"
function love.load()

    shader = gfx.newShader([[ 
       
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
      vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
      return pixel * color;
    }
    ]])
end

function love.update(dt)

end


function love.draw()
    love.graphics.setShader(shader)
    gfx.rect(10, 0, 50, 10, 255, 0)
    love.graphics.setShader()
>>>>>>> 5071a27ba2d6ed1f6663513966af610875fd4d2e
end