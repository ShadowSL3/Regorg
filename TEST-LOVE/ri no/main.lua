local phoneRinging = true
local ringSound
local timeSinceRing = 0
local ringDuration = 5
local dialogueActive = false

function love.load()
    ringSound = love.audio.newSource("sounds/ring.ogg", "stream")
    ringSound:setLooping(true)
    ringSound:play()
end

function love.update(dt)
    if phoneRinging then
        timeSinceRing = timeSinceRing + dt
        if timeSinceRing >= ringDuration then
            startDialogue()
        end
    end
end

function love.mousepressed(x, y, button)
    if phoneRinging then
        startDialogue()
    end
end

function startDialogue()
    phoneRinging = false
    ringSound:stop()
    dialogueActive = true
end

function love.draw()
    if phoneRinging then
        love.graphics.printf("Telefono in arrivo...", 0, 100, love.graphics.getWidth(), "center")
    elseif dialogueActive then
        love.graphics.printf("Personaggio: Pronto, mi senti?", 0, 100, love.graphics.getWidth(), "center")
    end
end