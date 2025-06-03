-- main.lua

local input = ""
local output = ""
local warning = false
local warningTime = 0
local warningDuration = 0.5 -- Durata del lampeggio di avviso
local systemIntercepted = false

local commands = {
    ["hack_lights"] = "Luci stradali hackerate!",
    ["hack_cameras"] = "Telecamere di sicurezza disabilitate!",
    ["hack_bank"] = "Conto bancario compromesso!"
}

function love.load()
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.setBackgroundColor(0, 0, 0) -- Sfondo nero
end

function love.update(dt)
    -- Gestione del lampeggio di avviso
    if warning then
        warningTime = warningTime + dt
        if warningTime > warningDuration then
            systemIntercepted = true
            warning = false
        end
    end

    -- Se il sistema è stato intercettato, chiudiamo il gioco dopo un breve ritardo
    if systemIntercepted then
        love.timer.sleep(0.5)
        love.event.quit()
    end
end

function love.draw()
    -- Simula il lampeggio rosso in caso di errore
    if warning then
        if math.floor(warningTime * 10) % 2 == 0 then
            love.graphics.clear(1, 0, 0) -- Sfondo rosso lampeggiante
        else
            love.graphics.clear(0, 0, 0) -- Sfondo nero
        end
    else
        love.graphics.clear(0, 0, 0) -- Sfondo nero
    end

    love.graphics.setColor(0, 1, 0) -- Testo verde stile terminale
    love.graphics.print("Console Hacking - Watch Dogs Style", 10, 10)
    love.graphics.print("Input: " .. input, 10, 30)
    love.graphics.print("Output: " .. output, 10, 50)
end

function love.textinput(t)
    if not systemIntercepted then
        input = input .. t
    end
end

function love.keypressed(key)
    if key == "return" then
        processCommand(input)
        input = ""
    elseif key == "backspace" then
        input = input:sub(1, -2)
    end
end

function processCommand(cmd)
    if commands[cmd] then
        output = commands[cmd]
    else
        output = "ERRORE: Comando non riconosciuto!"
        warning = true
        warningTime = 0
    end
end